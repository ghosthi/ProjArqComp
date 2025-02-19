library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
    port( 
        clk, rst    : in std_logic;
        address     : in unsigned(6 downto 0);
        output      : out unsigned(18 downto 0);
        estado      : in unsigned(1 downto 0)
    );
end entity;

architecture a_rom of rom is

    component regInst is
        port(
            clk, rst, wr_en : in std_logic;
            data_in : in unsigned(18 downto 0);
            data_out : out unsigned(18 downto 0)
        );
    end component;

    signal regDataIn, regDataOut : unsigned(18 downto 0) := "0000000000000000000";
    signal regInstrWrEn : std_logic := '0';

    type mem is array (0 to 127) of unsigned(18 downto 0);
    constant conteudo : mem := (
            0 => B"000000000000_011_1000", --A: LD r3, 0;  r3 <= 0
            1 => B"000000000000_100_1000", --B: LD r4, 0; r4 <= 0
            2 => B"000000000000_011_1011", --C: LOAD r3; A <= r3
            3 => B"000000000001_101_1000", --   LD r5, 1; R5 <= 1
            4 => B"000000000000_101_0010", --   ADD r5; A += R5
            5 => B"000000000000_011_1101", --  STORE r3; r3 <= A
            6 => B"000000010100_010_1000", --E: LD r2, 30; r2 <= 30
            7 => B"000000000000_010_1011", --   LOAD r2; A <= r2
            8 => B"111111111010_011_1100", --   BNE r3, -6; while A != r3 GOTO -6
            9 => B"000000000000_100_1011", --F: LOAD r4; A <= r4        
            10 => B"000000000000_101_1101", --   STORE r5; r5 <= A
            11 => B"0000000000000000000",
            12 => B"0000000000000000000",
            13 => B"0000000000000000000",
            14 => B"0000000000000000000",
            15 => B"0000000000000000000",
            16 => B"0000000000000000000",
            17 => B"0000000000000000000",
            18 => B"0000000000000000000",
            19 => B"0000000000000000000", 
        others => (others=>'0')
    );
    begin 
        regInstrucao : regInst port map(
            clk => clk,
            rst => rst,
            wr_en => regInstrWrEn,
            data_in => regDataIn,
            data_out => regDataOut
        );

        process(clk)
            begin
                if(rising_edge(clk)) then
                    regDataIn <= conteudo(to_integer(address));
                end if;
        end process;
        
        regInstrWrEn <= '1' WHEN estado = "00" ELSE '0'; -- FETCH
        output <= regDataOut; -- DECODE
end architecture;