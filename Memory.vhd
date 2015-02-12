
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity latch is
	port(
	write, in_val: IN STD_LOGIC;
	out_val: OUT STD_LOGIC
	);
end latch;

architecture behav  of latch is
	signal data: STD_LOGIC;
	begin

	process (write, in_val)
	begin
		if write = '1' then
			data <= in_val;
		end if;
	end process;

	out_val <= data;
	
end behav;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MEMORY_four_bit is
	port(
	write: IN STD_LOGIC;
	in_val: IN STD_LOGIC_VECTOR(3 downto 0);
	out_val: OUT STD_LOGIC_VECTOR(3 downto 0)
	);
end MEMORY_four_bit;

architecture behav  of MEMORY_four_bit is
	begin

	process (write, in_val)
	begin
		if write = '1' then
			out_val <= in_val;
		end if;
	end process;
	
end behav;
