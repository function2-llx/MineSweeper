library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MineSweeper is
    port (
        clk, rst: in std_logic;

        memory_cs: out std_logic;   --  always low
        memory_oe: out std_logic;   -- read
        memory_we: out std_logic;   -- wirte
        memory_addr: out std_logic_vector(19 downto 0);
        memory_data: inout std_logic_vector(31 downto 0)
    );
    end entity;
        
architecture bhv of MineSweeper is
    signal mode: std_logic_vector(0 to 1) := "11";
    constant n: integer := 5;
    signal r, c: integer range 0 to 31;
    signal lose: std_logic;
    signal remain, oper: integer range 0 to 300;
    
    component board is
        port(
            clk, rst: in std_logic;
            
            mode_in: in std_logic_vector(0 to 1);  -- 01：左击；10：右击；11：初始化
            r, c: in integer range 0 to 31;
            
            lose: out std_logic;
            remain: inout integer range 0 to 300; --  剩余雷数
            oper: inout integer range 0 to 300;   -- 剩余未操作格子数
    
            memory_oe: out std_logic;   -- read
            memory_we: out std_logic;   -- wirte
            memory_addr: out std_logic_vector(19 downto 0);
            memory_data: inout std_logic_vector(31 downto 0)
        );
    end component;
begin
    memory_cs <= '0';
    -- memory_oe <= '1';
    -- memory_we <= '1';
    
    board_ins: board port map(clk, rst, mode, r, c, lose, remain, oper, memory_oe, memory_we, memory_addr, memory_data);
end architecture;