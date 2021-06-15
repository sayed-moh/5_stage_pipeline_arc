Library ieee;
Use ieee.std_logic_1164.all;
Use IEEE.numeric_std.all;
ENTITY INS_Memory IS
GENERIC (n : integer := 32;
	 m : integer := 16);
PORT   (
	PC		:IN  std_logic_vector(19 DOWNTO 0);
	clk		:IN std_logic;
	AddSel          :IN std_logic;
	Instruction	:OUT std_logic_vector(n-1 DOWNTO 0)
);

END ENTITY;

ARCHITECTURE a_INS_Memory of INS_Memory is 
COMPONENT InstRam IS
GENERIC(
	  DataWidth    : INTEGER := 16;
	  AddressWidth : INTEGER := 20;
	  AddressSpace : INTEGER := 1048575 --(2^20-1)
	  );
PORT   (
	clk         : IN  std_logic;
	addenable   : IN  std_logic;
	address     : IN  std_logic_vector(AddressWidth-1 DOWNTO 0);
	dataout1    : OUT std_logic_vector(DataWidth-1 DOWNTO 0);
	dataout2    : OUT std_logic_vector(DataWidth-1 DOWNTO 0)
	);	
END Component;
signal twoWordInstruction: std_logic_vector(31 DOWNTO 0);
begin
InstructionRAM: InstRam PORT MAP (clk,AddSel,PC,twoWordInstruction(n-1 DOWNTO m),twoWordInstruction(m-1 DOWNTO 0));

Instruction(15 DOWNTO 0)<=  twoWordInstruction(m-1 DOWNTO 0);
Instruction(31 DOWNTO 16)<= twoWordInstruction(n-1 DOWNTO m);

end ARCHITECTURE;
