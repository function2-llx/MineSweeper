library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity board is
    port(
        clk100M, rst: in std_logic;
        
        mode_in: in std_logic_vector(0 to 1);  -- 01：左击；10：右击；11：初始化
        r, c: in integer range 0 to 31;
        lose, win: buffer std_logic;
        remain: buffer integer range 0 to 300; --  剩余雷数

        vga_wren: out std_logic := '0';
        vga_wraddr: out std_logic_vector(7 downto 0);
        vga_in: out std_logic_vector(3 downto 0)
    );
end entity;

architecture bhv of board is
    constant n: integer := 5;
    constant tot: integer := 3 * n * n - 3 * n + 1;
    component grid_ram IS
        PORT (
            address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            clock		: IN STD_LOGIC  := '1';
            q		: OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
        );
    END component;

    signal grid_addr: std_logic_vector(7 downto 0);
    signal grid_data: std_logic_vector(3 downto 0);


    component board_ram IS
        PORT (
            clock		: IN STD_LOGIC  := '1';
            data		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
            rdaddress		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            wraddress		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            wren		: IN STD_LOGIC  := '0';
            q		: OUT STD_LOGIC_VECTOR (1 DOWNTO 0)
        );
    END component;

    signal board_in, board_out: std_logic_vector(1 downto 0);
    signal board_rdaddr, board_wraddr: std_logic_vector(7 downto 0);
    signal board_wren: std_logic := '0';

    function get_addr(c: integer; r: integer) return std_logic_vector is
    begin
        if c <= n - 1 then
            return conv_std_logic_vector(c * (c + 1) / 2 + r, 8);
        end if;
    
        if c <= 3 * n - 3 then
            if (c - n) mod 2 = 0 then
                return conv_std_logic_vector(n * (n + 1) / 2 + (2 * n - 1) * ((c - n) / 2) + r, 8);
            else
                return conv_std_logic_vector(n * (n + 1) / 2 + (2 * n - 1) * ((c - n) / 2) + n - 1 + r, 8);
            end if;
        end if;
            
        return conv_std_logic_vector((n + 1) * n / 2 + (n - 1) * (2 * n - 1) + (c - 3 * n + 2) * (5 * n - c - 3) / 2 + r, 8);
    end function;

begin
    grid_ram_inst : grid_ram PORT MAP (
		address	 => grid_addr,
		clock	 => clk100M,
		q	 => grid_data
    );
    
    board_ram_inst : board_ram PORT MAP (
		clock	 => clk100M,
		data	 => board_in,
		rdaddress	 => board_rdaddr,
		wraddress	 => board_wraddr,
		wren	 => board_wren,
		q	 => board_out
    );
    
    process(rst, clk100M)
        variable addr: std_logic_vector(7 downto 0);
        variable mode: std_logic_vector(0 to 1);
        variable state: integer range 0 to 3;
        variable info: std_logic_vector(1 downto 0);
        variable oper: integer range 0 to tot;

        constant dead_state: std_logic_vector(3 downto 0) := "0111";
        constant flag_state: std_logic_vector(3 downto 0) := "1000";
        constant unknown_state: std_logic_vector(3 downto 0) := "1001";

    begin
        if rst = '0' then
            mode := mode_in;
            state := 0;
            oper := tot;

            if mode = "00" then
                addr := (others => '0');
            elsif mode = "01" or mode = "10" then
                addr := get_addr(c, r);
            end if;

        elsif clk100M'event and clk100M = '1' then
            if mode = "00" then --  初始化
                case state is
                when 0 =>
                    board_wraddr <= addr;
                    board_in <= "00";
                    board_wren <= '1';

                    vga_wraddr <= addr;
                    vga_in <= unknown_state;
                    vga_wren <= '1';

                    grid_addr <= addr;

                    state := 1;
                when 1 =>
                    if grid_data(3) = '1' then
                        remain <= remain + 1;
                    end if;

                    board_wren <= '0';
                    vga_wren <= '0';
                    addr := addr + '1';

                    if addr = conv_std_logic_vector(tot, 8) then
                        state := 2;
                    else
                        state := 0;
                    end if;
                
                when 2 | 3 => null;
                    
                end case;
            elsif mode = "01" or mode = "10" then   --  游戏中
                case state is
                when 0 =>
                    grid_addr <= addr;
                    board_rdaddr <= addr;
                    board_wraddr <= addr;
                    vga_wraddr <= addr;

                    state := 1;

                when 1 =>
                    info := board_out;
                    oper := oper - 1;

                    if mode = "01" then --  左击
                        if info = "00" then
                            -- info(0) := '1';
                            if grid_data(3) = '1' then
                                lose <= '1';
                                vga_in <= dead_state;   -- 翻开了雷
                            else
                                vga_in(3) <= '0';
                                vga_in(2 downto 0) <= grid_data(2 downto 0);
                            end if;
                            vga_wren <= '1';

                            board_in <= "01";
                            board_wren <= '1';

                            state := 2;
                        else 
                            state := 3;
                        end if;
                    else    --  右击
                        if info = "10" then
                            info(1) := '0';
                            remain <= remain + 1;

                            vga_in <= unknown_state;
                            vga_wren <= '1';

                            board_in <= "00";
                            board_wren <= '1';
                        elsif info = "00" then
                            info(1) := '1';
                            remain <= remain - 1;

                            vga_in <= flag_state;
                            vga_wren <= '1';

                            board_in <= info;
                            board_wren <= '1';
                        else
                            state := 3;
                        end if;
                    end if;

                    state := 2;
                when 2 =>
                    vga_wren <= '0';
                    board_wren <= '0';
                    if lose = '0' and remain = 0 and oper = 0 then
                        win <= '1';
                    end if;

                    state := 3;
                
                when 3 => null;

                end case;
            end if;
        end if;
    end process;

end;