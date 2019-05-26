library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity decoder is
    port (
        code: in std_logic_vector(3 downto 0);
        display: out std_logic_vector(0 to 6)
    );
end entity;

architecture bhv of decoder is
begin
    process(code)
    begin
        case code is
            when "0000" => display <= "1111110";
            when "0001" => display <= "1100000";
            when "0010" => display <= "1011101";
            when "0011" => display <= "1111001";
            when "0100" => display <= "1100011";
            when "0101" => display <= "0111011";
            when "0110" => display <= "0110111";
            when "0111" => display <= "1101000";
            when "1000" => display <= "1111111";
            when "1001" => display <= "1101011";
            when "1010" => display <= "1101111";
            when "1011" => display <= "0110111";
            when "1100" => display <= "0011110";
            when "1101" => display <= "1110101";
            when "1110" => display <= "0011111";
            when "1111" => display <= "0001111";
        end case;
    end process;
end architecture;