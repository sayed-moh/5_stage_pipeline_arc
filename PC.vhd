Library ieee;
use ieee.std_logic_1164.all;

ENTITY PC IS
GENERIC ( REG_WIDTH : integer := 20);
PORT( 		PC_IN           :    IN std_logic_vector(REG_WIDTH-1 DOWNTO 0);
		PC_OUT          :    OUT std_logic_vector(REG_WIDTH-1 DOWNTO 0);
		Clk             :    IN  std_logic;
		Stall           :    IN  std_logic
);	
END ENTITY;
ARCHITECTURE a_PC OF PC
IS
	COMPONENT nReg IS
	GENERIC ( n : integer := 32);
	PORT( Clk,Rst : IN std_logic;
		in_reg : IN std_logic_vector(n-1 DOWNTO 0);
		enable:IN std_logic;
		out_reg : OUT std_logic_vector(n-1 DOWNTO 0));
	END COMPONENT;
	signal Reset  :std_logic;
	signal Enable  :std_logic;
BEGIN
	PC : nReg generic map(20) PORT MAP(Clk,Reset,PC_IN,Enable,PC_OUT);
	Reset<='0';
	Enable<=Not(Stall);

END a_PC;

