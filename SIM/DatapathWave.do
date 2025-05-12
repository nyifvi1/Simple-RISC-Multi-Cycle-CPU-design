onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /tb_datapath/PM_datain
add wave -noupdate -radix hexadecimal /tb_datapath/DM_datain
add wave -noupdate /tb_datapath/clk
add wave -noupdate /tb_datapath/rst
add wave -noupdate /tb_datapath/ITCM_tb_wr
add wave -noupdate /tb_datapath/DTCM_tb_wr
add wave -noupdate -color Magenta /tb_datapath/TBactive
add wave -noupdate /tb_datapath/ITCM_tb_addr_in
add wave -noupdate -radix hexadecimal /tb_datapath/DTCM_tb_addr_in
add wave -noupdate -color Yellow -radix hexadecimal /tb_datapath/DTCM_tb_addr_out
add wave -noupdate /tb_datapath/DTCM_wr
add wave -noupdate /tb_datapath/DTCM_addr_out
add wave -noupdate /tb_datapath/DTCM_addr_in
add wave -noupdate /tb_datapath/DTCM_out
add wave -noupdate /tb_datapath/Ain
add wave -noupdate /tb_datapath/RFin
add wave -noupdate /tb_datapath/RFout
add wave -noupdate /tb_datapath/IRin
add wave -noupdate /tb_datapath/PCin
add wave -noupdate /tb_datapath/Imm1_in
add wave -noupdate /tb_datapath/Imm2_in
add wave -noupdate /tb_datapath/DTCM_addr_sel
add wave -noupdate /tb_datapath/RFaddr_rd
add wave -noupdate /tb_datapath/RFaddr_wr
add wave -noupdate /tb_datapath/PCsel
add wave -noupdate /tb_datapath/ALUFN
add wave -noupdate -color Yellow -radix hexadecimal /tb_datapath/DM_dataout
add wave -noupdate /tb_datapath/st
add wave -noupdate /tb_datapath/ld
add wave -noupdate /tb_datapath/mov
add wave -noupdate -color Magenta /tb_datapath/done
add wave -noupdate /tb_datapath/add
add wave -noupdate /tb_datapath/sub
add wave -noupdate /tb_datapath/jmp
add wave -noupdate /tb_datapath/jc
add wave -noupdate /tb_datapath/jnc
add wave -noupdate /tb_datapath/and_s
add wave -noupdate /tb_datapath/or_s
add wave -noupdate /tb_datapath/xor_s
add wave -noupdate /tb_datapath/Cflag
add wave -noupdate /tb_datapath/Zflag
add wave -noupdate /tb_datapath/Nflag
add wave -noupdate /tb_datapath/doneDatMemIn
add wave -noupdate /tb_datapath/doneProgMemIn
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {7892965 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 238
configure wave -valuecolwidth 69
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
WaveRestoreZoom {7665139 ps} {9305765 ps}
