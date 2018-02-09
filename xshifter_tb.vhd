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

entity xshifter_tb is
end entity;

architecture xshifter_tb_arch of xshifter_tb is

	component x_shifter is
		port (
			clk : in std_logic;

			x			: in std_logic_vector(27 downto 0);
			beta : in std_logic_vector(4 downto 0);
			alpha : in std_logic_vector(7 downto 0);

			x_alpha : out std_logic_vector(27 downto 0);
			x_beta : out std_logic_vector(27 downto 0)
		);
	end component;

	signal CLK_TB : std_logic;
	signal X_32_TB : std_logic_vector(31 downto 0);
	signal BETA_TB : std_logic_vector(4 downto 0);
	signal ALPHA_TB : std_logic_vector(7 downto 0);

	signal X_ALPHA_TB : std_logic_vector(27 downto 0);
	signal X_BETA_TB : std_logic_vector(27 downto 0);

begin
	DUT1 : x_shifter port map (clk => CLK_TB, beta => BETA_TB, alpha => ALPHA_TB, x => X_32_TB(29 downto 2), x_alpha =>  X_ALPHA_TB, x_beta => X_BETA_TB);

	process
	begin
		CLK_TB <= '0';
		X_32_TB <= x"00010000";
		BETA_TB <= "00000";
		ALPHA_TB <= x"00";
		wait for 1ns;

		CLK_TB <= '1';
		wait for 1ns;


	end process;
end architecture;
