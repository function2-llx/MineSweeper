library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MineSweeper is
    port (
        clk, rst: in std_logic;

        -- for test
        -- mode: in std_logic_vector(0 to 1);
        -- r, c: in integer range 0 to 31; 

        led_raw: out std_logic_vector(0 to 55);

        memory_cs: out std_logic;   --  always low
        memory_oe: out std_logic;   -- read
        memory_we: out std_logic;   -- wirte
        memory_addr: out std_logic_vector(19 downto 0);
        memory_data: inout std_logic_vector(31 downto 0)
    );
    end entity;
        
architecture bhv of MineSweeper is
    constant n: integer := 5;

    signal mode: std_logic_vector(0 to 1) := "11";
    signal r, c: integer range 0 to 31;

    signal lose, win: std_logic;
    signal remain: integer range 0 to 300;

    type led_type is array(0 to 7) of std_logic_vector(0 to 6);
    signal leds: led_type;
    
    component board is
        port(
            clk, rst: in std_logic;
            
            mode_in: in std_logic_vector(0 to 1);  -- 01：左击；10：右击；11：初始化
            r, c: in integer range 0 to 31;
            
            lose, win: out std_logic;
            remain: inout integer range 0 to 300; --  剩余雷数
    
            memory_oe: out std_logic;   -- read
            memory_we: out std_logic;   -- wirte
            memory_addr: out std_logic_vector(19 downto 0);
            memory_data: inout std_logic_vector(31 downto 0)
        );
    end component;

    component decoder is
        port (
            code: in std_logic_vector(3 downto 0);
            display: out std_logic_vector(0 to 6)
        );
    end component;

    signal test: std_logic_vector(0 to 3) := "0010";
begin
    memory_cs <= '0';
    led_raw(0 to 6) <= leds(0);
    led_raw(7 to 13) <= leds(1);
    led_raw(14 to 20) <= leds(2);
    led_raw(21 to 27) <= leds(3);
    led_raw(28 to 34) <= leds(4);
    led_raw(35 to 41) <= leds(5);
    led_raw(42 to 48) <= leds(6);
    led_raw(49 to 55) <= leds(7);

    process(clk, rst)
    begin
        if rst = '0' then
            test <= "0000";
        elsif clk'event and clk = '1' then
            test <= test + 1;
        end if;
    end process;

    decoder0: decoder port map(test, leds(0));
    decoder1: decoder port map(memory_data(3 downto 0), leds(1));
    board_ins: board port map(clk, rst, mode, r, c, lose, win, remain, memory_oe, memory_we, memory_addr, memory_data);
end architecture;