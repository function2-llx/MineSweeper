library ieee;
use ieee.std_logic_1164.all;

entity vga_rom is
port(
	clk_0,reset: in std_logic;
	hs,vs: out STD_LOGIC; 
	r,g,b: out STD_LOGIC_vector(2 downto 0)
);
end vga_rom;

architecture vga_rom of vga_rom is

component vga640480 is
	 port(
			address		:		  out	STD_LOGIC_VECTOR(13 DOWNTO 0);
			reset       :         in  STD_LOGIC;
			clk50       :		  out std_logic; 
			q		    :		  in STD_LOGIC_vector(0 downto 0);
			clk_0       :         in  STD_LOGIC; --100M时钟输入
			hs,vs       :         out STD_LOGIC; --行同步、场同步信号
			r,g,b       :         out STD_LOGIC_vector(2 downto 0)
	  );
end component;

component digital_rom IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		clock		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (0 DOWNTO 0)
	);
END component;

signal address_tmp: std_logic_vector(13 downto 0);
signal clk50: std_logic;
signal q_tmp: std_logic_vector(0 downto 0);


begin

u1: vga640480 port map(
						address=>address_tmp, 
						reset=>reset, 
						clk50=>clk50, 
						q=>q_tmp, 
						clk_0=>clk_0, 
						hs=>hs, vs=>vs, 
						r=>r, g=>g, b=>b
					);
u2: digital_rom port map(	
						address=>address_tmp, 
						clock=>clk50, 
						q=>q_tmp
					);
end vga_rom;