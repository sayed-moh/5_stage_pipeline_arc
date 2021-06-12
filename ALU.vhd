Library ieee;
Use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
ENTITY ALU IS
GENERIC (n : integer := 32);
PORT(
A,B  : IN std_logic_vector(n-1 downto 0);
Cin  : IN std_logic;
ALUOP: IN std_logic_vector(2 downto 0);
F    : OUT std_logic_vector(n-1 downto 0);
CCR  : OUT std_logic_vector(2 DOWNTO 0)
);
END ENTITY ALU;

ARCHITECTURE struct OF ALU IS

	SIGNAL ALUOutput: std_logic_vector(n downto 0);

BEGIN

	ALUOutput <= std_logic_vector(('0' & unsigned(A)) + ('0' & unsigned(B))) 			WHEN ALUOP = "000"
	ELSE std_logic_vector(('0' & unsigned(A)) - ('0' & unsigned(B))) 	 			WHEN ALUOP = "001"
	ELSE '0' & NOT B 				   			 			WHEN ALUOP = "010"
	ELSE '0' & (A AND B)     				   		         		WHEN ALUOP = "011"
	ELSE '0' & (A OR B)     				                         		WHEN ALUOP = "100"			
	ELSE B(n-to_integer(unsigned(A)) DOWNTO 0) & (to_integer(unsigned(A))-1 DOWNTO 0 => '0')   	WHEN ALUOP = "101" AND B/="UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU"
	ELSE (to_integer(unsigned(A))-1 DOWNTO 0 => '0') & B(n-1 DOWNTO to_integer(unsigned(A))-1)     	WHEN ALUOP = "110" AND A/="UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU"
	ELSE '0'&B            										WHEN ALUOP = "111";
	
	F <= ALUOutput ( n DOWNTO 1 ) WHEN ALUOP = "110"
	ELSE ALUOutput ( n-1 DOWNTO 0 );
	
	CCR(0) <= '1' WHEN  ( ALUOutput(n-1 DOWNTO 0) = "00000000000000000000000000000000" ) AND ( ALUOP /= "101" AND ALUOP /= "110" AND ALUOP /= "111" )
	ELSE '0';
	
	CCR(1) <= ALUOutput(n) WHEN ALUOP = "110"
	ELSE ALUOutput(n-1);
	
	CCR(2) <= ALUOutput(n) WHEN ALUOP = "000" OR ALUOP = "001" OR ALUOP = "101"
	ELSE ALUOutput(0) WHEN ALUOP = "110"
	ELSE Cin;
	

END struct;

