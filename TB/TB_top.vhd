library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
USE work.aux_package.all;
use std.textio.all;
use IEEE.STD_LOGIC_TEXTIO.all;
---------------------------------------------------------
entity TB_Top is
	constant	m : integer:=16;    --m is Dwidth of program memory
	constant    n : integer:=16;	--n is Dwidth of data memory
	constant	Awidth : integer:=6;
	
	constant dataMemResult:	 	string(1 to 56) :=
	"C:\Users\nyifv\Desktop\LAB3\Memory files\DTCMcontent.txt";
	
	constant dataMemLocation: 	string(1 to 53) :=
	"C:\Users\nyifv\Desktop\LAB3\Memory files\DTCMinit.txt";
	
	constant progMemLocation: 	string(1 to 53) :=
	"C:\Users\nyifv\Desktop\LAB3\Memory files\ITCMinit.txt";
end TB_Top;
---------------------------------------------------------
architecture TB_Top of TB_Top is
signal		rst,clk,ena : std_logic;
signal		PM_datain : std_logic_vector(m-1 downto 0);
signal		DM_datain : std_logic_vector(n-1 downto 0);
signal		DM_dataout : std_logic_vector(n-1 downto 0);
signal		ITCM_tb_wr,DTCM_tb_wr,TBactive : std_logic;
signal		ITCM_tb_addr_in : std_logic_vector(Awidth-1 downto 0);
signal		DTCM_tb_addr_in,DTCM_tb_addr_out : std_logic_vector(n-1 downto 0);
signal		done_o : std_logic;
SIGNAL doneDatMemIn,doneProgMemIn: BOOLEAN;		
begin
C1 : top port map(rst=>rst,clk=>clk,ena=>ena,PM_datain=>PM_datain,DM_datain=>DM_datain,DM_dataout=>DM_dataout,
			ITCM_tb_wr=>ITCM_tb_wr,DTCM_tb_wr=>DTCM_tb_wr,TBactive=>TBactive,ITCM_tb_addr_in=>ITCM_tb_addr_in,
			DTCM_tb_addr_in=>DTCM_tb_addr_in,DTCM_tb_addr_out=>DTCM_tb_addr_out,done_o=>done_o);
--------------------------------------------------------------------------------------------------------
gen_clock : process
			begin
			clk <= '1';
			wait for 50 ns;
			clk <= not clk;
			wait for 50 ns;
			end process;
			
gen_TB : process  --TBactive = 1 when loading DataMem,ProgMem after TBactive = 0 to start simulation
	begin
	 TBactive <= '1';
	 wait until doneDatMemIn and doneProgMemIn;
	 TBactive <= '0';
	 wait until done_o = '1';  -- TBactive = 1 again to read ProgMem as output
	 TBactive <= '1';	
	end process;
	
ena <= '1' when (doneDatMemIn and doneProgMemIn) else '0';             
rst <= '0' when (doneDatMemIn and doneProgMemIn) else '1';   
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
-----------------------DataMem Exporting (when done_o=1)----------------------- 
WriteToDataMem: process 
	file OutDataMemFile : text open write_mode is dataMemResult; 
	variable    linetomem			: std_logic_vector(n-1 downto 0);
	variable	good				: boolean;
	variable 	L 					: line;
	variable	TempAddr		: std_logic_vector(n-1 downto 0) ; -- Awidth
	variable 	counter				: integer;
begin 
	wait until done_o = '1';  
	TempAddr := (others => '0');
	counter := 0;
	while counter < 64 loop	    --Depth of ProgMem 
		DTCM_tb_addr_out <= TempAddr;
		wait until rising_edge(clk);
		wait until rising_edge(clk);  -- spend another clock cycle for reading
		hwrite(L,DM_dataout); -- hwrite is hexa write
		writeline(OutDataMemFile,L);
		TempAddr := TempAddr +1;
		counter := counter +1;
	end loop ;
	file_close(OutDataMemFile);
	wait;
end process;
end architecture TB_Top;
