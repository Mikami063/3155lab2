library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bit2counter is
    Port (
        i_clock : in STD_LOGIC;
        i_enable : in STD_LOGIC;
        i_resetBar : in STD_LOGIC;
        o_count : out STD_LOGIC_VECTOR(1 downto 0)
    );
end entity;

architecture Structural of bit2counter is

    COMPONENT enARdFF_2 IS
	PORT(
		i_resetBar	: IN	STD_LOGIC;
		i_d		: IN	STD_LOGIC;
		i_enable	: IN	STD_LOGIC;
		i_clock		: IN	STD_LOGIC;
		o_q, o_qBar	: OUT	STD_LOGIC);
    END COMPONENT;


    signal LSB, LSB_not, MSB, MSB_not : STD_LOGIC;

begin

    DFF0: enARdFF_2
    port map (
        i_resetBar => i_resetBar,
        i_d => LSB_not,    -- Toggling
        i_enable => i_enable,
        i_clock => i_clock,
        o_q => LSB,
        o_qBar => LSB_not
    );

    DFF1: enARdFF_2
    port map (
        i_resetBar => i_resetBar,
        i_d => MSB and LSB_not, -- Toggle when LSB is high
        i_enable => i_enable,
        i_clock => i_clock,
        o_q => MSB,
        o_qBar => MSB_not
    );

    o_count <= MSB & LSB;

end Structural;
