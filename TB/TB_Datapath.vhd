library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
use std.textio.all;
use IEEE.STD_LOGIC_TEXTIO.all;
---------------------------------------------------------
entity TB_Datapath is
	constant	m : integer:=16;    --m is Dwidth of program memory
	constant    n : integer:=16;	--n is Dwidth of data memory
	constant	Awidth : integer:=6;
	
	constant dataMemResult:	 	string(1 to 56) :=
	"C:\Users\nyifv\Desktop\LAB3\Memory files\DTCMcontent.txt";

	constant dataMemLocation: 	string(1 to 53) :=
	"C:\Users\nyifv\Desktop\LAB3\Memory files\DTCMinit.txt";

	constant progMemLocation: 	string(1 to 53) :=
	"C:\Users\nyifv\Desktop\LAB3\Memory files\ITCMinit.txt";
end TB_Datapath;
---------------------------------------------------------
architecture TB_Datapath of TB_Datapath is
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
		st,ld,mov,done,add,sub,jmp,jc,jnc,and_s,or_s,xor_s,Cflag,Zflag,Nflag : out std_logic
		);
end component;
signal	PM_datain : std_logic_vector(m-1 downto 0);
signal	DM_datain : std_logic_vector(n-1 downto 0);
signal	clk,rst : std_logic;
signal	ITCM_tb_wr,DTCM_tb_wr,TBactive : std_logic;
signal	ITCM_tb_addr_in : std_logic_vector(Awidth-1 downto 0);
signal	DTCM_tb_addr_in,DTCM_tb_addr_out : std_logic_vector(n-1 downto 0);
signal	DTCM_wr,DTCM_addr_out,DTCM_addr_in,DTCM_out,Ain,RFin,RFout,IRin,PCin,Imm1_in,Imm2_in,DTCM_addr_sel : std_logic;
signal	RFaddr_rd,RFaddr_wr,PCsel : std_logic_vector(1 downto 0);
signal	ALUFN : std_logic_vector(3 downto 0);
signal	DM_dataout : std_logic_vector(n-1 downto 0);
signal	st,ld,mov,done,add,sub,jmp,jc,jnc,and_s,or_s,xor_s,Cflag,Zflag,Nflag : std_logic;
SIGNAL doneDatMemIn,doneProgMemIn: BOOLEAN;		

begin
L0 : Datapath generic map (m,n,Awidth) port map(PM_datain=>PM_datain,DM_datain=>DM_datain,clk=>clk,rst=>rst,
	ITCM_tb_wr=>ITCM_tb_wr,DTCM_tb_wr=>DTCM_tb_wr,TBactive=>TBactive,ITCM_tb_addr_in=>ITCM_tb_addr_in,
	DTCM_tb_addr_in=>DTCM_tb_addr_in,DTCM_tb_addr_out=>DTCM_tb_addr_out,DTCM_wr=>DTCM_wr,DTCM_addr_out=>DTCM_addr_out,
	DTCM_addr_in=>DTCM_addr_in,DTCM_out=>DTCM_out,Ain=>Ain,RFin=>RFin,RFout=>RFout,IRin=>IRin,PCin=>PCin,Imm1_in=>Imm1_in,
	Imm2_in=>Imm2_in,DTCM_addr_sel=>DTCM_addr_sel,RFaddr_rd=>RFaddr_rd,RFaddr_wr=>RFaddr_wr,PCsel=>PCsel,ALUFN=>ALUFN,
	DM_dataout=>DM_dataout,st=>st,ld=>ld,mov=>mov,done=>done,add=>add,sub=>sub,jmp=>jmp,jc=>jc,jnc=>jnc,and_s=>and_s,
	or_s=>or_s,xor_s=>xor_s,Cflag=>Cflag,Zflag=>Zflag,Nflag=>Nflag);
-----------------------DataMem Initializing----------------------- 
LoadDataMem: process 
	file InDataMemFile : text open read_mode is dataMemLocation; 
	variable    linetomem : std_logic_vector(n-1 downto 0);
	variable	good : boolean;
	variable 	L : line;
	variable	TempAddr : std_logic_vector(n-1 downto 0) ; -- Awidth TempAddr
