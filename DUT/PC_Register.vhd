library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use work.aux_package.all;
--------------------------------------------------------------
entity PC_Register is
generic( Awidth : integer:=6;
		 dept : integer:=64);
port(	clk,PCin : in std_logic;	
		PCsel : in std_logic_vector(1 downto 0);
		IR : in std_logic_vector(7 downto 0);
		readAddr : out std_logic_vector(Awidth-1 downto 0));
end PC_Register;
--------------------------------------------------------------
architecture PC_Register of PC_Register is
signal PCsig : std_logic_vector(7 downto 0);
signal AdderSub1_res,AdderSub2_res : std_logic_vector(7 downto 0); 
signal AdderSub1_c,AdderSub2_c : std_logic;
begin
C1:	AdderSub generic map(8) port map(x=>"00000001",
									y=>PCsig,
									sub_c=>'0',
									cout=>AdderSub1_c,
									res=>AdderSub1_res);
C2: AdderSub generic map(8) port map(x=>IR(7 downto 0),
									 y=>AdderSub1_res,
									 sub_c=>'0',
									 cout=>AdderSub2_c,
									 res=>AdderSub2_res);
									 
process(clk)
begin
if (clk'event and clk='1') then
	if (PCin='1') then
		if PCsel = 	  "00" then PCsig <= AdderSub1_res; 
		elsif PCsel = "01" then PCsig <= AdderSub2_res;
		else PCsig <= (others => '0');
		end if;
		report "nextPC = " & to_string(PCsig);
	end if;
end if;
end process;
readAddr <= PCsig(7)&PCsig(Awidth-2 downto 0);
end architecture PC_Register;
