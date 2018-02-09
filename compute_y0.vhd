--
-- James Durtka
--
-- EELE 466 Computational Computer Architecture
-- Spring 2017
-- Lab #3 - Implementing the reciprocal squareroot function in hardware
--

--Idiosyncracies:
--  Alpha is -2 beta + 1/2 beta (possibly +1/2). In order to calculate this, we have a signed 8-bit word,
--		and there is a single fractional bit at the end (this should always be zero due to how alpha is calculated)
--  This fractional bit is handled in the shifter (which produces x_alpha and x_beta), not in the computation of alpha

--This unit has been carefully constructed so that y0 is computed in a single clock cycle. The tradeoff will be logic elements,
--because any time a decision must be made based on whether beta is even or odd, we make the calculation both ways and then choose
--using combinational logic. This is sort of an inline "demux" and therefore requires additional logic elements, but the advantage
--is being able to use y0 after a single clock cycle. 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity compute_y0 is
	port (
		clk	: in std_logic;
		x	: in std_logic_vector (27 downto 0);

		y0	: out std_logic_vector (27 downto 0)
	);

	constant W : integer := 28;
	constant F : integer := 14;
end entity;

architecture compute_y0_arch of compute_y0 is

	component lzc is
	    port (
	        clk        : in  std_logic;
	        lzc_vector : in  std_logic_vector (27 downto 0);
	        lzc_count  : out std_logic_vector ( 4 downto 0)
	    );
	end component;

	component compute_beta is
		port (
			clk	: in std_logic;
			lzc_count : in std_logic_vector (4 downto 0);

			beta	: out std_logic_vector(4 downto 0)
		);
	end component;

	component compute_alpha is
		port (
			clk	: in std_logic;
			beta	: in std_logic_vector(4 downto 0);

			alpha	: out std_logic_vector(7 downto 0)
		);
	end component;

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

	component LUT is
		port (
			clk : in std_logic;
			x_beta : in std_logic_vector(27 downto 0);
			x_beta_lut_out : out std_logic_vector(27 downto 0)
    );
	end component;

	signal lzc_cnt_int : std_logic_vector (4 downto 0);
	signal beta_int : std_logic_vector(4 downto 0);
	signal beta_parity_int : std_logic;

	signal alpha_int : std_logic_vector(7 downto 0);

	signal x_alpha_int, x_beta_int, x_beta_lut_int : std_logic_vector(27 downto 0);

	signal invsqrt_two : std_logic_vector(27 downto 0);

	signal y0_big_beta_even : std_logic_vector(55 downto 0);
	signal y0_big_beta_odd : std_logic_vector(83 downto 0);

begin

	-- Compute leading zero count at the first step
	-- Available immediately (at the first rising edge of the clock)
	LZC_1 : lzc port map (clk => clk, lzc_vector => x, lzc_count => lzc_cnt_int);

	-- Compute beta at the second step: beta = W - F - Z - 1
	-- No latency!
	BETA_1 : compute_beta port map (clk => clk, lzc_count => lzc_cnt_int, beta => beta_int);

	-- Get beta parity by looking at the lowest bit (0 = even, 1 = odd)
	-- No latency!
	beta_parity_int <= beta_int(0);

	-- Compute alpha at the third step: alpha = -2beta + 1/2 beta (+1/2 if beta is odd)
	-- No latency!
	ALPHA_1 : compute_alpha port map (clk => clk, beta => beta_int, alpha => alpha_int);

	-- Compute x_alpha and x_beta
	-- No latency!
	XSHIFT : x_shifter port map (clk => clk, x => x, alpha => alpha_int, beta => beta_int, x_alpha => x_alpha_int, x_beta => x_beta_int);

	-- Compute x_beta ^ (-3/2)
	-- One clock cycle latency!
	XBETA_LUT : LUT port map (clk => clk, x_beta => x_beta_int, x_beta_lut_out => x_beta_lut_int);

	--value generated using Matlab = x"0002d41" via fi((1/sqrt(2)), 0, 28, 14)
	invsqrt_two <= x"0002d41";

	--Valid only if beta is even!
	y0_big_beta_even <= std_logic_vector(shift_right(unsigned(x_alpha_int) * unsigned(x_beta_lut_int), F));
	--Valid only if beta is odd!
	y0_big_beta_odd <= std_logic_vector(shift_right(unsigned(x_alpha_int) * unsigned(x_beta_lut_int) * unsigned(invsqrt_two), 2*F));

	--This hideous expression is essentially a one-line demux that allows us to choose between the two options without using a clock-based process
	--(thus using more logic elements in exchange for reduced clock cycles per computation)
	y0 <= (y0_big_beta_even(27 downto 0) and not (beta_int(0) & beta_int(0) & beta_int(0) & beta_int(0) & beta_int(0) & beta_int(0) & beta_int(0) & beta_int(0) & beta_int(0) & beta_int(0) & beta_int(0) & beta_int(0) & beta_int(0) & beta_int(0) & beta_int(0) & beta_int(0) & beta_int(0) & beta_int(0) & beta_int(0) & beta_int(0) & beta_int(0) & beta_int(0) & beta_int(0) & beta_int(0) & beta_int(0) & beta_int(0) & beta_int(0) & beta_int(0))) or (y0_big_beta_odd(27 downto 0) and (beta_int(0) & beta_int(0) & beta_int(0) & beta_int(0) & beta_int(0) & beta_int(0) & beta_int(0) & beta_int(0) & beta_int(0) & beta_int(0) & beta_int(0) & beta_int(0) & beta_int(0) & beta_int(0) & beta_int(0) & beta_int(0) & beta_int(0) & beta_int(0) & beta_int(0) & beta_int(0) & beta_int(0) & beta_int(0) & beta_int(0) & beta_int(0) & beta_int(0) & beta_int(0) & beta_int(0) & beta_int(0)));
	


end architecture;