library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity full_adder is
	port(
	INVAL_1: 	 IN STD_LOGIC;
	INVAL_2: 	 IN STD_LOGIC;
	CARRY_IN:	 IN STD_LOGIC;
	OUTVAL:		 OUT STD_LOGIC;
	CARRY_OUT: OUT STD_LOGIC
	);
end full_adder;

architecture behav  of full_adder is
begin	

	OUTVAL <= INVAL_1 xor INVAL_2 xor CARRY_IN;
	CARRY_OUT <= (INVAL_1 and INVAL_2) or (CARRY_IN and (INVAL_1 xor INVAL_2));

end behav;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity four_bit_adder is
	port(
	INVAL_1: 	 IN STD_LOGIC_VECTOR (3 downto 0);
	INVAL_2: 	 IN STD_LOGIC_VECTOR (3 downto 0);
	CARRY_IN:	 IN STD_LOGIC;
	OUTVAL:		 OUT STD_LOGIC_VECTOR (3 downto 0);
	CARRY_OUT: OUT STD_LOGIC
	);
end four_bit_adder;

architecture behav  of four_bit_adder is
	component full_adder is
		port(
		INVAL_1: 	 IN STD_LOGIC;
		INVAL_2: 	 IN STD_LOGIC;
		CARRY_IN:	 IN STD_LOGIC;
		OUTVAL:		 OUT STD_LOGIC;
		CARRY_OUT: OUT STD_LOGIC
		);
	end component;

	signal CARRY_TMP: STD_LOGIC_VECTOR (2 downto 0);

begin
	
	full_adder_0: full_adder port map(INVAL_1 => INVAL_1(0), INVAL_2 => INVAL_2(0), CARRY_IN  => CARRY_IN, OUTVAL => OUTVAL(0), CARRY_OUT => CARRY_TMP(0));
	full_adder_1: full_adder port map(INVAL_1 => INVAL_1(1), INVAL_2 => INVAL_2(1), CARRY_IN  => CARRY_TMP(0), OUTVAL => OUTVAL(1), CARRY_OUT => CARRY_TMP(1));
	full_adder_2: full_adder port map(INVAL_1 => INVAL_1(2), INVAL_2 => INVAL_2(2), CARRY_IN  => CARRY_TMP(1), OUTVAL => OUTVAL(2), CARRY_OUT => CARRY_TMP(2));
	full_adder_3: full_adder port map(INVAL_1 => INVAL_1(3), INVAL_2 => INVAL_2(3), CARRY_IN  => CARRY_TMP(2), OUTVAL => OUTVAL(3), CARRY_OUT =>CARRY_OUT);

end behav;
