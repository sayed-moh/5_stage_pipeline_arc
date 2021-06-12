Library ieee;
Use ieee.std_logic_1164.all;
Use IEEE.numeric_std.all;
ENTITY wbstage IS
GENERIC (n : integer := 32);
PORT   (MemoryRead             : IN  std_logic_vector(n-1 DOWNTO 0);   
	ResultAlu              : IN  std_logic_vector(n-1 DOWNTO 0);
	InPort                 : IN  std_logic_vector(n-1 DOWNTO 0);
	CU_WBS                 : IN  std_logic_vector(1 DOWNTO 0);
	WBOutput               : OUT std_logic_vector(n-1 DOWNTO 0));
END ENTITY;


ARCHITECTURE a_wbstage of wbstage is 
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
	SIGNAL WB_signal : std_logic_vector(n-1 DOWNTO 0);
	BEGIN
		MUX1: MUX41 PORT MAP ( MemoryRead,ResultAlu,InPort,"ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ",CU_WBS,WB_signal);
		WBOutput <= WB_signal;
end ARCHITECTURE;