begin 
	doneDatMemIn <= false;
	TempAddr := (others => '0');
	while not endfile(InDataMemFile) loop
		readline(InDataMemFile,L);
		hread(L,linetomem,good);         -- hread is hexa read
		next when not good;
		DTCM_tb_wr <= '1';
		DTCM_tb_addr_in <= TempAddr;
		DM_datain <= linetomem;
		wait until rising_edge(clk);
		TempAddr := TempAddr +1;
	end loop;
	DTCM_tb_wr <= '0';
	doneDatMemIn <= true;
	file_close(InDataMemFile);
	wait;
end process;								
-----------------------ProgMem Initializing----------------------- 
LoadProgramMem: process 
	file InProgMemFile : text open read_mode is progMemLocation; 
	variable    linetomem : std_logic_vector(n-1 downto 0); 
	variable	good : boolean;
	variable 	L : line;
	variable	TempAddr : std_logic_vector(Awidth-1 downto 0) ; -- Awidth
begin 
	doneProgMemIn <= false;
	TempAddr := (others => '0');
	while not endfile(InProgMemFile) loop
		readline(InProgMemFile,L);
		hread(L,linetomem,good);
		next when not good;
		ITCM_tb_wr <= '1';
		ITCM_tb_addr_in <= TempAddr;
		PM_datain <= linetomem;
		wait until rising_edge(clk);
		TempAddr := TempAddr +1;
	end loop ;
	ITCM_tb_wr <= '0';
	doneProgMemIn <= true;
	file_close(InProgMemFile);
	wait;
end process;	
-----------------------start of stimulus section----------------------- 			
gen_clock : process
			begin
			clk <= '1';
			wait for 50 ns;
			clk <= not clk;
			wait for 50 ns;
			end process;
			
rst <= '0' when (doneDatMemIn and doneProgMemIn) else '1';   
	
gen_TB : process  --TBactive = 1 when loading DataMem,ProgMem after TBactive = 0 to start simulation
	begin
	 TBactive <= '1';
	 wait until doneDatMemIn and doneProgMemIn;	 
	 TBactive <= '0'; 
	 
--reset
-----------------------------Reset-----------------------------
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='0';PCin<='1';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="10";
	ALUFN<="1111";
	wait until clk'event and clk='1';	
--load	
-----------------------------Fetch-----------------------------
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='1';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="1111";
	wait until clk'event and clk='1';	
-----------------------------Decode-----------------------------
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='0';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="1111";
	wait until clk'event and clk='1';	
-----------------------------R1-----------------------------	
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='1';RFin<='0';RFout<='1';IRin<='0';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="01";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="0000";
	wait until clk'event and clk='1';
-----------------------------ld1-----------------------------	
	DTCM_wr<='0';DTCM_addr_out<='1';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='0';PCin<='0';Imm1_in<='0';Imm2_in<='1';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="0001";
	wait until clk'event and clk='1';
-----------------------------ld2-----------------------------	
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='0';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="1111";
	wait until clk'event and clk='1';
-----------------------------ld3-----------------------------	
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='1';Ain<='0';RFin<='1';RFout<='0';IRin<='0';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="10";PCsel<="00";
	ALUFN<="0000";
	wait until clk'event and clk='1';
-----------------------------PCinc1-----------------------------	
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='0';PCin<='1';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="1111";
	wait until clk'event and clk='1';
--load	
-----------------------------Fetch-----------------------------
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='1';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="1111";
	wait until clk'event and clk='1';
-----------------------------Decode-----------------------------
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='0';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="1111";
	wait until clk'event and clk='1';
-----------------------------R1-----------------------------	
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='1';RFin<='0';RFout<='1';IRin<='0';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="01";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="0000";
	wait until clk'event and clk='1';
-----------------------------ld1-----------------------------	
	DTCM_wr<='0';DTCM_addr_out<='1';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='0';PCin<='0';Imm1_in<='0';Imm2_in<='1';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="0001";
	wait until clk'event and clk='1';
-----------------------------ld2-----------------------------	
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='0';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="1111";
	wait until clk'event and clk='1';
-----------------------------ld3-----------------------------	
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='1';Ain<='0';RFin<='1';RFout<='0';IRin<='0';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="10";PCsel<="00";
	ALUFN<="0000";
	wait until clk'event and clk='1';
-----------------------------PCinc1-----------------------------	
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='0';PCin<='1';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="1111";
	wait until clk'event and clk='1';
--mov
-----------------------------Fetch-----------------------------
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='1';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="1111";
	wait until clk'event and clk='1';
