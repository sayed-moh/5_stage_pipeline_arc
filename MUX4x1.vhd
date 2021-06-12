Library ieee;
Use ieee.std_logic_1164.all;

ENTITY mux41 IS
GENERIC (DATA_WIDTH : integer := 32);
PORT   (input1   : IN std_logic_vector(DATA_WIDTH-1 DOWNTO 0) ;
        input2   : IN std_logic_vector(DATA_WIDTH-1 DOWNTO 0) ;
	input3   : IN std_logic_vector(DATA_WIDTH-1 DOWNTO 0) ;
	input4   : IN std_logic_vector(DATA_WIDTH-1 DOWNTO 0) ;
	sel      : IN std_logic_vector(1 DOWNTO 0);
        output_M : OUT std_logic_vector(DATA_WIDTH-1 DOWNTO 0));
END ENTITY;


ARCHITECTURE a_mux41 of mux41 is 
begin
    	output_M<=input1 WHEN sel="00"
	ELSE input2 WHEN sel="01"
	ELSE input3 WHEN sel="10"
	ELSE input4 WHEN sel="11"
	ELSE (others=>'Z');
end ARCHITECTURE;

