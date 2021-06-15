LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
ENTITY Integration IS
PORT(  
	Clk : IN std_logic;
	Rst : IN std_logic;
    --7agat hattetshal lam an3ml full integration
    RegDJMPAddp	 :      IN std_logic_vector(19 DOWNTO 0);
    RegCJMPAddp	 :      IN std_logic_vector(19 DOWNTO 0);
    PCSELp	     :	    IN std_logic_vector(1 DOWNTO 0);
    PCALUSELp	 :	    IN std_logic;
    InPort:IN std_logic_vector (31 DOWNTO 0);
    OutPort:OUT std_logic_vector (31 DOWNTO 0);
    WR_EX_MEMI:IN std_logic_vector(2 DOWNTO 0);
    WE_EX_MEMI:IN std_logic;
    WR_MEM_WBI:IN std_logic_vector(2 DOWNTO 0);
    WE_MEM_WBI:IN std_logic
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
    GENERIC(AddressWidth : INTEGER := 20);
    PORT (
        InPort_in        :     IN std_logic_vector(31 DOWNTO 0);
        InPort_out       :     OUT std_logic_vector(31 DOWNTO 0);
        clk              :      IN  std_logic;
        WB		 :      IN  std_logic_vector(AddressWidth-1 DOWNTO 0);
        RegDJMPAdd	 :      IN  std_logic_vector(AddressWidth-1 DOWNTO 0);
        RegCJMPAdd	 :      IN  std_logic_vector(AddressWidth-1 DOWNTO 0);
        PCSEL	         :	    IN  std_logic_vector(1 DOWNTO 0);
        PCALUSEL	 :	    IN  std_logic;
        STALL		 :	    IN  std_logic;
        Instruction	 :	    OUT std_logic_vector(31 DOWNTO 0);
        PCNext   	 :      OUT std_logic_vector(AddressWidth-1 DOWNTO 0)        
        );
    END COMPONENT;
        --stall=0 for now
       -- Fetch_Stage:  Fetch  port map(InPort,INportSignalIN_Fetch,OutPort,OUTportSignalIN_Fetch,Clk,WBP,RegDJMPAddp,RegCJMPAddp,PCSELp,PCALUSELp,'0',INST_IN,ENABLEINSTRp,DataINp,PCNext_IN_Fetch);

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
            InPort_out  :    OUT std_logic_vector(REG_WIDTH-1 DOWNTO 0) 
             ); 
            
    END Component;


    COMPONENT FU IS
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
    --

    END COMPONENT;
    COMPONENT ExcuteStage IS
    GENERIC ( REG_WIDTH : integer := 32);
    PORT( 	Reg1        	:    IN std_logic_vector(REG_WIDTH-1 DOWNTO 0);
            Reg2       	:    IN std_logic_vector(REG_WIDTH-1 DOWNTO 0);
            Imm        	:    IN std_logic_vector(REG_WIDTH-1 DOWNTO 0);
            WriteReg1_in    :    IN std_logic_vector(2 DOWNTO 0);
            ReadReg1_in     :    IN std_logic_vector(2 DOWNTO 0);
            PCADD_in        :    IN std_logic_vector(19 DOWNTO 0);
            WriteReg1_out   :    OUT std_logic_vector(2 DOWNTO 0);
            ReadReg1_out    :    OUT std_logic_vector(2 DOWNTO 0);
            PCADD_out   	:    OUT std_logic_vector(19 DOWNTO 0);
            ExcuteOutput    :    OUT std_logic_vector(REG_WIDTH-1 DOWNTO 0);
            InPort_in       :    IN std_logic_vector(REG_WIDTH-1 DOWNTO 0);
            InPort_out      :    OUT std_logic_vector(REG_WIDTH-1 DOWNTO 0);
            OutPort         :    OUT std_logic_vector(REG_WIDTH-1 DOWNTO 0);
            Reg1_OUT        :    OUT std_logic_vector(REG_WIDTH-1 DOWNTO 0);
            CU_InnerMUX1SEL :    IN std_logic_vector(1 DOWNTO 0);
            CU_InnerMUX2SEL :    IN std_logic;
            CU_CCR          :    IN std_logic_vector(3 DOWNTO 0);
            ALUOP           :    IN std_logic_vector(2 DOWNTO 0);
            FU_SEL0         :    IN std_logic_vector(1 DOWNTO 0);
            FU_SEL1         :    IN std_logic_vector(1 DOWNTO 0);
            CU_MEM_IN       :    IN std_logic_vector(6 DOWNTO 0);
            CU_MEM_OUT      :    OUT std_logic_vector(6 DOWNTO 0);
            CU_WB_IN        :    IN std_logic_vector(2 DOWNTO 0);
            CU_WB_OUT       :    OUT std_logic_vector(2 DOWNTO 0); 
            ExcuteForwarding:    IN std_logic_vector(REG_WIDTH-1 DOWNTO 0);
            MemoryForwarding:    IN std_logic_vector(REG_WIDTH-1 DOWNTO 0)
            ); 

    END COMPONENT;

    COMPONENT memorystage IS
    GENERIC ( REG_WIDTH : integer := 32);
    PORT   (clk             : IN  std_logic;
            CU_MEMW         : IN  std_logic;  
            CU_MEMR         : IN  std_logic;
            CU_MEMDataSel   : IN  std_logic;
            CU_MEMAddressSel: IN  std_logic;
            CU_SPOperation  : IN  std_logic_vector(1 DOWNTO 0);
            MemoryOutput    : OUT std_logic_vector(REG_WIDTH-1 DOWNTO 0);
            InPort_in       : IN std_logic_vector(REG_WIDTH-1 DOWNTO 0);
            InPort_out      : OUT std_logic_vector(REG_WIDTH-1 DOWNTO 0);
            CU_WB_IN        : IN std_logic_vector(2 DOWNTO 0);
            CU_WB_OUT       : OUT std_logic_vector(2 DOWNTO 0);   
            Reg1            : IN std_logic_vector(REG_WIDTH-1 DOWNTO 0);
            PCAdd           : IN std_logic_vector(REG_WIDTH-1 DOWNTO 0);
            ResultALU       : IN std_logic_vector(REG_WIDTH-1 DOWNTO 0);
            WriteReg1_in    : IN std_logic_vector(2 DOWNTO 0);
            WriteReg1_out   : OUT std_logic_vector(2 DOWNTO 0)
        );  
    END COMPONENT;


    COMPONENT wbstage IS
    GENERIC (n : integer := 32);
    PORT   (MemoryRead             : IN  std_logic_vector(n-1 DOWNTO 0);   
            ResultAlu              : IN  std_logic_vector(n-1 DOWNTO 0);
            InPort                 : IN  std_logic_vector(n-1 DOWNTO 0);
            CU_WBS                 : IN  std_logic_vector(1 DOWNTO 0);
            WBOutput               : OUT std_logic_vector(n-1 DOWNTO 0));
    END COMPONENT;
    ----------------------signals
    --WB_stage:  wbstage  port map(MemoryRead_WB,ResultAlu_WB,INport_WB,CU_WBS,WBOutput_WB);


