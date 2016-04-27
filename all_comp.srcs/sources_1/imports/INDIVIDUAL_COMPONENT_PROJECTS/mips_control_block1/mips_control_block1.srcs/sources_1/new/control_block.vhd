----------------------------------------------------------------------------------
-- 
-- Create Date: 04/16/2016 12:30:10 PM
-- Module Name: control_block - Behavioral

-- Revision 0.01 - File Created

----------------------------------------------------------------------------------
--CONTROL BLOCK FOR MIPS ARCHITECTURE
--Team 1
--Ashley Laudenbach, David Vitale, Ryan Walsh
--
-- DESCRIPTION OF CONTROL BLOCK
-- The control block takes an instruction as input and determines the appropriate output for each control signal
-----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

--define control block i/o
entity control_block is
    Port ( control_in : in STD_LOGIC_VECTOR (5 downto 0);
           RegDst : out STD_LOGIC_VECTOR (1 downto 0);
           Jump : out STD_LOGIC;
           Branch : out STD_LOGIC;
           MemRead : out STD_LOGIC;
           MemtoReg : out STD_LOGIC_VECTOR (1 downto 0);
           ALUOp : out STD_LOGIC_VECTOR (1 downto 0);
           MemWrite : out STD_LOGIC;
           ALUSrc : out STD_LOGIC;
           RegWrite : out STD_LOGIC);
end control_block;

--define behavior of control block
architecture Behavioral of control_block is
    SIGNAL R_FORMAT, LW, SW, BEQ, ADDI, ORI, LUI, JAL : STD_LOGIC;

begin
    --use opcode to determine instruction 
    R_FORMAT    <= '1' WHEN control_in = "000000" ELSE '0';
    LW          <= '1' WHEN control_in = "100011" ELSE '0';
    SW          <= '1' WHEN control_in = "101011" ELSE '0';
    BEQ         <= '1' WHEN control_in = "000010" ELSE '0';
    ADDI        <= '1' WHEN control_in = "001000" ELSE '0';
    ORI         <= '1' WHEN control_in = "001101" ELSE '0';
    LUI         <= '1' WHEN control_in = "001111" ELSE '0';
    JAL         <= '1' WHEN control_in = "000011" ELSE '0';
    
    --use instruction to determine output signals
    RegDst(1)   <= JAL;
    RegDst(0)   <= R_FORMAT OR LUI;
    Branch      <= BEQ;
    MemRead     <= LW;
    MemtoReg(1) <= JAL;
    MemtoReg(0) <= LW;
    ALUOp(1)    <= R_FORMAT OR ADDI OR ORI OR LUI;
    ALUOp(0)    <= BEQ OR ADDI OR ORI OR LUI;
    MemWrite    <= LW OR SW;
    ALUSrc      <= LW OR SW OR ADDI OR ORI OR LUI;
    RegWrite    <= R_FORMAT OR LW OR ADDI OR ORI OR JAL OR LUI;
    Jump        <= JAL;

end Behavioral;
