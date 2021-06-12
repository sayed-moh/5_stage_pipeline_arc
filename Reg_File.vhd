Library ieee;
use ieee.std_logic_1164.all;


ENTITY reg_file IS
GENERIC ( REG_WIDTH : integer := 32);

	PORT( clk : IN std_logic;
	reset_regs : IN std_logic;
	read_data1 : OUT std_logic_vector(REG_WIDTH-1 DOWNTO 0);
	read_data2 : OUT std_logic_vector(REG_WIDTH-1 DOWNTO 0);
	write_data : IN std_logic_vector(REG_WIDTH-1 DOWNTO 0);
	r_addr1 : IN std_logic_vector(2 DOWNTO 0);		
	r_addr2 : IN std_logic_vector(2 DOWNTO 0);
	w_addr : IN std_logic_vector(2 DOWNTO 0);
	w_en : IN std_logic);
END reg_file;

ARCHITECTURE a_reg_file OF reg_file IS


	COMPONENT nReg IS
	GENERIC ( n : integer := 32);
	PORT( Clk,Rst : IN std_logic;
		in_reg : IN std_logic_vector(n-1 DOWNTO 0);
		enable:IN std_logic;
		out_reg : OUT std_logic_vector(n-1 DOWNTO 0));
	END COMPONENT;

	COMPONENT Decod IS
	PORT(   out_decod : out std_logic_vector(7 DOWNTO 0);
		enable:in std_logic;
		in_decod: in std_logic_vector(2 DOWNTO 0)
		);
	END COMPONENT;
	

signal R0,R1,R2,R3,R4,R5,R6,R7:std_logic_vector(REG_WIDTH-1 DOWNTO 0);
signal Write_enable:std_logic_vector(7 DOWNTO 0);

begin
D_W:Decod PORT MAP(Write_enable,w_en,w_addr);

R_0:nReg PORT MAP(Clk,reset_regs,write_data,Write_enable(0),R0 );
R_1:nReg PORT MAP(Clk,reset_regs,write_data,Write_enable(1),R1 );
R_2:nReg PORT MAP(Clk,reset_regs,write_data,Write_enable(2),R2 );
R_3:nReg PORT MAP(Clk,reset_regs,write_data,Write_enable(3),R3 );
R_4:nReg PORT MAP(Clk,reset_regs,write_data,Write_enable(4),R4 );
R_5:nReg PORT MAP(Clk,reset_regs,write_data,Write_enable(5),R5 );
R_6:nReg PORT MAP(Clk,reset_regs,write_data,Write_enable(6),R6 );
R_7:nReg PORT MAP(Clk,reset_regs,write_data,Write_enable(7),R7 );
--Memory_enable<=not(w_en);

-- CT:Counter PORT MAP(Clk,reset_reg,Address);
-- Ram:Ram_Memory PORT MAP(Clk,Memory_enable,Address,data_i_o,Memory_bus);
--*****************Read data register
		read_data1 <=R0 when r_addr1="000"
		else(others=>'Z');
		read_data1 <=R1 when r_addr1="001"else
		(others=>'Z');
		read_data1 <=R2 when r_addr1="010"else
		(others=>'Z');
		read_data1 <=R3 when r_addr1="011"else
		(others=>'Z');
		read_data1 <=R4 when r_addr1="100"else
		(others=>'Z');
		read_data1 <=R5 when r_addr1="101"else
		(others=>'Z');
		read_data1 <=R6 when r_addr1="110"else
		(others=>'Z');
		read_data1 <=R7 when r_addr1="111"else
		(others=>'Z');

		read_data2 <=R0 when r_addr2="000"
		else(others=>'Z');
		read_data2 <=R1 when r_addr2="001"else
		(others=>'Z');
		read_data2 <=R2 when r_addr2="010"else
		(others=>'Z');
		read_data2 <=R3 when r_addr2="011"else
		(others=>'Z');
		read_data2 <=R4 when r_addr2="100"else
		(others=>'Z');
		read_data2 <=R5 when r_addr2="101"else
		(others=>'Z');
		read_data2 <=R6 when r_addr2="110"else
		(others=>'Z');
		read_data2 <=R7 when r_addr2="111"else
		(others=>'Z');

end a_reg_file;



