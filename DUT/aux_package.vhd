LIBRARY ieee;
USE ieee.std_logic_1164.all;


package aux_package is

component ProgMem is
generic( Dwidth: integer:=16;
		 Awidth: integer:=6;
		 dept:   integer:=64);
port(	clk,memEn: in std_logic;	
		WmemData:	in std_logic_vector(Dwidth-1 downto 0);
		WmemAddr,RmemAddr: in std_logic_vector(Awidth-1 downto 0);
		RmemData: 	out std_logic_vector(Dwidth-1 downto 0));
end component;
  
component dataMem is
generic( Dwidth: integer:=16;
		 Awidth: integer:=6;
		 dept:   integer:=64);
port(	clk,memEn : in std_logic;	
		WmemData : in std_logic_vector(Dwidth-1 downto 0);
		WmemAddr,RmemAddr : in std_logic_vector(Awidth-1 downto 0);
		RmemData : out std_logic_vector(Dwidth-1 downto 0));
end component;

component RF is
generic( Dwidth: integer:=16;
		 Awidth: integer:=4);
port(	clk,rst,WregEn : in std_logic;	
		WregData : in std_logic_vector(Dwidth-1 downto 0);
		WregAddr,RregAddr :	in std_logic_vector(Awidth-1 downto 0);
		RregData : out std_logic_vector(Dwidth-1 downto 0));
end component;

component PC_Register is
generic( Awidth : integer:=6;
		 dept : integer:=64);
port(	clk,PCin : in std_logic;	
		PCsel : in std_logic_vector(1 downto 0);
		IR : in std_logic_vector(7 downto 0);
		readAddr : out std_logic_vector(Awidth-1 downto 0));
end component;

component OPC_Decoder is
port(	OPC : in std_logic_vector(3 downto 0);	
		st,ld,mov,done,add,sub,jmp,jc,jnc,and_s,or_s,xor_s : out std_logic);
end component;

component IR is
generic(Dwidth : integer:=16;
	    Awidth : integer:=4);
port(	PM_dataOut : in std_logic_vector(Dwidth-1 downto 0);
		IRin,clk : in std_logic;
		IR_Reg : out std_logic_vector(Dwidth-1 downto 0));
end component;

component ALU is
generic(Dwidth : integer:=16);
port(	BUS_B : in std_logic_vector(Dwidth-1 downto 0);
		Ain,clk : in std_logic;
		ALUFN : in std_logic_vector(3 downto 0);
		BUS_A : inout std_logic_vector(Dwidth-1 downto 0);
		Cflag,Zflag,Nflag : out std_logic);
end component;

component Control is
generic(Dwidth : integer:=16);
port(	rst,ena,clk : in std_logic;
		st,ld,mov,done_i,add,sub,jmp,jc,jnc,and_s,or_s,xor_s,Cflag,Zflag,Nflag : in std_logic;
		done_o : out std_logic;
		DTCM_wr,DTCM_addr_out,DTCM_addr_in,DTCM_out,Ain,RFin,RFout,IRin,PCin,Imm1_in,Imm2_in,DTCM_addr_sel : out std_logic;
		RFaddr_rd,RFaddr_wr,PCsel : out std_logic_vector(1 downto 0);
		ALUFN : out std_logic_vector(3 downto 0));
end component;

component BidirPin is
	generic( width: integer:=16 );
	port(   Dout : in std_logic_vector(width-1 downto 0);
			en : in std_logic;
			IOpin : out std_logic_vector(width-1 downto 0));
end component;

component Datapath is
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
end component;

component top is
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
end component;

component AdderSub IS
	GENERIC (n : INTEGER := 8);
	PORT (x,y : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		  sub_c : IN STD_LOGIC;
		  cout : OUT STD_LOGIC;
		  res : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0));
END component;
end aux_package;

