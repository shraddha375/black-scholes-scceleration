module top (
    input wire spi_sck,
    input wire spi_mosi,
    input wire spi_cs,
    output wire spi_miso,
    output wire led   // debug output
);

wire [7:0] rx_data;
wire data_ready;

spi_slave SLV (
    .sck(spi_sck),
    .mosi(spi_mosi),
    .cs(spi_cs),
    .miso(spi_miso),
    .data(rx_data),
    .data_ready(data_ready)
);

assign led = data_ready;  // Flash LED when byte received

endmodule
