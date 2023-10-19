LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY controlpathMultiplication IS
    PORT(
        i_resetBar, i_clock,i_act:IN	STD_LOGIC;
        A,B:in STD_LOGIC_VECTOR(3 downto 0);
        SA,SB,SA1,SA0,SB1,SB0,MAC,MA1,MA0,MB1,MB0,LoadP,RPclr,sINC,sCLR,iINC,iCLR ,LPI,RS,EN:OUT STD_LOGIC);
END ENTITY;

ARCHITECTURE rtl of controlpathMultiplication IS
    COMPONENT enARdFF_2
		PORT(
			i_resetBar	: IN	STD_LOGIC;
			i_d		: IN	STD_LOGIC;
			i_enable	: IN	STD_LOGIC;
			i_clock		: IN	STD_LOGIC;
			o_q, o_qBar	: OUT	STD_LOGIC);
	END COMPONENT;
BEGIN

S6: enARdFF_2
    PORT MAP(i_resetBar => i_resetBar,
             i_d => (S4 and LPI and not RS)or S5,
             i_enable => '1', 
			 i_clock => i_clock,
			 o_q => EN);

S5: enARdFF_2
    PORT MAP(i_resetBar => i_resetBar,
             i_d => S4 and LPI and RS,
             i_enable => '1', 
			 i_clock => i_clock,
			 o_q => S5 & LoadP & MA1 & MA0 & MB1);

S4: enARdFF_2
    PORT MAP(i_resetBar => i_resetBar,
             i_d => S3,
             i_enable => '1', 
			 i_clock => i_clock,
			 o_q => S4 & SA0 & SB0 & iINC);

S3: enARdFF_2
    PORT MAP(i_resetBar => i_resetBar,
             i_d => S2 or (S1 and not B3) or (S0 and not A3 and not B3) or (S4 and LPI),
             i_enable => '1', 
			 i_clock => i_clock,
			 o_q => S3 & LoadP & MB1 & MB0 & MAC);

S2: enARdFF_2
    PORT MAP(i_resetBar => i_resetBar,
             i_d => (B3 and S1)or(B3 and not A3 and S0),
             i_enable => '1', 
			 i_clock => i_clock,
			 o_q => S2 & sINC & SB1 & SB & MA1 & MB0 & SB0);

S1: enARdFF_2
    PORT MAP(i_resetBar => i_resetBar,
             i_d => A3 and S0,
             i_enable => '1', 
			 i_clock => i_clock,
			 o_q => S1 & sINC & SA1 & SA & MA0 & MB1 & SA0);

S0: enARdFF_2
    PORT MAP(i_resetBar => i_resetBar,
             i_d => i_act,
             i_enable => '1', 
			 i_clock => i_clock,
			 o_q => S0 & RPclr & sCLR & SA1 & SB1 & iCLR);

END ARCHITECTURE;