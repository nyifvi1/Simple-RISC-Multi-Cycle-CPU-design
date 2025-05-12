LIBRARY ieee;
USE ieee.std_logic_1164.all;
--------------------------------------------------------
ENTITY AdderSub IS
	GENERIC (n : INTEGER := 8);
	PORT (x,y : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		  sub_c : IN STD_LOGIC;
		  cout : OUT STD_LOGIC;
		  res : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0));
END AdderSub;
--------------------------------------------------------
ARCHITECTURE AdderSub OF AdderSub IS
	COMPONENT FA IS
	PORT (xi, yi, cin: IN std_logic;
			  s, cout: OUT std_logic);
	END COMPONENT;
	SIGNAL reg : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
	SIGNAL xor_o : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
BEGIN 
	FA_IN:	FOR i IN 0 to n-1 GENERATE --XOR Output Configuration
				xor_o(i) <= x(i) XOR sub_c;
			END GENERATE;
			
first:		FA PORT MAP(xi => xor_o(0), --Configuration of the first FA
					yi => y(0),
					cin => sub_c,
					s => res(0),
					cout => reg(0));
					
rest:		FOR i IN 1 TO n-1 GENERATE --Configuration of the rest FA
			chain:	FA PORT MAP(xi => xor_o(i),
							yi => y(i),
							cin => reg(i-1),
							s => res(i),
							cout => reg(i));
					END GENERATE;
					cout <= reg(n-1);
END AdderSub;