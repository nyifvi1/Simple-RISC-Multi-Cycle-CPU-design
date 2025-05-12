LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;
USE work.aux_package.all;
------------------------------------------------------------------
entity top is
generic(m : integer:=16;    --m is Dwidth of program memory
	    n : integer:=16;	--n is Dwidth of data memory
		Awidth : integer:=6);
port(	rst,clk,ena : in std_logic;
		PM_datain : in std_logic_vector(m-1 downto 0);
		DM_datain : in std_logic_vector(n-1 downto 0);
		DM_dataout : out std_logic_vector(n-1 downto 0);
		ITCM_tb_wr,DTCM_tb_wr,TBactive : in std_logic;
		ITCM_tb_addr_in : in std_logic_vector(Awidth-1 downto 0);
		DTCM_tb_addr_in,DTCM_tb_addr_out : in std_logic_vector(n-1 downto 0);
		done_o : out std_logic);
end top;
------------------------------------------------------------------
architecture top of top is
signal st,ld,mov,done_i,add,sub,jmp,jc,jnc,and_s,or_s,xor_s,Cflag,Zflag,Nflag : std_logic;
signal DTCM_wr,DTCM_addr_out,DTCM_addr_in,DTCM_out,Ain,RFin,RFout,IRin,PCin,Imm1_in,Imm2_in,DTCM_addr_sel : std_logic;
signal RFaddr_rd,RFaddr_wr,PCsel : std_logic_vector(1 downto 0);
signal ALUFN : std_logic_vector(3 downto 0);
begin
C1 : Control port map(rst=>rst,ena=>ena,clk=>clk,st=>st,ld=>ld,mov=>mov,done_i=>done_i,add=>add,sub=>sub,jmp=>jmp,
		jc=>jc,jnc=>jnc,and_s=>and_s,or_s=>or_s,xor_s=>xor_s,Cflag=>Cflag,Zflag=>Zflag,Nflag=>Nflag,
		done_o=>done_o,
		DTCM_wr=>DTCM_wr,DTCM_addr_out=>DTCM_addr_out,DTCM_addr_in=>DTCM_addr_in,DTCM_out=>DTCM_out,Ain=>Ain,RFin=>RFin,
		RFout=>RFout,IRin=>IRin,PCin=>PCin,Imm1_in=>Imm1_in,Imm2_in=>Imm2_in,DTCM_addr_sel=>DTCM_addr_sel,
		RFaddr_rd=>RFaddr_rd,RFaddr_wr=>RFaddr_wr,PCsel=>PCsel,
		ALUFN=>ALUFN);
		
C2 : Datapath port map(PM_datain=>PM_datain,DM_datain=>DM_datain,clk=>clk,rst=>rst,ITCM_tb_wr=>ITCM_tb_wr,
		DTCM_tb_wr=>DTCM_tb_wr,TBactive=>TBactive,ITCM_tb_addr_in=>ITCM_tb_addr_in,DTCM_tb_addr_in=>DTCM_tb_addr_in,
		DTCM_tb_addr_out=>DTCM_tb_addr_out,DTCM_wr=>DTCM_wr,DTCM_addr_out=>DTCM_addr_out,DTCM_addr_in=>DTCM_addr_in,
		DTCM_out=>DTCM_out,Ain=>Ain,RFin=>RFin,RFout=>RFout,IRin=>IRin,PCin=>PCin,Imm1_in=>Imm1_in,Imm2_in=>Imm2_in,
		DTCM_addr_sel=>DTCM_addr_sel,RFaddr_rd=>RFaddr_rd,RFaddr_wr=>RFaddr_wr,PCsel=>PCsel,ALUFN=>ALUFN,
		DM_dataout=>DM_dataout,st=>st,ld=>ld,mov=>mov,done=>done_i,add=>add,sub=>sub,jmp=>jmp,jc=>jc,jnc=>jnc,
		and_s=>and_s,or_s=>or_s,xor_s=>xor_s,Cflag=>Cflag,Zflag=>Zflag,Nflag=>Nflag);
end top;





