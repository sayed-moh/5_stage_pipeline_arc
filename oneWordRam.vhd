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
	addenable   : IN  std_logic;
	address     : IN  std_logic_vector(AddressWidth-1 DOWNTO 0);
	dataout1    : OUT std_logic_vector(DataWidth-1 DOWNTO 0);
	dataout2    : OUT std_logic_vector(DataWidth-1 DOWNTO 0)
	);
END ENTITY;


ARCHITECTURE a_InstRam of InstRam is 
    	TYPE ram_type IS ARRAY(0 TO AddressSpace) of std_logic_vector(DataWidth-1 DOWNTO 0);
	SIGNAL ram : ram_type := (
        0 => X"6400",
	1 => X"6500",
	2 => X"6600",
	3 => X"6700",
	4 => X"6800",
	5 => X"6900",
	6 => X"6A00",
	7 => X"6B00",
	8 => X"6C00",
	9 => X"6D00",
        10 => X"6E00",
	11 => X"6F00",
	12 => X"7000",
	13 => X"7100",
	14 => X"7200",
	15 => X"7300",
	16 => X"7400",
	17 => X"7500",
	18 => X"7600",
	19 => X"7700",
        20 => X"7800",
	21 => X"7900",
	22 => X"7A00",
	23 => X"7B00",
	24 => X"7C00",
	25 => X"7D00",
	26 => X"7E00",
	27 => X"7F00",
	28 => X"8000",
	29 => X"8100",
        30 => X"8200",
	31 => X"8300",
	32 => X"8400",
	33 => X"8500",
	34 => X"8600",
	35 => X"8700",
	36 => X"8800",
	37 => X"8900",
	38 => X"8A00",
	39 => X"8B00",
        40 => X"8C00",
	41 => X"8D00",
	42 => X"80E0",
	43 => X"8F00",
	44 => X"9000",
	45 => X"9100",
	46 => X"9200",
	47 => X"9300",
	48 => X"9400",
	49 => X"9500",
        50 => X"9600",
	51 => X"9700",
	52 => X"9800",
	53 => X"9900",
	54 => X"9A00",
	55 => X"9B00",
	56 => X"9C00",
	57 => X"9D00",
	58 => X"9E00",
	59 => X"9F00",
        60 => X"A000",
	61 => X"A100",
	62 => X"A200",
	63 => X"A300",
        OTHERS => X"FF00"
    ); 
	BEGIN
		
	dataout1 <= ram(to_integer(unsigned(address)));
	dataout2 <= ram(to_integer(unsigned(address))+1) when addenable='1' else "0000000000000000";
end ARCHITECTURE;
