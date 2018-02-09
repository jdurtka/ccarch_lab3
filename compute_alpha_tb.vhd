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

entity compute_alpha_tb is
end entity;

architecture compute_alpha_tb_arch of compute_alpha_tb is

	component compute_alpha is
	port (
			clk	: in std_logic;
			beta	: in std_logic_vector(4 downto 0);

			alpha	: out std_logic_vector(7 downto 0)
		);
	end component;

	signal CLK_TB : std_logic;
	signal BETA_TB : std_logic_vector(4 downto 0);
	signal ALPHA_TB : std_logic_vector(7 downto 0);

begin
	DUT1 : compute_alpha port map (clk => CLK_TB, beta => BETA_TB, alpha => ALPHA_TB);

	process
	begin
		CLK_TB <= '0';
		BETA_TB <= "00000";
		wait for 1ns;

		CLK_TB <= '1';
		wait for 1ns;

		--CLK_TB <= '0';
		--BETA_TB <= "00001";
		--wait for 1ns;

		--CLK_TB <= '1';
		--wait for 1ns;

		--CLK_TB <= '0';
		--BETA_TB <= "01010";
		--wait for 1ns;

		--CLK_TB <= '1';
		--wait for 1ns;

		--CLK_TB <= '0';
		--BETA_TB <= "10101";
		--wait for 1ns;

		--CLK_TB <= '1';
		--wait for 1ns;


	end process;
end architecture;
