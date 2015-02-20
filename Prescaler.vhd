library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Scaler is
	generic (SCALE: integer range 0 to 500000000); --what is the clock scaled down by.
	port(
			IN_SIG: IN STD_LOGIC;
			OUT_SIG: OUT STD_LOGIC
			);
end Scaler;


architecture behav of Scaler is

	signal scaler: integer range 0 to SCALE / 2;
	signal scaled: STD_LOGIC;
	
begin
	process(IN_SIG)
	begin
		if rising_edge(IN_SIG) then
			if scaler = SCALE / 2 then
				scaler <= 0;
				scaled <= not scaled;
			else
				scaler <= scaler + 1;
			end if;
		end if;
	end process;
	
	OUT_SIG <= scaled;
end behav;
