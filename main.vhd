
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity main is
port ( 
	CLOCK: IN STD_LOGIC;
	SW: IN STD_LOGIC_VECTOR (3 downto 0);
	DP: OUT STD_LOGIC_VECTOR (6 downto 0);
	AN: OUT STD_LOGIC_VECTOR (3 downto 0)
		);
end main;

architecture Behavioral of main is

	component T_FlipFlop is
	port(
		D: IN STD_LOGIC;
		Q: OUT STD_LOGIC;
		IQ: OUT STD_LOGIC
		);
	end component;
	
	signal state, Istate: STD_LOGIC_VECTOR( 1 downto 0);
	
begin

T_FlipFlop_1: T_FlipFlop port map(D => CLOCK, Q=>state(0), IQ=> Istate(0));
T_FlipFlop_2: T_FlipFlop port map(D => Istate(0), Q=>state(1));

with state select
	AN <= "1110" when "00",
			"1101" when "01",
			"1011" when "10",
			"0111" when "11",
			"1111" when others;
			

with SW select
   DP<= "1111001" when "0001",   --1
         "0100100" when "0010",   --2
         "0110000" when "0011",   --3
         "0011001" when "0100",   --4
         "0010010" when "0101",   --5
         "0000010" when "0110",   --6
         "1111000" when "0111",   --7
         "0000000" when "1000",   --8
         "0010000" when "1001",   --9
         "0001000" when "1010",   --A
         "0000011" when "1011",   --b
         "1000110" when "1100",   --C
         "0100001" when "1101",   --d
         "0000110" when "1110",   --E
         "0001110" when "1111",   --F
         "1000000" when others;   --0

end Behavioral;
