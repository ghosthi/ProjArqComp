library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- para uso do unsigned

entity ula is
    port (
        -- componentes da ULA
        -- entadas
        ent1, ent2: in unsigned(15 downto 0);   -- entadas de valores
        uopt: in unsigned(2 downto 0);          -- entada do seletor de operação

        uout: out unsigned(15 downto 0);        -- saida da ula

        ovfl: out std_logic;                    -- ocorreu overflow
        zero: out std_logic                    -- ocorreu overflow
    );
end entity ula;

architecture aUla of ula is
    signal saida: unsigned(15 downto 0);
begin

    saida <=     --'ADD ops': 
                --'Dois operandos apenas'
                --( A <- A + R1 )
                ent1 + ent2 when uopt = "001" else                             -- SOMA

                --'SUB ops': 
                --'Dois operandos apenas' 
                --( A <- A - R1 )

                --'SUB ctes': 
                --'Há instr que subtrai uma cte' 
                --( A <- A - CTE )

                --'Subtração': 
                --'Subtração com SUB sem borrow' 
                --NÃO TEM FLAG DE CARRY
                ent1 - ent2 when uopt = "010" else                              -- SUBTRAÇÃO

                --'final do loop': 
                --'Contagem regressiva até zero usando DEC',
                ent1 - "0000000000000001"  when uopt = "011" else               -- DEC

                ent1(7 downto 0) * ent2(7 downto 0) when uopt = "100" else      -- MULTIPLICAÇÂO (NÃO UTILIZADO NO PROCESSADOR)
               "0000000000000000";

    --'Saltos condicionais': 

    --'BVS'
        --Só há estouro de números signed se somarmos dois números que têm um mesmo sinal e se o resultado tiver o sinal contrário
    ovfl <=     '1' when ent1(15) = ent2(15) AND saida(15) /= ent2(15) else '0';

    --'BNE'
    zero <=     '1' when saida = "0000000000000000" else '0';

    uout <= saida;
end aUla;