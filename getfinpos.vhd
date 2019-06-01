library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity getfinpos is
port
(
	clk:in std_logic;
	x,y:in integer;
	ox,oy:buffer integer;
	is_long:out std_logic;
	orst:out std_logic
);
end getfinpos;

architecture getfinpos_bhv of getfinpos is
signal px1,px2,py1,py2:integer:=2147483647;
signal n:integer:=0;
begin
	process(clk)
	begin
		if(clk'event and clk='1')then
			if(x>=px1 and x<=px2 and y>=py1 and y<=py2)then
				if(n>=45)then
					orst<='1';
					is_long<='1';
					n<=0;
					ox<=px1+10;
					oy<=py1+10;
					px1<=x-10;
					px2<=x+10;
					py1<=y-10;
					py2<=y+10;
				else
					n<=n+1;
					orst<='0';
				end if;
			else
				if(n>=15)then
					orst<='1';
					is_long<='0';
					ox<=px1+10;
					oy<=py1+10;
				end if;
				n<=0;
				px1<=x-10;
				px2<=x+10;
				py1<=y-10;
				py2<=y+10;
			end if;
		end if;
	end process;
end getfinpos_bhv;
			