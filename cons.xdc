##Clock signal
set_property -dict { PACKAGE_PIN K17   IOSTANDARD LVCMOS33 } [get_ports { CLK }]; 
create_clock -add -name clock -period 10 -waveform {0 5} [get_ports { CLK }];


##Switches
set_property -dict { PACKAGE_PIN G15   IOSTANDARD LVCMOS33 } [get_ports { RST }];
