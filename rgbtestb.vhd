library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity rgbtestb is
port
(
	clk,pclk,rst:in std_logic;
	ix,iy:in integer range 0 to 1600;
	ir,ig,ib:in std_logic_vector(31 downto 0);
	iok:in std_logic;
	vs,hs:buffer std_logic;
	ored,ogreen,oblue:out std_logic_vector(2 downto 0):="000"
);
end rgbtestb;

architecture rgb_bhv of rgbtestb is
signal ox,oy:integer range 0 to 1600:=0;
signal stat,stat2:integer range 0 to 1;
signal clk2:std_logic:='0';
signal rst1:std_logic;
signal addr_a,addr_b:STD_LOGIC_VECTOR (14 DOWNTO 0):=(others=>'0');
signal data_a,data_b:STD_LOGIC_VECTOR (15 DOWNTO 0);
signal we_a,we_b:STD_LOGIC  := '0';
signal q_a,q_b:STD_LOGIC_VECTOR (15 DOWNTO 0);
signal prer,preg,preb,sr,sg,sb:std_logic_vector(31 downto 0);
begin
	ram:entity work.ram port map(address_a=>addr_a,address_b=>addr_b,clock_a=>clk,clock_b=>pclk,data_a=>data_a,data_b=>data_b,wren_a=>we_a,wren_b=>we_b,q_a=>q_a,q_b=>q_b);
	process(clk)
	begin
		if(clk'event and clk='1')then
			clk2<=not clk2;
		end if;
	end process;
	addr_a<=std_logic_vector(to_unsigned(ox,11))(8 downto 2)&std_logic_vector(to_unsigned(oy,11))(9 downto 2);
	addr_b<=std_logic_vector(to_unsigned(ix,11))(8 downto 2)&std_logic_vector(to_unsigned(iy,11))(9 downto 2);
	process(clk2)
	begin
		if(clk2'event and clk2='1')then
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
--				if(ir>"00000000000000000000000011001000" and ig<"00000000000000000000000000110010" and ib<"00000000000000000000000000110010")then
--					data_b<="1110";
--				else
--					data_b<="0000";
--				end if;
				stat<=stat+1;
			when 1=>
				if(vs='1' and hs='1')then
					ored<=q_a(8 downto 6);
					ogreen<=q_a(5 downto 3);
					oblue<=q_a(2 downto 0);
				else
					ored<="000";
					ogreen<="000";
					oblue<="000";
				end if;
				stat<=0;
			end case;
		end if;
	end process;
	process(pclk)
	begin
		if(pclk'event and pclk='1')then
			case iok is
			when '1'=>
				prer<=ir;preg<=ig;preb<=ib;
				we_b<='1';
				if(rst='1' and ir>=200 and ir<=224 and prer-preg>=24 and prer-preb>=24 and ir-ig>=24 and ir-ib>=24)then
					data_b<="0000000000111000";
				else
					data_b<="0000000"&ir(7 downto 5)&ig(7 downto 5)&ib(7 downto 5);
				end if;
--					if(ir>x"40" and ig>x"40" and ib>x"40")then
--						data_b<="1";
--					else
--						data_b<="0";
--					end if;
			when '0'=>
				we_b<='0';
			end case;
		end if;
	end process;			
end rgb_bhv;

	
	