library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity cam_test is
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
	vhs,vvs:out std_logic;
	ored:out std_logic_vector (2 downto 0);
	ogreen:out std_logic_vector (2 downto 0);
	oblue:out std_logic_vector (2 downto 0)
);
end cam_test;

architecture test_bhv of cam_test is
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
--	process(clk)
--	begin
--		if(clk'event and clk='1')then
--			if(init_clk>=1500000)then
--				case stat is
--				when 0|30|60=>
--					if(tscl=99)then
--						sda<='0';
--						stat<=stat+1;
--					end if;
--				when 1|3 to 6|8 to 12|14|15|17 to 23|25 to 27|31|33 to 36|38 to 42|44|46|48|49|51 to 57|61|63 to 66|68 to 70|72 to 78|81|83 to 87=>
--					if(tscl=299)then
--						sda<='0';
--						stat<=stat+1;
--					end if;
--				when 2|7|13|16|24|32|37|43|45|47|50|62|67|71|79|80|82=>
--					if(tscl=299)then
--						sda<='1';
--						stat<=stat+1;
--					end if;
--				when 28|58|88=>
--					if(tscl=99)then
--						sda<='1';
--						stat<=stat+2;
--					end if;
--				--when 90=>stat<=0;
--				when others=>null;
--				end case;
--			end if;
--		end if;
--	end process;
--	vhs<=sda;
--	process(clk)
--	begin
--		if(clk'event and clk='1')then
--			if(init_clk>=1500000)then
--				case stat is
--				when 0|20=>
--					if(tscl=99)then
--						sda<='0';
--						stat<=stat+1;
--					end if;
--				when 1|3 to 6|8 to 13|15|17|18|21|23 to 26|29=>
--					if(tscl=299)then
--						sda<='0';
--						stat<=stat+1;
--					end if;
--				when 2|7|14|16|22|27|28|38=>
--					if(tscl=299)then
--						sda<='1';
--						stat<=stat+1;
--					end if;
--				when 30 to 37=>
--					if(tscl=299)then
--						sda<='Z';
--						stat<=stat+1;
--					end if;
--				when 19|39=>
--					if(tscl=60)then
--						sda<='0';
--					elsif(tscl=120)then
--						sda<='1';
--						stat<=stat+1;
--					end if;
--				when 40=>stat<=0;
--				when others=>null;
--				end case;
--			end if;
--		end if;
--	end process;
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

	
end test_bhv;