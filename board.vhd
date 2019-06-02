library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity board is
    port(
        clk, rst: in std_logic;
        
        mode_in: in std_logic_vector(0 to 1);  -- 01：左击；10：右击；11：初始化
        r, c: in integer range 0 to 31;
        
        lose, win: out std_logic;
        remain: buffer integer range 0 to 300; --  剩余雷数

        test_data: out std_logic_vector(31 downto 0);

        memory_ce: out std_logic;
        memory_oe: out std_logic;   -- read
        memory_we: out std_logic;   -- wirte
        memory_addr: out std_logic_vector(19 downto 0);
        memory_data: inout std_logic_vector(31 downto 0)
    );

end entity;

architecture bhv of board is
    constant n: integer := 5;
    constant tot: integer := 3 * n * n - 3 * n + 1;
    constant half_tot: integer := n * (3 * n - 1) / 2;
    -- signal data_tmp, data_out: std_logic_vector(31 downto 0) := (others => '0');
    signal data_tmp : std_logic_vector(31 downto 0) := (others => '0');


begin
    process(clk, rst)
        variable state: integer range 0 to 8 := 0;

        variable mode: std_logic_vector(0 to 1);
        variable pos: integer;

        variable oper: integer; --  剩余未操作格子数

        variable lei: std_logic;    -- 是否有雷
        variable grid: std_logic_vector(0 to 1);    -- 插旗或翻开状态
        
        variable cur_addr: std_logic_vector(19 downto 0) := (others => '0');
        variable cur_data: std_logic_vector(31 downto 0) := (others => '0');
    begin
        if rst = '0' then
            state := 0;
            memory_oe <= '1';
            memory_we <= '1';
            memory_ce <= '1';
            test_data <= (others => '0');
            -- data_tmp <= (others => 'Z');
            -- data_out <= (others => 'Z');
            memory_data <= (others => 'Z');
            cur_data := (others => '0');
            
            if mode_in = "11" then
                remain <= 0;
                oper := tot;
                win <= '0';
                lose <= '0';

                pos := 0;
                cur_addr := (others => '0');
            elsif mode_in = "01" or mode_in = "10" then
                if r <= n then
                    pos := (2 * n + r - 1) * r / 2 + c;
                    cur_addr := conv_std_logic_vector((2 * n + r - 1) * r / 2 + c, 20);
                else
                    pos := half_tot + (2 * n - 2 + 2 * n - 2 + (r - n - 1)) * (r - n) / 2 + c;
                    cur_addr := conv_std_logic_vector(half_tot + (2 * n - 2 + 2 * n - 2 + (r - n - 1)) * (r - n) / 2 + c, 20);
                end if;
            end if;
            mode := mode_in;

        elsif clk'event and clk = '1' then
            if mode = "01" or mode = "10" then  -- 游戏中
                case state is
                -- 0 ~ 2：读取
                when 0 =>   
                    memory_data <= (others => 'Z');

                    state := 1;

                when 1 => 
                    memory_we <= '1';
                    memory_oe <= '0';
                    memory_addr <= cur_addr;
                    state := 2;
                
                when 2 =>
                    data_tmp <= memory_data;
                    memory_oe <= '1';
                    state := 3;

                -- 整理信息
                when 3 =>
                    lei := data_tmp(0);
                    grid(0) := data_tmp(1);
                    grid(1) := data_tmp(2);

                    if mode = "01" then -- 翻开
                        oper := oper - 1;
                        if grid = "00" then
                            grid := "01";
                            lose <= lei;
                        end if;
                    else -- 插旗
                        if grid = "00" then --  插旗
                            remain <= remain - 1;
                            oper := oper - 1;
                            grid(0) := '1';
                        elsif grid = "10" then  --  取消插旗
                            remain <= remain + 1;
                            oper := oper + 1;
                            grid(0) := '0';
                        end if;
                    end if;

                    if oper = 0 and remain = 0 then
                        win <= '1';
                    end if;
                    state := 4;

                --  4 ~ 6写回
                when 4 =>
                    memory_addr <= cur_addr;
                    data_tmp(1) <= grid(0);
                    data_tmp(2) <= grid(1);
                    state := 5;
                
                when 5 =>
                    memory_data <= data_tmp;
                    state := 6;

                when 6 =>
                    -- memory_oe <= '1';
                    memory_we <= '0';
                    state := 7;
                
                --  关闭写模式
                when 7 =>
                    -- memory_oe <= '1';
                    memory_we <= '1';   
                    state := 8;

                when 8 => null;

                end case;
            elsif mode = "11" then  --  初始化
                case state is
                when 0 =>
                    memory_addr <= cur_addr;
                    memory_data <= cur_data;
                    memory_ce <= '0';
                    memory_we <= '0';
                    -- memory_we <= '1';
                    memory_oe <= '1';
                    state := 1;
                    if cur_data(0) = '1' then
                        remain <= remain + 1;
                    end if;

                when 1 =>
                    -- memory_data <= data_tmp;
                    state := 2;

                when 2 =>
                    -- memory_oe <= '1';
                    -- memory_we <= '1';
                    -- -- data_tmp <= (others => 'Z');
                    -- memory_ce <= '1';
                    state := 3;

                when 3 =>
                    -- memory_we <= '1';
                    memory_we <= '1';
                    -- data_tmp <= (others => 'Z');
                    memory_ce <= '1';
                    memory_data <= (others => 'Z');
                    memory_addr <= (others => 'Z');
                    cur_addr := cur_addr + '1';
                    cur_data := cur_data + '1';
                    pos := pos + 1;
                    if pos = tot then 
                        state := 4;
                    else
                        state := 0;
                    end if;

                when 4 => 
                    memory_addr <= (0 => '1', 2 => '1', others => '0');
                    memory_ce <= '0';
                    memory_oe <= '0';
                    -- test_data <= memory_data;
                    state := 5;
                    
                when 5 =>
                    -- memory_we <= '1';
                    -- memory_oe <= '0';
                    -- test_data <= memory_data;
                    state := 6;

                when 6 =>
                    -- test_data <= memory_data;
                    -- data_out <= memory_data;
                    test_data <= memory_data;

                    memory_oe <= '1';
                    memory_ce <= '1';
                    -- state := 7;
                
                when 7 => null;
                    -- test_data <= data_out;
                    -- state := 8;

                when 8 => null;
                
                -- when 7 | 8 => null;

                end case;
            end if;
        end if;
    end process;
end;