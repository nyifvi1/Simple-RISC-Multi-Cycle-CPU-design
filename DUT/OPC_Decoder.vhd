library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
--------------------------------------------------------------
entity OPC_Decoder is
port(	OPC : in std_logic_vector(3 downto 0);	
		st,ld,mov,done,add,sub,jmp,jc,jnc,and_s,or_s,xor_s : out std_logic);
end OPC_Decoder;
--------------------------------------------------------------
architecture OPC_Decoder of OPC_Decoder is
begin			   
	st <=    '1' when OPC = "1110" else '0'; 
	ld <=    '1' when OPC = "1101" else '0'; 
	mov <=   '1' when OPC = "1100" else '0'; 
	done <=  '1' when OPC = "1111" else '0'; 
	add <=   '1' when OPC = "0000" else '0'; 
	sub <=   '1' when OPC = "0001" else '0'; 
	jmp <=   '1' when OPC = "0111" else '0'; 
	jc <=    '1' when OPC = "1000" else '0'; 
	jnc <=   '1' when OPC = "1001" else '0'; 
	and_s <= '1' when OPC = "0010" else '0'; 
	or_s <=  '1' when OPC = "0011" else '0'; 
	xor_s <= '1' when OPC = "0100" else '0'; 
end architecture OPC_Decoder;