--ba2y el forwarding unit lama nedy el execute stage el inputs fa nstna shwya
--FUnit: FU port map(WR_EX_MEMI,WE_EX_MEMI,WR_MEM_WBI,WE_MEM_WBI,)
----------------------------------------------------------------------fetch signals
signal stall_Fetch:std_logic;
signal INportSignalIN_Fetch : std_logic_vector(31 DOWNTO 0);
signal INST_IN : std_logic_vector(31 DOWNTO 0);
signal PCNext_IN_Fetch : std_logic_vector(19 DOWNTO 0);
--0->31 INport
--32->63 inst
--64->83 pcnext
signal IF_ID_Signal_IN  :  std_logic_vector(83 DOWNTO 0);
signal IF_ID_Signal_OUT :  std_logic_vector(83 DOWNTO 0);
-------------------------------------------------------------------------
-----------------------------------------------------------------Decode Signals
signal INportSignalIN_Decode : std_logic_vector(31 DOWNTO 0);
signal INST_Decode : std_logic_vector(31 DOWNTO 0);
signal PCNext_IN_Decode : std_logic_vector(19 DOWNTO 0);
signal WriteData_Decode :std_logic_vector(31 DOWNTO 0);
signal WriteRegADD_Decode:std_logic_vector(2 DOWNTO 0);
SIGNAL WriteEnable_Decode :std_logic;
----
signal IMM_Decode :std_logic_vector(31 DOWNTO 0);
signal Rsrc_Decode :std_logic_vector(2 DOWNTO 0);
signal Rdst_Decode :std_logic_vector(2 DOWNTO 0);
signal RegData1 :std_logic_vector(31 DOWNTO 0);
signal RegData2 :std_logic_vector(31 DOWNTO 0);
signal PCADD_OUT_Decode :std_logic_vector(19 DOWNTO 0);
signal InPort_out_Decode :std_logic_vector(31 DOWNTO 0);
  --imm 0->31
  --rsrc 32->34
  --rdst 35->37
  --reg1 38->69
  --reg2 70->101
  --pcout 102->121
  --inport 122->153
