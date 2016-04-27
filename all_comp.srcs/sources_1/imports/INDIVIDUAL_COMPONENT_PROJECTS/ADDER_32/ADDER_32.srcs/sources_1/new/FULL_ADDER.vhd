library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FULL_ADDER is
    port (  a, b, cin: in STD_LOGIC;
            s, cout: out STD_LOGIC );
end FULL_ADDER;

architecture FULL_ADDER_STRUCTURE of FULL_ADDER is
    begin
    s <= a xor b xor cin;
    cout <= (a and b) or (cin and a) or (cin and b);
end FULL_ADDER_STRUCTURE;

