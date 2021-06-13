Library ieee;
Use ieee.std_logic_1164.all;
Use IEEE.numeric_std.all;
ENTITY InstRam IS
GENERIC(
	  DataWidth    : INTEGER := 16;
	  AddressWidth : INTEGER := 20;
	  AddressSpace : INTEGER := 1048575 --(2^20-1)
	  );
PORT   (
	clk         : IN  std_logic;
	we          : IN  std_logic;
	addenable   : IN  std_logic;
	address     : IN  std_logic_vector(AddressWidth-1 DOWNTO 0);
	datain1     : IN  std_logic_vector(DataWidth-1 DOWNTO 0);
	datain2     : IN  std_logic_vector(DataWidth-1 DOWNTO 0);
	dataout1    : OUT std_logic_vector(DataWidth-1 DOWNTO 0);
	dataout2    : OUT std_logic_vector(DataWidth-1 DOWNTO 0)
	);
END ENTITY;


ARCHITECTURE a_InstRam of InstRam is 
    	TYPE ram_type IS ARRAY(0 TO AddressSpace) of std_logic_vector(DataWidth-1 DOWNTO 0);
	SIGNAL ram : ram_type;
	BEGIN
		PROCESS(clk) IS
		BEGIN
			IF falling_edge(clk)and we = '1' and addenable='1' THEN
				
				ram(to_integer(unsigned(address)))   <= datain1;
				ram(to_integer(unsigned(address))+1) <= datain2;
			elsiF falling_edge(clk)and we = '1' and addenable='0' THEN
				ram(to_integer(unsigned(address)))   <= datain1;
				
			END IF;
		END PROCESS;

	dataout1 <= ram(to_integer(unsigned(address)));
	dataout2 <= ram(to_integer(unsigned(address))+1) when addenable='1'
		  else (others=>'0');
end ARCHITECTURE;
