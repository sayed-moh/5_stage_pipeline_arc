LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
ENTITY Integration IS
PORT(  
	Clk : IN std_logic;
	Rst : IN std_logic;
    --7agat hattetshal lam an3ml full integration
    WBP		     :      IN std_logic_vector(19 DOWNTO 0);
    RegDJMPAddp	 :      IN std_logic_vector(19 DOWNTO 0);
    RegCJMPAddp	 :      IN std_logic_vector(19 DOWNTO 0);
    PCSELp	     :	    IN std_logic_vector(1 DOWNTO 0);
    PCALUSELp	 :	    IN std_logic;
    DataINp    	 :      IN std_logic_vector(31 DOWNTO 0);
    ENABLEINSTRp :IN  std_logic;
	InPort:IN std_logic_vector (31 DOWNTO 0);
	OutPort:IN std_logic_vector (31 DOWNTO 0)
);
	
END ENTITY;

ARCHITECTURE a_Integration OF Integration
IS
    Component nReg IS
        GENERIC ( n : integer := 32);
        PORT( Clk,Rst : IN std_logic;
        in_reg : IN std_logic_vector(n-1 DOWNTO 0);
        enable:IN std_logic;
        out_reg : OUT std_logic_vector(n-1 DOWNTO 0));
    END Component;
    
    Component Fetch IS
    
    GENERIC(
        AddressWidth : INTEGER := 20
        );
    PORT (
        InPort_in        :     IN std_logic_vector(31 DOWNTO 0);
        InPort_out       :     OUT std_logic_vector(31 DOWNTO 0);
        OutPort_in       :     IN std_logic_vector(31 DOWNTO 0);
        OutPort_out      :     OUT std_logic_vector(31 DOWNTO 0);

        clk          :      IN  std_logic;
        WB		     :      IN  std_logic_vector(AddressWidth-1 DOWNTO 0);
        RegDJMPAdd	 :      IN  std_logic_vector(AddressWidth-1 DOWNTO 0);
        RegCJMPAdd	 :      IN  std_logic_vector(AddressWidth-1 DOWNTO 0);
        PCSEL	     :	    IN  std_logic_vector(1 DOWNTO 0);
        PCALUSEL	 :	    IN  std_logic;
        STALL		 :	    IN  std_logic;
        Instruction	 :	    OUT std_logic_vector(31 DOWNTO 0);
        ENABLEINSTR	 :      IN  std_logic;
        DataIN    	 :      IN  std_logic_vector(31 DOWNTO 0);
        PCNext   	 :      OUT std_logic_vector(AddressWidth-1 DOWNTO 0)        
        );
END COMPONENT;
        --stall=0 for now
        --Fetch_Stage:  Fetch generic map(20) port map(InPort,IF_ID_Signal_IN(31 DOWNTO 0),OutPort,IF_ID_Signal_IN(63 DOWNTO 32),Clk,WBP,RegDJMPAddp,RegCJMPAddp,PCSELp,PCALUSELp,0,IF_ID_Signal_IN(95 DOWNTO 64),ENABLEINSTRp,DataINp,IF_ID_Signal_IN(115 DOWNTO 96));

    Component decodStage IS
    GENERIC ( REG_WIDTH : integer := 32);
    PORT( 	instr       :    IN std_logic_vector(REG_WIDTH-1 DOWNTO 0);
            WriteData   :    IN std_logic_vector(REG_WIDTH-1 DOWNTO 0);
            WriteReg    :    IN std_logic_vector(2 DOWNTO 0);
            WriteEnable :    IN std_logic;
            clk 	    :    IN std_logic;
            reset       :    IN std_logic;
            Imm         :    OUT std_logic_vector(REG_WIDTH-1 DOWNTO 0);
            Rsrc        :    OUT std_logic_vector(2 DOWNTO 0);
            Rdst        :    OUT std_logic_vector(2 DOWNTO 0);
            Reg1        :    OUT std_logic_vector(REG_WIDTH-1 DOWNTO 0);
            Reg2        :    OUT std_logic_vector(REG_WIDTH-1 DOWNTO 0);
            PCADD_in    :    IN std_logic_vector(19 DOWNTO 0);
            PCADD_out   :    OUT std_logic_vector(19 DOWNTO 0);
            InPort_in   :    IN std_logic_vector(REG_WIDTH-1 DOWNTO 0);
            InPort_out  :    OUT std_logic_vector(REG_WIDTH-1 DOWNTO 0);
            OutPort_in  :    IN std_logic_vector(REG_WIDTH-1 DOWNTO 0);
            OutPort_out :    OUT std_logic_vector(REG_WIDTH-1 DOWNTO 0);
        
            WD1S        :    IN std_logic  ); --el mfrood ttl8y
            
    END Component;
--0->31 INport
--32->63 Outport
--64->95 inst
--96->115 pcnext
signal IF_ID_Signal_IN  :  std_logic_vector(115 DOWNTO 0);
signal IF_ID_Signal_OUT :  std_logic_vector(115 DOWNTO 0);--byd5ol el decod stage
--0->31 imm
--32->63 RData1
--64->95 RData2
--96->115 pcAdd
--116->147 inport
--148->179 outport
signal ID_EX_Signal_IN :std_logic_vector(179 DOWNTO 0);--bt5rog mn el decod stage
signal ID_EX_Signal_out :std_logic_vector(179 DOWNTO 0);

BEGIN
Fetch_Stage:  Fetch  port map(InPort,IF_ID_Signal_IN(31 DOWNTO 0),OutPort,IF_ID_Signal_IN(63 DOWNTO 32),Clk,WBP,RegDJMPAddp,RegCJMPAddp,PCSELp,PCALUSELp,'0',IF_ID_Signal_IN(95 DOWNTO 64),ENABLEINSTRp,DataINp,IF_ID_Signal_IN(115 DOWNTO 96));
Regi1:nReg generic map(116) port map(clk,Rst,IF_ID_Signal_IN,'1',IF_ID_Signal_OUT);
Decod_stage: decodStage   port map (IF_ID_Signal_OUT(95 DOWNTO 64),"00000000000000000000000000000000", IF_ID_Signal_OUT(72 DOWNTO 70),'0',clk,Rst,ID_EX_Signal_IN(31 DOWNTO 0), IF_ID_Signal_OUT(75 DOWNTO 73),IF_ID_Signal_OUT(72 DOWNTO 70),ID_EX_Signal_IN(63 DOWNTO 32),ID_EX_Signal_IN(95 DOWNTO 64),IF_ID_Signal_OUT(115 DOWNTO 96),ID_EX_Signal_IN(115 DOWNTO 96),IF_ID_Signal_OUT(31 DOWNTO 0),ID_EX_Signal_IN(147 DOWNTO 116),IF_ID_Signal_OUT(63 DOWNTO 32),ID_EX_Signal_IN(179 DOWNTO 148),'1');

END a_Integration;