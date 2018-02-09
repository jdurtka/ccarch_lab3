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

	entity x_shifter is
		port (
			clk : in std_logic;

			x			: in std_logic_vector(27 downto 0);
			beta : in std_logic_vector(4 downto 0);
			alpha : in std_logic_vector(7 downto 0);

			x_alpha : out std_logic_vector(27 downto 0);
			x_beta : out std_logic_vector(27 downto 0)
	);

	constant W : integer := 28;
	constant F : integer := 14;
end entity;



	architecture x_shifter_arch of x_shifter is
		signal neg_beta : signed(4 downto 0);
		signal neg_alpha : signed(6 downto 0);

	begin

			neg_beta <= 0-signed(beta);

			--This hideous expression amounts to a demux that allows us to select between the two without wasting clock cycles
			x_beta <= (std_logic_vector(shift_right(signed(x),to_integer(signed(beta)))) and not (beta(4) & beta(4) & beta(4) & beta(4) & beta(4) & beta(4) & beta(4) & beta(4) & beta(4) & beta(4) & beta(4) & beta(4) & beta(4) & beta(4) & beta(4) & beta(4) & beta(4) & beta(4) & beta(4) & beta(4) & beta(4) & beta(4) & beta(4) & beta(4) & beta(4) & beta(4) & beta(4) & beta(4))) or (std_logic_vector(shift_left(signed(x),to_integer(neg_beta))) and (beta(4) & beta(4) & beta(4) & beta(4) & beta(4) & beta(4) & beta(4) & beta(4) & beta(4) & beta(4) & beta(4) & beta(4) & beta(4) & beta(4) & beta(4) & beta(4) & beta(4) & beta(4) & beta(4) & beta(4) & beta(4) & beta(4) & beta(4) & beta(4) & beta(4) & beta(4) & beta(4) & beta(4)));


				-- VERY IMPORTANT:
				-- The process used to compute alpha will leave a single trailing fraction bit
				-- This must be concatenated!
			neg_alpha <= 0-signed(alpha(7 downto 1));

			--This hideous expression amounts to a demux that allows us to select between the two without wasting clock cycles
			x_alpha <= (std_logic_vector(shift_right(signed(x),to_integer(neg_alpha))) and (alpha(7) & alpha(7) & alpha(7) & alpha(7) & alpha(7) & alpha(7) & alpha(7) & alpha(7) & alpha(7) & alpha(7) & alpha(7) & alpha(7) & alpha(7) & alpha(7) & alpha(7) & alpha(7) & alpha(7) & alpha(7) & alpha(7) & alpha(7) & alpha(7) & alpha(7) & alpha(7) & alpha(7) & alpha(7) & alpha(7) & alpha(7) & alpha(7))) or (std_logic_vector(shift_left(signed(x),to_integer(signed(alpha(7 downto 1))))) and not (alpha(7) & alpha(7) & alpha(7) & alpha(7) & alpha(7) & alpha(7) & alpha(7) & alpha(7) & alpha(7) & alpha(7) & alpha(7) & alpha(7) & alpha(7) & alpha(7) & alpha(7) & alpha(7) & alpha(7) & alpha(7) & alpha(7) & alpha(7) & alpha(7) & alpha(7) & alpha(7) & alpha(7) & alpha(7) & alpha(7) & alpha(7) & alpha(7)));
	end architecture;