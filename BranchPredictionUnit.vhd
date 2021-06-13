Library ieee;
Use ieee.std_logic_1164.all;

ENTITY PredectionUnit IS
GENERIC (n : integer := 32);
PORT(         Branch  : IN std_logic_vector(2 DOWNTO 0);
              JmpEnable   : IN std_logic ;
              Flush : OUT std_logic
);

END  PredectionUnit;
ARCHITECTURE a_PredectionUnit OF PredectionUnit IS
BEGIN
	Flush <= '1' when (Branch(2)='1' or Branch(1)='1' or Branch(0)='1') and JmpEnable='1'
	else '0';
END a_PredectionUnit;


