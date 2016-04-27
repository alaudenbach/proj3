----------------------------------------------------------------------------------
-- Create Date: 04/17/2016 07:03:42 PM
-- Module Name: register_memory_tb - Behavioral
-- Project Name: mips processor
-- Team: 1
-- Ashley Laudenbach, David Vitale, Ryan Walsh

-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
-- REGISTER FILE TESTBENCH DESCRIPTION
-- The register file block stores 32 bit data for 32 registers
-- The register file test bench tests the functionality of the register file: reads and writes

----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

entity register_memory_tb is
--  Port ( );
end register_memory_tb;

architecture Behavioral of register_memory_tb is
    --define i/0 ports of design component
    COMPONENT reg_memory
    PORT (
        clk : in std_logic;
        write_en : in STD_LOGIC;
        write_data : in STD_LOGIC_VECTOR (31 downto 0);
        write_reg : in STD_LOGIC_VECTOR (4 downto 0);
        read_reg1 : in STD_LOGIC_VECTOR (4 downto 0);
        read_reg2 : in STD_LOGIC_VECTOR (4 downto 0);
        read_data1 : out STD_LOGIC_VECTOR (31 downto 0);
        read_data2 : out STD_LOGIC_VECTOR (31 downto 0)
        );
    END COMPONENT;

    --specify test block signals
    signal clk: std_logic := '0';
    signal write_en: std_logic := '0';
    signal write_reg, read_reg1, read_reg2 : std_logic_vector (4 downto 0) := (others => '0');
    signal write_data, read_data1, read_data2 : std_logic_vector (31 downto 0) := (others => '0');
    constant clk_period : time := 50 ns;


BEGIN
    --define unit under test, map out ports to virtual test bench
    UUT: reg_memory PORT MAP (
         clk => clk,
         write_en => write_en,
         write_data => write_data,
         write_reg => write_reg,
         read_reg1 => read_reg1,
         read_reg2 => read_reg2,
         read_data1 => read_data1,
         read_data2 => read_data2
         );
         
    --set clock frequency, duty cycle
    clk_process: process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;
    
    --the main process includes all test cases
    main_process: process
    begin
    
        --test case 1
        --write to registers when write enabled
        write_en <= '1';
        write_data <= "00000000000000000000000000000011";
        write_reg <= "00001";
        wait for clk_period;
        
        write_reg <= "00010";
        write_data <= "00000000000000000000000000000101";
        wait for clk_period;
        
        read_reg1 <= "00001";
        --wait for clk_period;
        read_reg2 <= "00010";
        wait for clk_period;
        
        assert  read_data1 = "00000000000000000000000000000011" 	   report "Failed Case 1" severity error;
        assert  read_data2 = "00000000000000000000000000000101" 	   report "Failed Case 1" severity error;
        write_en <= '0';
        wait for clk_period;
        
        --test case 2
        --try to write to register when clock is not enabled
        write_en <= '0';
        write_data <= "00000000000000000000000000000000";
        write_reg <= "00001";
        wait for clk_period;
        
        write_reg <= "00010";
        write_data <= "00000000000000000000000000000000";
        wait for clk_period;
        
        read_reg1 <= "00001";
        --wait for clk_period;
        read_reg2 <= "00010";
        wait for clk_period;
        
        assert  read_data1 = "00000000000000000000000000000011"        report "Failed Case 2" severity error;
        assert  read_data2 = "00000000000000000000000000000101"        report "Failed Case 2" severity error;
        write_en <= '0';
        wait for clk_period;
        
        --test case 3
        --over-write register data when clock is enabled
        write_en <= '1';
        write_data <= "00000000000000000000000000001111";
        write_reg <= "00001";
        wait for clk_period;
        
        write_reg <= "00010";
        write_data <= "00000000000000000000000000001111";
        wait for clk_period;
        
        read_reg1 <= "00001";
        --wait for clk_period;
        read_reg2 <= "00010";
        wait for clk_period;
        
        assert  read_data1 = "00000000000000000000000000001111"        report "Failed Case 3" severity error;
        assert  read_data2 = "00000000000000000000000000001111"        report "Failed Case 3" severity error;
        write_en <= '0';
        wait for clk_period;
        
        --test case 4
        --write to registers, then read registers
        write_en <= '1';
        write_data <= "11111111111111111111111111111111";
        write_reg <= "11111";
        wait for clk_period;
        
        write_reg <= "11110";
        write_data <= "11111111111111111111111111111110";
        wait for clk_period;
        
        read_reg1 <= "11111";
        --wait for clk_period;
        read_reg2 <= "11110";
        wait for clk_period;
        
        assert  read_data1 = "11111111111111111111111111111111"        report "Failed Case 4" severity error;
        assert  read_data2 = "11111111111111111111111111111110"        report "Failed Case 4" severity error;
        write_en <= '0';
        wait for clk_period;
        
    end process;
    
        
END Behavioral;
