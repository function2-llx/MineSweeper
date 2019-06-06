library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity getpos is
port
(
	clk:in std_logic;
	x,y:in integer range 0 to 1600;
	r,g,b:in std_logic_vector(31 downto 0);
	iok:in std_logic;
	ox,oy:buffer std_logic_vector(31 downto 0);
	ook:out std_logic
);
end getpos;

architecture getpos_bhv of getpos is
signal sx,sy,n:integer:=0;
signal tx,ty:std_logic_vector(31 downto 0);
signal ok,tok:std_logic:='0';
signal prer,preg,preb:std_logic_vector(31 downto 0);
begin
	process(clk)
	begin
		if(clk'event and clk='1')then
			if(x=0 and y=0 and iok='0')then
			--if(x>=479)then
				ok<='0';
				sx<=0;sy<=0;n<=0;
			else
				if(x=479 and y=639 and iok='1')then
					ok<='1';
				else
					ok<='0';
				end if;
				if(iok='1')then
					prer<=r;preg<=g;preb<=b;
				end if;
				if(iok='1' and prer-preg>=24 and prer-preb>=24 and r>=200 and r<=224 and r-g>=24 and r-b>=24)then
					sx<=sx+x;
					sy<=sy+y;
					n<=n+1;
				end if;
			end if;
			
		end if;
	end process;
	div1:entity work.div port map(x=>std_logic_vector(to_unsigned(sx,32)),y=>std_logic_vector(to_unsigned(n,32)),clk=>clk,z=>ox,iok=>ok,ook=>ook);
	div2:entity work.div port map(x=>std_logic_vector(to_unsigned(sy,32)),y=>std_logic_vector(to_unsigned(n,32)),clk=>clk,z=>oy,iok=>ok);
end getpos_bhv;
			