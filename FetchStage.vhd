LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY Fetch IS
GENERIC(
	  AddressWidth : INTEGER := 20
	  );
PORT (
	InPort_in        :     IN std_logic_vector(31 DOWNTO 0);
       	InPort_out       :     OUT std_logic_vector(31 DOWNTO 0);
	OutPort_in       :     IN std_logic_vector(31 DOWNTO 0);
    	OutPort_out      :     OUT std_logic_vector(31 DOWNTO 0);

	clk              :      IN std_logic;
 	WB		 :      IN std_logic_vector(AddressWidth-1 DOWNTO 0);
        RegDJMPAdd	 :      IN std_logic_vector(AddressWidth-1 DOWNTO 0);
	RegCJMPAdd	 :      IN std_logic_vector(AddressWidth-1 DOWNTO 0);
	PCSEL	         :	IN std_logic_vector(1 DOWNTO 0);
        PCALUSEL	 :	IN std_logic;
	STALL		 :	IN std_logic;
	Instruction	 :	OUT std_logic_vector(31 DOWNTO 0);
	ENABLEINSTR	 :      IN std_logic;
	DataIN    	 :      IN std_logic_vector(31 DOWNTO 0);
	PCNext   	 :      OUT std_logic_vector(AddressWidth-1 DOWNTO 0)        
     );
END  Fetch;


ARCHITECTURE a_Fetch OF Fetch IS



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
   COMPONENT PC IS
	GENERIC ( REG_WIDTH : integer := 20);
	PORT( 		
	PC_IN           :    IN std_logic_vector(REG_WIDTH-1 DOWNTO 0);
	PC_OUT          :    OUT std_logic_vector(REG_WIDTH-1 DOWNTO 0);
	Clk             :    IN  std_logic;
	Stall           :    IN  std_logic
	);	
   END COMPONENT;
   COMPONENT PCALU IS
	GENERIC ( REG_WIDTH : integer := 20);
	PORT   (
	PCADDIN		:IN  std_logic_vector(REG_WIDTH-1 DOWNTO 0);
	PCADDOUT	:OUT std_logic_vector(REG_WIDTH-1 DOWNTO 0);
	PCADDEN         :IN std_logic
	);
   END COMPONENT;
   COMPONENT  INS_Memory IS
	GENERIC (n : integer := 32;
	 	m : integer := 16);
	PORT   (
	PC		:IN  std_logic_vector(19 DOWNTO 0);
	clk		:IN std_logic;
	Enable		:IN std_logic;
	AddSel          :IN std_logic;
	Data_IN		:IN  std_logic_vector(n-1 DOWNTO 0);
	Instruction	:OUT std_logic_vector(n-1 DOWNTO 0)
	);
   END COMPONENT;

    SIGNAL OUTMUX41: std_logic_vector(AddressWidth-1 DOWNTO 0);
    SIGNAL PCOUT: std_logic_vector(AddressWidth-1 DOWNTO 0);
    SIGNAL PCALUOUT: std_logic_vector(AddressWidth-1 DOWNTO 0);
    SIGNAL INSS: std_logic_vector(31 DOWNTO 0);


    
    BEGIN

	MUX1:  mux41 GENERIC MAP(20) PORT MAP( RegDJMPAdd, RegCJMPAdd, PCALUOUT,WB , PCSEL, OUTMUX41 );
	PC1: PC GENERIC MAP(20) PORT MAP(OUTMUX41,PCOUT,clk,STALL);
	PCADD1: PCALU GENERIC MAP(20) PORT MAP(PCOUT,PCALUOUT,PCALUSEL);
	INMEM: INS_Memory PORT MAP(PCOUT,clk,ENABLEINSTR,PCALUSEL,DataIN,INSS);
--
	PCNext<=PCALUOUT;
	Instruction<=INSS;
	InPort_out <=InPort_in;
	OutPort_out <=OutPort_in;
END ARCHITECTURE;
