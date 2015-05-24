library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;
USE ieee.math_real.ALL;   -- for UNIFORM, TRUNC functions

entity Random_Blinker is
port (
	CLOCK: IN STD_LOGIC;
	LD: OUT STD_LOGIC_VECTOR (7 downto 0);
  SEEDS: IN STD_LOGIC_VECTOR(27 downto 0);
  NEW_BLINK: IN STD_LOGIC;
  TURNED_ON: OUT STD_LOGIC
		);
end Random_Blinker;

architecture behav of Random_Blinker is

  component COUNTER_X_BIT is
  generic (
		SIZE:	integer range 0 to 100000 --Size of counter in bits
					);
	port(
	D, RST: IN STD_LOGIC;
	Q: OUT STD_LOGIC_VECTOR(SIZE-1 downto 0);
	MAX: IN STD_LOGIC_VECTOR(SIZE-1 downto 0)
			);
  end component;
signal Random_vector: STD_LOGIC_VECTOR(27 downto 0) := "1010111101010111101011100111";
signal Counter_vec : STD_LOGIC_VECTOR(29 downto 0);
begin


COUNTER_29_bit: COUNTER_X_BIT generic map( SIZE => 30) port map(MAX => "111111111111111111111111111111", D => CLOCK, Q => Counter_vec, RST => NEW_BLINK);

process(CLOCK, NEW_BLINK)
begin
  if NEW_BLINK = '1' then
    LD <= "00000000";
    TURNED_ON <= '0';
  elsif Counter_vec(27 downto 0) = Random_vector then
    LD <= "11111111";
    TURNED_ON <= '1';
  end if;
end process;

  process(CLOCK)
  begin
    if(rising_edge(CLOCK)) then
      Random_vector <= Random_vector xor SEEDS;
    end if;
  end process;


end behav;
