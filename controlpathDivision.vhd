LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY controlpathDivision IS
    PORT(
        i_resetBar, i_clock,i_act:IN	STD_LOGIC;
        SA0,SA1,SR0,SR1,SQA0,SQA1,SR,ADDC,ADD1,SQ,SQ0,SQ1,SLD: IN std_logic;
        LDA,LDB,LDQ,LDR: IN std_logic;
        INC: IN std_logic;
        ICLR: IN std_logic;
        ICR,GT,S :IN std_logic
        );
END ENTITY;

ARCHITECTURE rtl of controlpathDivision IS
    COMPONENT enARdFF_2
		PORT(
			i_resetBar	: IN	STD_LOGIC;
			i_d		: IN	STD_LOGIC;
			i_enable	: IN	STD_LOGIC;
			i_clock		: IN	STD_LOGIC;
			o_q, o_qBar	: OUT	STD_LOGIC);
	END COMPONENT;
BEGIN

S7: enARdFF_2
    PORT MAP(i_resetBar => i_resetBar,
             i_d => (S3 and not GT and ICR and not S)or (S4 and ICR and not S) or S6,
             i_enable => '1', 
			 i_clock => i_clock,
			 o_q => EN);

S6: enARdFF_2
    PORT MAP(i_resetBar => i_resetBar,
             i_d => S5,
             i_enable => '1', 
			 i_clock => i_clock,
			 o_q => S6 & SR1 & SR0 & SR & ADD1 & SQA0);

S5: enARdFF_2
    PORT MAP(i_resetBar => i_resetBar,
             i_d => (S3 and not GT and ICR and S)or(S4 and ICR and S),
             i_enable => '1', 
			 i_clock => i_clock,
			 o_q => S5 & SQ1 & SQ0 & SQ & ADD1 & SQA1);

S4: enARdFF_2
    PORT MAP(i_resetBar => i_resetBar,
             i_d => S3 AND GT,
             i_enable => '1', 
			 i_clock => i_clock,
			 o_q => S4 & SQ1 & SQ0 & SR1 & SR0 & ADDC & SR);

S3: enARdFF_2
    PORT MAP(i_resetBar => i_resetBar,
             i_d => S2,
             i_enable => '1', 
			 i_clock => i_clock,
			 o_q => S3 & SR1 & SR0 & SA0 & SQ0 & INC);

S2: enARdFF_2
    PORT MAP(i_resetBar => i_resetBar,
             i_d => (S3 and not GT and not ICR)or(S4 and not ICR)or S1,
             i_enable => '1', 
			 i_clock => i_clock,
			 o_q => S2 & SR0);

S1: enARdFF_2
    PORT MAP(i_resetBar => i_resetBar,
             i_d => S0,
             i_enable => '1', 
			 i_clock => i_clock,
			 o_q => S1 & SA1 & SA0);

S0: enARdFF_2
    PORT MAP(i_resetBar => i_resetBar,
             i_d => i_act,
             i_enable => '1', 
			 i_clock => i_clock,
			 o_q => S0 & RC & QC & SLD & ICLR & LDA & LDB);

END ARCHITECTURE;