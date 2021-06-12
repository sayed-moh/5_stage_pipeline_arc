Library ieee;
Use ieee.std_logic_1164.all;
Use IEEE.numeric_std.all;
ENTITY sp IS
PORT   (clk             : IN  std_logic;
	CU_SP_Operation : IN  std_logic_vector(1 DOWNTO 0);   -- 00 for SP, 01 for SP + 2, 10 for SP-2, 11 for initial value for SP
	SP              : OUT std_logic_vector(31 DOWNTO 0));
END ENTITY;


ARCHITECTURE a_sp of sp is 
	SIGNAL SP_signal : std_logic_vector(31 DOWNTO 0);
	BEGIN
		PROCESS(clk) IS
		BEGIN
			IF falling_edge(clk) THEN
				IF CU_SP_Operation = "01" THEN
					SP_signal <= std_logic_vector(unsigned(SP_signal)+"10");
				ELSIF CU_SP_Operation = "10" THEN
					SP_signal <= std_logic_vector(unsigned(SP_signal)-"10");
				ELSIF CU_SP_Operation = "11" THEN
					SP_signal <= std_logic_vector(to_unsigned(2**20-2,32));
				END IF;
			END IF;
		END PROCESS;
		SP <= SP_signal;
end ARCHITECTURE;