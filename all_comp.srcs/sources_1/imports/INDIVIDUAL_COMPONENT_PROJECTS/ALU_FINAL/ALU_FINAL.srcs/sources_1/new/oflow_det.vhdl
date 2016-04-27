library IEEE;
use IEEE.std_logic_1164.all;
USE IEEE.numeric_std.ALL;

entity oflow_det is
    port(a_sign_bit         : in STD_LOGIC;
         b_sign_bit         : in STD_LOGIC;
         result_sign_bit    : in STD_LOGIC;
         carry_out          : in STD_LOGIC;
         alu_op             : in STD_LOGIC_VECTOR(1 downto 0);
         func               : in STD_LOGIC_VECTOR(5 downto 0);
         result_overflow    : out STD_LOGIC);
end oflow_det;

architecture MY_STRUCTURE of oflow_det is

signal tmp: STD_LOGIC;
signal s_result_overflow: STD_LOGIC;

begin

process(a_sign_bit, b_sign_bit, result_sign_bit, carry_out, alu_op, func) is begin

--signal b_int : integer;
--signal result_int : integer;

--begin

--b_int := to_integer(unsigned(b));
--result_int := to_integer(unsigned(result));

if alu_op = "11" then   --for unsigned

    if (func = "000110") or (func = "000111") then --if subtract or slt
   --     if b_int > result_int then
    --        result_overflow<='1';
        result_overflow<= not carry_out;
    else
        result_overflow<= carry_out;
    --    else
    --        result_overflow<='0';  
   -- else
       --result_overflow<=carry_out;
    end if;

else

    if func = "000010" then     -- if addition
       tmp <= b_sign_bit;      --normal
    else                        -- else its subtraction
        tmp <= (not b_sign_bit);  -- else b sign bit should be opposite
    end if;

    if (a_sign_bit = not tmp) then   --opposite sign numbers can never overflow
        result_overflow <= '0';
    elsif (a_sign_bit = result_sign_bit) then   --if the sign bits of a = b = result
        result_overflow <= '0';                 --no overflow
    else
       result_overflow <= '1';                 --else there is an overflow
    end if;


end if;

end process;


END MY_STRUCTURE;
