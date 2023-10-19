LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mux4to1 IS
    PORT(
        i_S:IN STD_LOGIC_VECTOR(1 downto 0);
        i_I:IN STD_LOGIC_VECTOR(3 downto 0);
        o_O:OUT STD_LOGIC);
END ENTITY;

ARCHITECTURE rtl OF mux4to1 IS
    SIGNAL int_SINV: STD_LOGIC_VECTOR(1 downto 0);
    SIGNAL int_I:STD_LOGIC_VECTOR(3 downto 0);
    SIGNAL A0,A1,A2,A3:STD_LOGIC;
BEGIN 
	 int_I<=i_I;
    int_SINV <= not i_S;
    A3<= int_I(3) and i_S(0) and i_S(1);
    A2<= int_I(2) and int_SINV(0) and i_S(1);
    A1<= int_I(1) and i_S(0) and int_SINV(1);
    A0<= int_I(0) and int_SINV(0) and int_SINV(1);
    o_O<=A3 or A2 or A1 or A0;
END ARCHITECTURE;