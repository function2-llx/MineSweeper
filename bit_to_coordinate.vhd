---------------------------------------------------------------------------------------------
--创建日期   : 2019-06-01
--目标芯片   : EP2C70F672C8N
--时钟选择   : 无
--演示说明   : 无
--主要信号说明: x, y: 鼠标所在的像素位置
--            cout, rout: 鼠标所处的格子编号
--主要进程说明: 基于vga640480.vhd代码改写，专门用于判断鼠标所处的格子编号
---------------------------------------------------------------------------------------------
library	ieee;
use		ieee.std_logic_1164.all;
use		ieee.std_logic_unsigned.all;
use		ieee.std_logic_arith.all;

entity bit_to_coordinate is
	port(
		x, y: in integer range 0 to 1600;
		cout: out integer range 0 to 17;--17 means illegal column
		rout: out integer range 0 to 5  --5 means illegal row
	);
end bit_to_coordinate;

architecture bhv of bit_to_coordinate is
	
begin
	process(x, y)
	begin
		if (x >= 72 and x < 128 and y >= 216 and y < 280 and (((((y + 72) mod 96)-16)*(((x + 40) mod 56)-28))<=((((y + 72) mod 96)-0)*(((x + 40) mod 56)-0))) and (((y + 72) mod 96)-64)*(((x + 40) mod 56)-55)-(((y + 72) mod 96)-48)*(((x + 40) mod 56)-28)>=0 and (((y + 72) mod 96)-48)*(((x + 40) mod 56)-28)-(((y + 72) mod 96)-64)*(((x + 40) mod 56)-0)>=0 and (((y + 72) mod 96)-0)*(((x + 40) mod 56)-55)-(((y + 72) mod 96)-16)*(((x + 40) mod 56)-28)<=0) then
			--Line 0
			cout <= 0;
			rout <= 0;
		elsif (x >= 100 and x < 156 and y >= 168 and y < 328 and (((((y + 24) mod 96)-16)*(((x + 12) mod 56)-28))<=((((y + 24) mod 96)-0)*(((x + 12) mod 56)-0))) and (((y + 24) mod 96)-64)*(((x + 12) mod 56)-55)-(((y + 24) mod 96)-48)*(((x + 12) mod 56)-28)>=0 and (((y + 24) mod 96)-48)*(((x + 12) mod 56)-28)-(((y + 24) mod 96)-64)*(((x + 12) mod 56)-0)>=0 and (((y + 24) mod 96)-0)*(((x + 12) mod 56)-55)-(((y + 24) mod 96)-16)*(((x + 12) mod 56)-28)<=0) then
			--Line 1
			cout <= 1;
			if y < 248 then
				rout <= 0;
			else
				rout <= 1;
			end if;
		elsif (x >= 128 and x < 184 and y >= 120 and y < 376 and (((((y + 72) mod 96)-16)*(((x + 40) mod 56)-28))<=((((y + 72) mod 96)-0)*(((x + 40) mod 56)-0))) and (((y + 72) mod 96)-64)*(((x + 40) mod 56)-55)-(((y + 72) mod 96)-48)*(((x + 40) mod 56)-28)>=0 and (((y + 72) mod 96)-48)*(((x + 40) mod 56)-28)-(((y + 72) mod 96)-64)*(((x + 40) mod 56)-0)>=0 and (((y + 72) mod 96)-0)*(((x + 40) mod 56)-55)-(((y + 72) mod 96)-16)*(((x + 40) mod 56)-28)<=0) then
			--line 2
			cout <= 2;
			if y < 200 then
				rout <= 0;
			elsif y < 296 then
				rout <= 1;
			else
				rout <= 2;
			end if;
		elsif (x >= 156 and x < 212 and y >= 72 and y < 424 and (((((y + 24) mod 96)-16)*(((x + 12) mod 56)-28))<=((((y + 24) mod 96)-0)*(((x + 12) mod 56)-0))) and (((y + 24) mod 96)-64)*(((x + 12) mod 56)-55)-(((y + 24) mod 96)-48)*(((x + 12) mod 56)-28)>=0 and (((y + 24) mod 96)-48)*(((x + 12) mod 56)-28)-(((y + 24) mod 96)-64)*(((x + 12) mod 56)-0)>=0 and (((y + 24) mod 96)-0)*(((x + 12) mod 56)-55)-(((y + 24) mod 96)-16)*(((x + 12) mod 56)-28)<=0) then
			--line 3
			cout <= 3;
			if y < 152 then
				rout <= 0;
			elsif y < 248 then
				rout <= 1;
			elsif y < 344 then
				rout <= 2;
			else
				rout <= 3;
			end if;
		elsif (x >= 184 and x < 240 and y >= 24 and y < 472 and (((((y + 72) mod 96)-16)*(((x + 40) mod 56)-28))<=((((y + 72) mod 96)-0)*(((x + 40) mod 56)-0))) and (((y + 72) mod 96)-64)*(((x + 40) mod 56)-55)-(((y + 72) mod 96)-48)*(((x + 40) mod 56)-28)>=0 and (((y + 72) mod 96)-48)*(((x + 40) mod 56)-28)-(((y + 72) mod 96)-64)*(((x + 40) mod 56)-0)>=0 and (((y + 72) mod 96)-0)*(((x + 40) mod 56)-55)-(((y + 72) mod 96)-16)*(((x + 40) mod 56)-28)<=0) then
			--line 4
			cout <= 4;
			if y < 104 then
				rout <= 0;
			elsif y < 200 then
				rout <= 1;
			elsif y < 296 then
				rout <= 2;
			elsif y < 392 then
				rout <= 3;
			else
				rout <= 4;
			end if;
		elsif (x >= 212 and x < 268 and y >= 72 and y < 424 and (((((y + 24) mod 96)-16)*(((x + 12) mod 56)-28))<=((((y + 24) mod 96)-0)*(((x + 12) mod 56)-0))) and (((y + 24) mod 96)-64)*(((x + 12) mod 56)-55)-(((y + 24) mod 96)-48)*(((x + 12) mod 56)-28)>=0 and (((y + 24) mod 96)-48)*(((x + 12) mod 56)-28)-(((y + 24) mod 96)-64)*(((x + 12) mod 56)-0)>=0 and (((y + 24) mod 96)-0)*(((x + 12) mod 56)-55)-(((y + 24) mod 96)-16)*(((x + 12) mod 56)-28)<=0) then
			--line 5
			cout <= 5;
			if y < 152 then
				rout <= 0;
			elsif y < 248 then
				rout <= 1;
			elsif y < 344 then
				rout <= 2;
			else
				rout <= 3;
			end if;
		elsif (x >= 240 and x < 296 and y >= 24 and y < 472 and (((((y + 72) mod 96)-16)*(((x + 40) mod 56)-28))<=((((y + 72) mod 96)-0)*(((x + 40) mod 56)-0))) and (((y + 72) mod 96)-64)*(((x + 40) mod 56)-55)-(((y + 72) mod 96)-48)*(((x + 40) mod 56)-28)>=0 and (((y + 72) mod 96)-48)*(((x + 40) mod 56)-28)-(((y + 72) mod 96)-64)*(((x + 40) mod 56)-0)>=0 and (((y + 72) mod 96)-0)*(((x + 40) mod 56)-55)-(((y + 72) mod 96)-16)*(((x + 40) mod 56)-28)<=0) then
			--line 6
			cout <= 6;
			if y < 104 then
				rout <= 0;
			elsif y < 200 then
				rout <= 1;
			elsif y < 296 then
				rout <= 2;
			elsif y < 392 then
				rout <= 3;
			else
				rout <= 4;
			end if;
		elsif (x >= 268 and x < 324 and y >= 72 and y < 424 and (((((y + 24) mod 96)-16)*(((x + 12) mod 56)-28))<=((((y + 24) mod 96)-0)*(((x + 12) mod 56)-0))) and (((y + 24) mod 96)-64)*(((x + 12) mod 56)-55)-(((y + 24) mod 96)-48)*(((x + 12) mod 56)-28)>=0 and (((y + 24) mod 96)-48)*(((x + 12) mod 56)-28)-(((y + 24) mod 96)-64)*(((x + 12) mod 56)-0)>=0 and (((y + 24) mod 96)-0)*(((x + 12) mod 56)-55)-(((y + 24) mod 96)-16)*(((x + 12) mod 56)-28)<=0) then
			--line 7
			cout <= 7;
			if y < 152 then
				rout <= 0;
			elsif y < 248 then
				rout <= 1;
			elsif y < 344 then
				rout <= 2;
			else
				rout <= 3;
			end if;
		elsif (x >= 296 and x < 352 and y >= 24 and y < 472 and (((((y + 72) mod 96)-16)*(((x + 40) mod 56)-28))<=((((y + 72) mod 96)-0)*(((x + 40) mod 56)-0))) and (((y + 72) mod 96)-64)*(((x + 40) mod 56)-55)-(((y + 72) mod 96)-48)*(((x + 40) mod 56)-28)>=0 and (((y + 72) mod 96)-48)*(((x + 40) mod 56)-28)-(((y + 72) mod 96)-64)*(((x + 40) mod 56)-0)>=0 and (((y + 72) mod 96)-0)*(((x + 40) mod 56)-55)-(((y + 72) mod 96)-16)*(((x + 40) mod 56)-28)<=0) then
			--line 8
			cout <= 8;
			if y < 104 then
				rout <= 0;
			elsif y < 200 then
				rout <= 1;
			elsif y < 296 then
				rout <= 2;
			elsif y < 392 then
				rout <= 3;
			else
				rout <= 4;
			end if;
		elsif (x >= 324 and x < 380 and y >= 72 and y < 424 and (((((y + 24) mod 96)-16)*(((x + 12) mod 56)-28))<=((((y + 24) mod 96)-0)*(((x + 12) mod 56)-0))) and (((y + 24) mod 96)-64)*(((x + 12) mod 56)-55)-(((y + 24) mod 96)-48)*(((x + 12) mod 56)-28)>=0 and (((y + 24) mod 96)-48)*(((x + 12) mod 56)-28)-(((y + 24) mod 96)-64)*(((x + 12) mod 56)-0)>=0 and (((y + 24) mod 96)-0)*(((x + 12) mod 56)-55)-(((y + 24) mod 96)-16)*(((x + 12) mod 56)-28)<=0) then
			--line 9
			cout <= 9;
			if y < 152 then
				rout <= 0;
			elsif y < 248 then
				rout <= 1;
			elsif y < 344 then
				rout <= 2;
			else
				rout <= 3;
			end if;
		elsif (x >= 352 and x < 408 and y >= 24 and y < 472 and (((((y + 72) mod 96)-16)*(((x + 40) mod 56)-28))<=((((y + 72) mod 96)-0)*(((x + 40) mod 56)-0))) and (((y + 72) mod 96)-64)*(((x + 40) mod 56)-55)-(((y + 72) mod 96)-48)*(((x + 40) mod 56)-28)>=0 and (((y + 72) mod 96)-48)*(((x + 40) mod 56)-28)-(((y + 72) mod 96)-64)*(((x + 40) mod 56)-0)>=0 and (((y + 72) mod 96)-0)*(((x + 40) mod 56)-55)-(((y + 72) mod 96)-16)*(((x + 40) mod 56)-28)<=0) then
			--line 10
			cout <= 10;
			if y < 104 then
				rout <= 0;
			elsif y < 200 then
				rout <= 1;
			elsif y < 296 then
				rout <= 2;
			elsif y < 392 then
				rout <= 3;
			else
				rout <= 4;
			end if;
		elsif (x >= 380 and x < 436 and y >= 72 and y < 424 and (((((y + 24) mod 96)-16)*(((x + 12) mod 56)-28))<=((((y + 24) mod 96)-0)*(((x + 12) mod 56)-0))) and (((y + 24) mod 96)-64)*(((x + 12) mod 56)-55)-(((y + 24) mod 96)-48)*(((x + 12) mod 56)-28)>=0 and (((y + 24) mod 96)-48)*(((x + 12) mod 56)-28)-(((y + 24) mod 96)-64)*(((x + 12) mod 56)-0)>=0 and (((y + 24) mod 96)-0)*(((x + 12) mod 56)-55)-(((y + 24) mod 96)-16)*(((x + 12) mod 56)-28)<=0) then
			--line 11
			cout <= 11;
			if y < 152 then
				rout <= 0;
			elsif y < 248 then
				rout <= 1;
			elsif y < 344 then
				rout <= 2;
			else
				rout <= 3;
			end if;
		elsif (x >= 408 and x < 464 and y >= 24 and y < 472 and (((((y + 72) mod 96)-16)*(((x + 40) mod 56)-28))<=((((y + 72) mod 96)-0)*(((x + 40) mod 56)-0))) and (((y + 72) mod 96)-64)*(((x + 40) mod 56)-55)-(((y + 72) mod 96)-48)*(((x + 40) mod 56)-28)>=0 and (((y + 72) mod 96)-48)*(((x + 40) mod 56)-28)-(((y + 72) mod 96)-64)*(((x + 40) mod 56)-0)>=0 and (((y + 72) mod 96)-0)*(((x + 40) mod 56)-55)-(((y + 72) mod 96)-16)*(((x + 40) mod 56)-28)<=0) then
			--line 12
			cout <= 12;
			if y < 104 then
				rout <= 0;
			elsif y < 200 then
				rout <= 1;
			elsif y < 296 then
				rout <= 2;
			elsif y < 392 then
				rout <= 3;
			else
				rout <= 4;
			end if;
		elsif (x >= 436 and x < 492 and y >= 72 and y < 424 and (((((y + 24) mod 96)-16)*(((x + 12) mod 56)-28))<=((((y + 24) mod 96)-0)*(((x + 12) mod 56)-0))) and (((y + 24) mod 96)-64)*(((x + 12) mod 56)-55)-(((y + 24) mod 96)-48)*(((x + 12) mod 56)-28)>=0 and (((y + 24) mod 96)-48)*(((x + 12) mod 56)-28)-(((y + 24) mod 96)-64)*(((x + 12) mod 56)-0)>=0 and (((y + 24) mod 96)-0)*(((x + 12) mod 56)-55)-(((y + 24) mod 96)-16)*(((x + 12) mod 56)-28)<=0) then
			--line 13
			cout <= 13;
			if y < 152 then
				rout <= 0;
			elsif y < 248 then
				rout <= 1;
			elsif y < 344 then
				rout <= 2;
			else
				rout <= 3;
			end if;
		elsif (x >= 464 and x < 520 and y >= 120 and y < 376 and (((((y + 72) mod 96)-16)*(((x + 40) mod 56)-28))<=((((y + 72) mod 96)-0)*(((x + 40) mod 56)-0))) and (((y + 72) mod 96)-64)*(((x + 40) mod 56)-55)-(((y + 72) mod 96)-48)*(((x + 40) mod 56)-28)>=0 and (((y + 72) mod 96)-48)*(((x + 40) mod 56)-28)-(((y + 72) mod 96)-64)*(((x + 40) mod 56)-0)>=0 and (((y + 72) mod 96)-0)*(((x + 40) mod 56)-55)-(((y + 72) mod 96)-16)*(((x + 40) mod 56)-28)<=0) then
			--line 14
			cout <= 14;
			if y < 200 then
				rout <= 0;
			elsif y < 296 then
				rout <= 1;
			else
				rout <= 2;
			end if;
		elsif (x >= 492 and x < 548 and y >= 168 and y < 328 and (((((y + 24) mod 96)-16)*(((x + 12) mod 56)-28))<=((((y + 24) mod 96)-0)*(((x + 12) mod 56)-0))) and (((y + 24) mod 96)-64)*(((x + 12) mod 56)-55)-(((y + 24) mod 96)-48)*(((x + 12) mod 56)-28)>=0 and (((y + 24) mod 96)-48)*(((x + 12) mod 56)-28)-(((y + 24) mod 96)-64)*(((x + 12) mod 56)-0)>=0 and (((y + 24) mod 96)-0)*(((x + 12) mod 56)-55)-(((y + 24) mod 96)-16)*(((x + 12) mod 56)-28)<=0) then
			--Line 15
			cout <= 15;
			if y < 248 then
				rout <= 0;
			else
				rout <= 1;
			end if;
		elsif (x >= 520 and x < 576 and y >= 216 and y < 280 and (((((y + 72) mod 96)-16)*(((x + 40) mod 56)-28))<=((((y + 72) mod 96)-0)*(((x + 40) mod 56)-0))) and (((y + 72) mod 96)-64)*(((x + 40) mod 56)-55)-(((y + 72) mod 96)-48)*(((x + 40) mod 56)-28)>=0 and (((y + 72) mod 96)-48)*(((x + 40) mod 56)-28)-(((y + 72) mod 96)-64)*(((x + 40) mod 56)-0)>=0 and (((y + 72) mod 96)-0)*(((x + 40) mod 56)-55)-(((y + 72) mod 96)-16)*(((x + 40) mod 56)-28)<=0) then
			--Line 16
			cout <= 16;
			rout <= 0;
		else 
			cout <= 17;
			rout <= 5;
		end if;
	end process;
end bhv;