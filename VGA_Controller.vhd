library	ieee;
use		ieee.std_logic_1164.all;
use		ieee.std_logic_unsigned.all;
use		ieee.std_logic_arith.all;

entity VGA_Controller is
port(
	clk_0,reset: in std_logic;
	hs,vs: out STD_LOGIC; 
	r,g,b: out STD_LOGIC_vector(2 downto 0);
	addr: out std_logic_vector(7 downto 0);
	data: in std_logic_vector(3 downto 0);
	mouse_x: in std_logic_vector(9 downto 0);--鼠标x坐标
	mouse_y: in std_logic_vector(8 downto 0);--鼠标y坐标
	remain : in integer;  -- 剩余雷数
	win    : in std_logic;-- 胜利
	lose   : in std_logic;-- 失败
	mouse_r: in integer;
	mouse_c: in integer
);
end VGA_Controller;

architecture vga_rom of VGA_Controller is

	component vga640480 is
		 port(
				addresshex	:		  out	STD_LOGIC_VECTOR(15 DOWNTO 0);
				addresswl	:		  out STD_LOGIC_VECTOR(12 DOWNTO 0);
				reset       :       in  STD_LOGIC;
				clk25       :		  out std_logic; 
				qhex	      :		  in STD_LOGIC_vector(8 downto 0);
				qwl	      :		  in STD_LOGIC_vector(8 downto 0);
				clk_0       :       in  STD_LOGIC; --100M时钟输入
				hs,vs       :       out STD_LOGIC; --行同步、场同步信号
				r,g,b       :       out STD_LOGIC_vector(2 downto 0);
				addr        :       out std_logic_vector(7 downto 0);
				data        :       in std_logic_vector(3 downto 0);
				mouse_x     :       in std_logic_vector(9 downto 0);--鼠标x坐标
				mouse_y     :       in std_logic_vector(8 downto 0);--鼠标y坐标
				remain      :       in integer;  -- 剩余雷数
				win         :       in std_logic;-- 胜利
				lose        :       in std_logic;-- 失败
				mouse_r     :       in integer;
				mouse_c     :       in integer
		  );
	end component;
	
	component digital_rom_cut IS
		PORT
		(
			address		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			clock		: IN STD_LOGIC ;
			q		: OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
		);
	END component;
	
	component digital_rom_wl IS
		PORT
		(
			address		: IN STD_LOGIC_VECTOR (12 DOWNTO 0);
			clock		: IN STD_LOGIC ;
			q		: OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
		);
	END component;
	
	signal addresshex_tmp: std_logic_vector(15 downto 0);
	signal addresswl_tmp: std_logic_vector(12 downto 0);
	signal clk25: std_logic;
	signal qhex_tmp: std_logic_vector(8 downto 0);
	signal qwl_tmp: std_logic_vector(8 downto 0);

	constant n: integer := 5;
begin

	u1: vga640480 port map(
							addresshex=>addresshex_tmp,
							addresswl=>addresswl_tmp,
							reset=>reset, 
							clk25=>clk25, 
							qhex=>qhex_tmp,
							qwl=>qwl_tmp,
							clk_0=>clk_0, 
							hs=>hs, vs=>vs, 
							r=>r, g=>g, b=>b,
							addr=>addr,
							data=>data,
							mouse_x=>mouse_x,
							mouse_y=>mouse_y,
							remain=>remain,
							win=>win,
							lose=>lose,
							mouse_r=>mouse_r,
							mouse_c=>mouse_c
						);
	uhex: digital_rom_cut port map(	
							address=>addresshex_tmp, 
							clock=>clk25, 
							q=>qhex_tmp
						);
	uwl: digital_rom_wl port map(	
							address=>addresswl_tmp, 
							clock=>clk25, 
							q=>qwl_tmp
						);

end vga_rom;