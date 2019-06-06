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
signal px1,py1:integer:=998244353;
signal px2,py2:integer:=998244352;
signal n:integer:=0;
constant thr:integer:=20;
begin
	process(clk)
	begin
		if(clk'event and clk='1')then
			if(x>=px1 and x<=px2 and y>=py1 and y<=py2)then
				if(n>=60)then
					orst<='1';
					is_long<='1';
					n<=0;
					ox<=px1+thr;
					oy<=py1+thr;
					px1<=x-thr;
					px2<=x+thr;
					py1<=y-thr;
					py2<=y+thr;
				else
					n<=n+1;
					orst<='0';
				end if;
			else
				if(n>=15)then
					orst<='1';
					is_long<='0';
					ox<=px1+thr;
					oy<=py1+thr;
				else
					orst<='0';
				end if;
				n<=0;
				if(x>=0 and x<=480 and y>=0 and y<=640)then
					px1<=x-thr;
					px2<=x+thr;
					py1<=y-thr;
					py2<=y+thr;
				else
					px1<=998244353;
					py1<=998244352;
					px2<=998244353;
					py2<=998244352;
				end if;
			end if;
		end if;
	end process;
end getfinpos_bhv;
			