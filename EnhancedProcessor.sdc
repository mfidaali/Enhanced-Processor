## Generated SDC file "EnhancedProcessor.sdc"

## Copyright (C) 2018  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 18.1.0 Build 625 09/12/2018 SJ Lite Edition"

## DATE    "Sun Dec 02 10:22:09 2018"

##
## DEVICE  "5CGXFC7C7F23C8"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {SYS_CLK} -period 20.000 -waveform { 0.000 10.000 } [get_ports {SYS_CLK}]


#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {SYS_CLK}] -rise_to [get_clocks {SYS_CLK}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {SYS_CLK}] -rise_to [get_clocks {SYS_CLK}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {SYS_CLK}] -fall_to [get_clocks {SYS_CLK}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {SYS_CLK}] -fall_to [get_clocks {SYS_CLK}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {SYS_CLK}] -rise_to [get_clocks {SYS_CLK}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {SYS_CLK}] -rise_to [get_clocks {SYS_CLK}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {SYS_CLK}] -fall_to [get_clocks {SYS_CLK}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {SYS_CLK}] -fall_to [get_clocks {SYS_CLK}] -hold 0.060  


#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay  -clock [get_clocks {SYS_CLK}]  2.000 [get_ports {KEY}]
set_input_delay -add_delay  -clock [get_clocks {SYS_CLK}]  2.000 [get_ports {SW}]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay -max -clock [get_clocks {SYS_CLK}]  2.000 [get_ports {LEDR[0]}]
set_output_delay -add_delay -min -clock [get_clocks {SYS_CLK}]  1.000 [get_ports {LEDR[0]}]
set_output_delay -add_delay -max -clock [get_clocks {SYS_CLK}]  2.000 [get_ports {LEDR[1]}]
set_output_delay -add_delay -min -clock [get_clocks {SYS_CLK}]  1.000 [get_ports {LEDR[1]}]
set_output_delay -add_delay -max -clock [get_clocks {SYS_CLK}]  2.000 [get_ports {LEDR[2]}]
set_output_delay -add_delay -min -clock [get_clocks {SYS_CLK}]  1.000 [get_ports {LEDR[2]}]
set_output_delay -add_delay -max -clock [get_clocks {SYS_CLK}]  2.000 [get_ports {LEDR[3]}]
set_output_delay -add_delay -min -clock [get_clocks {SYS_CLK}]  1.000 [get_ports {LEDR[3]}]
set_output_delay -add_delay -max -clock [get_clocks {SYS_CLK}]  2.000 [get_ports {LEDR[4]}]
set_output_delay -add_delay -min -clock [get_clocks {SYS_CLK}]  1.000 [get_ports {LEDR[4]}]
set_output_delay -add_delay -max -clock [get_clocks {SYS_CLK}]  2.000 [get_ports {LEDR[5]}]
set_output_delay -add_delay -min -clock [get_clocks {SYS_CLK}]  1.000 [get_ports {LEDR[5]}]
set_output_delay -add_delay -max -clock [get_clocks {SYS_CLK}]  2.000 [get_ports {LEDR[6]}]
set_output_delay -add_delay -min -clock [get_clocks {SYS_CLK}]  1.000 [get_ports {LEDR[6]}]
set_output_delay -add_delay -max -clock [get_clocks {SYS_CLK}]  2.000 [get_ports {LEDR[7]}]
set_output_delay -add_delay -min -clock [get_clocks {SYS_CLK}]  1.000 [get_ports {LEDR[7]}]
set_output_delay -add_delay -max -clock [get_clocks {SYS_CLK}]  2.000 [get_ports {LEDR[8]}]
set_output_delay -add_delay -min -clock [get_clocks {SYS_CLK}]  1.000 [get_ports {LEDR[8]}]
set_output_delay -add_delay -max -clock [get_clocks {SYS_CLK}]  2.000 [get_ports {LEDR[9]}]
set_output_delay -add_delay -min -clock [get_clocks {SYS_CLK}]  1.000 [get_ports {LEDR[9]}]


#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

