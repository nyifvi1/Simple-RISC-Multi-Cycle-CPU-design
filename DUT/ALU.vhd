library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use work.aux_package.all;
--------------------------------------------------------------
entity ALU is
generic(Dwidth : integer:=16);
port(	BUS_B : in std_logic_vector(Dwidth-1 downto 0);
		Ain,clk : in std_logic;
		ALUFN : in std_logic_vector(3 downto 0);
		BUS_A : inout std_logic_vector(Dwidth-1 downto 0);
		Cflag,Zflag,Nflag : out std_logic);
end ALU;
--------------------------------------------------------------
architecture ALU of ALU is
signal RegA,AdderSub_res : std_logic_vector(Dwidth-1 downto 0);
signal Ctemp : std_logic_vector(Dwidth-1 downto 0);
signal AdderSub_sub_c,AdderSub_c : std_logic;
begin
  process(clk)
  begin
	if (clk'event and clk='1') then
	    if (Ain='1') then
			RegA <= BUS_A;
		end if;
	end if;
  end process;
  
AdderSub_sub_c <= '1' when ALUFN="0011" else '0';  
C1:	AdderSub generic map(Dwidth) port map(x=>BUS_B,
										  y=>RegA,
										  sub_c=> AdderSub_sub_c,
										  cout=>AdderSub_c,
										  res=>AdderSub_res);	  
   
Ctemp <= BUS_B        		  when ALUFN = "0000" else -- C=B
         AdderSub_res  		  when ALUFN = "0001" else -- C=A+B
         RegA         		  when ALUFN = "0010" else -- C=A
         AdderSub_res   	  when ALUFN = "0011" else -- C=A-B
         RegA and BUS_B       when ALUFN = "0100" else -- C=A and B
         RegA or BUS_B        when ALUFN = "0101" else -- C=A or B
         RegA xor BUS_B       when ALUFN = "0110" else -- C=A xor B
         (others => '0');  							   -- C=0 (ALUFN = "1111" is default)

	BUS_A <= Ctemp;
	Cflag <= AdderSub_c when (ALUFN="0001" or ALUFN="0011") else '0';
	Nflag <= Ctemp(Dwidth-1);
	Zflag <= '1' when Ctemp=0 else '0';	
end architecture ALU;
