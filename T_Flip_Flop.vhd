library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity T_FlipFlop is
	port(
	D: IN STD_LOGIC;
	Q,IQ: OUT STD_LOGIC
	);
end T_FlipFlop;

architecture behav  of T_FlipFlop is
	signal temp: STD_LOGIC;
	
	begin
	
	process(D)
		begin
		if(rising_edge(D)) then
			temp <= '1' xor temp;
		end if;
	end process;
	
	Q <= temp;
	IQ <= not temp;
end behav;
