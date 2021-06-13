Library ieee;
Use ieee.std_logic_1164.all;

ENTITY Branching IS
GENERIC (n : integer := 32);
PORT(         ConBranchEnable   : IN std_logic_vector(1 DOWNTO 0);
              DirBranch   : IN std_logic;
              ReadData2   : IN std_logic_vector (n-1 DOWNTO 0);
              CCR   : IN std_logic_vector(2 DOWNTO 0);
              JmpEnable   : OUT std_logic ;
              JmpAddr : OUT std_logic_vector (n-1 DOWNTO 0)
);

END  Branching;
ARCHITECTURE a_Branching OF Branching IS
 
BEGIN
 --ConBranchEnable 10 carry
 --ConBranchEnable 01 negative
 --ConBranchEnable 11 zero

JmpEnable <= '1' when DirBranch='1' 
		 or (ConBranchEnable="10" and CCR(2)='1')
		 or (ConBranchEnable="01" and CCR(1)='1') 
		 or (ConBranchEnable="11" and CCR(0)='1')
else '0';
JmpAddr <= ReadData2;
END a_Branching;

