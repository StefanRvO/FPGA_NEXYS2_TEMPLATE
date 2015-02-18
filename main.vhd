
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity main is
port ( 
	CLOCK: IN STD_LOGIC;
	DP: OUT STD_LOGIC_VECTOR (7 downto 0);
	AN: OUT STD_LOGIC_VECTOR (3 downto 0);
	BTN: IN STD_LOGIC_VECTOR (3 downto 0);
	LD: OUT STD_LOGIC_VECTOR (7 downto 0)
		);
end main;

architecture Behavioral of main is
	component Scaler is
	generic (SCALE: integer range 0 to 500000000); --what is the clock scaled down by.
	port(
			IN_SIG: IN STD_LOGIC;
			OUT_SIG: OUT STD_LOGIC
			);
	end component;
	
	component T_FlipFlop is
	port(
		D: IN STD_LOGIC;
		Q: OUT STD_LOGIC;
		IQ: OUT STD_LOGIC
		);
	end component;
	
	component MEMORY_four_bit is
		port(
		write: IN STD_LOGIC;
		in_val: IN STD_LOGIC_VECTOR(3 downto 0);
		out_val: OUT STD_LOGIC_VECTOR(3 downto 0)
		);
	end component;
	
	component four_bit_adder is
		port(
			INVAL_1: 	 IN STD_LOGIC_VECTOR (3 downto 0);
			INVAL_2: 	 IN STD_LOGIC_VECTOR (3 downto 0);
			CARRY_IN:	 IN STD_LOGIC;
			OUTVAL:		 OUT STD_LOGIC_VECTOR (3 downto 0);
			CARRY_OUT: OUT STD_LOGIC
			);
	end component;

	
	signal state, Istate: STD_LOGIC_VECTOR( 1 downto 0);
	signal DP_0: STD_LOGIC_VECTOR (7 downto 0);
	signal DP_1: STD_LOGIC_VECTOR (7 downto 0);
	signal DP_2: STD_LOGIC_VECTOR (7 downto 0);
	signal DP_3: STD_LOGIC_VECTOR (7 downto 0);
	signal ScaledCLK_7SEG: STD_LOGIC;
	signal ScaledCLK_TIME: STD_LOGIC;
	signal LED_2560_PARTS: STD_LOGIC_VECTOR( 7 downto 0);
	signal SECOND_10_FRAC: STD_LOGIC_VECTOR (3 downto 0);
	signal SECONDS_1: STD_LOGIC_VECTOR( 3 downto 0);
	signal SECONDS_10: STD_LOGIC_VECTOR( 2 downto 0);
	signal MINUTES: STD_LOGIC_VECTOR (3 downto 0);
begin

--Clock for switching the desplay on and of
Scaler_1:	Scaler generic map(SCALE => 10000) port map( IN_SIG => CLOCK, OUT_SIG => ScaledCLK_7SEG);
T_FlipFlop_1: T_FlipFlop port map(D => ScaledCLK_7SEG, Q=>state(1), IQ=> Istate(1));
state(0) <= ScaledCLK_7SEG;

Scaler_2:	Scaler generic map(SCALE => 50000000 / (2560)) port map( IN_SIG => CLOCK, OUT_SIG => ScaledCLK_TIME); --Get a clock which counts 2560 times per second

process(ScaledCLK_TIME)
begin
	if rising_edge(ScaledCLK_TIME) then
		LED_2560_PARTS <= LED_2560_PARTS + "1";
	end if;
end process;

process(LED_2560_PARTS(7))
begin
	if(falling_edge(LED_2560_PARTS(7))) then
		if ( CONV_INTEGER(SECOND_10_FRAC) = 9) then
			SECOND_10_FRAC <=  (others => '0');
		else
			SECOND_10_FRAC <= SECOND_10_FRAC + "1";
		end if;
	end if;
end process;

process(SECOND_10_FRAC(3))
begin
	if(falling_edge(SECOND_10_FRAC(3))) then
		if ( CONV_INTEGER(SECONDS_1) = 9) then
			SECONDS_1 <=  (others => '0');
		else
			SECONDS_1 <= SECONDS_1 + "1";
		end if;
	end if;
end process;

process(SECONDS_1(3))
begin
	if(falling_edge(SECONDS_1(3))) then
		if ( CONV_INTEGER(SECONDS_10) = 5) then
			SECONDS_10 <=  (others => '0');
		else
			SECONDS_10 <= SECONDS_10 + "1";
		end if;
	end if;
end process;

process(SECONDS_10(2))
begin
	if(falling_edge(SECONDS_10(2))) then
		if ( CONV_INTEGER(MINUTES) = 9) then
			MINUTES <=  (others => '0');
		else
			MINUTES <= MINUTES + "1";
		end if;
	end if;
end process;

LD <= LED_2560_PARTS;


with state select
	AN <= not "0001" 	when "00",
			 not "0010" 				when "01",
			 not "0100" 				when "10",
			 not "1000" 				when "11",
			"0000" when others;

with state select
	DP <= DP_0 	when "00",
			DP_1 				when "01",
			DP_2 				when "10",
			DP_3 				when "11",
			(others => '1') when others;


with SECOND_10_FRAC select
   DP_0<= "11111001" when "0001",   --1
         "10100100" when "0010",   --2
         "10110000" when "0011",   --3
         "10011001" when "0100",   --4
         "10010010" when "0101",   --5
         "10000010" when "0110",   --6
         "11111000" when "0111",   --7
         "10000000" when "1000",   --8
         "10010000" when "1001",   --9
         "11000000" when others;   --0

with SECONDS_1 select
   DP_1<= "01111001" when "0001",   --1
         "00100100" when "0010",   --2
         "00110000" when "0011",   --3
         "00011001" when "0100",   --4
         "00010010" when "0101",   --5
         "00000010" when "0110",   --6
         "01111000" when "0111",   --7
         "00000000" when "1000",   --8
         "00010000" when "1001",   --9
         "01000000" when others;   --0

with SECONDS_10 select
   DP_2<= "11111001" when "001",   --1
         "10100100" when "010",   --2
         "10110000" when "011",   --3
         "10011001" when "100",   --4
         "10010010" when "101",   --5
         "11000000" when others;   --0

with MINUTES select
   DP_3<= "01111001" when "0001",   --1
         "00100100" when "0010",   --2
         "00110000" when "0011",   --3
         "00011001" when "0100",   --4
         "00010010" when "0101",   --5
         "00000010" when "0110",   --6
         "01111000" when "0111",   --7
         "00000000" when "1000",   --8
         "00010000" when "1001",   --9
         "01000000" when others;   --0


end Behavioral;
