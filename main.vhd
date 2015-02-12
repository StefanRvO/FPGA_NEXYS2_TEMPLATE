
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity main is
port ( 
	CLOCK: IN STD_LOGIC;
	SW: IN STD_LOGIC_VECTOR (3 downto 0);
	DP: OUT STD_LOGIC_VECTOR (6 downto 0);
	AN: OUT STD_LOGIC_VECTOR (3 downto 0);
	BTN: IN STD_LOGIC_VECTOR (3 downto 0)
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
	
	component MEMORY_four_bit is
		port(
		write: IN STD_LOGIC;
		in_val: IN STD_LOGIC_VECTOR(3 downto 0);
		out_val: OUT STD_LOGIC_VECTOR(3 downto 0)
		);
	end component;
	
	signal state, Istate: STD_LOGIC_VECTOR( 29 downto 0);
--	signal MEM_0: STD_LOGIC_VECTOR (3 downto 0);
	signal MEM_1: STD_LOGIC_VECTOR (3 downto 0);
	signal MEM_2: STD_LOGIC_VECTOR (3 downto 0);
	signal MEM_3: STD_LOGIC_VECTOR (3 downto 0);
	signal DP_0: STD_LOGIC_VECTOR (6 downto 0);
	signal DP_1: STD_LOGIC_VECTOR (6 downto 0);
	signal DP_2: STD_LOGIC_VECTOR (6 downto 0);
	signal DP_3: STD_LOGIC_VECTOR (6 downto 0);
begin

T_FlipFlop_1: T_FlipFlop port map(D => CLOCK, Q=>state(0), IQ=> Istate(0));
T_FlipFlop_2: T_FlipFlop port map(D => Istate(0), Q=>state(1), IQ=> Istate(1));
T_FlipFlop_3: T_FlipFlop port map(D => Istate(1), Q=>state(2), IQ=> Istate(2));
T_FlipFlop_4: T_FlipFlop port map(D => Istate(2), Q=>state(3), IQ=> Istate(3));
T_FlipFlop_5: T_FlipFlop port map(D => Istate(3), Q=>state(4), IQ=> Istate(4));
T_FlipFlop_6: T_FlipFlop port map(D => Istate(4), Q=>state(5), IQ=> Istate(5));
T_FlipFlop_7: T_FlipFlop port map(D => Istate(5), Q=>state(6), IQ=> Istate(6));
T_FlipFlop_8: T_FlipFlop port map(D => Istate(6), Q=>state(7), IQ=> Istate(7));
T_FlipFlop_9: T_FlipFlop port map(D => Istate(7), Q=>state(8), IQ=> Istate(8));
T_FlipFlop_10: T_FlipFlop port map(D => Istate(8), Q=>state(9), IQ=> Istate(9));
T_FlipFlop_11: T_FlipFlop port map(D => Istate(9), Q=>state(10), IQ=> Istate(10));
T_FlipFlop_12: T_FlipFlop port map(D => Istate(10), Q=>state(11), IQ=> Istate(11));
T_FlipFlop_13: T_FlipFlop port map(D => Istate(11), Q=>state(12), IQ=> Istate(12));
T_FlipFlop_14: T_FlipFlop port map(D => Istate(12), Q=>state(13), IQ=> Istate(13));
T_FlipFlop_15: T_FlipFlop port map(D => Istate(13), Q=>state(14), IQ=> Istate(14));
T_FlipFlop_16: T_FlipFlop port map(D => Istate(14), Q=>state(15), IQ=> Istate(15));
T_FlipFlop_17: T_FlipFlop port map(D => Istate(15), Q=>state(16), IQ=> Istate(16));
T_FlipFlop_18: T_FlipFlop port map(D => Istate(16), Q=>state(17), IQ=> Istate(17));
T_FlipFlop_19: T_FlipFlop port map(D => Istate(17), Q=>state(18), IQ=> Istate(18));
T_FlipFlop_20: T_FlipFlop port map(D => Istate(18), Q=>state(19), IQ=> Istate(19));
T_FlipFlop_21: T_FlipFlop port map(D => Istate(19), Q=>state(20), IQ=> Istate(20));
T_FlipFlop_22: T_FlipFlop port map(D => Istate(20), Q=>state(21), IQ=> Istate(21));
T_FlipFlop_23: T_FlipFlop port map(D => Istate(21), Q=>state(22), IQ=> Istate(22));
T_FlipFlop_24: T_FlipFlop port map(D => Istate(22), Q=>state(23), IQ=> Istate(23));
T_FlipFlop_25: T_FlipFlop port map(D => Istate(23), Q=>state(24), IQ=> Istate(24));
T_FlipFlop_26: T_FlipFlop port map(D => Istate(24), Q=>state(25), IQ=> Istate(25));
T_FlipFlop_27: T_FlipFlop port map(D => Istate(25), Q=>state(26), IQ=> Istate(26));
T_FlipFlop_28: T_FlipFlop port map(D => Istate(26), Q=>state(27), IQ=> Istate(27));
T_FlipFlop_29: T_FlipFlop port map(D => Istate(27), Q=>state(28), IQ=> Istate(28));
T_FlipFlop_30: T_FlipFlop port map(D => Istate(28), Q=>state(29), IQ=> Istate(29));

--MEMORY_4_bit_0: MEMORY_four_bit port map(write => BTN(0), in_val => SW, out_val => MEM_0);
MEMORY_4_bit_1: MEMORY_four_bit port map(write => BTN(1), in_val => SW, out_val => MEM_1);
MEMORY_4_bit_2: MEMORY_four_bit port map(write => BTN(2), in_val => SW, out_val => MEM_2);
MEMORY_4_bit_3: MEMORY_four_bit port map(write => BTN(3), in_val => SW, out_val => MEM_3);


with state(13 downto 12) select
	AN <= not "0001" 	when "00",
			 not "0010" 				when "01",
			 not "0100" 				when "10",
			 not "1000" 				when "11",
			"0000" when others;

with state(13 downto 12) select
	DP <= DP_0 	when "00",
			DP_1 				when "01",
			DP_2 				when "10",
			DP_3 				when "11",
			"1111111" when others;


with SW select
   DP_0<= "1111001" when "0001",   --1
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

with MEM_1 select
   DP_1<= "1111001" when "0001",   --1
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

with MEM_2 select
   DP_2<= "1111001" when "0001",   --1
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

with MEM_3 select
   DP_3<= "1111001" when "0001",   --1
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
