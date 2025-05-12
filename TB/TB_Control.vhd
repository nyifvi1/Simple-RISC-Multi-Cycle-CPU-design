LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
USE work.aux_package.all;
--------------------------------------------------------
ENTITY TB_Control is
	constant Dwidth : integer:=16;
END TB_Control;
--------------------------------------------------------
architecture TB_Control of TB_Control is

signal		rst,ena,clk : std_logic;
signal		st,ld,mov,done_i,add,sub,jmp,jc,jnc,and_s,or_s,xor_s,Cflag,Zflag,Nflag : std_logic;
signal		done_o : std_logic;
signal		DTCM_wr,DTCM_addr_out,DTCM_addr_in,DTCM_out,Ain,RFin,RFout,IRin,PCin,Imm1_in,Imm2_in,DTCM_addr_sel : std_logic;
signal		RFaddr_rd,RFaddr_wr,PCsel : std_logic_vector(1 downto 0);
signal		ALUFN : std_logic_vector(3 downto 0);
	   
begin 
L0 : Control generic map (Dwidth) port map (rst=>rst,ena=>ena,clk=>clk,st=>st,ld=>ld,mov=>mov,done_i=>done_i,add=>add,
	sub=>sub,jmp=>jmp,jc=>jc,jnc=>jnc,and_s=>and_s,or_s=>or_s,xor_s=>xor_s,Cflag=>Cflag,Zflag=>Zflag,Nflag=>Nflag,
	done_o=>done_o,DTCM_wr=>DTCM_wr,DTCM_addr_out=>DTCM_addr_out,DTCM_addr_in=>DTCM_addr_in,DTCM_out=>DTCM_out,Ain=>Ain,
	RFin=>RFin,RFout=>RFout,IRin=>IRin,PCin=>PCin,Imm1_in=>Imm1_in,Imm2_in=>Imm2_in,DTCM_addr_sel=>DTCM_addr_sel,
	RFaddr_rd=>RFaddr_rd,RFaddr_wr=>RFaddr_wr,PCsel=>PCsel,ALUFN=>ALUFN);
	--------- start of stimulus section ------------------		
gen_clock : process
			begin
			clk <= '1';
			wait for 50 ns;
			clk <= not clk;
			wait for 50 ns;
			end process;

gen_rst :   process
			begin
			rst <= '1';
			wait for 50 ns;
			rst <= '0';
			wait;
			end process;
			
gen_ena :   process
			begin
			ena <= '0';
			wait for 150 ns;
			ena <= '1';
			wait;
			end process;
------------------------------------------------------------------			
gen_st :    process
			begin
			st <= '0';
			wait for 1000 ns;
			st <= '1';
			wait for 1000 ns;
			st <= '0';
			wait;
			end process;
			
gen_ld :    process
			begin
			ld <= '0';
			wait for 2000 ns;
			ld <= '1';
			wait for 1000 ns;
			ld <= '0';
			wait;
			end process;
			
gen_mov :   process
			begin
			mov <= '0';
			wait for 3000 ns;
			mov <= '1';
			wait for 1000 ns;
			mov <= '0';
			wait;
			end process;
			
gen_done_i :process
			begin
			done_i <= '0';
			wait for 4000 ns;
			done_i <= '1';
			wait for 1000 ns;
			done_i <= '0';
			wait;
			end process;
			
gen_add :   process
			begin
			add <= '0';
			wait for 5000 ns;
			add <= '1';
			wait for 1000 ns;
			add <= '0';
			wait;
			end process;
			
gen_sub :   process
			begin
			sub <= '0';
			wait for 6000 ns;
			sub <= '1';
			wait for 1000 ns;
			sub <= '0';
			wait;
			end process;
			
gen_jmp :   process
			begin
			jmp <= '0';
			wait for 7000 ns;
			jmp <= '1';
			wait for 1000 ns;
			jmp <= '0';
			wait;
			end process;
			
gen_jc :    process
			begin
			jc <= '0';
			wait for 8000 ns;
			jc <= '1';
			wait for 2000 ns;
			jc <= '0';
			wait;
			end process;

			
gen_Cflag : process
			begin
			Cflag <= '0';
			wait for 9000 ns;
			Cflag <= '1';
			wait for 2000 ns;
			Cflag <= '0';
			wait;
			end process;			
			
														
gen_jnc :   process
			begin
			jnc <= '0';
			wait for 10000 ns;
			jnc <= '1';
			wait for 2000 ns;
			jnc <= '0';
			wait;
			end process;
			
gen_and_s : process
			begin
			and_s <= '0';
			wait for 12000 ns;
			and_s <= '1';
			wait for 1000 ns;
			and_s <= '0';
			wait;
			end process;
			
gen_or_s :  process
			begin
			or_s <= '0';
			wait for 13000 ns;
			or_s <= '1';
			wait for 1000 ns;
			or_s <= '0';
			wait;
			end process;
			
gen_xor_s : process
			begin
			xor_s <= '0';
			wait for 14000 ns;
			xor_s <= '1';
			wait for 1000 ns;
			xor_s <= '0';
			wait;
			end process;
			
Zflag <= '0';
Nflag <= '0';		
end architecture TB_Control;