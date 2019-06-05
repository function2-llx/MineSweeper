library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MineSweeper is
    port (
        clk100M, rst: in std_logic;

        led_raw: out std_logic_vector(0 to 55)
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

    signal grids: std_logic_vector(0 to 3 * 300);
    signal info: std_logic_vector(0 to 2);
    signal zwls: integer range 0 to 6;

    component board is
        port(
            clk, rst: in std_logic;
            
            mode_in: in std_logic_vector(0 to 1);  -- 01：左击；10：右击；11：初始化
            r, c: in integer range 0 to 31;
    
            grids: buffer std_logic_vector(0 to 300 * 3);
    
            info: out std_logic_vector(0 to 2);
            zwls: buffer integer range 0 to 6; -- 周围雷数
            
            lose, win: out std_logic;
            remain: buffer integer range 0 to 300 --  剩余雷数
        );
    end component;

    component decoder is
        port (
            code: in std_logic_vector(3 downto 0);
            display: out std_logic_vector(0 to 6)
        );
    end component;

    signal clk50M, clk25M: std_logic;

    component in_sram IS
	PORT (
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		rdaddress		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		wraddress		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		wren		: IN STD_LOGIC  := '0';
		q		: OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
	);
    END component;

    signal data_sig: std_logic_vector(3 downto 0);
    signal rdaddress_sig, wraddress_sig: std_logic_vector(7 downto 0);
    signal wren_sig: std_logic;
    signal test_addr: std_logic_vector(7 downto 0) := "00000100";
    signal q_sig: std_logic_vector(3 downto 0);

begin
    led_raw(0 to 6) <= leds(0);
    led_raw(7 to 13) <= leds(1);
    led_raw(14 to 20) <= leds(2);
    led_raw(21 to 27) <= leds(3);
    led_raw(28 to 34) <= leds(4);
    led_raw(35 to 41) <= leds(5);
    led_raw(42 to 48) <= leds(6);
    led_raw(49 to 55) <= leds(7);

    decoder0: decoder port map("1110", leds(0));
    decoder1: decoder port map(q_sig, leds(1));

    in_sram_inst : in_sram PORT MAP (
		clock	 => clk100M,
		data	 => data_sig,
		rdaddress	 => rdaddress_sig,
		wraddress	 => wraddress_sig,
		wren	 => wren_sig,
		q	 => q_sig
    );
    
    process(rst, clk100M)
        variable state: integer range 0 to 4;
        -- variable data: std_logic_vector(3 downto 0);
        -- variable addr: std_logic_vector(7 downto 0);
        variable pos: integer;
    begin
        if rst = '0' then
            state := 0;
            pos := 0;
            wraddress_sig <= (others => '0');
            rdaddress_sig <= (others => '0');
            wren_sig <= '0';
            data_sig <= (others => '0');

        elsif clk100M'event and clk100M = '1' then
            case state is

            when 0 => 
                wren_sig <= '1';
                state := 1;
            
            when 1 =>
                wren_sig <= '0';
                state := 2;
            
            when 2 =>
                wraddress_sig <= wraddress_sig + '1';
                data_sig <= data_sig + '1';
                pos := pos + 1;

                if pos = 10 then
                    state := 3;
                else
                    state := 0;
                end if;

            when 3 =>
                rdaddress_sig <= test_addr;
                state := 4;
            when 4 => null;
            end case;
        end if;
    end process;

    -- -- board_ins: board port map(clk25M, rst, mode, r, c, grids, info, zwls, lose, win, remain);

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

end architecture;