
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;

entity main is
port (
	CLOCK: IN STD_LOGIC;
	DP: OUT STD_LOGIC_VECTOR (7 downto 0);
	AN: OUT STD_LOGIC_VECTOR (3 downto 0);
	BTN: IN STD_LOGIC_VECTOR (1 downto 0);
	LD: OUT STD_LOGIC_VECTOR (7 downto 0)
		);
end main;

architecture Behavioral of main is
	component Timer is
	port (
	CLOCK: IN STD_LOGIC;
	DP: OUT STD_LOGIC_VECTOR (7 downto 0);
	AN: OUT STD_LOGIC_VECTOR (3 downto 0);
  START: IN STD_LOGIC;
  STOP: IN STD_LOGIC;
	LD: OUT STD_LOGIC_VECTOR (7 downto 0)
			);
	end component;

	component Debouncer is
		generic (THRESHOLD: integer range 0 to 500000000); --How many clock cycles the signal must remain the same for the output to switch
		port(
				IN_SIG: IN STD_LOGIC;
				CLK:	IN STD_LOGIC;
				OUT_SIG: OUT STD_LOGIC
				);
	end component;

	signal BTN_debounced : std_logic_vector(1 downto 0);
begin


Debouncer1: Debouncer generic map (THRESHOLD => 50000000 / 1000 * 25) port map(IN_SIG => BTN(0), CLK => CLOCK, OUT_SIG => BTN_debounced(0));
Debouncer2: Debouncer generic map (THRESHOLD => 50000000 / 1000 * 25) port map(IN_SIG => BTN(1), CLK => CLOCK, OUT_SIG => BTN_debounced(1));


Timer1:	Timer port map(CLOCK => CLOCK, DP => DP, AN => AN, START => BTN_debounced(0), STOP => BTN_debounced(1), LD => LD);



end Behavioral;
