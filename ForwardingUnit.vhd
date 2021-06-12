Library ieee;
Use ieee.std_logic_1164.all;
Use IEEE.numeric_std.all;
ENTITY FU IS
GENERIC ( REG_WIDTH : integer := 32);
PORT   (
	WR_EX_MEM:IN std_logic_vector(2 DOWNTO 0);
	WE_EX_MEM:IN std_logic;
	WR_MEM_WB:IN std_logic_vector(2 DOWNTO 0);
	WE_MEM_WB:IN std_logic;
	RS_ID_EX:IN std_logic_vector(2 DOWNTO 0);
	RD_ID_EX:IN std_logic_vector(2 DOWNTO 0);
	ENABLE  :IN std_logic;
	SEL0:OUT std_logic_vector(1 DOWNTO 0);
	SEL1:OUT std_logic_vector(1 DOWNTO 0)
);

END ENTITY;
ARCHITECTURE a_FU of FU is 
	BEGIN
sel1<="00" when Enable='0'
else "01" when RS_ID_EX=WR_EX_MEM and WE_EX_MEM='1'
else "10" when RS_ID_EX=WR_MEM_WB and WE_MEM_WB='1'
else "00" ;

sel0<="00" when Enable='0'
else "01" when RD_ID_EX=WR_EX_MEM and WE_EX_MEM='1'
else "10" when RD_ID_EX=WR_MEM_WB and WE_MEM_WB='1'
else "00" ;
end ARCHITECTURE;
