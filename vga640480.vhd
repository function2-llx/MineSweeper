---------------------------------------------------------------------------------------------
--创建日期   : 2019-05-18
--目标芯片   : EP2C70F672C8N
--时钟选择   : clk_0 = 100MHz
--演示说明   : 按rst按键可以使显示复位（不复位游戏，游戏有另外的复位操作），即全黑屏；松开恢复显示
--主要信号说明: addresshex, addresswl, qhex, qwl: 两部分RAM的读地址和返回值
--            addr, data: 格子的编号和状态信息
--            win, lose: 标志棋局是否胜负已决定，高电平表示胜或负
--            mouse_r, mouse_c: 鼠标所处的格子编号
--主要进程说明: 根据各种信息计算显示的内容，其中包括四分频产生25MHz时钟和VGA显示所需的各种进程
---------------------------------------------------------------------------------------------
library	ieee;
use		ieee.std_logic_1164.all;
use		ieee.std_logic_unsigned.all;
use		ieee.std_logic_arith.all;

entity vga640480 is
	 port(
			addresshex	:		  out	STD_LOGIC_VECTOR(15 DOWNTO 0);
			addresswl	:		  out STD_LOGIC_VECTOR(12 DOWNTO 0);
			reset       :       in  STD_LOGIC;
			clk25       :		  out std_logic; --25MHz
			qhex	      :		  in STD_LOGIC_vector(8 downto 0);--内存返回的数值
			qwl	      :		  in STD_LOGIC_vector(8 downto 0);--内存返回的数值
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
end vga640480;

architecture behavior of vga640480 is
	
	signal r1,g1,b1   : std_logic_vector(2 downto 0);					
	signal hs1,vs1    : std_logic;				
	signal vector_x   : std_logic_vector(9 downto 0);		--X坐标
	signal vector_y   : std_logic_vector(8 downto 0);		--Y坐标
	signal clk, CLK_2	: std_logic;
	constant n        : integer := 5;
	function get_addr(c: integer; r: integer) return std_logic_vector is
	begin
		  if c <= n - 1 then
				return conv_std_logic_vector(c * (c + 1) / 2 + r, 8);
		  end if;
	 
		  if c <= 3 * n - 3 then
				if (c - n) mod 2 = 0 then
					 return conv_std_logic_vector(n * (n + 1) / 2 + (2 * n - 1) * ((c - n) / 2) + r, 8);
				else
					 return conv_std_logic_vector(n * (n + 1) / 2 + (2 * n - 1) * ((c - n) / 2) + n - 1 + r, 8);
				end if;
		  end if;
				
		  return conv_std_logic_vector((n + 1) * n / 2 + (n - 1) * (2 * n - 1) + (c - 3 * n + 2) * (5 * n - c - 3) / 2 + r, 8);
	end function;
	
begin
	clk25 <= clk;
 -----------------------------------------------------------------------
	process (clk_0)
	begin
		if clk_0'event and clk_0 = '1' then	--对100M输入信号二分频 即 当时钟信号变化 并且是上升沿
			CLK_2 <= not CLK_2;                 -- 把CLK反赋给CLK2
		end if;
	end process;
	
	process (CLK_2)
	begin
		if CLK_2'event and CLK_2 = '1' then     --四分频
			clk <= not clk;
		end if;
	end process;

 -----------------------------------------------------------------------
	 process(clk,reset)	--行区间像素数（含消隐区）
	 begin
	  	if reset='0' then
	   		vector_x <= (others=>'0');
	  	elsif clk'event and clk='1' then
	   		if vector_x=799 then
	    		vector_x <= (others=>'0');
	   		else
	    		vector_x <= vector_x + 1;
	   		end if;
	  	end if;
	 end process;

  -----------------------------------------------------------------------
	 process(clk,reset)	--场区间行数（含消隐区）
	 begin
	  	if reset='0' then
	   		vector_y <= (others=>'0');
	  	elsif clk'event and clk='1' then
	   		if vector_x=799 then
	    		if vector_y=524 then
	     			vector_y <= (others=>'0');
	    		else
	     			vector_y <= vector_y + 1;
	    		end if;
	   		end if;
	  	end if;
	 end process;
 
  -----------------------------------------------------------------------
	 process(clk,reset) --行同步信号产生（同步宽度96，前沿16）
	 begin
		  if reset='0' then
		   hs1 <= '1';
		  elsif clk'event and clk='1' then
		   	if vector_x>=656 and vector_x<752 then
		    	hs1 <= '0';
		   	else
		    	hs1 <= '1';
		   	end if;
		  end if;
	 end process;
 
 -----------------------------------------------------------------------
	 process(clk,reset) --场同步信号产生（同步宽度2，前沿10）
	 begin
	  	if reset='0' then
	   		vs1 <= '1';
	  	elsif clk'event and clk='1' then
	   		if vector_y>=490 and vector_y<492 then
	    		vs1 <= '0';
	   		else
	    		vs1 <= '1';
	   		end if;
	  	end if;
	 end process;
 -----------------------------------------------------------------------
	 process(clk,reset) --行同步信号输出
	 begin
	  	if reset='0' then
	   		hs <= '0';
	  	elsif clk'event and clk='1' then
	   		hs <=  hs1;
	  	end if;
	 end process;

 -----------------------------------------------------------------------
	 process(clk,reset) --场同步信号输出
	 begin
	  	if reset='0' then
	   		vs <= '0';
	  	elsif clk'event and clk='1' then
	   		vs <=  vs1;
	  	end if;
	 end process;
	
 -----------------------------------------------------------------------	
	process(reset,clk,vector_x,vector_y) -- XY坐标定位控制
		variable x: integer;
		variable y: integer;
		variable cout: integer range 0 to 21; -- 17 is word area; 18 is 10x num area; 19 is 1x num area; 20 is illegal but in 640 * 480; 21 is out of range
		variable rout: integer range 0 to 4;
		variable vectors_x: std_logic_vector(5 downto 0);
		variable vectors_y: std_logic_vector(5 downto 0);
		variable prefix: std_logic_vector(3 downto 0);
		variable tens, ones: integer range 0 to 10;
	begin
		if reset='0' then
			r1 <= "000";
			g1	<= "000";
			b1	<= "000";	
		elsif(clk'event and clk='1')then
			x := conv_integer(vector_x);
			y := conv_integer(vector_y);
			--y += 16
			if (x >= 72 and x < 128 and y >= 216 and y < 280 and (((((y + 72) mod 96)-16)*(((x + 40) mod 56)-28))<=((((y + 72) mod 96)-0)*(((x + 40) mod 56)-0))) and (((y + 72) mod 96)-64)*(((x + 40) mod 56)-55)-(((y + 72) mod 96)-48)*(((x + 40) mod 56)-28)>=0 and (((y + 72) mod 96)-48)*(((x + 40) mod 56)-28)-(((y + 72) mod 96)-64)*(((x + 40) mod 56)-0)>=0 and (((y + 72) mod 96)-0)*(((x + 40) mod 56)-55)-(((y + 72) mod 96)-16)*(((x + 40) mod 56)-28)<=0) then-- 
				cout := 0;
				rout := 0;
				addr <= get_addr(cout, rout);
				vectors_y := conv_std_logic_vector((y + 72) mod 96, 6);
				vectors_x := conv_std_logic_vector((x + 40) mod 56, 6);
				--line 0: y [8 + 96 * 2, 8 + 64 * 7 - 96 * 2), x [16 + 1 * 56, 16 + 2 * 56) || [16 + 9 * 56, 16 + 10 * 56)
			elsif (x >= 100 and x < 156 and y >= 168 and y < 328 and (((((y + 24) mod 96)-16)*(((x + 12) mod 56)-28))<=((((y + 24) mod 96)-0)*(((x + 12) mod 56)-0))) and (((y + 24) mod 96)-64)*(((x + 12) mod 56)-55)-(((y + 24) mod 96)-48)*(((x + 12) mod 56)-28)>=0 and (((y + 24) mod 96)-48)*(((x + 12) mod 56)-28)-(((y + 24) mod 96)-64)*(((x + 12) mod 56)-0)>=0 and (((y + 24) mod 96)-0)*(((x + 12) mod 56)-55)-(((y + 24) mod 96)-16)*(((x + 12) mod 56)-28)<=0) then-- 
				cout := 1;
				if y < 248 then
					rout := 0;
				else
					rout := 1;
				end if;
				addr <= get_addr(cout, rout);
				vectors_y := conv_std_logic_vector((y + 24) mod 96, 6);
				vectors_x := conv_std_logic_vector((x + 12) mod 56, 6);
				--line 1: y [56 + 96, 56 + 64 * 4 + 32 * 3 - 96), x [16 + 2 * 56 - 28, 16 + 3 * 56 - 28) || [16 + 8 * 56 + 28, 16 + 9 * 56 + 28)
			elsif (x >= 128 and x < 184 and y >= 120 and y < 376 and (((((y + 72) mod 96)-16)*(((x + 40) mod 56)-28))<=((((y + 72) mod 96)-0)*(((x + 40) mod 56)-0))) and (((y + 72) mod 96)-64)*(((x + 40) mod 56)-55)-(((y + 72) mod 96)-48)*(((x + 40) mod 56)-28)>=0 and (((y + 72) mod 96)-48)*(((x + 40) mod 56)-28)-(((y + 72) mod 96)-64)*(((x + 40) mod 56)-0)>=0 and (((y + 72) mod 96)-0)*(((x + 40) mod 56)-55)-(((y + 72) mod 96)-16)*(((x + 40) mod 56)-28)<=0) then-- 
				cout := 2;
				if y < 200 then
					rout := 0;
				elsif y < 296 then
					rout := 1;
				else
					rout := 2;
				end if;
				addr <= get_addr(cout, rout);
				vectors_y := conv_std_logic_vector((y + 72) mod 96, 6);
				vectors_x := conv_std_logic_vector((x + 40) mod 56, 6);
				--line 2: y [8 + 96, 8 + 64 * 7 - 96), x [16 + 2 * 56, 16 + 3 * 56) || [16 + 8 * 56, 16 + 9 * 56)
			elsif (x >= 156 and x < 212 and y >= 72 and y < 424 and (((((y + 24) mod 96)-16)*(((x + 12) mod 56)-28))<=((((y + 24) mod 96)-0)*(((x + 12) mod 56)-0))) and (((y + 24) mod 96)-64)*(((x + 12) mod 56)-55)-(((y + 24) mod 96)-48)*(((x + 12) mod 56)-28)>=0 and (((y + 24) mod 96)-48)*(((x + 12) mod 56)-28)-(((y + 24) mod 96)-64)*(((x + 12) mod 56)-0)>=0 and (((y + 24) mod 96)-0)*(((x + 12) mod 56)-55)-(((y + 24) mod 96)-16)*(((x + 12) mod 56)-28)<=0) then-- 
				cout := 3;
				if y < 152 then
					rout := 0;
				elsif y < 248 then
					rout := 1;
				elsif y < 344 then
					rout := 2;
				else
					rout := 3;
				end if;
				addr <= get_addr(cout, rout);
				vectors_y := conv_std_logic_vector((y + 24) mod 96, 6);
				vectors_x := conv_std_logic_vector((x + 12) mod 56, 6);
				--line 3: y [56, 56 + 64 * 4 + 32 * 3), x [16 + 3 * 56 - 28, 16 + 8 * 56 + 28)
			elsif (x >= 184 and x < 240 and y >= 24 and y < 472 and (((((y + 72) mod 96)-16)*(((x + 40) mod 56)-28))<=((((y + 72) mod 96)-0)*(((x + 40) mod 56)-0))) and (((y + 72) mod 96)-64)*(((x + 40) mod 56)-55)-(((y + 72) mod 96)-48)*(((x + 40) mod 56)-28)>=0 and (((y + 72) mod 96)-48)*(((x + 40) mod 56)-28)-(((y + 72) mod 96)-64)*(((x + 40) mod 56)-0)>=0 and (((y + 72) mod 96)-0)*(((x + 40) mod 56)-55)-(((y + 72) mod 96)-16)*(((x + 40) mod 56)-28)<=0) then-- 
				cout := 4;
				if y < 104 then
					rout := 0;
				elsif y < 200 then
					rout := 1;
				elsif y < 296 then
					rout := 2;
				elsif y < 392 then
					rout := 3;
				else
					rout := 4;
				end if;
				addr <= get_addr(cout, rout);
				vectors_y := conv_std_logic_vector((y + 72) mod 96, 6);
				vectors_x := conv_std_logic_vector((x + 40) mod 56, 6);
				--line 4: y [8, 8 + 64 * 7), x [16 + 3 * 56, 16 + 8 * 56)
			elsif (x >= 212 and x < 268 and y >= 72 and y < 424 and (((((y + 24) mod 96)-16)*(((x + 12) mod 56)-28))<=((((y + 24) mod 96)-0)*(((x + 12) mod 56)-0))) and (((y + 24) mod 96)-64)*(((x + 12) mod 56)-55)-(((y + 24) mod 96)-48)*(((x + 12) mod 56)-28)>=0 and (((y + 24) mod 96)-48)*(((x + 12) mod 56)-28)-(((y + 24) mod 96)-64)*(((x + 12) mod 56)-0)>=0 and (((y + 24) mod 96)-0)*(((x + 12) mod 56)-55)-(((y + 24) mod 96)-16)*(((x + 12) mod 56)-28)<=0) then-- 
				cout := 5;
				if y < 152 then
					rout := 0;
				elsif y < 248 then
					rout := 1;
				elsif y < 344 then
					rout := 2;
				else
					rout := 3;
				end if;
				addr <= get_addr(cout, rout);
				vectors_y := conv_std_logic_vector((y + 24) mod 96, 6);
				vectors_x := conv_std_logic_vector((x + 12) mod 56, 6);
				--line 5: y [56, 56 + 64 * 4 + 32 * 3), x [16 + 3 * 56 - 28, 16 + 8 * 56 + 28)
			elsif (x >= 240 and x < 296 and y >= 24 and y < 472 and (((((y + 72) mod 96)-16)*(((x + 40) mod 56)-28))<=((((y + 72) mod 96)-0)*(((x + 40) mod 56)-0))) and (((y + 72) mod 96)-64)*(((x + 40) mod 56)-55)-(((y + 72) mod 96)-48)*(((x + 40) mod 56)-28)>=0 and (((y + 72) mod 96)-48)*(((x + 40) mod 56)-28)-(((y + 72) mod 96)-64)*(((x + 40) mod 56)-0)>=0 and (((y + 72) mod 96)-0)*(((x + 40) mod 56)-55)-(((y + 72) mod 96)-16)*(((x + 40) mod 56)-28)<=0) then-- 
				cout := 6;
				if y < 104 then
					rout := 0;
				elsif y < 200 then
					rout := 1;
				elsif y < 296 then
					rout := 2;
				elsif y < 392 then
					rout := 3;
				else
					rout := 4;
				end if;
				addr <= get_addr(cout, rout);
				vectors_y := conv_std_logic_vector((y + 72) mod 96, 6);
				vectors_x := conv_std_logic_vector((x + 40) mod 56, 6);
				--line 6: y [8, 8 + 64 * 7), x [16 + 3 * 56, 16 + 8 * 56)
			elsif (x >= 268 and x < 324 and y >= 72 and y < 424 and (((((y + 24) mod 96)-16)*(((x + 12) mod 56)-28))<=((((y + 24) mod 96)-0)*(((x + 12) mod 56)-0))) and (((y + 24) mod 96)-64)*(((x + 12) mod 56)-55)-(((y + 24) mod 96)-48)*(((x + 12) mod 56)-28)>=0 and (((y + 24) mod 96)-48)*(((x + 12) mod 56)-28)-(((y + 24) mod 96)-64)*(((x + 12) mod 56)-0)>=0 and (((y + 24) mod 96)-0)*(((x + 12) mod 56)-55)-(((y + 24) mod 96)-16)*(((x + 12) mod 56)-28)<=0) then-- 
				cout := 7;
				if y < 152 then
					rout := 0;
				elsif y < 248 then
					rout := 1;
				elsif y < 344 then
					rout := 2;
				else
					rout := 3;
				end if;
				addr <= get_addr(cout, rout);
				vectors_y := conv_std_logic_vector((y + 24) mod 96, 6);
				vectors_x := conv_std_logic_vector((x + 12) mod 56, 6);
				--line 7: y [56, 56 + 64 * 4 + 32 * 3), x [16 + 3 * 56 - 28, 16 + 8 * 56 + 28)
			elsif (x >= 296 and x < 352 and y >= 24 and y < 472 and (((((y + 72) mod 96)-16)*(((x + 40) mod 56)-28))<=((((y + 72) mod 96)-0)*(((x + 40) mod 56)-0))) and (((y + 72) mod 96)-64)*(((x + 40) mod 56)-55)-(((y + 72) mod 96)-48)*(((x + 40) mod 56)-28)>=0 and (((y + 72) mod 96)-48)*(((x + 40) mod 56)-28)-(((y + 72) mod 96)-64)*(((x + 40) mod 56)-0)>=0 and (((y + 72) mod 96)-0)*(((x + 40) mod 56)-55)-(((y + 72) mod 96)-16)*(((x + 40) mod 56)-28)<=0) then-- 
				cout := 8;
				if y < 104 then
					rout := 0;
				elsif y < 200 then
					rout := 1;
				elsif y < 296 then
					rout := 2;
				elsif y < 392 then
					rout := 3;
				else
					rout := 4;
				end if;
				addr <= get_addr(cout, rout);
				vectors_y := conv_std_logic_vector((y + 72) mod 96, 6);
				vectors_x := conv_std_logic_vector((x + 40) mod 56, 6);
				--line 8: y [8, 8 + 64 * 7), x [16 + 3 * 56, 16 + 8 * 56)
			elsif (x >= 324 and x < 380 and y >= 72 and y < 424 and (((((y + 24) mod 96)-16)*(((x + 12) mod 56)-28))<=((((y + 24) mod 96)-0)*(((x + 12) mod 56)-0))) and (((y + 24) mod 96)-64)*(((x + 12) mod 56)-55)-(((y + 24) mod 96)-48)*(((x + 12) mod 56)-28)>=0 and (((y + 24) mod 96)-48)*(((x + 12) mod 56)-28)-(((y + 24) mod 96)-64)*(((x + 12) mod 56)-0)>=0 and (((y + 24) mod 96)-0)*(((x + 12) mod 56)-55)-(((y + 24) mod 96)-16)*(((x + 12) mod 56)-28)<=0) then-- 
				cout := 9;
				if y < 152 then
					rout := 0;
				elsif y < 248 then
					rout := 1;
				elsif y < 344 then
					rout := 2;
				else
					rout := 3;
				end if;
				addr <= get_addr(cout, rout);
				vectors_y := conv_std_logic_vector((y + 24) mod 96, 6);
				vectors_x := conv_std_logic_vector((x + 12) mod 56, 6);
				--line 9: y [56, 56 + 64 * 4 + 32 * 3), x [16 + 3 * 56 - 28, 16 + 8 * 56 + 28)
			elsif (x >= 352 and x < 408 and y >= 24 and y < 472 and (((((y + 72) mod 96)-16)*(((x + 40) mod 56)-28))<=((((y + 72) mod 96)-0)*(((x + 40) mod 56)-0))) and (((y + 72) mod 96)-64)*(((x + 40) mod 56)-55)-(((y + 72) mod 96)-48)*(((x + 40) mod 56)-28)>=0 and (((y + 72) mod 96)-48)*(((x + 40) mod 56)-28)-(((y + 72) mod 96)-64)*(((x + 40) mod 56)-0)>=0 and (((y + 72) mod 96)-0)*(((x + 40) mod 56)-55)-(((y + 72) mod 96)-16)*(((x + 40) mod 56)-28)<=0) then-- 
				cout := 10;
				if y < 104 then
					rout := 0;
				elsif y < 200 then
					rout := 1;
				elsif y < 296 then
					rout := 2;
				elsif y < 392 then
					rout := 3;
				else
					rout := 4;
				end if;
				addr <= get_addr(cout, rout);
				vectors_y := conv_std_logic_vector((y + 72) mod 96, 6);
				vectors_x := conv_std_logic_vector((x + 40) mod 56, 6);
				--line 10: y [8, 8 + 64 * 7), x [16 + 3 * 56, 16 + 8 * 56)
			elsif (x >= 380 and x < 436 and y >= 72 and y < 424 and (((((y + 24) mod 96)-16)*(((x + 12) mod 56)-28))<=((((y + 24) mod 96)-0)*(((x + 12) mod 56)-0))) and (((y + 24) mod 96)-64)*(((x + 12) mod 56)-55)-(((y + 24) mod 96)-48)*(((x + 12) mod 56)-28)>=0 and (((y + 24) mod 96)-48)*(((x + 12) mod 56)-28)-(((y + 24) mod 96)-64)*(((x + 12) mod 56)-0)>=0 and (((y + 24) mod 96)-0)*(((x + 12) mod 56)-55)-(((y + 24) mod 96)-16)*(((x + 12) mod 56)-28)<=0) then-- 
				cout := 11;
				if y < 152 then
					rout := 0;
				elsif y < 248 then
					rout := 1;
				elsif y < 344 then
					rout := 2;
				else
					rout := 3;
				end if;
				addr <= get_addr(cout, rout);
				vectors_y := conv_std_logic_vector((y + 24) mod 96, 6);
				vectors_x := conv_std_logic_vector((x + 12) mod 56, 6);
				--line 11: y [56, 56 + 64 * 4 + 32 * 3), x [16 + 3 * 56 - 28, 16 + 8 * 56 + 28)
			elsif (x >= 408 and x < 464 and y >= 24 and y < 472 and (((((y + 72) mod 96)-16)*(((x + 40) mod 56)-28))<=((((y + 72) mod 96)-0)*(((x + 40) mod 56)-0))) and (((y + 72) mod 96)-64)*(((x + 40) mod 56)-55)-(((y + 72) mod 96)-48)*(((x + 40) mod 56)-28)>=0 and (((y + 72) mod 96)-48)*(((x + 40) mod 56)-28)-(((y + 72) mod 96)-64)*(((x + 40) mod 56)-0)>=0 and (((y + 72) mod 96)-0)*(((x + 40) mod 56)-55)-(((y + 72) mod 96)-16)*(((x + 40) mod 56)-28)<=0) then-- 
				cout := 12;
				if y < 104 then
					rout := 0;
				elsif y < 200 then
					rout := 1;
				elsif y < 296 then
					rout := 2;
				elsif y < 392 then
					rout := 3;
				else
					rout := 4;
				end if;
				addr <= get_addr(cout, rout);
				vectors_y := conv_std_logic_vector((y + 72) mod 96, 6);
				vectors_x := conv_std_logic_vector((x + 40) mod 56, 6);
				--line 12: y [8, 8 + 64 * 7), x [16 + 3 * 56, 16 + 8 * 56)
			elsif (x >= 436 and x < 492 and y >= 72 and y < 424 and (((((y + 24) mod 96)-16)*(((x + 12) mod 56)-28))<=((((y + 24) mod 96)-0)*(((x + 12) mod 56)-0))) and (((y + 24) mod 96)-64)*(((x + 12) mod 56)-55)-(((y + 24) mod 96)-48)*(((x + 12) mod 56)-28)>=0 and (((y + 24) mod 96)-48)*(((x + 12) mod 56)-28)-(((y + 24) mod 96)-64)*(((x + 12) mod 56)-0)>=0 and (((y + 24) mod 96)-0)*(((x + 12) mod 56)-55)-(((y + 24) mod 96)-16)*(((x + 12) mod 56)-28)<=0) then-- 
				cout := 13;
				if y < 152 then
					rout := 0;
				elsif y < 248 then
					rout := 1;
				elsif y < 344 then
					rout := 2;
				else
					rout := 3;
				end if;
				addr <= get_addr(cout, rout);
				vectors_y := conv_std_logic_vector((y + 24) mod 96, 6);
				vectors_x := conv_std_logic_vector((x + 12) mod 56, 6);
				--line 13: y [56, 56 + 64 * 4 + 32 * 3), x [16 + 3 * 56 - 28, 16 + 8 * 56 + 28)
			elsif (x >= 464 and x < 520 and y >= 120 and y < 376 and (((((y + 72) mod 96)-16)*(((x + 40) mod 56)-28))<=((((y + 72) mod 96)-0)*(((x + 40) mod 56)-0))) and (((y + 72) mod 96)-64)*(((x + 40) mod 56)-55)-(((y + 72) mod 96)-48)*(((x + 40) mod 56)-28)>=0 and (((y + 72) mod 96)-48)*(((x + 40) mod 56)-28)-(((y + 72) mod 96)-64)*(((x + 40) mod 56)-0)>=0 and (((y + 72) mod 96)-0)*(((x + 40) mod 56)-55)-(((y + 72) mod 96)-16)*(((x + 40) mod 56)-28)<=0) then-- 
				cout := 14;
				if y < 200 then
					rout := 0;
				elsif y < 296 then
					rout := 1;
				else
					rout := 2;
				end if;
				addr <= get_addr(cout, rout);
				vectors_y := conv_std_logic_vector((y + 72) mod 96, 6);
				vectors_x := conv_std_logic_vector((x + 40) mod 56, 6);
				--line 14: y [8 + 96, 8 + 64 * 7 - 96), x [16 + 2 * 56, 16 + 3 * 56) || [16 + 8 * 56, 16 + 9 * 56)
			elsif (x >= 492 and x < 548 and y >= 168 and y < 328 and (((((y + 24) mod 96)-16)*(((x + 12) mod 56)-28))<=((((y + 24) mod 96)-0)*(((x + 12) mod 56)-0))) and (((y + 24) mod 96)-64)*(((x + 12) mod 56)-55)-(((y + 24) mod 96)-48)*(((x + 12) mod 56)-28)>=0 and (((y + 24) mod 96)-48)*(((x + 12) mod 56)-28)-(((y + 24) mod 96)-64)*(((x + 12) mod 56)-0)>=0 and (((y + 24) mod 96)-0)*(((x + 12) mod 56)-55)-(((y + 24) mod 96)-16)*(((x + 12) mod 56)-28)<=0) then-- 
				cout := 15;
				if y < 248 then
					rout := 0;
				else
					rout := 1;
				end if;
				addr <= get_addr(cout, rout);
				vectors_y := conv_std_logic_vector((y + 24) mod 96, 6);
				vectors_x := conv_std_logic_vector((x + 12) mod 56, 6);
				--line 15: y [56 + 96, 56 + 64 * 4 + 32 * 3 - 96), x [16 + 2 * 56 - 28, 16 + 3 * 56 - 28) || [16 + 8 * 56 + 28, 16 + 9 * 56 + 28)
			elsif (x >= 520 and x < 576 and y >= 216 and y < 280 and (((((y + 72) mod 96)-16)*(((x + 40) mod 56)-28))<=((((y + 72) mod 96)-0)*(((x + 40) mod 56)-0))) and (((y + 72) mod 96)-64)*(((x + 40) mod 56)-55)-(((y + 72) mod 96)-48)*(((x + 40) mod 56)-28)>=0 and (((y + 72) mod 96)-48)*(((x + 40) mod 56)-28)-(((y + 72) mod 96)-64)*(((x + 40) mod 56)-0)>=0 and (((y + 72) mod 96)-0)*(((x + 40) mod 56)-55)-(((y + 72) mod 96)-16)*(((x + 40) mod 56)-28)<=0) then-- 
				cout := 16;
				rout := 0;
				addr <= get_addr(cout, rout);
				vectors_y := conv_std_logic_vector((y + 72) mod 96, 6);
				vectors_x := conv_std_logic_vector((x + 40) mod 56, 6);
				--line 16: y [8 + 96 * 2, 8 + 64 * 7 - 96 * 2), x [16 + 1 * 56, 16 + 2 * 56) || [16 + 9 * 56, 16 + 10 * 56)
			elsif (x >= 502 and x < 566 and y >= 16 and y < 80) then
				cout := 17;
				vectors_y := conv_std_logic_vector(y - 16, 6);
				vectors_x := conv_std_logic_vector(x - 502, 6);
			elsif (x >= 566 and x < 598 and y >= 16 and y < 80) then
				if remain < 0 then
					tens := 10;
				else
					tens := remain / 10;
				end if;
				cout := 18;
				vectors_y := conv_std_logic_vector(y - 16, 6);
				vectors_x := conv_std_logic_vector(x - 566, 6);
			elsif (x >= 598 and x < 630 and y >= 16 and y < 80) then
				if remain < 0 then
					ones := 0;
				else
					ones := remain mod 10;
				end if;
				cout := 19;
				vectors_y := conv_std_logic_vector(y - 16, 6);
				vectors_x := conv_std_logic_vector(x - 598, 6);
			elsif (x < 640 and y < 480) then
				cout := 20;
			else -- 消隐区必须明确输出置0
				cout := 21;
			end if;
			if cout = 20 then
				r1 <= "111";
				g1	<= "111";
				b1	<= "111";
			elsif cout = 21 then
				r1 <= "000";
				g1	<= "000";
				b1	<= "000";
			elsif cout = 17 then
				prefix := "1001";
				addresshex <= prefix & vectors_y(5 downto 0) & vectors_x(5 downto 0);--64 * 64
				r1 <= qhex(8 downto 6);
				g1 <= qhex(5 downto 3);
				b1 <= qhex(2 downto 0);
			elsif cout = 18 then
				prefix := conv_std_logic_vector(4 + tens, 4); -- 4 is 0100
				addresshex <= "1" & prefix & vectors_y(5 downto 0) & vectors_x(4 downto 0);--32 * 64
				r1 <= qhex(8 downto 6);
				g1 <= qhex(5 downto 3);
				b1 <= qhex(2 downto 0);
--				r1 <= "000";
--				g1	<= "011";
--				b1	<= "111";
			elsif cout = 19 then
				prefix := conv_std_logic_vector(4 + ones, 4); -- 4 is 0100
				addresshex <= "1" & prefix & vectors_y(5 downto 0) & vectors_x(4 downto 0);--32 * 64
				r1 <= qhex(8 downto 6);
				g1 <= qhex(5 downto 3);
				b1 <= qhex(2 downto 0);
--				r1 <= "011";
--				g1	<= "000";
--				b1	<= "111";
			else
				if data <= 6 then
					prefix := data + 1;
				elsif data = "0111" then
					prefix := "1001";
				elsif data = "1000" then
					prefix := "1000";
				else
					prefix := "0000";
				end if;
				addresshex <= prefix & vectors_y(5 downto 0) & vectors_x(5 downto 0);--64 * 64
				if (mouse_r = rout and mouse_c = cout) then
					r1 <= qhex(8 downto 6) + 2;
					g1 <= qhex(5 downto 3) + 2;
					b1 <= qhex(2 downto 0) + 2;
				else
					r1 <= qhex(8 downto 6);
					g1 <= qhex(5 downto 3);
					b1 <= qhex(2 downto 0);
				end if;
			end if;
			if win = '1' and x >= 288 and x < 352 and y >= 208 and y < 272 then
				vectors_y := conv_std_logic_vector(y - 208, 6);
				vectors_x := conv_std_logic_vector(x - 288, 6);
				addresswl <= "0" & vectors_y(5 downto 0) & vectors_x(5 downto 0);--64 * 64
				r1 <= qwl(8 downto 6);
				g1 <= qwl(5 downto 3);
				b1 <= qwl(2 downto 0);
			elsif lose = '1' and x >= 288 and x < 352 and y >= 208 and y < 272 then
				vectors_y := conv_std_logic_vector(y - 208, 6);
				vectors_x := conv_std_logic_vector(x - 288, 6);
				addresswl <= "1" & vectors_y(5 downto 0) & vectors_x(5 downto 0);--64 * 64
				r1 <= qwl(8 downto 6);
				g1 <= qwl(5 downto 3);
				b1 <= qwl(2 downto 0);
			end if;
			if (vector_x + 1 >= mouse_x and vector_x <= mouse_x + 1 and vector_y + 4 >= mouse_y and vector_y <= mouse_y + 4) or (vector_y  + 1 >= mouse_y and vector_y <= mouse_y + 1 and vector_x + 4 >= mouse_x and vector_x <= mouse_x + 4) then
				r1 <= "000";
				g1 <= "111";
				b1 <= "000";
			end if;
--		  end if;
		end if;	 
	    end process;	

	-----------------------------------------------------------------------
	process (hs1, vs1, r1, g1, b1)	--色彩输出
	begin
		if hs1 = '1' and vs1 = '1' then
			r	<= r1;
			g	<= g1;
			b	<= b1;
		else
			r	<= (others => '0');
			g	<= (others => '0');
			b	<= (others => '0');
		end if;
	end process;

end behavior;