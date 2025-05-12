library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
--------------------------------------------------------------
entity Control is
generic(Dwidth : integer:=16);
port(	rst,ena,clk : in std_logic;
		st,ld,mov,done_i,add,sub,jmp,jc,jnc,and_s,or_s,xor_s,Cflag,Zflag,Nflag : in std_logic;
		done_o : out std_logic;
		DTCM_wr,DTCM_addr_out,DTCM_addr_in,DTCM_out,Ain,RFin,RFout,IRin,PCin,Imm1_in,Imm2_in,DTCM_addr_sel : out std_logic;
		RFaddr_rd,RFaddr_wr,PCsel : out std_logic_vector(1 downto 0);
		ALUFN : out std_logic_vector(3 downto 0));
end Control;
--------------------------------------------------------------
architecture Control of Control is
type state is (state_reset,state_fetch,state_decode,state_R1,state_J,state_M,state_done,state_ld1,state_st1,state_st2,state_R2,state_ld2,state_ld3,state_PCinc1);
signal pr_state, nx_state : state;
begin
-------------------------LOWER section-------------------------
process (rst,clk)
begin
	 if (rst='1') then
		pr_state <= state_reset;
	elsif (clk'event and clk='1') then
		if (ena='1') then 
			pr_state <= nx_state;
			report "next state = " & to_string(nx_state);
		end if;
	end if;
end process;
-------------------------UPPER section-------------------------
process(pr_state,st,ld,mov,done_i,add,sub,jmp,jc,jnc,and_s,or_s,xor_s,Cflag,Zflag,Nflag)
begin
	case pr_state is
		when state_reset =>                       --update ALUFN default 0000 (not always C=B, zeros is better)
		DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='0';PCin<='1';Imm1_in<='0';Imm2_in<='0';			
		DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="10";
		ALUFN<="1111";
		done_o<='0';		
		nx_state <= state_fetch;

		when state_fetch =>
		DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='1';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
		DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
		ALUFN<="1111";
		done_o<='0';
		nx_state <= state_decode;

		when state_decode =>
		DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='0';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
		DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
		ALUFN<="1111";
		done_o<='0';
		if (add='1' or sub='1' or and_s='1' or or_s='1' or xor_s='1' or ld='1' or st='1') then
			nx_state <= state_R1;
		elsif ((jmp = '1') or ((jc = '1') and (Cflag = '1')) or ((jnc = '1') and (Cflag = '0'))) then
			nx_state <= state_J;
		elsif mov='1' then
			nx_state <= state_M;
		elsif done_i='1' then
			nx_state <= state_done;
		else 
			nx_state <= state_PCinc1;
		end if;

		when state_R1 =>
		DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='1';RFin<='0';RFout<='1';IRin<='0';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
		DTCM_addr_sel<='0';RFaddr_rd<="01";RFaddr_wr<="00";PCsel<="00";
		ALUFN<="0000";
		done_o<='0';
		if ld='1' then
			nx_state <= state_ld1; 
		elsif st='1' then
			nx_state <= state_st1;
		else
			nx_state <= state_R2;
		end if;
				
		when state_R2 =>
		DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='1';RFout<='1';IRin<='0';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
		DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="10";PCsel<="00";
		done_o<='0';
		nx_state <= state_PCinc1;	
		if add='1' then
			ALUFN <= "0001";
		elsif sub='1' then
			ALUFN <= "0011";
		elsif and_s='1' then
			ALUFN <= "0100";		
		elsif or_s='1' then
			ALUFN <= "0101";
		elsif xor_s='1' then
			ALUFN <= "0110";
		else
			ALUFN <= "1111";
		end if;
		
		when state_ld1 =>
		DTCM_wr<='0';DTCM_addr_out<='1';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='0';PCin<='0';Imm1_in<='0';Imm2_in<='1';			
		DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
		ALUFN<="0001";
		done_o<='0';
		nx_state <= state_ld2;
	
		when state_ld2 =>
		DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='0';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
		DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
		ALUFN<="1111";
		done_o<='0';	
		nx_state <= state_ld3;
		
		when state_ld3 =>
		DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='1';Ain<='0';RFin<='1';RFout<='0';IRin<='0';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
		DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="10";PCsel<="00";
		ALUFN<="0000";
		done_o<='0';	
		nx_state <= state_PCinc1;		
		
		when state_J =>
		DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='0';PCin<='1';Imm1_in<='0';Imm2_in<='0';			
		DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="01";
		ALUFN<="1111";
		done_o<='0';		
		nx_state <= state_fetch;
		
		when state_M =>
		DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='1';RFout<='0';IRin<='0';PCin<='0';Imm1_in<='1';Imm2_in<='0';			
		DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="10";PCsel<="00";
		ALUFN<="0000";
		done_o<='0';
		nx_state <= state_PCinc1;			
		
		when state_st1 =>
		DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='1';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='0';PCin<='0';Imm1_in<='0';Imm2_in<='1';			
		DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
		ALUFN<="0001";
		done_o<='0';
		nx_state <= state_st2;		
		
		when state_st2 =>
		DTCM_wr<='1';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='1';IRin<='0';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
		DTCM_addr_sel<='0';RFaddr_rd<="10";RFaddr_wr<="00";PCsel<="00";
		ALUFN<="1111";
		done_o<='0';
		nx_state <= state_PCinc1;

		when state_PCinc1 =>
		DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='0';PCin<='1';Imm1_in<='0';Imm2_in<='0';			
		DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
		ALUFN<="1111";
		done_o<='0';
		nx_state <= state_fetch;		
										
		when state_done =>
		DTCM_wr<='0';DTCM_addr_out<='0';DTCM_addr_in<='0';DTCM_out<='0';Ain<='0';RFin<='0';RFout<='0';IRin<='0';PCin<='0';Imm1_in<='0';Imm2_in<='0';			
		DTCM_addr_sel<='0';RFaddr_rd<="00";RFaddr_wr<="00";PCsel<="00";
		ALUFN<="1111";
		done_o<='1';
		nx_state <= state_PCinc1;		
	end case;
end process;
end architecture Control;