-----------------------------Decode-----------------------------
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='0';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="1111";
	wait until clk'event and clk='1';
-----------------------------M-----------------------------	
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='1';RFout<='0';IRin<='0';PCin<='0';Imm1_in<='1';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="10";PCsel<="00";
	ALUFN<="0000";
	wait until clk'event and clk='1';
-----------------------------PCinc1-----------------------------	
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='0';PCin<='1';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="1111";
	wait until clk'event and clk='1';
--mov
-----------------------------Fetch-----------------------------
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='1';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="1111";
	wait until clk'event and clk='1';
-----------------------------Decode-----------------------------
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='0';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="1111";
	wait until clk'event and clk='1';
-----------------------------M-----------------------------	
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='1';RFout<='0';IRin<='0';PCin<='0';Imm1_in<='1';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="10";PCsel<="00";
	ALUFN<="0000";
	wait until clk'event and clk='1';
-----------------------------PCinc1-----------------------------	
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='0';PCin<='1';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="1111";
	wait until clk'event and clk='1';
--mov
-----------------------------Fetch-----------------------------
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='1';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="1111";
	wait until clk'event and clk='1';
-----------------------------Decode-----------------------------
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='0';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="1111";
	wait until clk'event and clk='1';
-----------------------------M-----------------------------	
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='1';RFout<='0';IRin<='0';PCin<='0';Imm1_in<='1';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="10";PCsel<="00";
	ALUFN<="0000";
	wait until clk'event and clk='1';
-----------------------------PCinc1-----------------------------	
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='0';PCin<='1';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="1111";	
	wait until clk'event and clk='1';
--and
-----------------------------Fetch-----------------------------
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='1';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="1111";
	wait until clk'event and clk='1';
-----------------------------Decode-----------------------------
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='0';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="1111";
	wait until clk'event and clk='1';
-----------------------------R1-----------------------------	
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='1';RFin<='0';RFout<='1';IRin<='0';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="01";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="0000";
	wait until clk'event and clk='1';
-----------------------------R2(and)-----------------------------	
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='1';RFout<='1';IRin<='0';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="10";PCsel<="00";	
	ALUFN<="0100";
	wait until clk'event and clk='1';
-----------------------------PCinc1-----------------------------	
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='0';PCin<='1';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="1111";	
	wait until clk'event and clk='1';
--and
-----------------------------Fetch-----------------------------
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='1';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="1111";
	wait until clk'event and clk='1';
-----------------------------Decode-----------------------------
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='0';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="1111";
	wait until clk'event and clk='1';
-----------------------------R1-----------------------------	
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='1';RFin<='0';RFout<='1';IRin<='0';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="01";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="0000";
	wait until clk'event and clk='1';
-----------------------------R2(and)-----------------------------	
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='1';RFout<='1';IRin<='0';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="10";PCsel<="00";	
	ALUFN<="0100";
	wait until clk'event and clk='1';
-----------------------------PCinc1-----------------------------	
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='0';PCin<='1';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="1111";	
	wait until clk'event and clk='1';
--sub
-----------------------------Fetch-----------------------------
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='1';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="1111";
	wait until clk'event and clk='1';
-----------------------------Decode-----------------------------
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='0';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="1111";
	wait until clk'event and clk='1';
-----------------------------R1-----------------------------	
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='1';RFin<='0';RFout<='1';IRin<='0';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="01";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="0000";
	wait until clk'event and clk='1';
-----------------------------R2(sub)-----------------------------	
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='1';RFout<='1';IRin<='0';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="10";PCsel<="00";	
	ALUFN<="0011";
	wait until clk'event and clk='1';
-----------------------------PCinc1-----------------------------	
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='0';PCin<='1';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="1111";
	wait until clk'event and clk='1';	

--jc(false)
-----------------------------Fetch-----------------------------
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='1';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="1111";
	wait until clk'event and clk='1';
-----------------------------Decode-----------------------------
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='0';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="1111";
	wait until clk'event and clk='1';
-----------------------------PCinc1-----------------------------	
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='0';PCin<='1';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="1111";
	wait until clk'event and clk='1';	
--add
-----------------------------Fetch-----------------------------
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='1';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="1111";
	wait until clk'event and clk='1';
-----------------------------Decode-----------------------------
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='0';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="1111";
	wait until clk'event and clk='1';
