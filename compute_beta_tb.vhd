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

entity compute_beta_tb is
end entity;

architecture compute_beta_tb_arch of compute_beta_tb is

	component compute_beta is
		port (
			clk	: in std_logic;
			lzc_count : in std_logic_vector (4 downto 0);
	
			beta	: out std_logic_vector(4 downto 0)
		);
	end component;

	signal CLK_TB : std_logic;
	signal LZC_COUNT_TB, BETA_TB : std_logic_vector(4 downto 0);

begin
	DUT1 : compute_beta port map (clk => CLK_TB, lzc_count => LZC_COUNT_TB, beta => BETA_TB);

	process
	begin
		CLK_TB <= '0';
		LZC_COUNT_TB <= "01101";
		wait for 1ns;

		CLK_TB <= '1';
		wait for 1ns;

--		CLK_TB <= '0';
--		LZC_COUNT_TB <= "00001";
--		wait for 1ns;
--
--		CLK_TB <= '1';
--		wait for 1ns;
--
--		CLK_TB <= '0';
--		LZC_COUNT_TB <= "00111";
--		wait for 1ns;
--
--		CLK_TB <= '1';
--		wait for 1ns;
--
--		CLK_TB <= '0';
--		LZC_COUNT_TB <= "01101";
--		wait for 1ns;
--
--		CLK_TB <= '1';
--		wait for 1ns;
--
	end process;
end architecture;
