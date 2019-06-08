library	ieee;
use		ieee.std_logic_1164.all;
use		ieee.std_logic_unsigned.all;
use		ieee.std_logic_arith.all;

entity vga640480 is
	 port(
			address		:		  out	STD_LOGIC_VECTOR(13 DOWNTO 0);
			reset       :       in  STD_LOGIC;
			clk25       :		  out std_logic; --25MHz
			q		      :		  in STD_LOGIC_vector(2 downto 0);--内存返回的数值
			clicker     :       in std_logic;--新增测试按键
			clk_0       :       in  STD_LOGIC; --100M时钟输入
			hs,vs       :       out STD_LOGIC; --行同步、场同步信号
			r,g,b       :       out STD_LOGIC_vector(2 downto 0)
	  );
end vga640480;

architecture behavior of vga640480 is
	
	signal r1,g1,b1   : std_logic_vector(2 downto 0);					
	signal hs1,vs1    : std_logic;				
	signal vector_x   : std_logic_vector(9 downto 0);		--X坐标
	signal vector_y   : std_logic_vector(8 downto 0);		--Y坐标
	signal clk, CLK_2	: std_logic;
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
	process(reset,clk,vector_x,vector_y,clicker) -- XY坐标定位控制
		variable x: integer;
		variable y: integer;
		variable vectors_x: std_logic_vector(5 downto 0);
		variable vectors_y: std_logic_vector(5 downto 0);
	begin  
		if reset='0' then
			      r1 <= "000";
					g1	<= "000";
					b1	<= "000";	
		elsif(clk'event and clk='1')then
		  if clicker='0' then
			if (vector_x(9 downto 6) = "0010" and vector_y(8 downto 6) = "010") or (vector_x(9 downto 6) = "0100" and vector_y(8 downto 6) = "010") then
				address <= "00" & vector_y(5 downto 0) & vector_x(5 downto 0);--64 * 64
				if q(2) = '1' then
					r1 <= "111";				  	
				else
					r1 <= "000";
				end if;
				if q(1) = '1' then
					g1 <= "111";				  	
				else
					g1 <= "000";
				end if;
				if q(0) = '1' then
					b1	<= "111";		  	
				else
					b1	<= "000";
				end if;
			else 
					r1 <= "000";
					g1	<= "000";
					b1	<= "000";
			end if;
		  else
			x := conv_integer(vector_x);
			y := conv_integer(vector_y);
			--y += 16
			if (x >= 184 and x < 464 and y >= 24 and y < 472 and (((((y + 72) mod 96)-16)*(((x + 40) mod 56)-28))<=((((y + 72) mod 96)-0)*(((x + 40) mod 56)-0))) and (((y + 72) mod 96)-64)*(((x + 40) mod 56)-55)-(((y + 72) mod 96)-48)*(((x + 40) mod 56)-28)>=0 and (((y + 72) mod 96)-48)*(((x + 40) mod 56)-28)-(((y + 72) mod 96)-64)*(((x + 40) mod 56)-0)>=0 and (((y + 72) mod 96)-0)*(((x + 40) mod 56)-55)-(((y + 72) mod 96)-16)*(((x + 40) mod 56)-28)<=0) then-- 
				vectors_y := conv_std_logic_vector((y + 72) mod 96, 6);
				vectors_x := conv_std_logic_vector((x + 40) mod 56, 6);
				--line 4, 6, 8, 10, 12: y [8, 8 + 64 * 7), x [16 + 3 * 56, 16 + 8 * 56)
				address <= "00" & vectors_y(5 downto 0) & vectors_x(5 downto 0);--64 * 64
				if q(2) = '1' then
					r1 <= "111";				  	
				else
					r1 <= "000";
				end if;
				if q(1) = '1' then
					g1 <= "111";
				else
					g1 <= "000";
				end if;
				if q(0) = '1' then
					b1	<= "111";		  	
				else
					b1	<= "000";
				end if;
			elsif (((x >= 128 and x < 184) or (x >= 464 and x < 520)) and y >= 120 and y < 376 and (((((y + 72) mod 96)-16)*(((x + 40) mod 56)-28))<=((((y + 72) mod 96)-0)*(((x + 40) mod 56)-0))) and (((y + 72) mod 96)-64)*(((x + 40) mod 56)-55)-(((y + 72) mod 96)-48)*(((x + 40) mod 56)-28)>=0 and (((y + 72) mod 96)-48)*(((x + 40) mod 56)-28)-(((y + 72) mod 96)-64)*(((x + 40) mod 56)-0)>=0 and (((y + 72) mod 96)-0)*(((x + 40) mod 56)-55)-(((y + 72) mod 96)-16)*(((x + 40) mod 56)-28)<=0) then-- 
				vectors_y := conv_std_logic_vector((y + 72) mod 96, 6);
				vectors_x := conv_std_logic_vector((x + 40) mod 56, 6);
				--line 2, 14: y [8 + 96, 8 + 64 * 7 - 96), x [16 + 2 * 56, 16 + 3 * 56) || [16 + 8 * 56, 16 + 9 * 56)
				address <= "00" & vectors_y(5 downto 0) & vectors_x(5 downto 0);--64 * 64
				if q(2) = '1' then
					r1 <= "111";				  	
				else
					r1 <= "000";
				end if;
				if q(1) = '1' then
					g1 <= "111";				  	
				else
					g1 <= "000";
				end if;
				if q(0) = '1' then
					b1	<= "111";		  	
				else
					b1	<= "000";
				end if;
			elsif (((x >= 72 and x < 128) or (x >= 520 and x < 576)) and y >= 216 and y < 280 and (((((y + 72) mod 96)-16)*(((x + 40) mod 56)-28))<=((((y + 72) mod 96)-0)*(((x + 40) mod 56)-0))) and (((y + 72) mod 96)-64)*(((x + 40) mod 56)-55)-(((y + 72) mod 96)-48)*(((x + 40) mod 56)-28)>=0 and (((y + 72) mod 96)-48)*(((x + 40) mod 56)-28)-(((y + 72) mod 96)-64)*(((x + 40) mod 56)-0)>=0 and (((y + 72) mod 96)-0)*(((x + 40) mod 56)-55)-(((y + 72) mod 96)-16)*(((x + 40) mod 56)-28)<=0) then-- 
				vectors_y := conv_std_logic_vector((y + 72) mod 96, 6);
				vectors_x := conv_std_logic_vector((x + 40) mod 56, 6);
				--line 0, 16: y [8 + 96 * 2, 8 + 64 * 7 - 96 * 2), x [16 + 1 * 56, 16 + 2 * 56) || [16 + 9 * 56, 16 + 10 * 56)
				address <= "00" & vectors_y(5 downto 0) & vectors_x(5 downto 0);--64 * 64
				if q(2) = '1' then
					r1 <= "111";				  	
				else
					r1 <= "000";
				end if;
				if q(1) = '1' then
					g1 <= "111";				  	
				else
					g1 <= "000";
				end if;
				if q(0) = '1' then
					b1	<= "111";		  	
				else
					b1	<= "000";
				end if;
			elsif (x >= 156 and x < 492 and y >= 72 and y < 424 and (((((y + 24) mod 96)-16)*(((x + 12) mod 56)-28))<=((((y + 24) mod 96)-0)*(((x + 12) mod 56)-0))) and (((y + 24) mod 96)-64)*(((x + 12) mod 56)-55)-(((y + 24) mod 96)-48)*(((x + 12) mod 56)-28)>=0 and (((y + 24) mod 96)-48)*(((x + 12) mod 56)-28)-(((y + 24) mod 96)-64)*(((x + 12) mod 56)-0)>=0 and (((y + 24) mod 96)-0)*(((x + 12) mod 56)-55)-(((y + 24) mod 96)-16)*(((x + 12) mod 56)-28)<=0) then-- 
				vectors_y := conv_std_logic_vector((y + 24) mod 96, 6);
				vectors_x := conv_std_logic_vector((x + 12) mod 56, 6);
				--line 3, 5, 7, 9, 11, 13: y [56, 56 + 64 * 4 + 32 * 3), x [16 + 3 * 56 - 28, 16 + 8 * 56 + 28)
				address <= "00" & vectors_y(5 downto 0) & vectors_x(5 downto 0);--64 * 64
				if q(2) = '1' then
					r1 <= "111";				  	
				else
					r1 <= "000";
				end if;
				if q(1) = '1' then
					g1 <= "111";				  	
				else
					g1 <= "000";
				end if;
				if q(0) = '1' then
					b1	<= "111";		  	
				else
					b1	<= "000";
				end if;
			elsif (((x >= 100 and x < 156) or (x >= 492 and x < 548)) and y >= 168 and y < 328 and (((((y + 24) mod 96)-16)*(((x + 12) mod 56)-28))<=((((y + 24) mod 96)-0)*(((x + 12) mod 56)-0))) and (((y + 24) mod 96)-64)*(((x + 12) mod 56)-55)-(((y + 24) mod 96)-48)*(((x + 12) mod 56)-28)>=0 and (((y + 24) mod 96)-48)*(((x + 12) mod 56)-28)-(((y + 24) mod 96)-64)*(((x + 12) mod 56)-0)>=0 and (((y + 24) mod 96)-0)*(((x + 12) mod 56)-55)-(((y + 24) mod 96)-16)*(((x + 12) mod 56)-28)<=0) then-- 
				vectors_y := conv_std_logic_vector((y + 24) mod 96, 6);
				vectors_x := conv_std_logic_vector((x + 12) mod 56, 6);
				--line 1, 15: y [56 + 96, 56 + 64 * 4 + 32 * 3 - 96), x [16 + 2 * 56 - 28, 16 + 3 * 56 - 28) || [16 + 8 * 56 + 28, 16 + 9 * 56 + 28)
				address <= "00" & vectors_y(5 downto 0) & vectors_x(5 downto 0);--64 * 64
				if q(2) = '1' then
					r1 <= "111";				  	
				else
					r1 <= "000";
				end if;
				if q(1) = '1' then
					g1 <= "111";				  	
				else
					g1 <= "000";
				end if;
				if q(0) = '1' then
					b1	<= "111";		  	
				else
					b1	<= "000";
				end if;
--			elsif (y >= 128 and y < 185 and (((x-144)*(y-156))<=((x-128)*(y-128))) and (x-192)*(y-184)-(x-176)*(y-156)>=0 and (x-176)*(y-156)-(x-192)*(y-128)>=0 and (x-128)*(y-184)-(x-144)*(y-156)<=0) then-- 
--				address <= "00" & vector_y(5 downto 0) & vector_x(5 downto 0);--64 * 64
--				if q(2) = '1' then
--					r1 <= "111";				  	
--				else
--					r1 <= "000";
--				end if;
--				if q(1) = '1' then
--					g1 <= "111";				  	
--				else
--					g1 <= "000";
--				end if;
--				if q(0) = '1' then
--					b1	<= "111";		  	
--				else
--					b1	<= "000";
--				end if;
			else 
					r1 <= "000";
					g1	<= "000";
					b1	<= "000";
			end if;
		  end if;
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