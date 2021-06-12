Library ieee;
use ieee.std_logic_1164.all;

ENTITY HazardUnit IS

PORT( 
		Stall :    OUT  std_logic;
		clk : 	IN std_logic;
		MEMR: IN std_logic;
		WriteEnable:IN std_logic;
		RS_IF_ID: IN std_logic_vector(2 DOWNTO 0);
		RD_IF_ID: IN std_logic_vector(2 DOWNTO 0);
		WR_ID_EX: IN std_logic_vector(2 DOWNTO 0)
);	
END ENTITY;

ARCHITECTURE a_HazardUnit OF HazardUnit
IS
BEGIN
	Stall<='1' when MEMR='1' and WriteEnable='1' and (RS_IF_ID(2 DOWNTO 0)=WR_ID_EX(2 DOWNTO 0) or RD_IF_ID(2 DOWNTO 0)=WR_ID_EX(2 DOWNTO 0))
	else '0';
END a_HazardUnit;