SIGNAL ID_EX_Signal_IN:std_logic_vector(153 DOWNTO 0);
SIGNAL ID_EX_Signal_OUT:std_logic_vector(153 DOWNTO 0);
----------------------------------------------------------------------
-----------------------------------------------------------------------------------Excute stage signals
signal RegData1_EX :std_logic_vector(31 DOWNTO 0);
signal RegData2_EX :std_logic_vector(31 DOWNTO 0);
signal IMM_EX :std_logic_vector(31 DOWNTO 0);
signal Rdst_IN_EX :std_logic_vector(2 DOWNTO 0);
signal Rsrc_IN_EX :std_logic_vector(2 DOWNTO 0);
signal PCADD_IN_EX :std_logic_vector(19 DOWNTO 0);
signal InPort_IN_EX :std_logic_vector(31 DOWNTO 0);

signal ExcuteForwarding_EX:std_logic_vector(31 DOWNTO 0);
signal MemoryForwarding_EX:std_logic_vector(31 DOWNTO 0);
--out
signal Rdst_OUT_EX :std_logic_vector(2 DOWNTO 0);
signal Rsrc_OUT_EX :std_logic_vector(2 DOWNTO 0);
signal PCADD_OUT_EX :std_logic_vector(19 DOWNTO 0);
signal ExcuteOutput_EX :std_logic_vector(31 DOWNTO 0);
signal InPort_OUT_EX :std_logic_vector(31 DOWNTO 0);
signal OutPort_EX :std_logic_vector(31 DOWNTO 0);
signal Reg1_out_EX:std_logic_vector(31 DOWNTO 0);
--cu
signal CU_InnerMUX1SEL_EX:std_logic_vector(1 DOWNTO 0);
signal CU_InnerMUX2SEL_EX:std_logic;
signal CU_CCR:std_logic_vector(3 DOWNTO 0);
signal CU_ALU_OP:std_logic_vector(2 DOWNTO 0);
signal CU_MEM_IN_EX:std_logic_vector(6 DOWNTO 0);
signal CU_MEM_OUT_EX:std_logic_vector(6 DOWNTO 0);
signal CU_WB_IN_EX:std_logic_vector(2 DOWNTO 0);
signal CU_WB_OUT_EX:std_logic_vector(2 DOWNTO 0);
--fu
signal FU_SEL0_EX:std_logic_vector(1 DOWNTO 0);
signal FU_SEL1_EX:std_logic_vector(1 DOWNTO 0);
---
--rdst 0->2
--rsrc 3->5
--pc 6->25
--ALU 26->57
--inport 58->89
--outport 90->121
--MEMCU 122->128
--cuwb 129->131
--Reg1 132->163
signal EX_MEM_Signal_IN  :std_logic_vector(163 DOWNTO 0);
signal EX_MEM_Signal_Out :std_logic_vector(163 DOWNTO 0);
---------------------------------------------------------------------------
----------------------------------------------------------------------memory stage signals
--cu 
signal CU_MEMR_mem:std_logic;
signal CU_MEMW_mem:std_logic;
signal CU_MEMDataSel_mem:std_logic;
signal CU_MEMAddSel_mem:std_logic;
signal CU_SP_Sel:std_logic_vector(1 DOWNTO 0);
--out
signal Memory_Out_mem:std_logic_vector (31 DOWNTO 0);
signal INport_OUT_mem:std_logic_vector(31 DOWNTO 0);
signal CU_WB_OUT_mem:std_logic_vector(2 DOWNTO 0);
--signal RegData2_OUT_mem:std_logic_vector(31 DOWNTO 0);
signal WriteReg1_OUT_mem:std_logic_vector(2 DOWNTO 0);
--in
signal INport_IN_mem:std_logic_vector(31 DOWNTO 0);
signal CU_WB_IN_mem:std_logic_vector(2 DOWNTO 0);
--signal RegData2_IN_mem:std_logic_vector(31 DOWNTO 0);
signal RegData1_mem:std_logic_vector(31 DOWNTO 0);
signal PCAdd_IN_mem:std_logic_vector(31 DOWNTO 0);
signal ResultALU_mem:std_logic_vector(31 DOWNTO 0);
signal WriteReg1_in_mem:std_logic_vector(2 DOWNTO 0);
--Result alu 0->31
--memory out 32->63
--port in 64->95
--cU_WB 96->98
--WriteReg1_in 99->101
signal MEM_WB_Signal_IN :std_logic_vector(101 DOWNTO 0);
signal MEM_WB_Signal_OUT :std_logic_vector(101 DOWNTO 0);
---signal el write reg 1 msh da5la 3ala el wb bas hated5ol 3ala el alu w el fetch 

