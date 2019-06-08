library	ieee;
use		ieee.std_logic_1164.all;
use		ieee.std_logic_unsigned.all;
use		ieee.std_logic_arith.all;

entity VGA_Controller is
port(
	clk_0,reset: in std_logic;
	clicker: in std_logic;--新增测试按键
	hs,vs: out STD_LOGIC; 
	r,g,b: out STD_LOGIC_vector(2 downto 0)
);
end VGA_Controller;

architecture vga_rom of VGA_Controller is

component vga640480 is
	 port(
			address		:		  out	STD_LOGIC_VECTOR(13 DOWNTO 0);
			reset       :       in  STD_LOGIC;
			clk25       :		  out std_logic; 
			q		      :		  in STD_LOGIC_vector(2 downto 0);
			clicker     :       in std_logic;--新增测试按键
			clk_0       :       in  STD_LOGIC; --100M时钟输入
			hs,vs       :       out STD_LOGIC; --行同步、场同步信号
			r,g,b       :       out STD_LOGIC_vector(2 downto 0)
	  );
end component;

--component digital_rom_r IS
--	PORT
--	(
--		address		: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
--		clock		: IN STD_LOGIC ;
--		q		: OUT STD_LOGIC
--	);
--END component;
--component digital_rom_g IS
--	PORT
--	(
--		address		: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
--		clock		: IN STD_LOGIC ;
--		q		: OUT STD_LOGIC
--	);
--END component;
--component digital_rom_b IS
--	PORT
--	(
--		address		: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
--		clock		: IN STD_LOGIC ;
--		q		: OUT STD_LOGIC
--	);
--END component;
component digital_rom_cut IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		clock		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
	);
END component;

signal address_tmp: std_logic_vector(13 downto 0);
signal clk25: std_logic;
signal q_tmp: std_logic_vector(2 downto 0);


begin

u1: vga640480 port map(
						address=>address_tmp, 
						reset=>reset, 
						clk25=>clk25, 
						q=>q_tmp,
						clicker=>clicker,
						clk_0=>clk_0, 
						hs=>hs, vs=>vs, 
						r=>r, g=>g, b=>b
					);
--ur: digital_rom_r port map(	
--						address=>address_tmp, 
--						clock=>clk25, 
--						q=>q_tmp(2)
--					);
--ug: digital_rom_g port map(	
--						address=>address_tmp, 
--						clock=>clk25, 
--						q=>q_tmp(1)
--					);
--ub: digital_rom_b port map(	
--						address=>address_tmp, 
--						clock=>clk25, 
--						q=>q_tmp(0)
--					);
utest: digital_rom_cut port map(	
						address=>address_tmp, 
						clock=>clk25, 
						q=>q_tmp
					);

end vga_rom;



