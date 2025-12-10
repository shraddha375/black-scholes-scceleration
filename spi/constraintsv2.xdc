### CLOCK 100 MHz
set_property PACKAGE_PIN E3 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -name sys_clk -period 10.000 [get_ports clk]

### RESET BUTTON
set_property PACKAGE_PIN A17 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]

### SPI SIGNALS
## SCK
set_property PACKAGE_PIN G17 [get_ports spi_sck]
set_property IOSTANDARD LVCMOS33 [get_ports spi_sck]

## MOSI
set_property PACKAGE_PIN J18 [get_ports spi_mosi]
set_property IOSTANDARD LVCMOS33 [get_ports spi_mosi]

## MISO
set_property PACKAGE_PIN K15 [get_ports spi_miso]
set_property IOSTANDARD LVCMOS33 [get_ports spi_miso]

## CS
set_property PACKAGE_PIN L16 [get_ports spi_cs]
set_property IOSTANDARD LVCMOS33 [get_ports spi_cs]
