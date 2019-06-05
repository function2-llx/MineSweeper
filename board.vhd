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
        remain: buffer integer range 0 to 300 --  剩余雷数
    );
end entity;

architecture bhv of board is
    constant n: integer := 5;
    constant tot: integer := 3 * n * n - 3 * n + 1;
    constant half_tot: integer := n * (3 * n - 1) / 2；

    function get_len(r: integer) return integer is
    begin
        if r <= n then
            return r + n;
        else
            return 2 * n  - 1 - (r - n);
    end if;
    end function;

    -- 前 r 行之和
    function pre_sum(r: integer) return integer is
    begin
        if r <= 0 then 
            return 0;
        end if;

        if r <= n then
            return r * n + (((0 + r - 1) * r) / 2);
        else
            return half_tot + (r - n) * n + ((2 * n - 2 + 3 * n - 1 - r) * (r - n) / 2);
        end if;
    end function;

    function get_id(r: integer; c: integer) return integer is
    begin
        if r > 0 then
            return pre_sum(r - 1) + c;
        else
            return c;
        end if;
    end function;

    impure function get_lei(r: integer; c: integer) return integer is
        variable pos: integer;
    begin
        pos := get_id(r, c);
        if pos >= 0 then
            if grids(pos * 3) = '1' then
                return 1;
            end if;
        end if;

        return 0;
    end;
begin
    
    process(clk, rst)
        variable state: integer range 0 to 7;
        variable mode: std_logic_vector(0 to 1);
        variable pos, tmp_pos: integer;

        variable oper: integer; --  剩余未操作格子数

        variable lei: std_logic;    -- 是否有雷
        variable grid: std_logic_vector(0 to 1);    -- 插旗或翻开状态

        constant a: integer := 23;
        constant b: integer := 123;
        variable pre: std_logic_vector(0 to 1);

    begin
        if rst = '0' then
            if mode_in = "11" then
                remain <= 0;
                oper := tot;
                win <= '0';
                lose <= '0';
                pos := 0;
            elsif mode_in = "01" or mode_in = "10" then
                state := 0;
                pos := get_id(r, c);
            end if;
            mode := mode_in;

        elsif clk'event and clk = '1' then
            if (mode = "01" or mode = "10") then  -- 游戏中
                case state is
                when 0 => 
                    lei := grids(pos * 3);
                    grid := grids(pos * 3 + 1 to pos * 3 + 2);

                    if mode = "01" then -- 左击
                        oper := oper - 1;
                        if grid = "00" then
                            grid := "01";
                            lose <= lei;
                        end if;
                    elsif grid = "00" then --  插旗-- 右击
                        if oper = 1 and remain = 1 then
                            win <= '1';
                        end if;
                        remain <= remain - 1;
                        oper := oper - 1;
                        grid(0) := '1';
                    elsif grid = "10" then  --  取消插旗
                        remain <= remain + 1;
                        oper := oper + 1;
                        grid(0) := '0';
                    end if;

                    grids(pos * 3 + 1 to pos * 3 + 2) <= grid;
                    info(0) <= lei;
                    info(1 to 2) <= grid;

                    state := 1;

                when 1 =>
                    if r >= n then
                        -- if grids(get_id(r - 1, c) * 3) = '1' then
                        zwls <= zwls + get_lei(r - 1, c);
                        -- end if;
                    elsif r > 0 and c > 0 then
                        -- if grids(get_id(r - 1, c - 1) * 3) = '1' then
                        zwls <= zwls + get_lei(r - 1, c - 1);
                        -- end if;
                    end if;

                    state := 2;

                when 2 =>
                    if r >= n then
                        zwls <= zwls + get_lei(r - 1, c + 1);
                    elsif r > 0 and c < get_len(r) then
                        zwls <= zwls + get_lei(r - 1, c);
                    end if;

                when 3 =>
                    if c > 0 then
                        zwls <= zwls + get_lei(r, c - 1);
                    end if;
                    
                    state := 4;
                when 4 =>
                    if c + 1 < get_len(r) then
                        zwls <= zwls + get_lei(r, c + 1);
                    end if;
                    state := 5;

                when 5 =>
                    if r + 1 < n then
                        zwls <= zwls + get_lei(r + 1, c);
                    elsif r + 1 < 2 * n - 1 and c > 0 then 
                        zwls <= zwls + get_lei(r + 1, c - 1);
                    end if;

                    state := 6;

                when 6 =>
                    if r + 1 < n then
                        zwls <= zwls + get_lei(r + 1, c + 1);
                    elsif r + 1 < 2 * n - 1 and c < get_len(r) - 1 then
                        zwls <= zwls + get_lei(r + 1, c);
                    end if;

                    state := 7;
                when 7 => null;
                end case;

            elsif mode = "11" and pos < tot then  --  初始化
                grids(pos * 3 + 1 to pos * 3 + 2) <= "00";
                if pos > 20 then
                    remain <= remain + 1;
                    
                else
                end if;
                
                pos := pos + 1;
            end if;
        end if;
    end process;
end;