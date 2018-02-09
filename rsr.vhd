--
-- James Durtka
--
-- EELE 466 Computational Computer Architecture
-- Spring 2017
-- Lab #3 - Implementing the reciprocal squareroot function in hardware
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity rsr is
	port (
	        Clock        : in  std_logic;
	        x : in  std_logic_vector (27 downto 0);
	        y  : out std_logic_vector (27 downto 0)
	    );

	constant W : integer := 28;
	constant F : integer := 14;

end entity;

architecture rsr_arch of rsr is
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

			y	: out std_logic_vector(27 downto 0)
		);
	end component;

	signal y0_int : std_logic_vector (27 downto 0);
begin

	INIT_GUESS : compute_y0 port map (clk => Clock, x => x, y0 => y0_int);
	NEWTONS_METHOD : compute_y port map (clk => Clock, x => x, y0 => y0_int, y => y);

end architecture;