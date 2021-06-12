Library ieee;
use ieee.std_logic_1164.all;

ENTITY ExcuteStage IS
GENERIC ( REG_WIDTH : integer := 32);
PORT( 		Reg1        	:    IN std_logic_vector(REG_WIDTH-1 DOWNTO 0);
		Reg2       	:    IN std_logic_vector(REG_WIDTH-1 DOWNTO 0);
		Imm        	:    IN std_logic_vector(REG_WIDTH-1 DOWNTO 0);
		WriteReg1_in    :    IN std_logic_vector(2 DOWNTO 0);
		ReadReg1_in     :    IN std_logic_vector(2 DOWNTO 0);
		PCADD_in        :    IN std_logic_vector(REG_WIDTH-1 DOWNTO 0);
		WriteReg1_out   :    OUT std_logic_vector(2 DOWNTO 0);
		ReadReg1_out    :    OUT std_logic_vector(2 DOWNTO 0);
       		PCADD_out   	:    OUT std_logic_vector(REG_WIDTH-1 DOWNTO 0);
		ExcuteOutput    :    OUT std_logic_vector(REG_WIDTH-1 DOWNTO 0);

		CU_InnerMUX1SEL :    IN std_logic_vector(1 DOWNTO 0);
		CU_InnerMUX2SEL :    IN std_logic;
		CU_CCR          :    IN std_logic_vector(3 DOWNTO 0);
		ALUOP           :    IN std_logic_vector(2 DOWNTO 0);
		FU_SEL0         :    IN std_logic_vector(1 DOWNTO 0);
		FU_SEL1         :    IN std_logic_vector(1 DOWNTO 0);
		
		ExcuteForwarding:    IN std_logic_vector(REG_WIDTH-1 DOWNTO 0);
		MemoryForwarding:    IN std_logic_vector(REG_WIDTH-1 DOWNTO 0)
		); 
		
END ENTITY;

ARCHITECTURE a_excute_stage OF ExcuteStage IS

    COMPONENT ALU IS
	GENERIC (n : integer := 32);
	PORT(
	A,B  : IN std_logic_vector(n-1 downto 0);
	Cin  : IN std_logic;
	ALUOP: IN std_logic_vector(2 downto 0);
	F    : OUT std_logic_vector(n-1 downto 0);
	CCR  : OUT std_logic_vector(2 DOWNTO 0)
	);
    END COMPONENT;

    COMPONENT mux41 IS
	GENERIC (DATA_WIDTH : integer := 32);
	PORT(
	input1   : IN std_logic_vector(DATA_WIDTH-1 DOWNTO 0) ;
        input2   : IN std_logic_vector(DATA_WIDTH-1 DOWNTO 0) ;
	input3   : IN std_logic_vector(DATA_WIDTH-1 DOWNTO 0) ;
	input4   : IN std_logic_vector(DATA_WIDTH-1 DOWNTO 0) ;
	sel      : IN std_logic_vector(1 DOWNTO 0);
        output_M : OUT std_logic_vector(DATA_WIDTH-1 DOWNTO 0));
    END COMPONENT;
	
    COMPONENT mux21 IS
	GENERIC (DATA_WIDTH : integer := 32);
	PORT(
	input1   : IN std_logic_vector(DATA_WIDTH-1 DOWNTO 0) ;
        input2   : IN std_logic_vector(DATA_WIDTH-1 DOWNTO 0) ;
	sel      : IN std_logic;
        output_M : OUT std_logic_vector(DATA_WIDTH-1 DOWNTO 0));
    END COMPONENT;

    COMPONENT CCR IS
	PORT( 		
	CCROP        	:    IN std_logic_vector(3 DOWNTO 0); -- (3)RESET (2)CLEAR CARRY (1)SET CARRY (0)Enable Flags 
	CCR_ALU       	:    IN std_logic_vector(2 DOWNTO 0);
	ZF       	:    OUT std_logic;
	NF              :    OUT std_logic;
	CF              :    OUT std_logic); 
    END COMPONENT;
	
    SIGNAL OUT_MUX1,OUT_MUX2,OUT_MUX3,OUT_MUX4: std_logic_vector(REG_WIDTH-1 DOWNTO 0);
    SIGNAL CCR_Temporary: std_logic_vector(2 DOWNTO 0);
    SIGNAL Zflag,Nflag,Cflag: std_logic;

    BEGIN

	MUX1: mux41 PORT MAP( Reg1, ExcuteForwarding, MemoryForwarding, "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ", FU_SEL1, OUT_MUX1 );
	MUX2: mux41 PORT MAP( Reg2, ExcuteForwarding, MemoryForwarding, "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ", FU_SEL0, OUT_MUX2 );
	MUX3: mux41 PORT MAP( OUT_MUX1, Imm, "00000000000000000000000000000001", "11111111111111111111111111111111", CU_InnerMUX1SEL, OUT_MUX3);
	MUX4: mux21 PORT MAP( OUT_MUX2, Imm ,CU_InnerMUX2SEL,OUT_MUX4);
	CCR0: CCR   PORT MAP( CU_CCR,CCR_Temporary,Zflag,Nflag,Cflag );
	ALUMAP: ALU PORT MAP(OUT_MUX3,OUT_MUX4,'0',ALUOP,ExcuteOutput,CCR_Temporary);


	
	WriteReg1_out <= WriteReg1_in;
	ReadReg1_out <= ReadReg1_in;
	PCADD_out <= PCADD_in;
	

END ARCHITECTURE;