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
    constant n: integer := 4;
    signal clk50M, clk25M: std_logic;

    component board is
        port(
            clk, rst: in std_logic;
            
            mode_in: in std_logic_vector(0 to 1);  -- 01：左击；10：右击；11：初始化
            r, c: in integer range 0 to 31;
            lose, win: buffer std_logic;
            remain: buffer integer range 0 to 300; --  剩余雷数
    
            vga_wren: out std_logic;
            vga_wraddr: out std_logic_vector(7 downto 0);
            vga_in: out std_logic_vector(3 downto 0)
        );
    end component;

    signal mode: std_logic_vector(0 to 1) := "00";
    signal r, c: integer range 0 to 31;
    signal lose, win: std_logic;
    signal remain: integer range 0 to 300;

    component decoder is
        port (
            code: in std_logic_vector(3 downto 0);
            display: out std_logic_vector(0 to 6)
        );
    end component;

    type led_type is array(0 to 7) of std_logic_vector(0 to 6);
    signal leds: led_type;

    component vga_ram IS
	PORT (
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		rdaddress		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		wraddress		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		wren		: IN STD_LOGIC  := '0';
		q		: OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
	);
    END component;

    signal vga_in, vga_out: std_logic_vector(3 downto 0);
    signal vga_wren: std_logic := '0';
    signal vga_wraddr, vga_rdaddr: std_logic_vector(7 downto 0);


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

    vga_ram_inst : vga_ram PORT MAP (
		clock	 => clk100M,
		data	 => vga_in,
		rdaddress	 => vga_rdaddr,
		wraddress	 => vga_wraddr,
		wren	 => vga_wren,
		q	 => vga_out
    );
    
    board_ins: board port map (
        clk => clk100M,
        rst => rst,
        mode_in => mode,
        r => r,
        c => c,
        lose => lose,
        win => win,
        remain => remain,
        vga_wren => vga_wren,
        vga_wraddr => vga_wraddr,
        vga_in => vga_in
    );
    
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