LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY TwoComplement_4bit IS
    PORT(
        A : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        Load: IN STD_LOGIC;
        B : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END TwoComplement_4bit;

ARCHITECTURE Behav OF TwoComplement_4bit IS
BEGIN
    PROCESS(A, Load)
    BEGIN
        IF Load = '1' THEN
            B <= NOT A + "0001";
        ELSE
            B <= A;
        END IF;
    END PROCESS;
END Behav;
    