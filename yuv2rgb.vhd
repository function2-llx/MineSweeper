library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity yuv2rgb is
port
(
	y,u,v:in std_logic_vector(31 downto 0);
	px,py:in integer range 0 to 1600;
	clk,iok:in std_logic;
	r,g,b:out std_logic_vector(31 downto 0):=(others=>'0');
	ox,oy:out integer range 0 to 1600;
	ook:out std_logic:='0'
);
end yuv2rgb;

--architecture yuv2rgb_bhv of yuv2rgb is
--signal r1,g1,b1,u1,v1,y1,v1152,v15,u384,u20,v576,v18,u2080:std_logic_vector(31 downto 0);
--signal r2,g2,b2,u2,v2,y2,v1167,u404,v594:std_logic_vector(31 downto 0);
--signal r3,g3,b3,u3,v3,y3,v594_2:std_logic_vector(31 downto 0);
--signal r4,g4,b4,u4,v4,y4:std_logic_vector(31 downto 0);
--signal px1,py1,px2,py2,px3,py3,px4,py4:integer range 0 to 1600;
--signal ok1,ok2,ok3,ok4:std_logic:='0';
--begin
--	process(clk)
--	begin
--		if(clk'event and clk='1')then
--			px1<=px;py1<=py;ok1<=iok;
--			px2<=px1;py2<=py1;ok2<=ok1;
--			px3<=px2;py3<=py2;ok3<=ok2;
--			px4<=px3;py4<=py3;ok4<=ok3;
--			ox<=px4;oy<=py4;ook<=ok4;
--			
--			r1<=y(21 downto 0)&"0000000000";g1<=y(21 downto 0)&"0000000000";b1<=y(21 downto 0)&"0000000000";
--			v1152<=(v(21 downto 0)&"0000000000")+(v(24 downto 0)&"0000000");v15<=(v(27 downto 0)&"0000")-v;
--			u384<=(u(23 downto 0)&"00000000")+(u(24 downto 0)&"0000000");u20<=(u(27 downto 0)&"0000")+(u(29 downto 0)&"00");
--			v576<=(v(22 downto 0)&"000000000")+(v(25 downto 0)&"000000");v18<=(v(27 downto 0)&"0000")+(v(30 downto 0)&"0");
--			u2080<=(u(20 downto 0)&"00000000000")+(u(26 downto 0)&"00000");
--			
--			r2<=r1-149399;g2<=g1+127828;b2<=b1+u2080;
--			v1167<=v1152+v15;u404<=u384+u20;v594<=v576+v18;
--			
--			r3<=r2+v1167;g3<=g2-u404;b3<=b2-266353;v594_2<=v594;
--			
--			if(r3(31)='1')then
--				r4<=(others=>'0');
--			else
--				r4<="0000000000"&r3(31 downto 10);
--			end if;
--			g4<=g3-v594_2;
--			if(b3(31)='1')then
--				b4<=(others=>'0');
--			else
--				b4<="0000000000"&b3(31 downto 10);
--			end if;
--			
--			r<="000000000000000000000000"&r4(7 downto 0);
--			if(g4(31)='1')then
--				g<=(others=>'0');
--			else
--				g<="000000000000000000000000"&g4(17 downto 10);
--			end if;
--			b<="000000000000000000000000"&b4(7 downto 0);
--			
--		end if;
--	end process;
--end yuv2rgb_bhv;
			
architecture yuv2rgb_bhv2 of yuv2rgb is
signal r1,g1,b1,y288,y10,u96,u5,v416,v5,v208,v3,u512,u7:std_logic_vector(31 downto 0);
signal r2,g2,b2,y298,u101,v411,v211,u519:std_logic_vector(31 downto 0);
signal r3,g3,b3,v211_2:std_logic_vector(31 downto 0);
signal r4,g4,b4:std_logic_vector(31 downto 0);
signal px1,py1,px2,py2,px3,py3,px4,py4:integer range 0 to 1600;
signal ok1,ok2,ok3,ok4:std_logic:='0';
begin
	process(clk)
	begin
		if(clk'event and clk='1')then
			px1<=px;py1<=py;ok1<=iok;
			px2<=px1;py2<=py1;ok2<=ok1;
			px3<=px2;py3<=py2;ok3<=ok2;
			px4<=px3;py4<=py3;ok4<=ok3;
			ox<=px4;oy<=py4;ook<=ok4;
			
			y288<=(y(23 downto 0)&"00000000")+(y(26 downto 0)&"00000");y10<=(y(28 downto 0)&"000")+(y(30 downto 0)&"0");
			u96<=(u(25 downto 0)&"000000")+(u(26 downto 0)&"00000");u5<=(u(29 downto 0)&"00")+u;
			v416<=(v(23 downto 0)&"00000000")+(v(24 downto 0)&"0000000")+(v(26 downto 0)&"00000");v5<=(v(29 downto 0)&"00")+v;
			v208<=(v(24 downto 0)&"0000000")+(v(25 downto 0)&"000000")+(v(27 downto 0)&"0000");v3<=(v(30 downto 0)&"0")+v;
			u512<=(u(22 downto 0)&"000000000");u7<=(u(28 downto 0)&"000")-u;
			
			y298<=y288+y10;u101<=u96+u5;v411<=v416-v5;v211<=v208+v3;u519<=u512+u7;
			
			r3<=y298+v411;g3<=y298-u101;b3<=y298+u519;v211_2<=v211;
			
			r4<=r3-57344;g4<=g3-v211_2+34739;b4<=b3-71117;
			
			if(r4(31)='1')then
				r<=(others=>'0');
			else
				r<="000000000000000000000000"&r4(15 downto 8);
			end if;
			if(g4(31)='1')then
				g<=(others=>'0');
			else
				g<="000000000000000000000000"&g4(15 downto 8);
			end if;
			if(b4(31)='1')then
				b<=(others=>'0');
			else
				b<="000000000000000000000000"&b4(15 downto 8);
			end if;
			
			
		end if;
	end process;
end yuv2rgb_bhv2;