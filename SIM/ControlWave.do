onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color Red /tb_control/rst
add wave -noupdate -color Red /tb_control/ena
add wave -noupdate /tb_control/clk
add wave -noupdate -color Cyan /tb_control/st
add wave -noupdate /tb_control/ld
add wave -noupdate /tb_control/mov
add wave -noupdate /tb_control/done_i
add wave -noupdate /tb_control/add
add wave -noupdate /tb_control/sub
add wave -noupdate /tb_control/jmp
add wave -noupdate /tb_control/jc
add wave -noupdate /tb_control/jnc
add wave -noupdate /tb_control/and_s
add wave -noupdate /tb_control/or_s
add wave -noupdate /tb_control/xor_s
add wave -noupdate /tb_control/Cflag
add wave -noupdate /tb_control/Zflag
add wave -noupdate /tb_control/Nflag
add wave -noupdate /tb_control/done_o
add wave -noupdate -color Magenta /tb_control/DTCM_wr
add wave -noupdate /tb_control/DTCM_addr_out
add wave -noupdate -color Magenta /tb_control/DTCM_addr_in
add wave -noupdate /tb_control/DTCM_out
add wave -noupdate -color Magenta /tb_control/Ain
add wave -noupdate /tb_control/RFin
add wave -noupdate -color Magenta /tb_control/RFout
add wave -noupdate -color Yellow /tb_control/IRin
add wave -noupdate -color Yellow /tb_control/PCin
add wave -noupdate /tb_control/Imm1_in
add wave -noupdate -color Magenta /tb_control/Imm2_in
add wave -noupdate /tb_control/DTCM_addr_sel
add wave -noupdate /tb_control/RFaddr_rd
add wave -noupdate /tb_control/RFaddr_wr
add wave -noupdate -color Yellow /tb_control/PCsel
add wave -noupdate /tb_control/ALUFN
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 189
configure wave -valuecolwidth 39
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {2003736 ps}
