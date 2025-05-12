onerror {resume}
add list -width 24 /tb_datapath/PM_datain
add list /tb_datapath/DM_datain
add list /tb_datapath/clk
add list /tb_datapath/rst
add list /tb_datapath/ITCM_tb_wr
add list /tb_datapath/DTCM_tb_wr
add list /tb_datapath/TBactive
add list /tb_datapath/ITCM_tb_addr_in
add list /tb_datapath/DTCM_tb_addr_in
add list /tb_datapath/DTCM_tb_addr_out
add list /tb_datapath/DTCM_wr
add list /tb_datapath/DTCM_addr_out
add list /tb_datapath/DTCM_addr_in
add list /tb_datapath/DTCM_out
add list /tb_datapath/Ain
add list /tb_datapath/RFin
add list /tb_datapath/RFout
add list /tb_datapath/IRin
add list /tb_datapath/PCin
add list /tb_datapath/Imm1_in
add list /tb_datapath/Imm2_in
add list /tb_datapath/DTCM_addr_sel
add list /tb_datapath/RFaddr_rd
add list /tb_datapath/RFaddr_wr
add list /tb_datapath/PCsel
add list /tb_datapath/ALUFN
add list /tb_datapath/DM_dataout
add list /tb_datapath/st
add list /tb_datapath/ld
add list /tb_datapath/mov
add list /tb_datapath/done
add list /tb_datapath/add
add list /tb_datapath/sub
add list /tb_datapath/jmp
add list /tb_datapath/jc
add list /tb_datapath/jnc
add list /tb_datapath/and_s
add list /tb_datapath/or_s
add list /tb_datapath/xor_s
add list /tb_datapath/Cflag
add list /tb_datapath/Zflag
add list /tb_datapath/Nflag
add list /tb_datapath/doneDatMemIn
add list /tb_datapath/doneProgMemIn
configure list -usestrobe 0
configure list -strobestart {0 ps} -strobeperiod {0 ps}
configure list -usesignaltrigger 1
configure list -delta collapse
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