-------------------------------------------------------------- WriteBack signals  
signal MemoryRead_WB:std_logic_vector(31 DOWNTO 0);
signal ResultAlu_WB:std_logic_vector(31 DOWNTO 0);
signal INport_WB:std_logic_vector(31 DOWNTO 0);
signal CU_WBS:std_logic_vector(1 DOWNTO 0);
signal WBOutput_WB:std_logic_vector(31 DOWNTO 0);
--------------------------


----------------------------------------------------------------------
--------------------------------------
BEGIN
Fetch_Stage:  Fetch  port map(InPort,INportSignalIN_Fetch,Clk,WBOutput_WB(19 DOWNTO 0),RegDJMPAddp,RegCJMPAddp,PCSELp,PCALUSELp,'0',INST_IN,PCNext_IN_Fetch(19 DOWNTO 0));
RegF_Signal:nReg generic map(84) port map(clk,Rst,IF_ID_Signal_IN,'1',IF_ID_Signal_OUT);
Decode_stage: decodStage  port map (INST_Decode,WriteData_Decode,WriteRegADD_Decode,WriteEnable_Decode,clk,Rst,IMM_Decode, Rsrc_Decode, Rdst_Decode , RegData1,RegData2, PCNext_IN_Decode ,PCADD_OUT_Decode,INportSignalIN_Decode,InPort_out_Decode);
RegD:nReg generic map(154) port map(clk,Rst,ID_EX_Signal_IN,'1',ID_EX_Signal_OUT);
Excute_stage: ExcuteStage port map(RegData1_EX,RegData2_EX,IMM_EX,Rdst_IN_EX,Rsrc_IN_EX,PCADD_IN_EX,Rdst_OUT_EX,Rsrc_OUT_EX,PCADD_OUT_EX,ExcuteOutput_EX,InPort_IN_EX,InPort_OUT_EX,OutPort_EX,Reg1_out_EX,CU_InnerMUX1SEL_EX,CU_InnerMUX2SEL_EX,CU_CCR,CU_ALU_OP,FU_SEL0_EX,FU_SEL1_EX,CU_MEM_IN_EX,CU_MEM_OUT_EX,CU_WB_IN_EX,CU_WB_OUT_EX,ExcuteForwarding_EX,MemoryForwarding_EX);
RegE:nReg generic map(164) port map(clk,Rst,EX_MEM_Signal_IN,'1',EX_MEM_Signal_Out);
Mem_Stage:  memorystage  port map(clk,CU_MEMW_mem,CU_MEMR_mem,CU_MEMDataSel_mem,CU_MEMAddSel_mem,CU_SP_Sel,Memory_Out_mem,INport_IN_mem,INport_OUT_mem,CU_WB_IN_mem,CU_WB_OUT_mem,RegData1_mem,PCAdd_IN_mem,ResultALU_mem,WriteReg1_in_mem,WriteReg1_OUT_mem);
RegM:nReg generic map(102) port map(clk,Rst,MEM_WB_Signal_IN,'1',MEM_WB_Signal_OUT);
WB_stage:  wbstage  port map(MemoryRead_WB,ResultAlu_WB,INport_WB,CU_WBS,WBOutput_WB);


