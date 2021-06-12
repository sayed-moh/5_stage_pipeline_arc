Library ieee;
Use ieee.std_logic_1164.all;
Use IEEE.numeric_std.all;
ENTITY datamemory IS 
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
END ENTITY;


ARCHITECTURE a_datamemory of datamemory is 
	SIGNAL SP_signal : std_logic_vector(31 DOWNTO 0);
	COMPONENT Ram IS
	GENERIC(
	  	DataWidth    : INTEGER := 16;
	  	AddressWidth : INTEGER := 20;
	  	AddressSpace : INTEGER := 1048575 --(2^20-1)
	  );
	PORT(
		clk         : IN  std_logic;
		we          : IN  std_logic;
		address     : IN  std_logic_vector(AddressWidth-1 DOWNTO 0);
		datain1     : IN  std_logic_vector(DataWidth-1 DOWNTO 0);
		datain2     : IN  std_logic_vector(DataWidth-1 DOWNTO 0);
		dataout1    : OUT std_logic_vector(DataWidth-1 DOWNTO 0);
		dataout2    : OUT std_logic_vector(DataWidth-1 DOWNTO 0)
	);
 	END COMPONENT;
	
	SIGNAL DataOut : std_logic_vector (n-1 DOWNTO 0);
	
	BEGIN

	RAM0: Ram PORT MAP ( clk, CU_MEMW, AddressIn, WriteData(m-1 DOWNTO 0), WriteData(n-1 DOWNTO m), DataOut(m-1 DOWNTO 0), DataOut(n-1 DOWNTO m) );

	PROCESS (CU_MEMR,clk) IS
  	BEGIN
		IF CU_MEMR = '1' AND falling_edge(clk) THEN
			ReadData <= DataOut;
		ELSE
			ReadData <= (OTHERS=>'Z');	
		END IF;
  	END PROCESS;

end ARCHITECTURE;
