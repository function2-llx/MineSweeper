library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rgbtest is
port
(
	addr:out std_logic_vector(19 downto 0);
	data:inout std_logic_vector(31 downto 0):=(others=>'Z');
	oe,re:out std_logic:='1';
	clk,pclk,rst:in std_logic;
	ix,iy:in integer range 0 to 1600;
	ir,ig,ib:in std_logic_vector(31 downto 0);
	vs,hs:buffer std_logic;
	ored,ogreen,oblue:out std_logic_vector(2 downto 0):="000"
);
end rgbtest;

architecture rgb_bhv of rgbtest is
signal ox,oy:integer range 0 to 1600:=0;
signal stat:integer range 0 to 3;
signal preclk,nowclk:std_logic;
signal rst1:std_logic;
begin
--	process(clk)
--	begin
--		preclk<=nowclk;
--		nowclk<=pclk;
--	end process;
	process(clk)
	begin
		if(clk'event and clk='1')then
			case stat is
			when 0=>
				if(oy=799)then
					if(ox=524)then
						ox<=0;
					else
						ox<=ox+1;
					end if;
					oy<=0;
				else
					oy<=oy+1;
				end if;
				if(oy>=656 and oy<=751)then
					hs<='0';
				else
					hs<='1';
				end if;
				if(ox>=490 and ox<=491)then
					vs<='0';
				else
					vs<='1';
				end if;
				if(rst='1')then
					addr<=std_logic_vector(to_unsigned(ox,10))&std_logic_vector(to_unsigned(oy,10));
					data<=(others=>'Z');
				else
					addr<=std_logic_vector(to_unsigned(ix,10))&std_logic_vector(to_unsigned(iy,10));
					data<="00000000"&ir(7 downto 0)&ig(7 downto 0)&ib(7 downto 0);
				end if;
				rst1<=rst;
				stat<=stat+1;
			when 1=>
				if(rst1='1')then
					re<='0';
				else
					oe<='0';
				end if;
				stat<=stat+1;
			when 2=>
				if(rst1='1')then
					null;
				else
					null;
				end if;
				stat<=stat+1;
			when 3=>
				if(rst1='1')then
					if(vs='1' and hs='1')then
						ored<=data(23 downto 21);
						ogreen<=data(15 downto 13);
						oblue<=data(7 downto 5);
					else
						ored<="000";
						ogreen<="000";
						oblue<="000";
					end if;
					re<='1';
				else
					data<=(others=>'Z');
					oe<='1';
				end if;
				stat<=0;
			end case;
		end if;
	end process;
end rgb_bhv;

	
	