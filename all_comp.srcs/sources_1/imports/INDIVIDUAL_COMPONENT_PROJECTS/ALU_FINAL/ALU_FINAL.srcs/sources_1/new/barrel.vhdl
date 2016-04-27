library IEEE;
use IEEE.std_logic_1164.all;
USE IEEE.numeric_std.ALL;

entity barrel is   -- barrel shifter
      port (a       : in  std_logic_vector (31 downto 0);
            b       : in  std_logic_vector(31 downto 0);
            func    : in  std_logic_vector(5 downto 0); -- '1' for left, '0' for right
            result  : out std_logic_vector (31 downto 0) );
end barrel;

architecture foo of barrel is

begin

process(func, a, b)

variable b_int : integer;
variable s_result : std_logic_vector(31 downto 0);
variable tmp : integer;
variable tmp2 : integer;
variable tmp3 : integer;
                             
begin

b_int := to_integer(unsigned(b));

if (b_int < 0) or (b_int > 31) then
    result<="00000000000000000000000000000000";
else

if func = "110000" then

   -- for i in 0 to 31 loop
    --    s_result(i):= '1';
   -- end loop;

tmp2 := b_int - 1;

    for i in 0 to tmp2 loop
        s_result(i):= '0';
    end loop;
    
    tmp := 0;
    for i in b_int to 31 loop
        s_result(i) := a(tmp);
        tmp := tmp + 1;
    end loop;

   -- s_result := a(31 - b_int downto 0) & (b_int - 1 downto 0 => '0');
--s_result :="00000000000000000000000000000000";
else

    s_result := "00000000000000000000000000000000";

    for i in 0 to 31 loop
    s_result(i) := '1';
    end loop;

tmp3 := 31 - (b_int-1);
    for i in tmp3 to 31 loop
       s_result(i) := '0';
   end loop;
   
   --tmp := (31 - b_int);
  -- for i in 0 to (31 - b_int) loop
   ---    s_result(i) := a(tmp);
  --     tmp := tmp - 1;
  -- end loop;

   -- s_result := (31 downto 32 - b_int => '0') & a(31 downto b_int);
--s_result := "00000000000000000000000000000000";

end if;

result <= s_result;

end if;

end process;

END foo;