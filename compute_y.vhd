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

entity compute_y is
	port (
		clk	: in std_logic;
		x	: in std_logic_vector(27 downto 0);
		y0	: in std_logic_vector(27 downto 0);

		-- '0' means starting with a new x, '1' means iterating from the same x
		iterate : in std_logic;

		y	: out std_logic_vector(27 downto 0);
		count : out std_logic_vector(7 downto 0)
	);


	constant W : integer := 28;
	constant F : integer := 14;
end entity;

architecture compute_y_arch of compute_y is
	signal intermediate_big_y : unsigned(111 downto 0);
	signal iteration_count : integer;

	constant three : unsigned(83 downto 0) := to_unsigned(3,84);
begin

	y <= std_logic_vector(intermediate_big_y(27 downto 0));

	--EULER'S METHOD
	--		y1 = y0*(3-x*y0*y0)/2
	--		y2 = y1*(3-x*y1*y1)/2
	-- The division is accomplished by a simple shift to the right.
	-- HOWEVER, it is necessary to insert several more shifts. Each multiplication doubles the word size,
	-- so we store the extra bits but keep shifting back to maintain our radix. Especially, in the 3-x*yn*yn step
	-- it is critical to shift the 3 to the correct radix (left F bits) and the product back to the correct radix (right 2*F bits)
	-- 
	-- The final result must also be shifted to the correct radix (right F bits), which can be done along with the
	-- divide by two step (shift right 1 bit)
	-- 
	--etc.
	process (clk)
	begin
		if (rising_edge(clk)) then
			if (iterate = '1') then
				iteration_count <= iteration_count + 1;
				intermediate_big_y <= shift_right((intermediate_big_y(27 downto 0) * (shift_left(three,F) - shift_right((unsigned(x)*intermediate_big_y(27 downto 0)*intermediate_big_y(27 downto 0)),2*F))), 1 + (F));
			else
				iteration_count <= 0;
				intermediate_big_y <= shift_right((unsigned(y0) * (shift_left(three,F) - shift_right((unsigned(x)*unsigned(y0)*unsigned(y0)),2*F))), 1 + (F));
			end if;
			count <= std_logic_vector(to_unsigned(iteration_count, 8));
		end if;
	end process;

end architecture;