Library ieee;
use ieee.std_logic_1164.all;

ENTITY CCR IS
PORT( 		CCROP        	:    IN std_logic_vector(3 DOWNTO 0); -- (3)RESET (2)CLEAR CARRY (1)SET CARRY (0)Enable Flags 
		CCR_ALU       	:    IN std_logic_vector(2 DOWNTO 0);
		ZF       	:    OUT std_logic;
		NF              :    OUT std_logic;
		CF              :    OUT std_logic
		); 
END ENTITY;

ARCHITECTURE a_ccr OF CCR IS

BEGIN
	ZF <= CCR_ALU(0) WHEN CCROP(0) = '1'
	ELSE '0'         WHEN CCROP(3) = '1';

	NF <= CCR_ALU(1) WHEN CCROP(0) = '1'
	ELSE '0'         WHEN CCROP(3) = '1';

	CF <= CCR_ALU(2) WHEN CCROP(0) = '1'
	ELSE '0'         WHEN CCROP(2) = '1' OR CCROP(3) = '1'
	ELSE '1'	 WHEN CCROP(1) = '1';
	

END ARCHITECTURE;
