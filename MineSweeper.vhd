library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MineSweeper is
    port (
        clk100M, rst, clk: in std_logic;

        led_raw: out std_logic_vector(0 to 55);

        ps2_clk: inout std_logic;
        ps2_data: inout std_logic;

        hs,vs: out STD_LOGIC; 
        vga_r, vga_g, vga_b: out STD_LOGIC_vector(2 downto 0)
    );
end entity;
architecture bhv of MineSweeper is
    signal clk50M, clk25M: std_logic;

    component board is
        port(
            clk100M, rst: in std_logic;
            
            mode_in: in std_logic_vector(0 to 1);  -- 01：左击；10：右击；11：初始化
            r, c: in integer range 0 to 31;
            lose, win: buffer std_logic;
            remain: buffer integer range 0 to 300; --  剩余雷数
    
            vga_wren: out std_logic;
            vga_wraddr: out std_logic_vector(7 downto 0);
            vga_in: out std_logic_vector(3 downto 0)
        );
    end component;

    signal board_ctrl: std_logic;
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

    component vga_ram is 
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

    component ps2_mouse is
        port( 
            clk_in : in std_logic;
            reset_in : in std_logic;
            ps2_clk : inout std_logic;
            ps2_data : inout std_logic;
            left_button : out std_logic;
            right_button : out std_logic;
            middle_button : out std_logic;
            mousex: buffer std_logic_vector(9 downto 0);
            mousey: buffer std_logic_vector(9 downto 0);
            error_no_ack : out std_logic
        );
    end component;
    signal lbtn, rbtn, mbtn: std_logic;
    signal mx, my: std_logic_vector(9 downto 0);
    signal error_no_ack: std_logic;

    component bit_to_coordinate is
        port(
            x, y: in integer range 0 to 1600;
            cout: out integer range 0 to 17;--17 means illegal column
            rout: out integer range 0 to 5  --5 means illegal row
        );
    end component;

    signal r_tmp: std_logic_vector(7 downto 0);
 
    component VGA_Controller is
        port(
            clk_0,reset: in std_logic;
            hs,vs: out STD_LOGIC; 
            r,g,b: out STD_LOGIC_vector(2 downto 0);
            addr: out std_logic_vector(7 downto 0);
            data: in std_logic_vector(3 downto 0);
            mouse_x: in std_logic_vector(9 downto 0);--鼠标x坐标
            mouse_y: in std_logic_vector(8 downto 0);--鼠标y坐标
				remain: in integer;  -- 剩余雷数
				win: in std_logic;-- 胜利
				lose: in std_logic;-- 失败
				mouse_r: in integer;
				mouse_c: in integer
        );
    end component;
begin
    -- 点灯与测试
    led_raw(0 to 6) <= leds(0);
    led_raw(7 to 13) <= leds(1);
    led_raw(14 to 20) <= leds(2);
    led_raw(21 to 27) <= leds(3);
    led_raw(28 to 34) <= leds(4);
    led_raw(35 to 41) <= leds(5);
    led_raw(42 to 48) <= leds(6);
    led_raw(49 to 55) <= leds(7);


    -- decoder0: decoder port map("1010", leds(0));

    r_tmp <= conv_std_logic_vector(r, 8);

    decoder0: decoder port map(mx(3 downto 0), leds(0));
    decoder1: decoder port map(mx(7 downto 4), leds(1));
    decoder2: decoder port map("00" & mx(9 downto 8), leds(2));
    decoder3: decoder port map(my(3 downto 0), leds(3));
    decoder4: decoder port map(my(7 downto 4), leds(4));
    decoder5: decoder port map("00" & my(9 downto 8), leds(5));

    decoder6: decoder port map(r_tmp(3 downto 0), leds(6));
    decoder7: decoder port map(conv_std_logic_vector(c, 4), leds(7));

    -- decoder1: decoder port map(r_tmp(3 downto 0), leds(1));
    -- decoder2: decoder port map("000" & r_tmp(4), leds(2));
    -- decoder3: decoder port map(conv_std_logic_vector(c, 4)(3 downto 0), leds(3));

    -- decoder4: decoder port map("0" & lbtn & mbtn & rbtn, leds(4));

    vga_ram_inst : vga_ram PORT MAP (
		clock	 => clk100M,
		data	 => vga_in,
		rdaddress	 => vga_rdaddr,
		wraddress	 => vga_wraddr,
		wren	 => vga_wren,
		q	 => vga_out
    );
    
    board_ins: board port map (
        clk100M => clk100M,
        rst => board_ctrl,
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

    process(lbtn, rbtn, mbtn, clk100M)
    begin
        if clk100M'event and clk100M = '1' then
            if lbtn = '1' then
                mode <= "01";
                board_ctrl <= '1';
            elsif rbtn = '1' then
                mode <= "10";
                board_ctrl <= '1';
            elsif mbtn = '1' then
                mode <= "00";
                board_ctrl <= '1';
            else
                board_ctrl <= '0';
            end if;
        end if;
    end process;
 
    mouse: ps2_mouse port map (
        clk_in => clk100M,
        reset_in => clk,    --  用于鼠标死了的情况
        ps2_clk => ps2_clk,
        ps2_data => ps2_data,
        left_button => lbtn,
        right_button => rbtn,
        middle_button => mbtn,
        mousex => mx,
        mousey => my,
        error_no_ack => error_no_ack
    );

    btc_ins: bit_to_coordinate port map (
        x => conv_integer(mx),
        y => conv_integer(my),
		cout => c,
		rout => r
    );

    vga_ins: VGA_Controller port map (
        clk_0 => clk100M,
        reset => rst,
        hs => hs,
        vs => vs,
        r => vga_r,
        g => vga_g,
        b => vga_b,
        addr => vga_rdaddr,
        data => vga_out,
        mouse_x => mx,
        mouse_y => my(8 downto 0),
		  remain => remain,
		  win => win,
		  lose => lose,
		  mouse_r => r,
		  mouse_c => c
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