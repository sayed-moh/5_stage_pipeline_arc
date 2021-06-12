LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
ENTITY nReg IS
GENERIC ( n : integer := 32);
PORT( Clk,Rst : IN std_logic;
	in_reg : IN std_logic_vector(n-1 DOWNTO 0);
	enable:IN std_logic;
	out_reg : OUT std_logic_vector(n-1 DOWNTO 0));
END nReg;
ARCHITECTURE a_nReg OF nReg
IS
BEGIN
	PROCESS (Clk,Rst)
	BEGIN
	IF Rst = '1' THEN
		out_reg <= (OTHERS=>'0');
	ELSIF rising_edge(Clk)and enable ='1' THEN
		out_reg <= in_reg;
	END IF;
	END PROCESS;
END a_nReg;