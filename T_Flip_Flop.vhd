library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity T_FlipFlop is
	port(
	D, RST: IN STD_LOGIC;
	Q: OUT STD_LOGIC
	);
end T_FlipFlop;

architecture behav of T_FlipFlop is
	signal temp: STD_LOGIC;	
	begin
	
	Q <= temp;
	
	process(D,RST)
		begin
		if D'event and D = '0' then
			temp <= not temp;
		end if;
		if RST = '1' then
			temp <= '0';
		end if;
	end process;
end behav;
