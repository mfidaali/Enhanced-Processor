onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /enhanced_processor_top/SYS_CLK
add wave -noupdate /enhanced_processor_top/KEY
add wave -noupdate /enhanced_processor_top/SW
add wave -noupdate /enhanced_processor_top/LEDR
add wave -noupdate /enhanced_processor_top/output_LED_en
add wave -noupdate /enhanced_processor_top/memory_en
add wave -noupdate /enhanced_processor_top/Data2Mem
add wave -noupdate /enhanced_processor_top/Data2Proc
add wave -noupdate -divider Memory
add wave -noupdate /enhanced_processor_top/memory/address
add wave -noupdate /enhanced_processor_top/memory/clock
add wave -noupdate /enhanced_processor_top/memory/data
add wave -noupdate /enhanced_processor_top/memory/wren
add wave -noupdate /enhanced_processor_top/memory/q
add wave -noupdate -divider Processor
add wave -noupdate /enhanced_processor_top/p0/clk
add wave -noupdate /enhanced_processor_top/p0/reset_n
add wave -noupdate /enhanced_processor_top/p0/Run
add wave -noupdate /enhanced_processor_top/p0/DIN
add wave -noupdate /enhanced_processor_top/p0/DOUT
add wave -noupdate /enhanced_processor_top/p0/WEN
add wave -noupdate /enhanced_processor_top/p0/ADDR
add wave -noupdate -divider Instruction
add wave -noupdate /enhanced_processor_top/p0/Tstep_D
add wave -noupdate /enhanced_processor_top/p0/Tstep_Q
add wave -noupdate /enhanced_processor_top/p0/IRin
add wave -noupdate /enhanced_processor_top/p0/ADDRin
add wave -noupdate /enhanced_processor_top/p0/incr_PC
add wave -noupdate /enhanced_processor_top/p0/PC
add wave -noupdate /enhanced_processor_top/p0/IR
add wave -noupdate /enhanced_processor_top/p0/Instruction
add wave -noupdate /enhanced_processor_top/p0/Xreg
add wave -noupdate /enhanced_processor_top/p0/Yreg
add wave -noupdate /enhanced_processor_top/p0/BusWires
add wave -noupdate -divider {PC Counter}
add wave -noupdate /enhanced_processor_top/p0/ProgCount/aclr
#add wave -noupdate /enhanced_processor_top/p0/ProgCount/clock
add wave -noupdate /enhanced_processor_top/p0/ProgCount/cnt_en
#add wave -noupdate /enhanced_processor_top/p0/ProgCount/data
#add wave -noupdate /enhanced_processor_top/p0/ProgCount/sload
add wave -noupdate /enhanced_processor_top/p0/ProgCount/q
TreeUpdate [SetDefaultTree]
#WaveRestoreCursors {{Cursor 1} {200 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 296
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {805 ps}
force -freeze sim:/enhanced_processor_top/SYS_CLK 1 0, 0 {50 ps} -r 100
force -deposit sim:/enhanced_processor_top/KEY 0 0 -cancel 199
force -freeze sim:/enhanced_processor_top/KEY 1 200
#force -deposit sim:/enhanced_processor_top/SW 0 0 -cancel 399
#force -deposit sim:/enhanced_processor_top/SW 1 400
force -freeze sim:/enhanced_processor_top/SW 0 0, 1 {900 ps} -r 1000
log -r /*
run 4000