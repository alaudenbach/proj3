library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ADDER_32 is
    port (  a, b: in STD_LOGIC_VECTOR(31 downto 0);
            cin: in STD_LOGIC;
            s: out STD_LOGIC_VECTOR(31 downto 0);
            cout: out STD_LOGIC);
end ADDER_32;

architecture ADDER_32_STRUCTURE of ADDER_32 is 
    component FULL_ADDER
        port(   a, b, cin: in STD_LOGIC;
                s, cout: out STD_LOGIC);
    end component;

    signal c: STD_LOGIC_VECTOR(0 to 30);
    
    begin
      --32 bit adder generated via for loop of connected full adders
      a0: entity WORK.FULL_ADDER port map(a(0), b(0), cin, s(0), c(0));
      stage: for i in 1 to 30 generate
                 as: entity WORK.FULL_ADDER port map(a(i), b(i), c(i-1) , s(i), c(i));
             end generate stage;
      a31: entity WORK.FULL_ADDER port map(a(31), b(31), c(30) , s(31), cout);
end ADDER_32_STRUCTURE;
