library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bancoreg16bits is
    port(
        -- só 1 reg: outro é o acumulador
        readreg:            in unsigned(2 downto 0);
        wr_reg :            in unsigned(2 downto 0);
        data_in :           in unsigned(15 downto 0);
        data_out :           out unsigned(15 downto 0);

        wr_en, clk, rst :   in std_logic
    );
end entity;

architecture a_bancoreg16bits of bancoreg16bits is
    component reg16bits is
        port(
            clk, rst, wr_en : in std_logic;
            data_in : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;
    
    signal x1, x2, x3, x4, x5: unsigned(15 downto 0) := "0000000000000000";
    signal zero_signal : unsigned(15 downto 0):= "0000000000000000";
    signal mux : unsigned(4 downto 0);

    begin
        -- 'Número de registradores no banco': [5]
        mux <=  "00001" when wr_reg = "001" and wr_en ='1' else
                "00010" when wr_reg = "010" and wr_en ='1' else
                "00100" when wr_reg = "011" and wr_en ='1' else
                "01000" when wr_reg = "100" and wr_en ='1' else
                "10000" when wr_reg = "101" and wr_en ='1' else
                "00000";

        reg_x1 : reg16bits port map(clk => clk, rst => rst, wr_en => mux(0),  data_in => data_in,     data_out => x1);
        reg_x2 : reg16bits port map(clk => clk, rst => rst, wr_en => mux(1),  data_in => data_in,     data_out => x2);
        reg_x3 : reg16bits port map(clk => clk, rst => rst, wr_en => mux(2),  data_in => data_in,     data_out => x3);
        reg_x4 : reg16bits port map(clk => clk, rst => rst, wr_en => mux(3),  data_in => data_in,     data_out => x4);
        reg_x5 : reg16bits port map(clk => clk, rst => rst, wr_en => mux(4),  data_in => data_in,     data_out => x5);
        zero   : reg16bits port map(clk => clk, rst => rst, wr_en => '0',     data_in => zero_signal, data_out => zero_signal);

        data_out <= zero_signal when readreg = "000" else
                    x1 when readreg = "001" else
                    x2 when readreg = "010" else
                    x3 when readreg = "011" else
                    x4 when readreg = "100" else
                    x5 when readreg = "101" else
                    zero_signal;
            
end architecture;