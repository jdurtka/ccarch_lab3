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

entity compute_alpha is
	port (
			clk	: in std_logic;
			beta	: in std_logic_vector(4 downto 0);

			alpha	: out std_logic_vector(7 downto 0)
		);

	constant W : integer := 28;
	constant F : integer := 14;
end entity;

architecture compute_alpha_arch of compute_alpha is
	--signal Z_int, result_int : unsigned (4 downto 0);
	signal negtwobeta, halfbeta, plushalf : signed (7 downto 0);
	signal leading_zeroes : std_logic_vector(6 downto 0);
begin
	--Z_int <= unsigned(lzc_count);
	--beta <= std_logic_vector(result_int);

	leading_zeroes <= "0000000";

	-- 2*beta = beta, shifted to the left once (+1 for the fractional)
	--       XXXXX
	--		 ++++++++
	negtwobeta <= 0-shift_left(signed(beta(4) & beta(4) & beta(4) & beta), 2);

	--1/2 beta = beta, shifted to the right once (-1 for the fractional)
	halfbeta <= signed(beta(4) & beta(4) & beta(4) & beta);

	--plushalf = the lowest order bit of beta (0 if even, 1 if odd)
	plushalf <= signed(leading_zeroes & beta(0));

	alpha <= std_logic_vector(plushalf + halfbeta + negtwobeta);

end architecture;
