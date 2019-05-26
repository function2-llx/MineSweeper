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
	posx,posy:out integer;
	is_long:out std_logic
);
end cam_get;

architecture get_bhv of cam_get is
signal clk2,clk4:std_logic:='0';
signal stat:integer range 0 to 90:=0;
signal pstat:integer range 0 to 3:=0;
signal init_clk:integer:=0;
signal sccb_stat:integer:=0;
signal hnum,vnum,nhnum,vhnum,vvnum:integer range 0 to 1600:=0;
signal tr1,tg1,tb1,tr2,tg2,tb2,ty1,ty2,tu,tv:std_logic_vector(31 downto 0):=(others=>'0');
signal tscl:integer range 0 to 400:=0;
signal read_ok:std_logic:='0';
signal reg_r:std_logic;
signal t_ram_addr:std_logic_vector(20 downto 0) := (others => '0');
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
			if(tscl=199)then
				scl<='0';
				tscl<=tscl+1;
			elsif(tscl=399)then
				scl<='1';
				tscl<=0;
			else
				tscl<=tscl+1;
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
				nhnum<=nhnum+1;
				pstat<=0;
			else
				nhnum<=0;
				hnum<=hnum+1;
				if(pstat=3)then
					pstat<=0;
				else
					pstat<=pstat+1;
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
				ty1(7 downto 0)<=d;
			when 2=>
				tv(7 downto 0)<=d;
			when 3=>
				ty2(7 downto 0)<=d;
			end case;
				
		end if;
	end process;

	
end get_bhv;