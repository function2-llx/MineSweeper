library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity cam_get is
port
(
	scl:buffer std_logic;
	sda:inout std_logic:='1';
	vs,hs:in std_logic;
	pclk:in std_logic;
	mclk:buffer std_logic:='0';
	d:in std_logic_vector(7 downto 0);
	rst:out std_logic:='1';
	pwdn:out std_logic:='0';
	clk:in std_logic;
	posx,posy:out integer:=0;
	is_long:out std_logic
);
end cam_get;

architecture get_bhv of cam_get is
signal clk2,clk4:std_logic:='0';
signal pstat:integer range 0 to 3:=0;
signal init_clk:integer:=0;
signal hnum,vnum,tix,tiy,tox,toy:integer range 0 to 1600:=0;
signal tr,tg,tb,ty,tu,tv:std_logic_vector(31 downto 0):=(others=>'0');
signal tok:std_logic;
begin
	process(clk)
	begin
		if(clk'event and clk='1')then
			if(init_clk<1500000)then
				if(init_clk=0)then 
					rst<='0';
				elsif(init_clk=500000)then 
					rst<='1';
				end if;
				init_clk<=init_clk+1;
			end if;
		end if;
	end process;
	process(clk)
	begin
		if(clk'event and clk='1')then
			clk2<=not clk2;
		end if;
	end process;
	process(clk2)
	begin
		if(clk2'event and clk2='1')then
			clk4<=not clk4;
		end if;
	end process;
	mclk<=clk4;
	process(pclk)
	begin
		if(pclk'event and pclk='1')then
			if(hs='0')then
				hnum<=0;
				pstat<=0;
			else
				hnum<=hnum+1;
				if(pstat=3)then
					pstat<=0;
				else
					pstat<=pstat+1;
				end if;
				if(pstat=1 or pstat=2)then
					if(tiy=639)then
						tiy<=0;
					else
						tiy<=tiy+1;
					end if;
				end if;
			end if;
			if(vs='1')then
				vnum<=493;
			elsif(hnum=1279)then
				if(vnum=509)then
					vnum<=0;
				else
					vnum<=vnum+1;
				end if;
			end if;
			case pstat is
			when 0=>
				tu(7 downto 0)<=d;
			when 1=>
				ty(7 downto 0)<=d;
			when 2=>
				tv(7 downto 0)<=d;
			when 3=>
				ty(7 downto 0)<=d;
			end case;	
		end if;
	end process;
	conv:entity work.yuv2rgb port map(y=>ty,u=>tu,v=>tv,px=>vnum,py=>tiy,clk=>pclk,r=>tr,g=>tg,b=>tb,ox=>tox,oy=>toy,ook=>tok);
	process(pclk)
	begin
		if(pclk'event and pclk='1')then
			if(tok='1')then
				if(tr>150 and tg<50 and tb<50)then
					posx<=tox;
					posy<=toy;
					is_long<='0';
				end if;
			end if;
		end if;
	end process;
			
end get_bhv;