---fetch signal setting
IF_ID_Signal_IN(31 DOWNTO 0)<=INportSignalIN_Fetch;
IF_ID_Signal_IN(63 DOWNTO 32)<=INST_IN;
IF_ID_Signal_IN(83 DOWNTO 64)<=PCNext_IN_Fetch;
---fetch signal expansion
INportSignalIN_Decode<=IF_ID_Signal_OUT(31 DOWNTO 0);
INST_Decode<=IF_ID_Signal_OUT(63 DOWNTO 32);
PCNext_IN_Decode<=IF_ID_Signal_OUT(83 DOWNTO 64);
---decode signal setting
ID_EX_Signal_IN(31 DOWNTO 0)<=IMM_Decode;
ID_EX_Signal_IN(34 DOWNTO 32)<=Rsrc_Decode;
ID_EX_Signal_IN(37 DOWNTO 35)<=Rdst_Decode;
ID_EX_Signal_IN(69 DOWNTO 38)<=RegData1;
ID_EX_Signal_IN(101 DOWNTO 70)<=RegData2;
ID_EX_Signal_IN(121 DOWNTO 102)<=PCADD_OUT_Decode;
ID_EX_Signal_IN(153 DOWNTO 122)<=InPort_out_Decode;
----decode signal expantion
IMM_EX<=ID_EX_Signal_OUT(31 DOWNTO 0);
Rsrc_IN_EX<=ID_EX_Signal_OUT(34 DOWNTO 32);
Rdst_IN_EX<=ID_EX_Signal_OUT(37 DOWNTO 35);
RegData1_EX<=ID_EX_Signal_OUT(69 DOWNTO 38);
RegData2_EX<=ID_EX_Signal_OUT(101 DOWNTO 70);
PCADD_IN_EX<=ID_EX_Signal_OUT(121 DOWNTO 102);
InPort_IN_EX<=ID_EX_Signal_OUT(153 DOWNTO 122);
-------------excute signal setting
--EX_MEM_Signal_IN<=Reg1_out_EX&CU_WB_OUT_EX &CU_MEM_OUT_EX &OutPort_EX & InPort_OUT_EX & ExcuteOutput_EX & PCADD_OUT_EX & Rsrc_OUT_EX & Rdst_OUT_EX ;
 EX_MEM_Signal_IN(2 DOWNTO 0)<=Rdst_OUT_EX;
 EX_MEM_Signal_IN(5 DOWNTO 3)<=Rsrc_OUT_EX;
 EX_MEM_Signal_IN(25 DOWNTO 6)<=PCADD_OUT_EX;
 EX_MEM_Signal_IN(57 DOWNTO 26)<=ExcuteOutput_EX;
 EX_MEM_Signal_IN(89 DOWNTO 58)<=InPort_OUT_EX;
 EX_MEM_Signal_IN(121 DOWNTO 90)<=OutPort_EX;
 EX_MEM_Signal_IN(128 DOWNTO 122)<=CU_MEM_OUT_EX;
 EX_MEM_Signal_IN(131 DOWNTO 129)<=CU_WB_OUT_EX;
 EX_MEM_Signal_IN(163 DOWNTO 132)<=Reg1_out_EX;
---------------------excute signal expansion
WriteReg1_OUT_mem<=EX_MEM_Signal_Out(2 DOWNTO 0);
PCAdd_IN_mem(19 DOWNTO 0)<=EX_MEM_Signal_Out(25 DOWNTO 6);
PCAdd_IN_mem(31 DOWNTO 20)<="000000000000";
ResultALU_mem<=EX_MEM_Signal_Out(57 DOWNTO 26);
INport_IN_mem<=EX_MEM_Signal_Out(89 DOWNTO 58);
CU_WB_IN_mem<=EX_MEM_Signal_Out(131 DOWNTO 129);
RegData1_mem<=EX_MEM_Signal_Out(163 DOWNTO 132);
--mem cu
----fadel bit wa7da ely hated5ol 3ala el fu
CU_MEMR_mem<=EX_MEM_Signal_Out(122);
CU_MEMW_mem<=EX_MEM_Signal_Out(123);
CU_MEMDataSel_mem<=EX_MEM_Signal_Out(124);
CU_MEMAddSel_mem<=EX_MEM_Signal_Out(125);
CU_SP_Sel<=EX_MEM_Signal_Out(127 DOWNTO 126);
----------------------------------------------memory signal setting

MEM_WB_Signal_IN(31 DOWNTO 0)<=ResultALU_mem;
MEM_WB_Signal_IN(63 DOWNTO 32)<=Memory_Out_mem;
MEM_WB_Signal_IN(95 DOWNTO 64)<=INport_OUT_mem;
MEM_WB_Signal_IN(98 DOWNTO 96)<=CU_WB_OUT_mem;
MEM_WB_Signal_IN(101 DOWNTO 99)<=WriteReg1_OUT_mem;
----------------------------------------------memory signal expansion
MemoryRead_WB<=MEM_WB_Signal_OUT(31 DOWNTO 0);
ResultAlu_WB<=MEM_WB_Signal_OUT(63 DOWNTO 32);
INport_WB<=MEM_WB_Signal_OUT(95 DOWNTO 64);
CU_WBS<=MEM_WB_Signal_OUT(97 DOWNTO 96);


END a_Integration;
