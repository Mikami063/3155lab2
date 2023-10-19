LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY datapathDivion IS
    PORT(
        clk : IN std_logic;
        reset : IN std_logic;
        SA0,SA1,SR0,SR1,SQA0,SQA1,SR,ADDC,ADD1,SQ,SQ0,SQ1: IN std_logic;
        LDA,LDB,LDQ,LDR: IN std_logic;
        INC: IN std_logic;
        ICLR: IN std_logic;
        A,B: IN std_logic_vector(3 DOWNTO 0);

        ICR,GT,S :OUT std_logic;
        Q: OUT std_logic_vector(3 DOWNTO 0);
        R: OUT std_logic_vector(3 DOWNTO 0);
    );
END datapathDivion;

ARCHITECTURE rtl OF datapathDivion IS

    SIGNAL i_Rout,i_Qout,i_Rin,i_Qin,i_AddO,i_Addin0,i_Addin1,i_CAout,i_Aout,i_Bout: std_logic;
    SIGNAL i_ICR : std_logic;

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

    COMPONENT bit2counter is
    Port (
        i_clock : in STD_LOGIC;
        i_enable : in STD_LOGIC;
        i_resetBar : in STD_LOGIC;
        o_count : out STD_LOGIC_VECTOR(1 downto 0)
    );
    END COMPONENT;

    COMPONENT Reg_8 IS
    PORT(
        i_resetBar, i_load: IN STD_LOGIC;
        i_clock: IN STD_LOGIC;
        i_Value: IN STD_LOGIC_VECTOR(7 downto 0);
        o_Value: OUT STD_LOGIC_VECTOR(7 downto 0));
    END COMPONENT;

    COMPONENT Comparator IS
    PORT(
        R,B:IN STD_LOGIC_VECTOR(3 downto 0);
        Y:OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT TwoComplement_4bit IS
    PORT(
        A:IN STD_LOGIC_VECTOR(3 downto 0);
        B:OUT STD_LOGIC_VECTOR(3 downto 0));
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

RegR: algobits8shiftreg
    PORT MAP(
        i_S0 => SR0,
        i_S1 => SR1,
        i_resetBar => reset,
        i_clock => clk,
        i_I => i_Rin,
        o_O => i_Rout
    );

RegQ: algobits8shiftreg
    PORT MAP(
        i_S0 => SQ0,
        i_S1 => SQ1,
        i_resetBar => reset,
        i_clock => clk,
        i_I => i_Qin,
        o_O => i_Qout
    );

RegA: algobits8shiftreg
    PORT MAP(
        i_S0 => SA0,
        i_S1 => SA1,
        i_resetBar => reset,
        i_clock => clk,
        i_I => i_CAout,
        o_O => i_Aout
    );

CompA: TwoComplement_4bit
    PORT MAP(
        A => A,
        Load => LDA,
        B => i_CAout

    );

CompB: TwoComplement_4bit
    PORT MAP(
        A => B,
        Load => LDB,
        B => i_Bout
    );

muxRin: mux2to1
    PORT MAP(
        i_S => SR,
        i_a => i_Rout or i_CAout(3),
        i_b => i_AddO,
        o_O => i_Rin
    );

muxQin: mux2to1
    PORT MAP(
        i_S => SQ,
        i_a => i_Qout or '1',
        i_b => i_AddO,
        o_O => i_Qin
    );

muxBin: mux2to1
    PORT MAP(
        i_S => ADD1,
        i_a => i_Bout,
        i_b => '1',
        o_O => i_Addin1
    );
muxAddin: mux4to1
    PORT MAP(
        i_S(1) => SQA1,
        i_S(0) => SQA0,
        i_I(3) => '0',
        i_I(2) => i_Qout,
        i_I(1) => not i_Rout,
        i_I(0) => i_Rout,
        o_O => i_Addin0
    );

addr: byteAdder
    PORT MAP(
        i_Ai => i_Addin0,
        i_Bi => i_Addin1,
        i_Control => ADDC,
        o_Sum => i_AddO,
    );

cmpRB: Comparator
    PORT MAP(
        R => i_Rout,
        B => i_Bout,
        Y => GT
    );

RegSign: enaedFF_2
    PORT MAP(i_resetBar => reset,
             i_d => A(3) xor B(3),
             i_enable => '1', 
			 i_clock => clk,
			 o_q => S
             );

countICR: bit2counter
    PORT MAP(
        i_clock => clk,
        i_enable => INC,
        i_resetBar => ICLR,
        o_count(1) and o_count(0) => ICR
    );

Q <= i_Qout;
R <= i_AddO;

END rtl;
    

    
