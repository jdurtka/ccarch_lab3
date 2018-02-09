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

entity compute_y0_tb is
end entity;

architecture compute_y0_tb_arch of compute_y0_tb is

	component compute_y0 is
	port (
		clk	: in std_logic;
		x	: in std_logic_vector (27 downto 0);

		y0	: out std_logic_vector (27 downto 0)
	);
	end component;

	signal CLK_TB : std_logic;
	signal X_32_TB : std_logic_vector(31 downto 0);
	signal Y0_32_TB : std_logic_vector(31 downto 0);

begin
	DUT1 : compute_y0 port map (clk => CLK_TB, x => X_32_TB(29 downto 2), y0 => Y0_32_TB(29 downto 2));
  Y0_32_TB(1 downto 0) <= "00";
  Y0_32_TB(31 downto 30) <= "00";

	process
	begin
		CLK_TB <= '0';
		--X_32_TB <= x"00000000";
		X_32_TB <= "00000000000001000000000000000000";
		--X_32_TB <= x"00000001";
		wait for 1 ns;

		CLK_TB <= '1';
		wait for 1 ns;
 
--		CLK_TB <= '0';
--		X_32_TB <= x"00010000";
--		X_32_TB <= "00000000000000010000000000000000";
--		wait for 1 ns;
--
--		CLK_TB <= '1';
--		wait for 1 ns;


--		CLK_TB <= '0';
--		X_32_TB <= x"01000000";
--		wait for 1ns;

--		CLK_TB <= '1';
--		wait for 1ns;


--		CLK_TB <= '0';
--		X_32_TB <= x"00001000";
--		wait for 1ns;

--		CLK_TB <= '1';
--		wait for 1ns;

--		CLK_TB <= '0';
--		X_32_TB <= x"00000001";
--		wait for 1ns;

--		CLK_TB <= '1';
--		wait for 1ns;


--		CLK_TB <= '0';
--		X_32_TB <= x"10000000";
--		wait for 1ns;

--		CLK_TB <= '1';
--		wait for 1ns;



	end process;
end architecture;
