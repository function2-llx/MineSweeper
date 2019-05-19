library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity board is
    port(
        clk, rst: in std_logic;

        mode: in std_logic_vector(0 to 1);  -- 01：翻开；10：插旗
        r, c: in std_logic_vector(4 downto 0);   -- n <= 16=2^4,r < 2n, c < 2n

        memory_ctrl: inout std_logic;
        memory_oe: inout std_logic;   -- read
        memory_we: inout std_logic;   -- wirte
        memory_addr: inout std_logic_vector(19 downto 0);
        memory_data: inout std_logic_vector(31 downto 0)
    );
end entity;

architecture bhv of board is
begin

end;