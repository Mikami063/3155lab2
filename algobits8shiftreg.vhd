LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY algobits8shiftreg IS
    PORT(
        i_S0,i_S1:IN STD_LOGIC;
        i_resetBar, i_clock:IN	STD_LOGIC;
        i_I:IN STD_LOGIC_VECTOR(7 downto 0);
        o_O:OUT STD_LOGIC_VECTOR(7 downto 0));
END ENTITY;

ARCHITECTURE rtl OF algobits8shiftreg IS
    SIGNAL int_A,int_B,int_notB,int_left,int_right: STD_LOGIC_VECTOR(7 downto 0);

    COMPONENT fourtoonemux
        PORT(
            i_S:IN STD_LOGIC_VECTOR(1 downto 0);
            i_I:IN STD_LOGIC_VECTOR(3 downto 0);
            o_O:OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT enARdFF_2
		PORT(
			i_resetBar	: IN	STD_LOGIC;
			i_d		: IN	STD_LOGIC;
			i_enable	: IN	STD_LOGIC;
			i_clock		: IN	STD_LOGIC;
			o_q, o_qBar	: OUT	STD_LOGIC);
	END COMPONENT;

BEGIN

    int_right(6 downto 0) <= int_B(7 downto 1);
    int_right(7) <= int_B(7);
    int_left(7 downto 1)<= int_B(6 downto 0);
    int_left(0)<='0';

loop1:FOR i IN 7 downto 0 GENERATE
    mux: fourtoonemux
    PORT MAP (i_S=> i_S1 & i_S0,
              i_I=> i_I(i) & int_right(i) &  int_left(i) & int_B(i),
              o_O=> int_A(i));
END GENERATE;

loop2:FOR i IN 7 downto 0 GENERATE
    reg: enARdFF_2
    PORT MAP(i_resetBar => i_resetBar,
             i_d => int_A(i),
             i_enable => '1', 
			 i_clock => i_clock,
			 o_q => int_B(i),
             o_qBar => int_notB(i));
END GENERATE;

    o_O<= int_B;

END ARCHITECTURE;
