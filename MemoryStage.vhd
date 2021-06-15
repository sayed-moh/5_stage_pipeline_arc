Library ieee;
Use ieee.std_logic_1164.all;
Use IEEE.numeric_std.all;

ENTITY memorystage IS
GENERIC ( REG_WIDTH : integer := 32);
PORT   (clk             : IN  std_logic;
	CU_MEMW         : IN  std_logic;  
	CU_MEMR         : IN  std_logic;
	CU_MEMDataSel   : IN  std_logic;
	CU_MEMAddressSel: IN  std_logic;
	CU_SPOperation  : IN  std_logic_vector(1 DOWNTO 0);
	MemoryOutput    : OUT std_logic_vector(REG_WIDTH-1 DOWNTO 0);
	InPort_in       : IN std_logic_vector(REG_WIDTH-1 DOWNTO 0);
       	InPort_out      : OUT std_logic_vector(REG_WIDTH-1 DOWNTO 0);
	CU_WB_IN        : IN std_logic_vector(2 DOWNTO 0);
	CU_WB_OUT       : OUT std_logic_vector(2 DOWNTO 0);
	
	--Reg2_in         : IN  std_logic_vector(REG_WIDTH-1 DOWNTO 0);
	--Reg2_out        : OUT std_logic_vector(REG_WIDTH-1 DOWNTO 0);
	
	Reg1            : IN std_logic_vector(REG_WIDTH-1 DOWNTO 0);
	PCAdd           : IN std_logic_vector(REG_WIDTH-1 DOWNTO 0); 
	ResultALU       : IN std_logic_vector(REG_WIDTH-1 DOWNTO 0);
	WriteReg1_in    : IN std_logic_vector(2 DOWNTO 0);
	WriteReg1_out   : OUT std_logic_vector(2 DOWNTO 0)
);  
END ENTITY;


ARCHITECTURE a_memorystage of memorystage is 
	COMPONENT datamemory IS 
	GENERIC (n : integer := 32;
		 m : integer := 16);
	PORT (	
       	     	AddressIn     :      IN  std_logic_vector(19 DOWNTO 0);
 	     	WriteData     :      IN  std_logic_vector(n-1 DOWNTO 0);
	     	CU_MEMR       :      IN  std_logic;
	     	CU_MEMW       :      IN  std_logic;
	     	clk           :      IN  std_logic;
	     	ReadData      :      OUT std_logic_vector (n-1 DOWNTO 0)
	    );
	END COMPONENT;

	COMPONENT mux21 IS
	GENERIC (DATA_WIDTH : integer := 32);
	PORT(
		input1   : IN std_logic_vector(DATA_WIDTH-1 DOWNTO 0) ;
        	input2   : IN std_logic_vector(DATA_WIDTH-1 DOWNTO 0) ;
		sel      : IN std_logic;
        	output_M : OUT std_logic_vector(DATA_WIDTH-1 DOWNTO 0));
    	END COMPONENT;
	
	COMPONENT sp IS
	PORT   (clk             : IN  std_logic;
		CU_SP_Operation : IN  std_logic_vector(1 DOWNTO 0);   -- 00 for SP, 01 for SP + 2, 10 for SP-2, 11 for initial value for SP
		SP              : OUT std_logic_vector(31 DOWNTO 0));
	END COMPONENT;

	SIGNAL SP_Signal      : std_logic_vector(REG_WIDTH-1 DOWNTO 0);
	SIGNAL OUT_MUXAddress : std_logic_vector(REG_WIDTH-1 DOWNTO 0);
	SIGNAL OUT_MUXData    : std_logic_vector(REG_WIDTH-1 DOWNTO 0);
	

	BEGIN
		
		SP0: SP PORT MAP ( clk, CU_SPOperation, SP_Signal);
		MUX1: mux21 PORT MAP( ResultALU, SP_Signal ,CU_MEMAddressSel,OUT_MUXAddress);
		MUX2: mux21 PORT MAP( Reg1, PCAdd ,CU_MEMDataSel,OUT_MUXData);
		MEM: DataMemory PORT MAP ( OUT_MUXAddress(19 DOWNTO 0), OUT_MUXData, CU_MEMR, CU_MEMW, clk, MemoryOutput );
		
		--Reg2_out <= Reg2_in;
		WriteReg1_out <= WriteReg1_in;
		InPort_out <=InPort_in;
		CU_WB_OUT<=CU_WB_IN;

end ARCHITECTURE;