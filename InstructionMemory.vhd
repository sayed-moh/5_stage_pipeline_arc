Library ieee;
Use ieee.std_logic_1164.all;
Use IEEE.numeric_std.all;
ENTITY INS_Memory IS
GENERIC (n : integer := 32;
	 m : integer := 16);
PORT   (
	PC		:IN  std_logic_vector(19 DOWNTO 0);
	clk		:IN std_logic;
	Enable		:IN std_logic;
	Data_IN		:IN  std_logic_vector(n-1 DOWNTO 0);
	Instruction	:OUT std_logic_vector(n-1 DOWNTO 0)
);

END ENTITY;

ARCHITECTURE a_INS_Memory of INS_Memory is 
COMPONENT ram IS
GENERIC(
	  DataWidth    : INTEGER := 16;
	  AddressWidth : INTEGER := 20;
	  AddressSpace : INTEGER := 1048575 --(2^20-1)
	  );
PORT   (clk         : IN  std_logic;
	we          : IN  std_logic;
	address     : IN  std_logic_vector(AddressWidth-1 DOWNTO 0);
	datain1     : IN  std_logic_vector(DataWidth-1 DOWNTO 0);
	datain2     : IN  std_logic_vector(DataWidth-1 DOWNTO 0);
	dataout1    : OUT std_logic_vector(DataWidth-1 DOWNTO 0);
	dataout2    : OUT std_logic_vector(DataWidth-1 DOWNTO 0));
END COMPONENT;
begin
InstructionRAM: Ram PORT MAP (clk,Enable,PC,Data_IN(31 DOWNTO 16),Data_IN(15 DOWNTO 0),Instruction(m-1 DOWNTO 0),Instruction(n-1 DOWNTO m));



end ARCHITECTURE;