-----------------------------R1-----------------------------	
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='1';RFin<='0';RFout<='1';IRin<='0';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="01";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="0000";
	wait until clk'event and clk='1';
-----------------------------R2(add)-----------------------------	
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='1';RFout<='1';IRin<='0';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="10";PCsel<="00";	
	ALUFN<="0001";
	wait until clk'event and clk='1';
-----------------------------PCinc1-----------------------------	
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='0';PCin<='1';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="1111";
	wait until clk'event and clk='1';
--jmp
-----------------------------Fetch-----------------------------
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='1';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="1111";
	wait until clk'event and clk='1';
-----------------------------Decode-----------------------------
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='0';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="1111";
	wait until clk'event and clk='1';
-----------------------------J-----------------------------
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='0';PCin<='1';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="01";
	ALUFN<="1111";
	wait until clk'event and clk='1';
--st
-----------------------------Fetch-----------------------------
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='1';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="1111";
	wait until clk'event and clk='1';
-----------------------------Decode-----------------------------
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='0';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="1111";
	wait until clk'event and clk='1';
-----------------------------R1-----------------------------	
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='1';RFin<='0';RFout<='1';IRin<='0';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="01";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="0000";
	wait until clk'event and clk='1';	
-----------------------------st1-----------------------------	
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='1';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='0';PCin<='0';Imm1_in<='0';Imm2_in<='1';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="0001";
	wait until clk'event and clk='1';	
-----------------------------st2-----------------------------	
	DTCM_wr<='1';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='1';IRin<='0';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="10";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="1111";
	wait until clk'event and clk='1';	
-----------------------------PCinc1-----------------------------	
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='0';PCin<='1';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="1111";		
	wait until clk'event and clk='1';
--done
-----------------------------Fetch-----------------------------
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='1';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="1111";
	wait until clk'event and clk='1';
-----------------------------Decode-----------------------------
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='0';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="1111"; 
	wait until clk'event and clk='1';
-----------------------------done-----------------------------
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='0';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="1111";
	wait until clk'event and clk='1';
-----------------------------PCinc1-----------------------------	
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='0';PCin<='1';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="1111";
	wait until clk'event and clk='1';
	TBactive <= '1'; --when done state ends start exporting ProgMem
--add(nop)
-----------------------------Fetch-----------------------------
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='1';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="1111";
	wait until clk'event and clk='1';
-----------------------------Decode-----------------------------
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='0';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="1111";
	wait until clk'event and clk='1';
-----------------------------R1-----------------------------	
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='1';RFin<='0';RFout<='1';IRin<='0';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="01";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="0000";
	wait until clk'event and clk='1';
-----------------------------R2(add)-----------------------------	
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='1';RFout<='1';IRin<='0';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="10";PCsel<="00";	
	ALUFN<="0001";
	wait until clk'event and clk='1';
-----------------------------PCinc1-----------------------------	
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='0';PCin<='1';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="1111";	
	wait until clk'event and clk='1';
--jmp
-----------------------------Fetch-----------------------------
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='1';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="1111";
	wait until clk'event and clk='1';
-----------------------------Decode-----------------------------
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='0';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
	ALUFN<="1111";
	wait until clk'event and clk='1';
-----------------------------J-----------------------------
	DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='0';PCin<='1';Imm1_in<='0';Imm2_in<='0';			
	DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="01";
	ALUFN<="1111";
------------------------------------------------------------------	 
	end process;
	
-----------------------ProgMem Exporting (when done=1)----------------------- 
WriteToDataMem: process 
	file OutProgMemFile : text open write_mode is dataMemResult; 
	variable    linetomem			: std_logic_vector(n-1 downto 0);
	variable	good				: boolean;
	variable 	L 					: line;
	variable	TempAddr		: std_logic_vector(n-1 downto 0) ; -- Awidth
	variable 	counter				: integer;
begin 
	wait until TBactive='1' and done = '1';  
	TempAddr := (others => '0');
	counter := 0;
	while counter < 64 loop	    --Depth of ProgMem 
		DTCM_tb_addr_out <= TempAddr;
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		hwrite(L,DM_dataout); -- hwrite is hexa write
		writeline(OutProgMemFile,L);
		TempAddr := TempAddr +1;
		counter := counter +1;
	end loop ;
	file_close(OutProgMemFile);
	wait;
end process;	
end architecture TB_Datapath;
