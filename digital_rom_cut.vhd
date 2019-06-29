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

ENTITY digital_rom_cut IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		clock		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
	);
END digital_rom_cut;


ARCHITECTURE SYN OF digital_rom_cut IS

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
			address_a	: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			q_a	: OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
	);
	END COMPONENT;

BEGIN
	q    <= sub_wire0;

	altsyncram_component : altsyncram
	GENERIC MAP (
		clock_enable_input_a => "BYPASS",
		clock_enable_output_a => "BYPASS",
		init_file => "hex_final.mif",--digital
		intended_device_family => "Cyclone II",
		lpm_hint => "ENABLE_RUNTIME_MOD=NO",
		lpm_type => "altsyncram",
		numwords_a => 63488,--4096 = 2 ^ 12 = 64 * 64
		operation_mode => "ROM",
		outdata_aclr_a => "NONE",
		outdata_reg_a => "UNREGISTERED",
		widthad_a => 16,
		width_a => 9,--1
		width_byteena_a => 1
	)
	PORT MAP (
		clock0 => clock,
		address_a => address,
		q_a => sub_wire0
	);



END SYN;

-- ============================================================
-- CNX file retrieval info
-- ============================================================
-- Retrieval info: PRIVATE: ADDRESSSTALL_A NUMERIC "0"
-- Retrieval info: PRIVATE: AclrAddr NUMERIC "0"
-- Retrieval info: PRIVATE: AclrByte NUMERIC "0"
-- Retrieval info: PRIVATE: AclrOutput NUMERIC "0"
-- Retrieval info: PRIVATE: BYTE_ENABLE NUMERIC "0"
-- Retrieval info: PRIVATE: BYTE_SIZE NUMERIC "8"
-- Retrieval info: PRIVATE: BlankMemory NUMERIC "0"
-- Retrieval info: PRIVATE: CLOCK_ENABLE_INPUT_A NUMERIC "0"
-- Retrieval info: PRIVATE: CLOCK_ENABLE_OUTPUT_A NUMERIC "0"
-- Retrieval info: PRIVATE: Clken NUMERIC "0"
-- Retrieval info: PRIVATE: IMPLEMENT_IN_LES NUMERIC "0"
-- Retrieval info: PRIVATE: INIT_FILE_LAYOUT STRING "PORT_A"
-- Retrieval info: PRIVATE: INIT_TO_SIM_X NUMERIC "0"
-- Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Cyclone II"
-- Retrieval info: PRIVATE: JTAG_ENABLED NUMERIC "0"
-- Retrieval info: PRIVATE: JTAG_ID STRING "NONE"
-- Retrieval info: PRIVATE: MAXIMUM_DEPTH NUMERIC "0"
-- Retrieval info: PRIVATE: MIFfilename STRING "digital.mif"
-- Retrieval info: PRIVATE: NUMWORDS_A NUMERIC "16384"
-- Retrieval info: PRIVATE: RAM_BLOCK_TYPE NUMERIC "0"
-- Retrieval info: PRIVATE: RegAddr NUMERIC "1"
-- Retrieval info: PRIVATE: RegOutput NUMERIC "0"
-- Retrieval info: PRIVATE: SingleClock NUMERIC "1"
-- Retrieval info: PRIVATE: UseDQRAM NUMERIC "0"
-- Retrieval info: PRIVATE: WidthAddr NUMERIC "14"
-- Retrieval info: PRIVATE: WidthData NUMERIC "1"
-- Retrieval info: PRIVATE: rden NUMERIC "0"
-- Retrieval info: CONSTANT: CLOCK_ENABLE_INPUT_A STRING "BYPASS"
-- Retrieval info: CONSTANT: CLOCK_ENABLE_OUTPUT_A STRING "BYPASS"
-- Retrieval info: CONSTANT: INIT_FILE STRING "digital.mif"
-- Retrieval info: CONSTANT: INTENDED_DEVICE_FAMILY STRING "Cyclone II"
-- Retrieval info: CONSTANT: LPM_HINT STRING "ENABLE_RUNTIME_MOD=NO"
-- Retrieval info: CONSTANT: LPM_TYPE STRING "altsyncram"
-- Retrieval info: CONSTANT: NUMWORDS_A NUMERIC "16384"
-- Retrieval info: CONSTANT: OPERATION_MODE STRING "ROM"
-- Retrieval info: CONSTANT: OUTDATA_ACLR_A STRING "NONE"
-- Retrieval info: CONSTANT: OUTDATA_REG_A STRING "UNREGISTERED"
-- Retrieval info: CONSTANT: WIDTHAD_A NUMERIC "14"
-- Retrieval info: CONSTANT: WIDTH_A NUMERIC "1"
-- Retrieval info: CONSTANT: WIDTH_BYTEENA_A NUMERIC "1"
-- Retrieval info: USED_PORT: address 0 0 14 0 INPUT NODEFVAL address[13..0]
-- Retrieval info: USED_PORT: clock 0 0 0 0 INPUT NODEFVAL clock
-- Retrieval info: USED_PORT: q 0 0 1 0 OUTPUT NODEFVAL q[0..0]
-- Retrieval info: CONNECT: @address_a 0 0 14 0 address 0 0 14 0
-- Retrieval info: CONNECT: q 0 0 1 0 @q_a 0 0 1 0
-- Retrieval info: CONNECT: @clock0 0 0 0 0 clock 0 0 0 0
-- Retrieval info: LIBRARY: altera_mf altera_mf.altera_mf_components.all
-- Retrieval info: GEN_FILE: TYPE_NORMAL digital_rom.vhd TRUE
-- Retrieval info: GEN_FILE: TYPE_NORMAL digital_rom.inc FALSE
-- Retrieval info: GEN_FILE: TYPE_NORMAL digital_rom.cmp TRUE
-- Retrieval info: GEN_FILE: TYPE_NORMAL digital_rom.bsf TRUE
-- Retrieval info: GEN_FILE: TYPE_NORMAL digital_rom_inst.vhd FALSE
-- Retrieval info: LIB_FILE: altera_mf