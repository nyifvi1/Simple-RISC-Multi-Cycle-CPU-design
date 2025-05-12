library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use work.aux_package.all;

--------------------------------------------------------------
entity Datapath is
generic(m : integer:=16;    --m is Dwidth of program memory
	    n : integer:=16;	--n is Dwidth of data memory
		Awidth : integer:=6);
port(	PM_datain : in std_logic_vector(m-1 downto 0);
		DM_datain : in std_logic_vector(n-1 downto 0);
		clk,rst : in std_logic;
		ITCM_tb_wr,DTCM_tb_wr,TBactive : in std_logic;
		ITCM_tb_addr_in : in std_logic_vector(Awidth-1 downto 0);
		DTCM_tb_addr_in,DTCM_tb_addr_out : in std_logic_vector(n-1 downto 0);
		DTCM_wr,DTCM_addr_out,DTCM_addr_in,DTCM_out,Ain,RFin,RFout,IRin,PCin,Imm1_in,Imm2_in,DTCM_addr_sel : in std_logic;
		RFaddr_rd,RFaddr_wr,PCsel : in std_logic_vector(1 downto 0);
		ALUFN : in std_logic_vector(3 downto 0);
		DM_dataout : out std_logic_vector(n-1 downto 0);
		st,ld,mov,done,add,sub,jmp,jc,jnc,and_s,or_s,xor_s,Cflag,Zflag,Nflag : out std_logic);
end Datapath;
--------------------------------------------------------------
architecture Datapath of Datapath is
signal readAddr_PM : std_logic_vector(Awidth-1 downto 0); 
signal RmemData_PM,IR_o : std_logic_vector(m-1 downto 0);
signal memEn_DM,Cflag_ALU,Nflag_ALU,Zflag_ALU,add_OPC,sub_OPC : std_logic;
signal WmemData_DM,BUS_B,Q0,Q1,D0,D1,WmemAddr_DM,RmemAddr_DM,RmemData_DM,BUS_A,RregData : std_logic_vector(n-1 downto 0);
signal WregAddr,RregAddr : std_logic_vector(3 downto 0);
signal IR_o_ext  : std_logic_vector(15 downto 0);
signal IR_o_ext2 : std_logic_vector(15 downto 0);
begin			   
C1 : progMem port map(clk=>clk,
					  memEn=>ITCM_tb_wr,
					  WmemData=>PM_datain,
					  WmemAddr=>ITCM_tb_addr_in,
					  RmemAddr=>readAddr_PM,
					  RmemData=>RmemData_PM); 

memEn_DM <= DTCM_wr when TBactive='0' else DTCM_tb_wr;
WmemData_DM <= BUS_B when TBactive='0' else DM_datain; 
WmemAddr_DM <= Q1 when TBactive='0' else DTCM_tb_addr_in;
RmemAddr_DM <= Q0 when TBactive='0' else DTCM_tb_addr_out;
DM_dataout <= RmemData_DM;
D0 <= BUS_A when DTCM_addr_sel='0' else BUS_B; 
D1 <= BUS_A when DTCM_addr_sel='0' else BUS_B; 
-----------------------------------------------------------
process(clk)	--DFF 0
begin
if (clk'event and clk='1') then
	if (DTCM_addr_out='1') then
		Q0 <= D0;
	end if;
end if;
end process;

process(clk)     --DFF 1
begin
if (clk'event and clk='1') then
	if (DTCM_addr_in='1') then
		Q1 <= D1;
	end if;
end if;
end process;  
-----------------------------------------------------------
C2 : dataMem port map(clk=>clk,
					  memEn=>memEn_DM,
					  WmemData=>WmemData_DM,
					  WmemAddr=>WmemAddr_DM(Awidth-1 downto 0),
					  RmemAddr=>RmemAddr_DM(Awidth-1 downto 0),
					  RmemData=>RmemData_DM); 


C3 : PC_Register port map(clk=>clk,
					  PCin=>PCin,
					  PCsel=>PCsel,
					  IR=>IR_o(7 downto 0),
					  readAddr=>readAddr_PM); 
					  
C4 : IR 		 port map(clk=>clk,
					  PM_dataOut=>RmemData_PM,
					  IRin=>IRin,
					  IR_Reg=>IR_o); 					  

C5 : OPC_Decoder port map(OPC=>IR_o(m-1 downto m-4),
					  st=>st,
					  ld=>ld,
					  mov=>mov,
					  done=>done,
					  add=>add_OPC,
					  sub=>sub_OPC,
					  jmp=>jmp,
					  jc=>jc,
					  jnc=>jnc,
					  and_s=>and_s,
					  or_s=>or_s,
					  xor_s=>xor_s); 
					  
add <= add_OPC;  --Auxilary net for flags updade
sub <= sub_OPC;	 --Auxilary net for flags updade
-----------------------------------------------------------
WregAddr <= IR_o(3 downto 0) when RFaddr_wr="00" else IR_o(7 downto 4) when RFaddr_wr="01" else IR_o(11 downto 8);
RregAddr <= IR_o(3 downto 0) when RFaddr_rd="00" else IR_o(7 downto 4) when RFaddr_rd="01" else IR_o(11 downto 8);    
C6 : RF 		 port map(clk=>clk,
					  rst=>rst,
					  WregEn=>RFin,
					  WregData=>BUS_A,
					  WregAddr=>WregAddr,
					  RregAddr=>RregAddr,
					  RregData=>RregData); 					  

C7 : ALU 		 port map(clk=>clk,
					  BUS_B=>BUS_B,
					  Ain=>Ain,
					  ALUFN=>ALUFN,
					  BUS_A=>BUS_A,
					  Cflag=>Cflag_ALU,
					  Zflag=>Zflag_ALU,
					  Nflag=>Nflag_ALU); 	
-----------------------------------------------------------
process(clk)
begin
if (clk'event and clk='1') then
	if ((add_OPC='1' and ALUFN="0001")or(sub_OPC='1' and ALUFN="0011")) then  --if C=A+B or C=A-B update flags otherwise save previous
			Cflag <= Cflag_ALU;
			Nflag <= Nflag_ALU;
			Zflag <= Zflag_ALU;
	end if;
end if;
end process;
-----------------------------------------------------------
IR_o_ext  <= (15 downto 8 => IR_o(7)) & IR_o(7 downto 0);   -- Sign extension for Imm1
IR_o_ext2 <= (15 downto 4 => IR_o(3)) & IR_o(3 downto 0);   -- Sign extension for Imm2
-----------------------------------------------------------
Imm1_Tri : BidirPin generic map(n) 	 port map(Dout => IR_o_ext,
											  en=>Imm1_in,
					                          IOpin=>BUS_B);
								  
Imm2_Tri : BidirPin generic map(n)	 port map(Dout=> IR_o_ext2,
								              en=>Imm2_in,
					                          IOpin=>BUS_B);
								  
RF_Tri : BidirPin 	generic map(n) 	port map(Dout=>RregData,
								             en=>RFout,
					                         IOpin=>BUS_B);
								  
DM_Tri : BidirPin 	generic map(n) 	port map(Dout=>RmemData_DM,
											 en=>DTCM_out,
											 IOpin=>BUS_B);								  					  
end architecture Datapath;