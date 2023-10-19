LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mux2to1 IS
    PORT(
        i_S,i_a,i_b:IN STD_LOGIC;
        o_O:OUT STD_LOGIC);
END ENTITY;

ARCHITECTURE rtl OF mux2to1 IS
BEGIN 
    o_O<=(i_b and i_S) or (i_a and not i_S);
END ARCHITECTURE;