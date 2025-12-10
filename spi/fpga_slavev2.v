module top_spi_blackscholes (
    input  wire clk,       // 100 MHz
    input  wire rst,       // reset
    input  wire spi_sck,
    input  wire spi_mosi,
    input  wire spi_cs,
    output wire spi_miso
);

    // ------------------
    // SPI Slave
    // ------------------
    reg [7:0] rx_shift;
    reg [7:0] tx_shift;
    reg [2:0] bit_cnt;
    reg byte_received;
    reg [7:0] rx_byte;

    always @(posedge spi_sck) begin
        if (!spi_cs) begin
            rx_shift <= {rx_shift[6:0], spi_mosi};
            bit_cnt <= bit_cnt + 1;

            if (bit_cnt == 7) begin
                rx_byte <= {rx_shift[6:0], spi_mosi};
                byte_received <= 1;
            end else begin
                byte_received <= 0;
            end
        end
    end

    assign spi_miso = tx_shift[7];

    always @(negedge spi_sck) begin
        if (!spi_cs)
            tx_shift <= {tx_shift[6:0], 1'b0};
    end

    // ------------------
    // Command FSM
    // ------------------
    typedef enum logic [2:0] {
        WAIT_CMD,
        GET_INPUTS,
        RUN_BS,
        WAIT_DONE,
        SEND_RESULT
    } state_t;

    state_t state = WAIT_CMD;

    reg [3:0] byte_count;

    reg signed [15:0] S, K, r, sigma, T;
    reg start = 0;

    wire done;
    wire signed [15:0] call_price;

    // Instantiate Black–Scholes
    black_scholes BS (
        .clk(clk),
        .rst(rst),
        .start(start),
        .S(S),
        .K(K),
        .r(r),
        .sigma(sigma),
        .T(T),
        .done(done),
        .call_price(call_price)
    );

    always @(posedge clk) begin
        start <= 0;

        case (state)
            WAIT_CMD: begin
                if (byte_received && rx_byte == 8'hA0) begin
                    byte_count <= 0;
                    state <= GET_INPUTS;
                end
            end

            GET_INPUTS: begin
                if (byte_received) begin
                    byte_count <= byte_count + 1;

                    case (byte_count)
                        0: S[15:8]     <= rx_byte;
                        1: S[7:0]      <= rx_byte;
                        2: K[15:8]     <= rx_byte;
                        3: K[7:0]      <= rx_byte;
                        4: r[15:8]     <= rx_byte;
                        5: r[7:0]      <= rx_byte;
                        6: sigma[15:8] <= rx_byte;
                        7: sigma[7:0]  <= rx_byte;
                        8: T[15:8]     <= rx_byte;
                        9: T[7:0]      <= rx_byte;
                    endcase

                    if (byte_count == 9) begin
                        start <= 1;
                        state <= RUN_BS;
                    end
                end
            end

            RUN_BS: begin
                state <= WAIT_DONE;
            end

            WAIT_DONE: begin
                if (done) begin
                    tx_shift <= call_price[15:8];  // prepare MSB
                    state <= SEND_RESULT;
                end
            end

            SEND_RESULT: begin
                // ESP32 will clock 2 bytes out
                // byte 1 = tx_shift
                // byte 2 = call_price[7:0]
                // After sending, return to WAIT_CMD
                // Simplest: remain here until CS rises

                if (spi_cs) begin
                    tx_shift <= call_price[7:0];
                    state <= WAIT_CMD;
                end
            end

        endcase
    end

endmodule
