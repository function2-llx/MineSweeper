library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity yuv2rgb is
port
(
	y,u,v:in std_logic_vector(31 downto 0);
	px,py:in integer range 0 to 1600;
	clk:in std_logic;
	r,g,b:out std_logic_vector(31 downto 0):=(others=>'0');
	ox,oy:out integer range 0 to 1600;
	ook:out std_logic
);
end yuv2rgb;

architecture yuv2rgb_bhv of yuv2rgb is
signal r1,g1,b1,u1,v1,y1,v1152,v15,u384,u20,v576,v18,u2080:std_logic_vector(31 downto 0);
signal r2,g2,b2,u2,v2,y2,v1167,u404,v594:std_logic_vector(31 downto 0);
signal r3,g3,b3,u3,v3,y3:std_logic_vector(31 downto 0);
signal px1,py1,px2,py2,px3,py3:integer range 0 to 1600;
signal ok1,ok2,ok3:std_logic;
begin
	process(clk)
	begin
		if(clk'event and clk='1')then
			px1<=px;py1<=py;u1<=u;y1<=y;v1<=v;
			if(px1=px and py1=py)then
				ok1<='0';
			else
				ok1<='1';
			end if;
			px2<=px1;py2<=py1;u2<=u1;y2<=y1;v2<=v1;ok2<=ok1;
			px3<=px2;py3<=py2;u3<=u2;y3<=y2;v3<=v2;ok3<=ok2;
			ox<=px3;oy<=py3;ook<=ok3;
			
			r1<=y(21 downto 0)&"0000000000";g1<=y(21 downto 0)&"0000000000";b1<=y+266353;
			v1152<=(v(21 downto 0)&"0000000000")+(v(24 downto 0)&"0000000");v15<=(v(27 downto 0)&"0000")-v;
			u384<=(u(23 downto 0)&"00000000")+(u(24 downto 0)&"0000000");u20<=(u(27 downto 0)&"0000")+(u(29 downto 0)&"00");
			v576<=(v(22 downto 0)&"000000000")+(v(25 downto 0)&"000000");v18<=(v(27 downto 0)&"0000")+(v(30 downto 0)&"0");
			u2080<=(u(20 downto 0)&"00000000000")+(v(26 downto 0)&"00000");
			
			r2<=r1-149399;g2<=g1+127828;b2<=b1+u2080;
			v1167<=v1152+v15;u404<=u384+u20;v594<=v576+v18;
			
			r3<=r2+v1167;g3<=g2+u404;b3<="0000000000"&b2(31 downto 10);
			
			r<="0000000000"&r3(31 downto 10);g<="0000000000"&(g3(31 downto 10)-v594(31 downto 10));b<=b3;
		end if;
	end process;
end yuv2rgb_bhv;
			