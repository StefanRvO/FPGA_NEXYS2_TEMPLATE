
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
	BTN: IN STD_LOGIC_VECTOR (2 downto 0);
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
	D, RST: IN STD_LOGIC;
	Q: OUT STD_LOGIC
	);
	end component;
	
component MEMORY_X_BIT is
	generic (
		SIZE:	integer range 0 to 100000 --Size of counter in bits
					);  
  port (
    in_val   : in std_logic_vector(SIZE-1 downto 0);
    reset : in std_logic;
    out_val  : out std_logic_vector(SIZE-1 downto 0);
    write    : in std_logic;
    clk: in std_logic
    );

end component;

component COUNTER_X_BIT is
	generic (
		SIZE:	integer range 0 to 100000 --Size of counter in bits
					);
	port(
	D, RST: IN STD_LOGIC;
	Q: INOUT STD_LOGIC_VECTOR(SIZE-1 downto 0);
	MAX: IN STD_LOGIC_VECTOR(SIZE-1 downto 0)
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
	
	signal state: STD_LOGIC_VECTOR( 1 downto 0);
	signal DP_0: STD_LOGIC_VECTOR (7 downto 0);
	signal DP_1: STD_LOGIC_VECTOR (7 downto 0);
	signal DP_2: STD_LOGIC_VECTOR (7 downto 0);
	signal DP_3: STD_LOGIC_VECTOR (7 downto 0);
	signal ScaledCLK_7SEG: STD_LOGIC;
	signal ScaledCLK_TIME: STD_LOGIC;
	signal ScaledCLK_TIME_STOP: STD_LOGIC;
	signal LED_2560_PARTS: STD_LOGIC_VECTOR(7 downto 0);
	signal SECOND_10_FRAC: STD_LOGIC_VECTOR (3 downto 0);
	signal SECONDS_1: STD_LOGIC_VECTOR( 3 downto 0);
	signal SECONDS_10: STD_LOGIC_VECTOR( 2 downto 0);
	signal MINUTES: STD_LOGIC_VECTOR (3 downto 0);
	signal DISPLAY: STD_LOGIC_VECTOR(14 downto 0);
	signal DISPLAY_HOLD: STD_LOGIC_VECTOR(14 downto 0);
	signal DISPLAY_LIVE: STD_LOGIC_VECTOR(14 downto 0);
	signal Reset_Debounce: STD_LOGIC;
	signal Hold_Debounce: STD_LOGIC;
	signal Stop_Debounce: STD_LOGIC;
	signal Hold_Switch: STD_LOGIC := '0';
	signal Stop_Switch: STD_LOGIC := '0';
begin

Debouncer_Reset: Debouncer generic map (THRESHOLD => 50000000 / 1000 * 25) port map(IN_SIG => BTN(0), CLK => CLOCK, OUT_SIG => Reset_Debounce);
Debouncer_Hold: Debouncer generic map (THRESHOLD => 50000000 / 1000 * 25) port map(IN_SIG => BTN(1), CLK => CLOCK, OUT_SIG => Hold_Debounce);
Debouncer_Stop: Debouncer generic map (THRESHOLD => 50000000 / 1000 * 25) port map(IN_SIG => BTN(2), CLK => CLOCK, OUT_SIG => Stop_Debounce);

--Clock for switching the display on and off
Scaler_1:	Scaler generic map(SCALE => 50000) port map( IN_SIG => CLOCK, OUT_SIG => ScaledCLK_7SEG);
T_FlipFlop_1: T_FlipFlop port map(D => ScaledCLK_7SEG, Q=>state(1) , RST => '0');
state(0) <= ScaledCLK_7SEG;

--Clock for driving the counter
Scaler_2:	Scaler generic map(SCALE => 50000000 / 2560) port map( IN_SIG => CLOCK, OUT_SIG => ScaledCLK_TIME); --Get a clock which counts 2560 times per second


process(Stop_Debounce)
begin
	if rising_edge(Stop_Debounce) then
		Stop_Switch <= not Stop_Switch;
	end if;
end process;

process(Hold_Debounce)
begin
	if rising_edge(Hold_Debounce) then
		Hold_Switch <= not Hold_Switch;
	end if;
end process;

ScaledCLK_TIME_STOP <= ScaledCLK_TIME and not Stop_Switch;
COUNTER_256: COUNTER_X_BIT generic map( SIZE => 8) port map(MAX => "11111111", D => ScaledCLK_TIME_STOP, Q => LED_2560_PARTS, RST => Reset_Debounce);
COUNTER_10_1: COUNTER_X_BIT generic map( SIZE => 4) port map(MAX => "1001", D => not LED_2560_PARTS(7), Q => SECOND_10_FRAC, RST => Reset_Debounce);
COUNTER_10_2: COUNTER_X_BIT generic map( SIZE => 4) port map(MAX => "1001", D => not SECOND_10_FRAC(3), Q => SECONDS_1, RST => Reset_Debounce);
COUNTER_6: COUNTER_X_BIT generic map( SIZE => 3) port map(MAX => "100", D => not SECONDS_1(3), Q => SECONDS_10, RST => Reset_Debounce);
COUNTER_10_3: COUNTER_X_BIT generic map( SIZE => 4) port map(MAX => "1001", D => not SECONDS_10(2), Q => MINUTES, RST => Reset_Debounce);
LD <= LED_2560_PARTS(7 downto 0);

DISPLAY_LIVE(3 downto 0) <= SECOND_10_FRAC;
DISPLAY_LIVE(7 downto 4) <= SECONDS_1;
DISPLAY_LIVE(10 downto 8) <= SECONDS_10;
DISPLAY_LIVE(14 downto 11) <= MINUTES; 

--Memory to hold a counter value
MEMORY_15_bit_1:	MEMORY_X_BIT generic map(SIZE => 15)  port map(write => not Hold_Switch, in_val => DISPLAY_LIVE,  out_val => DISPLAY_HOLD, reset => '0', clk => CLOCK );



with Hold_Switch select
	DISPLAY <= DISPLAY_LIVE when '0',
						 DISPLAY_HOLD when others;

with state select
	AN <= not "0001" 				when "00",
			 not "0010" 				when "01",
			 not "0100" 				when "10",
			 not "1000" 				when "11",
			"0000" 							when others;

with state select
	DP <= DP_0 	when "00",
			DP_1 				when "01",
			DP_2 				when "10",
			DP_3 				when "11",
			(others => '1') when others;


with DISPLAY(3 downto 0) select
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

with DISPLAY(7 downto 4) select
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

with DISPLAY(10 downto 8) select
   DP_2<= "11111001" when "001",   --1
         "10100100" when "010",   --2
         "10110000" when "011",   --3
         "10011001" when "100",   --4
         "10010010" when "101",   --5
         "11000000" when others;   --0

with DISPLAY(14 downto 11) select
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
