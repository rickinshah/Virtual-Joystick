# Clock input for Zed Board
set_property PACKAGE_PIN Y9 [get_ports CLK100MHZ]
set_property IOSTANDARD LVCMOS33 [get_ports CLK100MHZ]

# PMOD ACL2 connections (SPI for accelerometer)
set_property PACKAGE_PIN Y11 [get_ports ACL_CSN]
set_property PACKAGE_PIN Y10 [get_ports ACL_MISO]
set_property PACKAGE_PIN AA11 [get_ports ACL_MOSI]
set_property PACKAGE_PIN AA9 [get_ports ACL_SCLK]
set_property IOSTANDARD LVCMOS33 [get_ports ACL_CSN]
set_property IOSTANDARD LVCMOS33 [get_ports ACL_MISO]
set_property IOSTANDARD LVCMOS33 [get_ports ACL_MOSI]
set_property IOSTANDARD LVCMOS33 [get_ports ACL_SCLK]

# OLED connections
set_property PACKAGE_PIN U10 [get_ports oled_dc_n]
set_property PACKAGE_PIN U9 [get_ports oled_reset_n]
set_property PACKAGE_PIN AB12 [get_ports oled_spi_clk]
set_property PACKAGE_PIN AA12 [get_ports oled_spi_data]
set_property PACKAGE_PIN U11 [get_ports oled_vbat]
set_property PACKAGE_PIN U12 [get_ports oled_vdd]
set_property IOSTANDARD LVCMOS33 [get_ports oled_dc_n]
set_property IOSTANDARD LVCMOS33 [get_ports oled_reset_n]
set_property IOSTANDARD LVCMOS33 [get_ports oled_spi_clk]
set_property IOSTANDARD LVCMOS33 [get_ports oled_spi_data]
set_property IOSTANDARD LVCMOS33 [get_ports oled_vbat]
set_property IOSTANDARD LVCMOS33 [get_ports oled_vdd]

# Reset signal
set_property PACKAGE_PIN P16 [get_ports reset]
set_property IOSTANDARD LVCMOS18 [get_ports reset]

# Create a clock constraint (assuming 100 MHz)
create_clock -period 10.000 -name clock -waveform {0.000 5.000} [get_ports CLK100MHZ]