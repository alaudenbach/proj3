-- 4-bit adder
-- Structural description of a 4-bit adder. This device
-- adds two 4-bit numbers together using four 1-bit full adders
-- described above.

-- This is just to make a reference to some common things needed.
LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- This describes the black-box view of the component we are
-- designing. The inputs and outputs are again described
-- inside port(). It takes two 4-bit values as input (x and y)
-- and produces a 4-bit output (ANS) and a carry out bit (Cout).

entity thirtytwo_alu is
	port( a, b		    : in	STD_LOGIC_VECTOR(31 downto 0);
	      alu_op        : in    STD_LOGIC_VECTOR(1 downto 0);
	      func          : in    STD_LOGIC_VECTOR(5 downto 0);
	      result	    : out	STD_LOGIC_VECTOR(31 downto 0);
	      overflow		: out	STD_LOGIC;	
	      zero          : out   STD_LOGIC;           
	      carryout      : out   STD_LOGIC);
end thirtytwo_alu;

-- Although we have already described the inputs and outputs,
-- we must now describe the functionality of the adder (ie:
-- how we produced the desired outputs from the given inputs).

architecture MY_STRUCTURE of thirtytwo_alu is

-- We are going to need four 1-bit adders, so include the
-- design that we have already studied in full_adder.vhd.

component one_alu
	port(a, b, cin      : in std_logic;
         func           : in STD_LOGIC_VECTOR(5 downto 0);
         result, cout   : out std_logic);
end component;

component oflow_det
    port(a_sign_bit         : in STD_LOGIC;
         b_sign_bit         : in STD_LOGIC;
         result_sign_bit    : in STD_LOGIC;
         carry_out          : in STD_LOGIC;
         alu_op             : in STD_LOGIC_VECTOR(1 downto 0);
         func               : in STD_LOGIC_VECTOR(5 downto 0);
         result_overflow    : out STD_LOGIC);
end component;

component barrel
    port(a       : in  std_logic_vector(31 downto 0);
         b       : in  std_logic_vector(31 downto 0);
         func    : in  std_logic_vector(5 downto 0);
         result  : out std_logic_vector(31 downto 0));
end component;
-- Now create the signals which are going to be necessary
-- to pass the outputs of one adder to the inputs of the next
-- in the sequence.
signal c : std_logic_vector(31 downto 0);
signal s_carry_out : STD_LOGIC;
signal s_overflow: STD_LOGIC;
signal s_result : STD_LOGIC_VECTOR(31 downto 0);
signal b_result : STD_LOGIC_VECTOR(31 downto 0);
signal zero_const : STD_LOGIC_VECTOR(31 downto 0);

begin

zero_const<="00000000000000000000000000000000";

process(func) is begin

if func = "000110" then --if addition
    c(0) <= '1';
else
    c(0) <= '0';
end if;

end process;

shifter: barrel port map (a, b, func, b_result);


stage: for i in 0 to 30 generate
    as: one_alu port map(a(i), b(i), c(i), func, s_result(i), c(i+1));
    end generate;

last_time: one_alu port map (a(31), b(31), c(31), func, s_result(31), s_carry_out); 
carryout<=s_carry_out;

overlow_detection: oflow_det port map (a(31), b(31), s_result(31), s_carry_out, alu_op, func, s_overflow);
overflow<=s_overflow;


process(s_result, b_result, s_overflow, func) is begin

if (func = "110000") or (func = "100000") then  --if shifter func
    result<= b_result;
    if b_result = zero_const then
        zero<= '1';
    else
        zero<='0';
    end if;

elsif (func = "000111") and (alu_op = "00") then    --if signed slt
    if (s_result(31) = '1') and (s_overflow = '0') then
        result<="00000000000000000000000000000001";
    else
        result<="00000000000000000000000000000000";
    end if;

elsif (func = "000111") and (alu_op = "11") then    --if unsigned slt
    if (s_overflow = '1') then
        result<="00000000000000000000000000000001";
    else
        result<="00000000000000000000000000000000";
    end if;

else

    result<=s_result; 
    if s_result = zero_const then
        zero<= '1';
    else
        zero<='0';
    end if;
   
end if;


end process;

END MY_STRUCTURE;
