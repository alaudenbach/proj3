-- 1-bit full adder
-- Declare the 1-bit full adder with the inputs and outputs
-- shown inside the port(). This adds two bits together (x,y)
-- with a carry in (cin) and outputs the sum (sum) and a 
-- carry out (cout).

library IEEE;
use IEEE.std_logic_1164.all;

entity one_alu is
	port(a, b, cin : in std_logic;
	func           : in STD_LOGIC_VECTOR(5 downto 0);
	result, cout   : out std_logic);
end one_alu;

architecture my_dataflow of one_alu is

begin

process (a,b,cin,func) is

begin

case func is
    --000000 = and
    when "000000" =>
    result<= (a and b);
    cout<= '0';

--000001 = or
when "000001" =>
    result<= (a or b);
    cout<= '0';

--100111 = nor
when "100111" =>
    result<= not (a or b);
    cout<= '0';

--101000 = nand
when "101000" =>
    result<= not (a and b);
    cout<= '0';

--000010 = addition
when "000010" =>
    result<= (a xor b) xor cin;
    cout<= (a and b) or (a and cin) or (b and cin);

--000110 = subtract
when "000110" =>
    result<= (a xor (not b)) xor cin;
    cout<= (a and (not b)) or (a and cin) or ((not b) and cin);

--000111 = slt
when "000111" =>
    result<= (a xor (not b)) xor cin;
    cout<= (a and (not b)) or (a and cin) or ((not b) and cin);


when others =>
result<= '0';
cout<= '0';

end case;

end process;

end my_dataflow;
