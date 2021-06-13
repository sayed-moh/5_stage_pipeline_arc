Library ieee;
use ieee.std_logic_1164.all;

ENTITY decodStage IS
GENERIC ( REG_WIDTH : integer := 32);
PORT( 		instr       :    IN std_logic_vector(REG_WIDTH-1 DOWNTO 0);
		WriteData   :    IN std_logic_vector(REG_WIDTH-1 DOWNTO 0);
		WriteReg    :    IN std_logic_vector(2 DOWNTO 0);
		WriteEnable :    IN std_logic;
		clk 	    :    IN std_logic;
		reset       :    IN std_logic;
		Imm         :    OUT std_logic_vector(REG_WIDTH-1 DOWNTO 0);
		Rsrc        :    OUT std_logic_vector(2 DOWNTO 0);
		Rdst        :    OUT std_logic_vector(2 DOWNTO 0);
		Reg1        :    OUT std_logic_vector(REG_WIDTH-1 DOWNTO 0);
		Reg2        :    OUT std_logic_vector(REG_WIDTH-1 DOWNTO 0);
		PCADD_in    :    IN std_logic_vector(19 DOWNTO 0);
       		PCADD_out   :    OUT std_logic_vector(19 DOWNTO 0);
		InPort_in   :    IN std_logic_vector(REG_WIDTH-1 DOWNTO 0);
       		InPort_out  :    OUT std_logic_vector(REG_WIDTH-1 DOWNTO 0);
		OutPort_in  :    IN std_logic_vector(REG_WIDTH-1 DOWNTO 0);
       		OutPort_out :    OUT std_logic_vector(REG_WIDTH-1 DOWNTO 0);
	
		WD1S        :    IN std_logic  ); --el mfrood ttl8y
		
END ENTITY;


ARCHITECTURE a_decode_stage OF decodStage IS

    COMPONENT reg_file IS
	GENERIC( REG_WIDTH  : integer := REG_WIDTH);
	PORT(   clk         : IN std_logic;
		reset_regs  : IN std_logic;
		read_data1  : OUT std_logic_vector(REG_WIDTH-1 DOWNTO 0);
		read_data2  : OUT std_logic_vector(REG_WIDTH-1 DOWNTO 0);
		write_data  : IN std_logic_vector(REG_WIDTH-1 DOWNTO 0);
		r_addr1     : IN std_logic_vector(2 DOWNTO 0);		
		r_addr2     : IN std_logic_vector(2 DOWNTO 0);
		w_addr      : IN std_logic_vector(2 DOWNTO 0);
		w_en        : IN std_logic);
    END COMPONENT;
	
    SIGNAL read_reg1,read_reg2: std_logic_vector(REG_WIDTH-1 DOWNTO 0);

    BEGIN

	Register_file: reg_file PORT MAP( clk, reset, read_reg1, read_reg2, WriteData, instr(11 DOWNTO 9), instr(8 DOWNTO 6), WriteReg, WriteEnable );

	Imm  <= (15 DOWNTO 0 => '0') & instr(31 DOWNTO 16);
	Rsrc <= instr(11 DOWNTO 9);
	Rdst <= instr(8 DOWNTO 6);

	Reg1 <= read_reg1;
	Reg2 <= read_reg2;

	PCADD_out <= PCADD_in;
	InPort_out <=InPort_in;
	OutPort_out <=OutPort_in;

END ARCHITECTURE;
