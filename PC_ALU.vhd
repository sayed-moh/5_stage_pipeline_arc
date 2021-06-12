Library ieee;
Use ieee.std_logic_1164.all;
Use IEEE.numeric_std.all;
ENTITY PCALU IS
GENERIC ( REG_WIDTH : integer := 20);
PORT   (
	PCADDIN		:IN  std_logic_vector(REG_WIDTH-1 DOWNTO 0);
	PCADDOUT	:OUT std_logic_vector(REG_WIDTH-1 DOWNTO 0);
	PCADDEN         :IN std_logic
	
);

END ENTITY;
ARCHITECTURE a_PCALU of PCALU is 
COMPONENT mux21 IS
GENERIC (DATA_WIDTH : integer := 32);
PORT   (input1 : IN std_logic_vector(DATA_WIDTH-1 DOWNTO 0) ;
        input2 : IN std_logic_vector(DATA_WIDTH-1 DOWNTO 0) ;
		sel: IN std_logic;
        output_M : OUT std_logic_vector(DATA_WIDTH-1 DOWNTO 0));
END COMPONENT;
signal MUXOUT:std_logic_vector(REG_WIDTH-1 DOWNTO 0);
begin
PCADDMUX : mux21 generic map(20) PORT MAP(std_logic_vector(to_unsigned(1,20)),std_logic_vector(to_unsigned(2,20)),PCADDEN,MUXOUT);
PCADDOUT <= std_logic_vector(unsigned(PCADDIN) + unsigned(MUXOUT));
end ARCHITECTURE;
