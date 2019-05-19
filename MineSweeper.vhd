library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MineSweeper is
    port (
        clk, rst: in std_logic;

        memory_cs: out std_logic;   --  always low
        memory_oe: inout std_logic;   -- read
        memory_we: inout std_logic;   -- wirte
        memory_addr: inout std_logic_vector(19 downto 0);
        memory_data: inout std_logic_vector(31 downto 0)
        );
        end entity;
        
architecture bhv of MineSweeper is
    
    component board is
        port(
            clk, rst: in std_logic;
            
            mode: in std_logic_vector(0 to 1);  -- 10：左击；01：右击；else：不做
            r, c: in std_logic_vector(4 downto 0);   -- n <= 16=2^4,r < 2n, c < 2n

            memory_ctrl: inout std_logic;
            memory_oe: inout std_logic;   -- read
            memory_we: inout std_logic;   -- wirte
            memory_addr: inout std_logic_vector(19 downto 0);
            memory_data: inout std_logic_vector(31 downto 0)
        );
    end component;
    
    signal memory_ctrl: std_logic;        
    signal mode: std_logic_vector(0 to 1) := "11";
    signal r, c: std_logic_vector(4 downto 0);
begin
    memory_cs <= '0';
    memory_oe <= '1';
    memory_we <= '1';
    
    board_ins: board port map(clk, rst, mode, r, c, memory_ctrl, memory_oe, memory_we, memory_addr, memory_data);
end architecture;