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
	ox,oy:buffer std_logic_vector(31 downto 0);
	ook:out std_logic
);
end getpos;

architecture getpos_bhv of getpos is
signal sx,sy,n:integer:=0;
signal tx,ty:std_logic_vector(31 downto 0);
signal ok,tok:std_logic:='0';
begin
	process(clk)
	begin
		if(clk'event and clk='1')then
			if(x=479 and y=639)then
			--if(x>=479)then
				ok<='1';
				sx<=0;sy<=0;n<=0;
			else
				ok<='0';
				if(r<100 and g>200 and b<100)then
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
			