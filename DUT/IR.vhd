library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
--------------------------------------------------------------
entity IR is
generic(Dwidth : integer:=16;
	    Awidth: integer:=4);
port(	PM_dataOut : in std_logic_vector(Dwidth-1 downto 0);
		IRin,clk : in std_logic;
		IR_Reg : out std_logic_vector(Dwidth-1 downto 0));
end IR;
--------------------------------------------------------------
architecture IR of IR is
signal IRreg : std_logic_vector(Dwidth-1 downto 0);
begin			   
  process(clk)
  begin
	if (clk'event and clk='1') then
	    if (IRin='1') then
			IRreg <= PM_dataOut;
			report "IR = " & to_string(PM_dataOut);
		end if;
	end if;
  end process;
IR_Reg <= IRreg;
end architecture IR;
