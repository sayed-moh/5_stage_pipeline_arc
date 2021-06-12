Library ieee;
Use ieee.std_logic_1164.all;

ENTITY mux21 IS
GENERIC (DATA_WIDTH : integer := 32);
PORT   (input1 : IN std_logic_vector(DATA_WIDTH-1 DOWNTO 0) ;
        input2 : IN std_logic_vector(DATA_WIDTH-1 DOWNTO 0) ;
		sel: IN std_logic;
        output_M : OUT std_logic_vector(DATA_WIDTH-1 DOWNTO 0));
END ENTITY;


ARCHITECTURE a_mux21 of mux21 is 
begin
    	output_M<=input1 WHEN sel='0'
	ELSE input2 WHEN sel='1'
	ELSE (others=>'Z');
end ARCHITECTURE;

