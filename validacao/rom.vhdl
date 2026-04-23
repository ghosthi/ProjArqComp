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
        --# Loop carregando na RAM
        0 => (B"000000100000_001_1000"), -- LD r1, 32;		r1 <= 32

        1 => (B"000000000000_001_1011"), -- LOAD r1;		A <= r1		    -- A = 32		--- Linha bne r1, -5
        2 => (B"000000000000_001_0110"), -- SW $r1;			MEM[$r1] <= A 	-- MEM[32] = A = 32
        3 => (B"000000000000_000_0001"), -- DEC;			A -= 1;		    -- A = 31
        4 => (B"000000000000_001_1101"), -- STORE r1;		r1 <= A		    -- r1 = A = 31
        5 => (B"000000000000_000_1011"), -- LOAD zero;		A <= zero       -- A = 0
        6 => (B"111111111011_001_1100"), -- BNE r1, -5;			    	    -- n preencheu os 32 end de mem, volta p linhas 3

        --# Eliminando multiplos de 1
        7 => (B"000000000001_010_1000"), -- LD r2, 1;		r2 <= 1	        -- primo
        8 => (B"000000000001_011_1000"), -- LD r3, 1;		r4 <= 1		    -- ingremento dos multiplos
        9 => (B"000000000000_100_1000"), -- LD r4, 0;                       -- CONTROLE LOOP MULTIPLOS
        10 => (B"000000000001_101_1000"), -- LD r5, 1;                       -- Icremento para cada numero

        --# =============================
        --# CORE DO BAGULHO
        --# =============================

        11 => (B"000000000000_010_1011"), -- LOAD r2			A <= r2 	    -- A = x		
        12 => (B"000000000000_101_0010"), -- ADD r5	            A += r5         -- A = x + 1
        
        13 => (B"000000000000_010_1101"), -- STORE r2           r2 <= A         --# volta BNE FINAL
        14 => (B"000000000000_011_1101"), -- STORE r3           r3 <= A
        15 => (B"000000000000_011_0010"), -- ADD r3;			A += r3 	    -- segundo multiplo do primo x
        16 => (B"000000000000_010_1101"), -- STORE r2;		    r2 <= A		    -- r2 = 2x

        17 => (B"011111100000_001_1000"), -- LD r1, 2016;                       -- teto p overflow  (VOLTA BNE ZERADOR)
        18 => (B"000000000000_000_1011"), -- LOAD zero;		    A <= zero = 0	-- zera A 		    
        19 => (B"000000000000_010_0110"), -- SW $r2;			MEM[$r2] <= A	-- zera registo r2 da mem	 
        20 => (B"000000000000_011_1011"), -- LOAD r3;		    A <= r3 = x	    -- passo da soma (multiplos sao de x em x)
        21 => (B"000000000000_010_0010"), -- ADD r2;			A += r2         -- soma o proximo multiplo
        22 => (B"000000000000_010_1101"), -- STORE r2;		    r2 <= A		    -- r2 = valor do proximo multiplo
        23 => (B"000000000000_100_1101"), -- STORE r4;		    r4 <= A		    -- carrega valor de mem para comparar se já n acabou os numero na ram
        24 => (B"000000000000_001_1011"), -- LOAD r1;		    A <= r1 = 2016  -- A <= 2016
        25 => (B"111111111000_100_1010"), -- BVS r4,-8;                         -- se chegou em 32, volta -7 linhas

        26 => (B"000000100000_001_1000"), -- LD r1, 32;		    r1 <= 32
        27 => (B"000000000000_011_1011"), -- LOAD r3                            -- A <= r3 = x
        28 => (B"000000000000_101_0010"), -- ADD r5;                            -- A <= A + R5 (R5 = 1)
        29 => (B"111111110000_001_1100"), -- BNE r1, -16;                       -- SE A /= 32

        --# =============================
        --# CORE DO BAGULHO
        --# =============================
        --# Ler a ram

        30 => (B"000000100001_001_1000"), -- LD r1, 33;		r1 <= 33
        31 => (B"000000000000_011_1000"), -- LD r3, 0;	
        32 => (B"000000000000_001_0011"), -- LW $r1;		A <= MEM[$r1]   -- A <= MEM[32] <-BNE
        33 => (B"000000000000_011_1101"), -- STORE r3;		r3 <= A		    -- r3 = A
        34 => (B"000000000000_001_1011"), -- LOAD r1;		A <= r1		    -- A = 32		
        35 => (B"000000000000_000_0001"), -- DEC;			A -= 1;		    -- A = 31
        36 => (B"000000000000_001_1101"), -- STORE r1;		r1 <= A
        37 => (B"111111111011_000_1100"), -- BNE zero, -5; -- n iterou até 0
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