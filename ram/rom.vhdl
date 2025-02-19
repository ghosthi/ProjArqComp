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
        0 => B"000000001001_001_1000", -- LD r1, 1;  r1 <= 9
        1 => B"000000001010_010_1000", -- LD r2, 2;  r2 <= 10
        2 => B"000000000011_011_1000", -- LD r3, 3;  r3 <= 3
        3 => B"000000001100_100_1000", -- LD r4, 4;  r4 <= 12
        4 => B"000000000101_101_1000", -- LD r5, 5;  r5 <= 5
        5 => B"000000000000_001_0010", -- ADD r1;   A += r1
        6 => B"000000000000_001_0010", -- ADD r1;   A += r1 (A = 2)
        7 => B"000000000000_001_0110", -- SW $r1;   MEM[$r1] <= A
        8 => B"000000000000_010_0010", -- ADD r2;   A += r2
        9 => B"000000000000_010_0010", -- ADD r2;   A += r2 (A = 4)
        10 => B"000000000000_010_0110", -- SW $r2;   MEM[$r2] <= A
        11 => B"000000000000_001_0011", -- LW $r1;   A <= MEM[$r1]
        12 => B"000000000000_011_0010", -- ADD r3;   A += r3
        13 => B"000000000000_011_0010", -- ADD r3;   A += r3 (A = 6)
        14 => B"000000000000_011_0110", -- SW $r3;   MEM[$r3] <= A
        15 => B"000000000000_010_0011", -- LW $r2;   A <= MEM[$r2]
        16 => B"000000000000_100_0010", -- ADD r4;   A += r4
        17 => B"000000000000_100_0010", -- ADD r4;   A += r4 (A = 8)
        18 => B"000000000000_100_0110", -- SW $r4;   MEM[$r4] <= A
        19 => B"000000000000_011_0011", -- LW $r3;   A <= MEM[$r3]
        20 => B"000000000000_101_0010", -- ADD r5;   A += r5
        21 => B"000000000000_101_0010", -- ADD r5;   A += r5 (A = 10)
        22 => B"000000000000_101_0110", -- SW $r5;   MEM[$r5] <= A
        23 => B"000000000000_100_0011", -- LW $r4;   A <= MEM[$r4]
        24 => B"000000000000_101_0011", -- LW $r5;   A <= MEM[$r5]
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