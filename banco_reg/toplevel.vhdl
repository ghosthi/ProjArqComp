library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity toplevel_tb is
end toplevel_tb;

architecture a_toplevel_tb of toplevel_tb is
    component bancoreg16bits is
        port ( 
            readreg:            in unsigned(2 downto 0);
            wr_reg :            in unsigned(2 downto 0);
            data_in :           in unsigned(15 downto 0);
            data_out :           out unsigned(15 downto 0);
    
            wr_en, clk, rst :   in std_logic
        );
    end component;
    
    component ula is
        port (
            ent1, ent2: in unsigned(15 downto 0);   -- entadas de valores
            uopt: in unsigned(2 downto 0);          -- entada do seletor de operação
            uout: out unsigned(15 downto 0);        -- saida da ula
            ovfl: out std_logic;                    -- ocorreu overflow
            zero: out std_logic                    -- ocorreu overflow
        );
	end component;

    component reg16bits is
        port(
            clk, rst, wr_en : in std_logic;
            data_in : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;

	constant soma: unsigned(2 downto 0):= "001";
	constant subt: unsigned(2 downto 0):= "010";
    constant dec: unsigned(2 downto 0):= "011";
    constant mult: unsigned(2 downto 0):= "100";

    constant period_time                  : time := 100 ns;
    signal finished, wr_en, rst, clk      : std_logic;
    signal readreg, wr_reg                : unsigned(2 downto 0);  -- VIRIA DA UC
    signal data_in, dataout               : unsigned(15 downto 0);
    signal ent1_ula, ent2_ula, uout_ula   : unsigned(15 downto 0):= "0000000000000000"; -- Primeira entrada e saída do Acumulador vazias
    signal uopt_ula                       : unsigned(2 downto 0);  -- VIRIA DA UC
    signal zero_ula, ovfl_ula             : std_logic;
    signal A_wr_en                        : std_logic; -- VIRIA DA UC

    begin
    uut: bancoreg16bits port map(
            readreg => readreg, 
            wr_reg => wr_reg, 
            data_in => data_in,
            
            data_out => ent2_ula,
            wr_en => wr_en, 
            rst => rst, 
            clk => clk
        );

    ula_inst: ula port map (
            ent1 => ent1_ula,
            ent2 => ent2_ula,
            uopt => uopt_ula,
            uout => uout_ula,
            ovfl => ovfl_ula,
            zero => zero_ula
        );
    
    A: reg16bits port map(
            clk => clk, 
            rst => rst, 
            wr_en => A_wr_en,  
            data_in => uout_ula,     
            data_out => ent1_ula
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


        -- MEXE COM readreg, wr_reg, wr_en e data_in, uopt_ula

        -- Lê zero, não escreve, soma com A
        wr_en <= '0';
        wr_reg <= "111";
        readreg <= "000";
        data_in <= "1101101001010101";
        uopt_ula <= soma;
        wait for period_time;

        -- Escreve em x1, lê x2 e soma com A
        wr_en <= '1';
        wr_reg <= "001";
        readreg <= "010";
        data_in <= "1010011101100110";
        uopt_ula <= soma;
        wait for period_time;

        -- Lê x3 e subtrai de A
        wr_en <= '0';
        wr_reg <= "010";
        readreg <= "011";
        data_in <= "1110001001011101";
        uopt_ula <= subt;
        wait for period_time;

        -- Escreve em x3, lê x4, decrementa 1 e leva pro Acumulador
        wr_en <= '1';
        wr_reg <= "011";
        readreg <= "100";
        data_in <= "0101101010101010";
        uopt_ula <= dec;
        wait for period_time;

        -- Lê x5 e multiplica com A
        wr_en <= '0';
        wr_reg <= "100";
        readreg <= "101";
        data_in <= "0010110111011011";
        uopt_ula <= mult;
        wait for period_time;

        -- Escreve em x5, lê "0000000000000000" (reg inválido) e som com A
        wr_en <= '1';
        wr_reg <= "101";
        readreg <= "110";
        data_in <= "1001010110101011";
        uopt_ula <= soma;
        wait for period_time;

        -- Lê "0000000000000000" (reg inválido) e subtrai de A
        wr_en <= '0';
        wr_reg <= "110";
        readreg <= "111";
        data_in <= "1101101001010101";
        uopt_ula <= subt;
        wait for period_time;

        -- Lê zero, não escreve (reg inválido) decrementa 1 e leva pro Acumulador
        wr_en <= '1';
        wr_reg <= "111";
        readreg <= "000";
        data_in <= "1010110010101101";
        uopt_ula <= dec;
        wait for period_time;

        -- Lê x1 e multiplica com A
        wr_en <= '0';
        wr_reg <= "000";
        readreg <= "001";
        data_in <= "0101101101010101";
        uopt_ula <= mult;
        wait for period_time;

        rst <= '1';
        wait;
    end process;
end a_toplevel_tb;