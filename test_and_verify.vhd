--
-- James Durtka
--
-- EELE 466 Computational Computer Architecture
-- Spring 2017
-- Lab #3 - Implementing the reciprocal squareroot function in hardware
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity test_and_verify is
end entity;

architecture test_and_verify_arch of test_and_verify is

	component compute_y0 is
	port (
		clk	: in std_logic;
		x	: in std_logic_vector (27 downto 0);

		y0	: out std_logic_vector (27 downto 0)
	);
	end component;

	component compute_y is
	port (
		clk	: in std_logic;
		x	: in std_logic_vector(27 downto 0);
		y0	: in std_logic_vector(27 downto 0);

		-- '0' means starting with a new x, '1' means iterating from the same x
		iterate : in std_logic;

		y	: out std_logic_vector(27 downto 0);
		count : out std_logic_vector(7 downto 0)
	);
	end component;


	signal CLK_TB : std_logic;
	signal X_32_TB, Y_32_TB : std_logic_vector (31 downto 0);
	signal Y0_TB : std_logic_vector (27 downto 0);
	signal iterate_TB : std_logic;
	signal count_TB : std_logic_vector(7 downto 0);

begin
	DUT1 : compute_y0 port map (clk => CLK_TB, x => X_32_TB(29 downto 2), y0 => Y0_TB);
	DUT2 : compute_y port map (clk => CLK_TB, x => X_32_TB(29 downto 2), y0 => Y0_TB, iterate => iterate_TB, y => Y_32_TB(29 downto 2), count => count_TB);

	--fill in the unused part of Y_32_TB so it doesn't show up as red in the waveform
	Y_32_TB(1 downto 0) <= "00";
	Y_32_TB(31 downto 30) <= "00";

	process
	begin
		CLK_TB <= '0';
		X_32_TB <= x"00170000";
		iterate_TB <= '0';
		wait for 1ns;
		CLK_TB <= '1';
		wait for 1ns;



		CLK_TB <= '0';
		X_32_TB <= x"00170000";
		iterate_TB <= '0';
		wait for 1ns;
		CLK_TB <= '1';
		wait for 1ns;
		CLK_TB <= '0';

		X_32_TB <= x"00170000";
		iterate_TB <= '1';
		wait for 1ns;
		CLK_TB <= '1';
		wait for 1ns;
		CLK_TB <= '0';

		X_32_TB <= x"00170000";
		iterate_TB <= '1';
		wait for 1ns;
		CLK_TB <= '1';
		wait for 1ns;




	end process;
end architecture;
