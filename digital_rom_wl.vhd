---------------------------------------------------------------------------------------------
--创建日期   : 2019-06-08
--目标芯片   : EP2C70F672C8N
--时钟选择   : clock = 25MHz
--演示说明   : 无
--主要信号说明: address: RAM读地址
--            q: 返回值
--主要进程说明: 利用Quartus相关功能和示例代码，实现对RAM的读取
---------------------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY altera_mf;
USE altera_mf.all;

ENTITY digital_rom_wl IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (12 DOWNTO 0);
		clock		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
	);
END digital_rom_wl;


ARCHITECTURE SYN OF digital_rom_wl IS

	SIGNAL sub_wire0	: STD_LOGIC_VECTOR(8 DOWNTO 0);



	COMPONENT altsyncram
	GENERIC (
		clock_enable_input_a		: STRING;
		clock_enable_output_a		: STRING;
		init_file		: STRING;
		intended_device_family		: STRING;
		lpm_hint		: STRING;
		lpm_type		: STRING;
		numwords_a		: NATURAL;
		operation_mode		: STRING;
		outdata_aclr_a		: STRING;
		outdata_reg_a		: STRING;
		widthad_a		: NATURAL;
		width_a		: NATURAL;
		width_byteena_a		: NATURAL
	);
	PORT (
			clock0	: IN STD_LOGIC ;
			address_a	: IN STD_LOGIC_VECTOR (12 DOWNTO 0);
			q_a	: OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
	);
	END COMPONENT;

BEGIN
	q    <= sub_wire0;

	altsyncram_component : altsyncram
	GENERIC MAP (
		clock_enable_input_a => "BYPASS",
		clock_enable_output_a => "BYPASS",
		init_file => "wonlost.mif",--digital
		intended_device_family => "Cyclone II",
		lpm_hint => "ENABLE_RUNTIME_MOD=NO",
		lpm_type => "altsyncram",
		numwords_a => 8192,--4096 = 2 ^ 12 = 64 * 64
		operation_mode => "ROM",
		outdata_aclr_a => "NONE",
		outdata_reg_a => "UNREGISTERED",
		widthad_a => 13,
		width_a => 9,--1
		width_byteena_a => 1
	)
	PORT MAP (
		clock0 => clock,
		address_a => address,
		q_a => sub_wire0
	);



END SYN;