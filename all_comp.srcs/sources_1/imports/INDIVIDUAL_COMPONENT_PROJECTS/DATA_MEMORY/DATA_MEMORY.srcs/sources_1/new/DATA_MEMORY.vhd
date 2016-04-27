library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DATA_MEMORY is
    port (  clk, mem_write: in STD_LOGIC;
            data_in, addr_in: in STD_LOGIC_VECTOR(31 downto 0);
            data_out: out STD_LOGIC_VECTOR(31 downto 0));
end DATA_MEMORY;

architecture DATA_MEMORY_STRUCTURE of DATA_MEMORY is 
    type MEM_ARRAY_16Kx32 is array(0 to 16383) of STD_LOGIC_VECTOR(31 downto 0);
    signal RAM: MEM_ARRAY_16Kx32;-- := (others => (others => '0')); --Init all to 0
    
    --RAM(0) <= "000000000000000000000000000";
    --RAM(16383) <= "1";
    
    begin          
        process(clk)
            begin
                if clk'event and clk = '1' then
                    if mem_write = '1' then
                        RAM(conv_integer(addr_in(15 downto 0))) <= data_in; --sync write
                    end if;
                end if;
        end process;
        
        data_out <= RAM(conv_integer(addr_in(15 downto 0))); --async read

end DATA_MEMORY_STRUCTURE;
