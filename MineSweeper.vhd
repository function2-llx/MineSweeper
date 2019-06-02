library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MineSweeper is
    port (
        clk100M, rst: in std_logic;

        -- for test
        -- mode: in std_logic_vector(0 to 1);
        -- r, c: in integer range 0 to 31; 

        led_raw: out std_logic_vector(0 to 55);

        memory_ce: out std_logic;
        memory_oe: buffer std_logic;   -- read
        memory_we: buffer std_logic;   -- wirte
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

            test_data: buffer std_logic_vector(31 downto 0);
    
            memory_ce: out std_logic;
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

    -- signal test: std_logic_vector(0 to 3) := "0000";
    signal clk50M, clk25M: std_logic;
    -- signal cnt: std_logic_vector(0 to 21);
    signal test_data: std_logic_vector(31 downto 0);
    -- signal read_data: std_logic_vector(31 downto 0);
    -- constant write_data: std_logic_vector(31 downto 0) := "11010000000000000000000000000011";
    signal test_addr: std_logic_vector(19 downto 0) := "00000000000000000100";
    -- signal sram_led: std_logic_vector(31 downto 0);
    -- signal test_out: std_logic_vector(0 to 3);

begin
    -- memory_ce <= '0';
    led_raw(0 to 6) <= leds(0);
    led_raw(7 to 13) <= leds(1);
    led_raw(14 to 20) <= leds(2);
    led_raw(21 to 27) <= leds(3);
    led_raw(28 to 34) <= leds(4);
    led_raw(35 to 41) <= leds(5);
    led_raw(42 to 48) <= leds(6);
    led_raw(49 to 55) <= leds(7);

    decoder0: decoder port map("1110", leds(0));
    decoder1: decoder port map(test_data(3 downto 0), leds(1));
    decoder2: decoder port map(test_addr(3 downto 0), leds(2));

    process(clk100M)
        variable cnt: std_logic_vector(0 to 20);
    begin
        if clk100M'event and clk100M = '1' then
            clk50M <= not clk50M;
        end if;
    end process;

    process(clk50M)
    begin
        if clk50M'event and clk50M = '1' then
            clk25M <= not clk25M;
        end if;
    end process;

    -- memory_ce <= clk;

    -- process(memory_ce)
	-- begin
	-- 	if ce = '1' then
	-- 		data <= (others => 'Z');
	-- 	else
	-- 		if state = '0' then
	-- 			r_data <= data;
	-- 		else
	-- 			data <= w_temp;
	-- 		end if;
	-- 	end if;
	-- end process;

    process(clk25M, rst)
        variable state: integer range 0 to 8;
        variable write_cnt: integer := 0;
        variable addr: std_logic_vector(19 downto 0);
        variable data: std_logic_vector(31 downto 0);

    begin
        if rst = '0' then
            state := 0;
            write_cnt := 0;
            test_data <= (others => '0');
            
            addr := (others => '0');
            data := (others => '0');
            memory_addr <= addr;
            memory_ce <= '1';
            memory_oe <= '1';
            memory_we <= '1';

        elsif clk25M'event and clk25M = '1' then
            case state is

            when 0 =>
                memory_addr <= addr;

                state := 1;
                
            when 1 =>
                memory_ce <= '0';
                memory_we <= '0';

                state := 2;
                
            when 2 =>
                memory_data <= data;

                state := 3;
                
            when 3 =>
                memory_we <= '1';
                memory_ce <= '1';
                
                state := 4;
                
            when 4 => 
                memory_data <= (others => 'Z');
                if write_cnt = 9 then
                    state := 5;
                else
                    write_cnt := write_cnt + 1;
                    data := data + '1';
                    addr := addr + 1;
                    state := 0;
                end if;
                
            when 5 =>
                memory_addr <= test_addr;
                memory_ce <= '0';
                
                state := 6;
                
            when 6 =>
                memory_oe <= '0';
                
                state := 7;
                
            when 7 =>
                test_data <= memory_data;

                state := 8;
            
            when 8 =>
                memory_ce <= '1';
                memory_oe <= '1';

                write_cnt := 0;
                test_data <= (others => '0');
                
                addr := (others => '0');
                data := (others => '0');

                state := 0;
            
            end case;
        end if;

    end process;
    -- decoder2: decoder port map(test_data(3 downto 0), leds(2));
    -- board_ins: board port map(clk, rst, mode, r, c, lose, win, remain, test_data, memory_ce, memory_oe, memory_we, memory_addr, memory_data);
    
end architecture;