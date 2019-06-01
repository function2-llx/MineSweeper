library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity div is
port
(
	x,y:in std_logic_vector(31 downto 0);
	clk,iok:in std_logic;
	z:out std_logic_vector(31 downto 0);
	ook:out std_logic
);
end div;

architecture div_bhv of div is
type div_array is array(0 to 30) of std_logic_vector(31 downto 0);
signal tx,ty,tz:div_array;
signal ok:std_logic_vector(0 to 30);
begin
	process(clk)
	variable i:integer;
	begin
		if(clk'event and clk='1')then
			ty(0)<=y;ok(0)<=iok;
			if(std_logic_vector(to_unsigned(0,31))&x(31 downto 31)>=y)then
				tz(0)<=(31=>'1',others=>'0');
				tx(0)<=std_logic_vector(unsigned(x(31 downto 31))-unsigned(y(0 downto 0)))&x(30 downto 0);
			else
				tz(0)<=(others=>'0');
				tx(0)<=x;
			end if;
			for i in 1 to 30 loop
				ty(i)<=ty(i-1);ok(i)<=ok(i-1);
				if(std_logic_vector(to_unsigned(0,31-i))&tx(i-1)(31 downto 31-i)>=ty(i-1))then
					tz(i)<=tz(i-1)(31 downto 31-i+1)&'1'&tz(i-1)(31-i-1 downto 0);
					tx(i)<=std_logic_vector(unsigned(tx(i-1)(31 downto 31-i))-unsigned(ty(i-1)(i downto 0)))&tx(i-1)(31-i-1 downto 0);
				else
					tz(i)<=tz(i-1);
					tx(i)<=tx(i-1);
				end if;
			end loop;
			ook<=ok(30);
			if(tx(30)>=ty(30))then
				z<=tz(30)(31 downto 1)&'1';
			else
				z<=tz(30);
			end if;
		end if;
	end process;
end div_bhv;
			