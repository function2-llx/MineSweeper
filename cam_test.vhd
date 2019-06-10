library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity cam_test is
port
(
	scl:out std_logic;
	sda:inout std_logic;
	vs,hs:in std_logic;
	pclk:in std_logic;
	mclk:buffer std_logic:='0';
	d:in std_logic_vector(7 downto 0);
	rst:out std_logic:='1';
	pwdn:out std_logic:='0';
	clk:in std_logic;
	vclk:out std_logic;
	vhs,vvs:out std_logic;
	oRed:out std_logic_vector (2 downto 0);
	oGreen:out std_logic_vector (2 downto 0);
	oBlue:out std_logic_vector (2 downto 0);
);
end cam_test;

architecture test_bhv of cam_test is
signal qf:integer range 0 to 1:=0;
variable stat:integer:=0;
begin
	process(clk)
	begin
		if(clk'event and clk='1')then
			if(qf=1)then
				qf<=0;
				mclk<=not mclk;
			else
				qf<=1;
			end if;
		end if;
	end process;
	process
end test_bhv;