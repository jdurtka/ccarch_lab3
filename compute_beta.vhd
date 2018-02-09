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

entity compute_beta is
	port (
		clk	: in std_logic;
		lzc_count : in std_logic_vector (4 downto 0);

		beta	: out std_logic_vector(4 downto 0)
	);

	constant W : integer := 28;
	constant F : integer := 14;
end entity;

architecture compute_beta_arch of compute_beta is
	signal result_int : signed (4 downto 0);

	signal neg_f : signed(4 downto 0);
	signal neg_1 : signed(4 downto 0);
	signal neg_Z : signed(4 downto 0);
begin
	neg_Z <= 0-signed(lzc_count);
	neg_F <= 0-to_signed(F,5);
	neg_1 <= to_signed(0-1,5);

	beta <= std_logic_vector(result_int);

	result_int <= to_signed(W+to_integer(neg_Z)+to_integer(neg_F)+to_integer(neg_1),5);

end architecture;
