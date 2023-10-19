LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY datapathMultiplication IS
    PORT(
        -- Clock and Reset
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;

        SA,SB,SA1,SA0,SB1,SB0,MAC,MA1,MA0,MB1,MB0,LoadP,RPclr,sINC,sCLR,iINC,iCLR:in STD_LOGIC;
        A,B:in STD_LOGIC_VECTOR(3 downto 0);
        P:OUT STD_LOGIC_VECTOR(3 downto 0);
        RS,LPI:OUT STD_LOGIC;
        );
END ENTITY;

ARCHITECTURE rtl of datapathMultiplication IS

    SIGNAL int_Bus,int_Ain,int_Bin,int_Aout,int_Bout,int_MAout,int_MBout,int_Pout,int_B0EXT,int_MACout: STD_LOGIC_VECTOR(7 downto 0);
    SIGNAL int_RIout: STD_LOGIC_VECTOR(1 downto 0);

    COMPONENT byteAdder IS
	    PORT(
		    i_Ai, i_Bi		: IN	STD_LOGIC_VECTOR(7 downto 0);
		    i_Control       : IN    STD_LOGIC;
		    o_CarryOut		: OUT	STD_LOGIC;
		    o_Sum			: OUT	STD_LOGIC_VECTOR(7 downto 0));
    END COMPONENT;

    COMPONENT algobits8shiftreg IS
        PORT(
            i_S0,i_S1:IN STD_LOGIC;
            i_resetBar, i_clock:IN	STD_LOGIC;
            i_I:IN STD_LOGIC_VECTOR(7 downto 0);
            o_O:OUT STD_LOGIC_VECTOR(7 downto 0));
    END COMPONENT;

    COMPONENT mux4to1 IS
    PORT(
        i_S:IN STD_LOGIC_VECTOR(1 downto 0);
        i_I:IN STD_LOGIC_VECTOR(3 downto 0);
        o_O:OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT mux2to1 IS
    PORT(
        i_S,i_a,i_b:IN STD_LOGIC;
        o_O:OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT tFF IS
	PORT(
		i_t		: IN	STD_LOGIC;
		i_clock		: IN	STD_LOGIC;
		o_q, o_qBar	: OUT	STD_LOGIC);
    END COMPONENT;

    COMPONENT bit2counter is
    Port (
        i_clock : in STD_LOGIC;
        i_enable : in STD_LOGIC;
        i_resetBar : in STD_LOGIC;
        o_count : out STD_LOGIC_VECTOR(1 downto 0)
    );
    end COMPONENT;

    COMPONENT Reg_8 IS
    PORT(
        i_resetBar, i_load: IN STD_LOGIC;
        i_clock: IN STD_LOGIC;
        i_Value: IN STD_LOGIC_VECTOR(7 downto 0);
        o_Value: OUT STD_LOGIC_VECTOR(7 downto 0));
    END COMPONENT;
BEGIN

    int_B0EXT<=(others=>int_Bout(0));
    LPI<= int_RIout(1) and int_RIout(0);

SAQ: mux2to1
    PORT MAP(
        i_S => SA,
        i_a => ((3 downto 0)=>A,others=>A(3)),
        i_b => int_Bus,
        o_O => int_Ain
    );

SBQ: mux2to1
    PORT MAP(
        i_S => SB,
        i_a => ((3 downto 0)=>B,others=>B(3)),
        i_b => int_Bus,
        o_O => int_Bin
    );

RA: algobits8shiftreg
    PORT MAP(
        i_S0 => SA0,
        i_S1 => SA1,
        i_resetBar => reset,
        i_clock => clk,
        i_I => int_Ain,
        o_O => int_Aout
    );

RB: algobits8shiftreg
    PORT MAP(
        i_S0 => SB0,
        i_S1 => SB1,
        i_resetBar => reset,
        i_clock => clk,
        i_I => int_Bin,
        o_O => int_Bout
    );

MACQ: mux2to1
    PORT MAP(
        i_S => MAC,
        i_a => int_Aout,
        i_b => int_Aout and int_B0EXT,
        o_O => int_MACout
    );

MAQ: mux4to1
    PORT MAP(
        i_S=> MA1 & MA0,
        i_I=> (not int_Pout) & "00000001" & (not int_Aout) & int_MACout,
        o_O=> int_MAout
    );

MBQ: mux4to1
    PORT MAP(
        i_S=> MB1 & MB0,
        i_I=> int_Pout & "00000001" & (not int_Bout) & int_Bout,
        o_O=> int_MBout
    );

ADDER: byteAdder
	PORT MAP(
	    i_Ai => int_MAout,
        i_Bi =>	int_MBout,
	    i_Control => '0',
	    o_Sum => int_Bus
    );

RP: Reg_8
    PORT MAP(
        i_resetBar => reset,
        i_load => LoadP,
        i_clock => clk,
        i_Value => int_Bus,
        o_Value => int_Pout
    );

RS: tFF
	PORT MAP(
		i_t => sINC,
		i_clock => clk,
		o_q => RS
    );

RI: bit2counter
    PORT MAP(
        i_clock => clk,
        i_enable => iINC,
        i_resetBar => reset,
        o_count => int_RIout
    );

END ARCHITECTURE;