--library ieee;
--use ieee.std_logic_1164.all;
--use ieee.std_logic_unsigned.all;
--
--entity VGA_Controller is
--	port (
--	--VGA Side
--		VGA_CLK	: out std_logic;
--		hs,vs	: out std_logic;		--行同步、场同步信号
--		oRed	: out std_logic_vector (2 downto 0);--位宽
--		oGreen	: out std_logic_vector (2 downto 0);--位宽
--		oBlue	: out std_logic_vector (2 downto 0);--位宽
--	--RAM side
----		R,G,B	: in  std_logic_vector (9 downto 0);
----		addr	: out std_logic_vector (18 downto 0);
--	--Control Signals
--		reset	: in  std_logic;--复位
--		CLK_in	: in  std_logic	--时钟		--100M时钟输入
--	);		
--end entity VGA_Controller;
--
--architecture behave of VGA_Controller is
--
----VGA
--	signal CLK,CLK_2,CLK_4	: std_logic;
--	signal rt,gt,bt	: std_logic_vector (2 downto 0);--颜色信号
--	signal hst,vst	: std_logic;
--	signal x		: std_logic_vector (9 downto 0);		--X坐标
--	signal y		: std_logic_vector (8 downto 0);		--Y坐标
----	signal inside: std_logic;
--	
----	component Judge is
----		port(
----			xx: in std_logic_vector (9 downto 0);
----			yy: in std_logic_vector (8 downto 0);
----			inside: out std_logic
----		);
----	end component;
--begin
----reset<=not reset_in;
--	
----	in_hex: Judge port map(x, y, inside);
--	
--	VGA_CLK	<= CLK; -- 把CLK的值赋值给VGA_CLK
--	CLK<=CLK_4;
-- -----------------------------------------------------------------------
--	process (CLK_in)
--	begin
--		if CLK_in'event and CLK_in = '1' then	--对100M输入信号二分频 即 当时钟信号变化 并且是上升沿
--			CLK_2 <= not CLK_2;                 -- 把CLK反赋给CLK2
--		end if;
--	end process;
--	
--	process (CLK_2)
--	begin
--		if CLK_2'event and CLK_2 = '1' then     --四分频
--			CLK_4 <= not CLK_4;
--		end if;
--	end process;	
--
-- -----------------------------------------------------------------------
--	process (CLK, reset)	--行区间像素数（含消隐区）
--	begin
--		if reset = '0' then
--			x <= (others => '0');
--		elsif CLK'event and CLK = '1' then
--			if x = 799 then --当X=799时 把0赋值给X
--				x <= (others => '0');
--			else
--				x <= x + 1; --时钟信号每上升一次 X记录一次
--			end if;
--		end if;
--	end process;
--
--  -----------------------------------------------------------------------
--	 process (CLK, reset)	--场区间行数（含消隐区）
--	 begin
--	  	if reset = '0' then
--	   	y <= (others => '0');
--	  	elsif CLK'event and CLK = '1' then
--	   	if x = 799 then
--	    		if y = 524 then
--	     			y <= (others => '0');
--	    		else
--	     			y <= y + 1;
--	    		end if;
--	   	end if;
--	  	end if;
--	 end process;
-- 
--  -----------------------------------------------------------------------
--	 process (CLK, reset)	--行同步信号产生（同步宽度96，前沿16）
--	 begin
--		  if reset = '0' then
--				hst <= '1'; 
--		  elsif CLK'event and CLK = '1' then
--		   	if x >= 656 and x < 752 then
--					hst <= '0';
--		   	else
--					hst <= '1';
--		   	end if;
--		  end if;
--	 end process;
-- 
-- -----------------------------------------------------------------------
--	 process (CLK, reset)	--场同步信号产生（同步宽度2，前沿10）
--	 begin
--	  	if reset = '0' then
--	   		vst <= '1';
--	  	elsif CLK'event and CLK = '1' then
--	   		if y >= 490 and y< 492 then
--					vst <= '0';
--	   		else
--					vst <= '1';
--	   		end if;
--	  	end if;
--	 end process;
-- -----------------------------------------------------------------------
--	 process (CLK, reset)	--行同步信号输出
--	 begin
--	  	if reset = '0' then
--	   		hs <= '1';
--	  	elsif CLK'event and CLK = '1' then
--	   		hs <=  hst;
--	  	end if;
--	 end process;
--
-- -----------------------------------------------------------------------
--	 process (CLK, reset)	--场同步信号输出
--	 begin
--	  	if reset = '0' then
--	   		vs <= '1';
--	  	elsif CLK'event and CLK='1' then
--	   		vs <=  vst;
--	  	end if;
--	 end process;
--
--------------------------------------------------------------------------
----	process (CLK, reset) -- XY坐标定位控制
----	begin	  	
----		if reset = '0' then
----			rt		<=	(others => '0');
----			gt		<=	(others => '0');
----			bt		<=	(others => '0');
----			addr	<=	(others => '0');
----	  	elsif CLK'event and CLK='1' then
----			addr	<=	x&y;
----			rt		<=	R;
----			gt		<=	G;
----			bt		<=	B;
----	  	end if;
----	end process;
-------------------------------------------------------------------------	
-------------------------------------------------------------------------
-------------------------------------------------------------------------
--	process(reset,clk,x,y) -- XY坐标定位控制
--	begin  
--		if reset='0' then
--			rt <= "000";
--			gt	<= "000";
--			bt	<= "000";	
--		elsif(clk'event and clk='1')then 
--			if (y>=188 and y<292 and x>=0 and x<640) then   -- X方向控制,分为3列，
--			-- and (x-260)*(y-188)+(x-290)*(y-240)>=0 and (x-350)*(y-240)+(x-380)*(y-292)<=0 and (x-380)*(y-188)+(x-350)*(y-240)<=0 and (x-290)*(y-240)+(x-260)*(y-292)<=0
--			--if (x>=290 and x<350 and (x-260)*(y-188)+(x-290)*(y-240)>=0 and (x-350)*(y-240)+(x-380)*(y-292)<=0 and (x-380)*(y-188)+(x-350)*(y-240)<=0 and (x-290)*(y-240)+(x-260)*(y-292)>=0)
--				rt <= "011";
--				gt <= "110";
--				bt <= "111";
----			elsif x>=213 and x<426 and y>=0 and y<240 then
----				rt <="111";
----				gt <="111";
----				bt <="000";
----			elsif x>=426 and x<640 and y>=0 and y<240 then
----				rt <="111";
----				gt <="111";
----				bt <="111";
----			elsif x>=0 and x<213 and y>=240 and y<480 then
----				rt <="000";
----				gt <="000";
----				bt <="111";
----			elsif x>=213 and x<426 and y>=240 and y<480 then
----				rt <="111";
----				gt <="000";
----				bt <="000";
----			elsif x>=426 and x<640 and y>=240 and y<480 then
----				rt <="111";
----				gt <="000";
----				bt <="111";
--			else
--				rt <="000";
--				gt <="000";
--				bt <="000";
--			end if;
--		    
----			if y>=0 and y<240 then				-- Y方向控制，分为2行
----			   gt <="111";
----			else
----			   gt <="000";
----			end if;		
--		end if;		 
--	    end process;	
--
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-------------------------------------------------------------------------
--	process (hst, vst, rt, gt, bt)	--色彩输出
--	begin
--		if hst = '1' and vst = '1' then
--			oRed	<= rt;
--			oGreen	<= gt;
--			oBlue	<= bt;
--		else
--			oRed	<= (others => '0');
--			oGreen	<= (others => '0');
--			oBlue	<= (others => '0');
--		end if;
--	end process;
--
--end behave;