LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;

entity SRAM is 
port(
--- reset & clk 
	clk      : in std_logic;
	reset    : in std_logic;

	button	: in std_logic;	--0x0 0x1
	button3	: in std_logic;  --write sram
	button4	: in std_logic;	-- read sram
	LEDBUS	: out std_logic_vector(31 downto 0);-- 32 LED
--- memory 	to CFPGA
	BASERAMWE           : out std_logic;   --write                    
	BASERAMOE           : out std_logic;    --read                   
	BASERAMCE           : out std_logic;		--cs
	BASERAMADDR         : out std_logic_vector(19 downto 0);                                                              
	BASERAMDATA         : inout std_logic_vector(31 downto 0)
);
end SRAM;

architecture logic_memy of SRAM is 

type memory_state is  (idle,mem_read,mem_write,mem_end);
signal state : memory_state;
signal addrS: std_logic_vector(19 downto 0);
signal addrD: std_logic_vector(19 downto 0):="00000000000000001000";
signal Data	: std_logic_vector(31 downto 0);
signal CLK50M	: std_logic;
signal CLK25M : std_logic;	
begin

process(clk,reset)
begin
	if clk'event and clk='1' then
		clk50M<=not clk50M;
		end if;
end process;

process(clk50M,reset)
begin
	if clk50M'event and clk50M='1' then
		clk25M<=not clk25M;
		end if;
end process;


process(reset,clk25M,clk,clk50M,addrD,addrS,BASERAMDATA,Data)
begin 
	if reset='0' then 
		state<=idle;
		addrS<="00000000000000000000";
		addrD<="00000000000000001000";
		--BASERAMADDR<=(others=>'Z');                                                                    
		--BASERAMDATA<=(others=>'Z'); 		
	elsif clk50M'event and clk50M='1' then 
		case state is 
			when idle      =>
										state<=mem_read;
			when mem_read  => 
										state<=mem_write;
			when mem_write => 
										state<=mem_end;
			when mem_end   =>
										if (addrS="00000000000000000111") then
												state<=mem_end;
										else
												addrS<=addrS + 1;
												addrD<=addrD + 1;
										end if;
												state<=idle;
			when others    => state<=idle;
		end case ;
	end if ;
end process;

process(reset,clk50M,clk25M,clk)
begin 
	if reset='0' then 
		BASERAMCE<='1';                                 
		BASERAMOE<='1';  
		BASERAMWE<='1';								
	elsif clk'event and clk='1' then 
		case state is 
			when idle      => 
									BASERAMCE<='1';                                 
		                     BASERAMOE<='1';  
		                     BASERAMWE<='1';		
									BASERAMADDR<=addrS;
									--BASERAMDATA<=(others=>'Z');							
		                     --BASERAMADDR<=(others=>'Z');												  
			when mem_read  => 
									BASERAMCE<='0';                                 
		                     BASERAMOE<='0';  
		                     BASERAMWE<='1';
									Data<=BASERAMDATA;
		   when mem_write => 
									BASERAMCE<='0';                                 
		                     BASERAMOE<='1';  
		                     BASERAMWE<='0';
									BASERAMADDR<=addrD;
									BASERAMDATA<=Data;
			when mem_end   => 
									BASERAMCE<='1';                                 
		                     BASERAMOE<='1';  
		                     BASERAMWE<='1';								
		                     BASERAMADDR<=(others=>'Z');                                                                    
		                     BASERAMDATA<=(others=>'Z');					
			when others    => 
									BASERAMCE<='1';                                 
		                     BASERAMOE<='1';  
		                     BASERAMWE<='1';								
		                     BASERAMADDR<=(others=>'Z');                                                                    
		                     BASERAMDATA<=(others=>'Z');
									
		end case ;
	end if ;
end process;

process(reset)
begin
		if reset = '0' then
		LEDBUS<=x"FFFF0000";
		else
		LEDBUS<=Data;
		end if;
end process;
end ;