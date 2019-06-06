----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Mike Field <hamster@sanp.net.nz> 
-- 
-- Description: Register settings for the OV7670 Caamera (partially from OV7670.c
--              in the Linux Kernel
------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ov7670_registers is
    Port ( clk      : in  STD_LOGIC;
           resend   : in  STD_LOGIC;
           advance  : in  STD_LOGIC;
           command  : out  std_logic_vector(15 downto 0);
           finished : out  STD_LOGIC);
end ov7670_registers;

architecture Behavioral of ov7670_registers is
	signal sreg   : std_logic_vector(15 downto 0);
	signal address : std_logic_vector(7 downto 0) := (others => '0');
begin
	command <= sreg;
	with sreg select finished  <= '1' when x"FFFF", '0' when others;
	
	process(clk)
	begin
		if rising_edge(clk) then
			if resend = '1' then 
				address <= (others => '0');
			elsif advance = '1' then
				address <= std_logic_vector(unsigned(address)+1);
			end if;

			case address is
				when x"00" => sreg <= x"1280"; -- COM7   Reset
				when x"01" => sreg <= x"1280"; -- COM7   Reset
				when x"02" => sreg <= x"1204"; -- COM7   Reset
 				when x"03" => sreg <= x"40d0"; -- COM15  Full 0-255 output, RGB 565
				when x"04"=>sreg<=x"1180";
				when x"05"=>sreg<=x"6b0a";
				when x"06"=>sreg<=x"2a00";
				when x"07"=>sreg<=x"2b00";
				when x"08"=>sreg<=x"9200";
				when x"09"=>sreg<=x"9300";
				when x"0a"=>sreg<=x"3b0a";
				when x"0b"=>sreg<=x"8c00";
				when x"0c"=>sreg<=x"3a04";
				when x"0d"=>sreg<=x"67c0";
				when x"0e"=>sreg<=x"6880";
				when x"0f"=>sreg<=x"1e37";
				when x"10"=>sreg<=x"b084";
				when x"11"=>sreg<=x"13e7";
				when x"12"=>sreg<=x"6f9f";
				when x"13"=>sreg<=x"0000";
				when x"14"=>sreg<=x"1460";
				when x"15"=>sreg<=x"2475";
				when x"16"=>sreg<=x"2563";
				when x"17"=>sreg<=x"26a5";
				when x"18"=>sreg<=x"aa94";
				when x"19"=>sreg<=x"9f78";
				when x"1a"=>sreg<=x"a068";
				when x"1b"=>sreg<=x"a6df";
				when x"1c"=>sreg<=x"a7df";
				when x"1d"=>sreg<=x"a8f0";
				when x"1e"=>sreg<=x"a990";
				when x"1f"=>sreg<=x"7a20";
				when x"20"=>sreg<=x"7b1c";
				when x"21"=>sreg<=x"7c28";
				when x"22"=>sreg<=x"7d3c";
				when x"23"=>sreg<=x"7e55";
				when x"24"=>sreg<=x"7f68";
				when x"25"=>sreg<=x"8076";
				when x"26"=>sreg<=x"8180";
				when x"27"=>sreg<=x"8288";
				when x"28"=>sreg<=x"838f";
				when x"29"=>sreg<=x"8496";
				when x"2a"=>sreg<=x"85a3";
				when x"2b"=>sreg<=x"86af";
				when x"2c"=>sreg<=x"87c4";
				when x"2d"=>sreg<=x"88d7";
				when x"2e"=>sreg<=x"89e8";
				when x"2f"=>sreg<=x"5510";
				when x"30"=>sreg<=x"5660";
				when x"31"=>sreg<=x"4100";
				when x"32"=>sreg<=x"4cff";
				when x"33"=>sreg<=x"7710";
				
				--when x"34"=>sreg<=x"0700";
				
				
				--when x"34"=>sreg<=x"4f60";
				--when x"35"=>sreg<=x"504e";
				--when x"36"=>sreg<=x"5112";
				--when x"37"=>sreg<=x"5222";
				--when x"38"=>sreg<=x"5352";
				--when x"39"=>sreg<=x"543d";
				
				
				--when x"31"=>sreg<=x"4112";
				--when x"04"=>sreg<=x"139f";
				--when x"04" => sreg<=x"0c40";
 				--when x"04" => sreg <= x"4208"; -- COM15  Full 0-255 output, RGB 565
 				
				--when x"04" => sreg <= x"1711"; -- HSTART HREF start (high 8 bits)
				--when x"05" => sreg <= x"1839"; -- HSTOP  HREF stop (high 8 bits)
				--when x"05" => sreg <= x"3240"; -- HSTOP  HREF stop (high 8 bits)
				--when x"06" => sreg <= x"703a"; -- SCALING_XSC
				--when x"07" => sreg <= x"7135"; -- SCALING_YSC
				--when x"08" => sreg <= x"4c08"; -- SCALING_YSC
--				when x"12" => sreg <= x"7200"; -- SCALING_DCWCTR  -- zzz was 11 
--				when x"13" => sreg <= x"7300"; -- SCALING_PCLK_DIV
--				when x"14" => sreg <= x"a200"; -- SCALING_PCLK_DELAY  must match COM14
--          when x"15" => sreg <= x"1500"; -- COM10 Use HREF not hSYNC
--				
--				when x"1D" => sreg <= x"B104"; -- ABLC1 - Turn on auto black level
--				when x"1F" => sreg <= x"138F"; -- COM8  - AGC, White balance
--				when x"21" => sreg <= x"FFFF"; -- spare
--				when x"22" => sreg <= x"FFFF"; -- spare
--				when x"23" => sreg <= x"0000"; -- spare
--				when x"24" => sreg <= x"0000"; -- spare
--				when x"25" => sreg <= x"138F"; -- COM8 - AGC, White balance
--				when x"26" => sreg <= x"0000"; -- spare
--				when x"27" => sreg <= x"1000"; -- AECH Exposure
--				when x"28" => sreg <= x"0D40"; -- COMM4 - Window Size
--				when x"29" => sreg <= x"0000"; -- spare
--				when x"2a" => sreg <= x"a505"; -- AECGMAX banding filter step
--				when x"2b" => sreg <= x"2495"; -- AEW AGC Stable upper limite
--				when x"2c" => sreg <= x"2533"; -- AEB AGC Stable lower limi
--				when x"2d" => sreg <= x"26e3"; -- VPT AGC fast mode limits
--				when x"2e" => sreg <= x"9f78"; -- HRL High reference level
--				when x"2f" => sreg <= x"A068"; -- LRL low reference level
--				when x"30" => sreg <= x"a103"; -- DSPC3 DSP control
--				when x"31" => sreg <= x"A6d8"; -- LPH Lower Prob High
--				when x"32" => sreg <= x"A7d8"; -- UPL Upper Prob Low
--				when x"33" => sreg <= x"A8f0"; -- TPL Total Prob Low
--				when x"34" => sreg <= x"A990"; -- TPH Total Prob High
--				when x"35" => sreg <= x"AA94"; -- NALG AEC Algo select
--				when x"36" => sreg <= x"13E5"; -- COM8 AGC Settings
				when others => sreg <= x"ffff";
			end case;
		end if;
	end process;
end Behavioral;

