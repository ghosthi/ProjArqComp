library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bancoreg16bits_tb is
end bancoreg16bits_tb;

architecture a_bancoreg16bits_tb of bancoreg16bits_tb is
    component bancoreg16bits is
        port ( 
            readreg:            in unsigned(2 downto 0);
            wr_reg :            in unsigned(2 downto 0);
            data_in :           in unsigned(15 downto 0);
            data_out :           out unsigned(15 downto 0);
    
            wr_en, clk, rst :   in std_logic
        );
    end component;
    

    constant period_time                  : time := 100 ns;
    signal finished, wr_en, rst, clk      : std_logic;
    signal readreg, wr_reg                : unsigned(2 downto 0);
    signal data_in, dataout               : unsigned(15 downto 0);

    begin
    uut: bancoreg16bits port map(
            readreg => readreg, 
            wr_reg => wr_reg, 
            data_in => data_in,
            data_out => dataout,
            wr_en => wr_en, 
            rst => rst, 
            clk => clk
        );
        
    sim_time_proc: process
    begin
        wait for 1 us;
        finished <= '1';
        wait;
    end process;

    clk_proc: process
    begin
        while finished /= '1' loop
            clk <= '0';
            wait for period_time/2;
            clk <= '1';
            wait for period_time/2;
        end loop;
        wait;
    end process;

    process 
    begin
        rst <= '1';
        wait for period_time*2;

        rst <= '0';

        -- MEXE COM readreg, wr_reg, wr_en e data_in

        -- Lê x1, sem escrever nada
        wr_en <= '0';
        wr_reg <= "001";
        readreg <= "001";
        data_in <= "1101001010110101";
        wait for period_time;

        -- Escreve em x2 e lê seu valor
        wr_en <= '1';
        wr_reg <= "010";
        readreg <= "010";
        data_in <= "1010011101100110";
        wait for period_time;

        -- Lê x3, sem escrever nada
        wr_en <= '0';
        wr_reg <= "100";
        readreg <= "011";
        data_in <= "1110001001011101";
        wait for period_time;

        -- Escreve em x4 e le em x3
        wr_en <= '1';
        wr_reg <= "011";
        readreg <= "100";
        data_in <= "0101101010101010";
        wait for period_time;

        -- Não lê nenhum reg nem escreve, data out := "0000000000000000"
        wr_en <= '0';
        wr_reg <= "101";
        readreg <= "110";
        data_in <= "0010110111011011";
        wait for period_time;

        -- Não lê nenhum reg nem escreve, ambos reg inválido, data out := "0000000000000000"
        wr_en <= '1';
        wr_reg <= "110";
        readreg <= "111";
        data_in <= "1001010110101011";
        wait for period_time;

        -- Não escreve, lê zero
        wr_en <= '0';
        wr_reg <= "111";
        readreg <= "000";
        data_in <= "1101101001010101";
        wait for period_time;

        rst <= '1';
        wait;
    end process;
end a_bancoreg16bits_tb;