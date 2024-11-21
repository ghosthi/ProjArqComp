library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
    port( 
        clk         : in std_logic;
        address     : in unsigned(6 downto 0);
        output      : out unsigned(18 downto 0) 
    );
end entity;

architecture a_rom of rom is
    type mem is array (0 to 127) of unsigned(18 downto 0);
    constant conteudo : mem := (
        0 => "0000000000000101111", -- JMP 2
        1 => "0000000000000111111", -- JMP 3
        2 => "0000000000000011111", -- JMP 1
        3 => "0000000000000000000", -- NOP (passa pra 4)
        4 => "0000000000010001111", -- JMP 8
        5 => "0000000000001101111", -- JMP 6
        6 => "0000000000000001001", -- OPCODE INVÁLIDO (passa pra 7)
        7 => "0000000000000000000", -- NOP (passa pra 8)
        8 => "0000000000100001111", -- JMP 16
        9 => "0000000000000000000",
        10 => "0000000000000000000",
        11 => "0000000000000000000",
        12 => "0000000000000000000",
        13 => "0000000000000000000",
        14 => "0000000000000000000",
        15 => "0000000000000000000",
        16 => "0000000000010001111", -- JMP 6 E INICIA LOOP WHILE TRUE
        17 => "0000000000000000000",
        18 => "0000000000000000000",
        19 => "0000000000000000000",
        others => (others=>'0') --zera todos os outros endereços de memória
    );
    begin 
        process(clk)
            begin
                if(rising_edge(clk)) then
                    output <= conteudo(to_integer(address));
                end if;
        end process;
end architecture;