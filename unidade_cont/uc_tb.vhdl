library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc_tb is
end entity;

architecture a_uc_tb of uc_tb is
	component uc is
        port(
            clk, wr_en, rst             : in std_logic;
            instr                       : in unsigned(18 downto 0);
            rom_out                     : out unsigned(18 downto 0);
            exception                   : out unsigned(1 downto 0)
        );
	end component;
	
    signal rom_out_tb, instr_tb         : unsigned(18 downto 0):= "0000000000000000000";
	signal clk_tb, rst_tb, wr_en_tb     : std_logic;
	signal finished                     : std_logic := '0';
    signal exception_tb                 : unsigned(1 downto 0) := "00";

	constant period_time    : time := 100 ns;
	
    begin
        program_c : uc port map(
            clk     => clk_tb,
            wr_en => wr_en_tb,
            rst => rst_tb,
            instr => instr_tb,
            rom_out => rom_out_tb,
            exception => exception_tb
        );

        sim_time_proc : process begin
            wait for 10 us;
            finished <= '1';
            wait;
        end process sim_time_proc;
        
        clk_proc : process begin
            while finished /= '1' loop
                clk_tb <= '0';
                wait for period_time/2;
                clk_tb <= '1';
                wait for period_time/2;
            end loop;
            wait;
        end process clk_proc;
        
        testing_process : process begin
            rst_tb <= '1';
            wr_en_tb <= '1';

            wait for period_time;
            rst_tb <= '0';
            wr_en_tb <= '1';

            instr_tb <= "0000000000000000000";
            wait for period_time;

            instr_tb <= rom_out_tb;
            wait for period_time;

            instr_tb <= rom_out_tb;
            wait for period_time;

            instr_tb <= rom_out_tb;
            wait for period_time;

            instr_tb <= rom_out_tb;
            wait for period_time;

            instr_tb <= rom_out_tb;
            wait for period_time;

            instr_tb <= rom_out_tb;
            wait for period_time;

            instr_tb <= rom_out_tb;
            wait for period_time;

            instr_tb <= rom_out_tb;
            wait for period_time;

            instr_tb <= rom_out_tb;
            wait for period_time;

            instr_tb <= rom_out_tb;
            wait for period_time;

            instr_tb <= rom_out_tb;
            wait for period_time;

            instr_tb <= rom_out_tb;
            wait for period_time;

            instr_tb <= rom_out_tb;
            wait for period_time;

            instr_tb <= rom_out_tb;
            wait for period_time;

            instr_tb <= rom_out_tb;
            wait for period_time;

            instr_tb <= rom_out_tb;
            wait for period_time;

            instr_tb <= rom_out_tb;
            wait for period_time;

            instr_tb <= rom_out_tb;
            wait for period_time;

            instr_tb <= rom_out_tb;
            wait for period_time;

            instr_tb <= rom_out_tb;
            wait for period_time;

            instr_tb <= rom_out_tb;
            wait for period_time;

            instr_tb <= rom_out_tb;
            wait for period_time;

            instr_tb <= rom_out_tb;
            wait for period_time;

            instr_tb <= rom_out_tb;
            wait for period_time;

            instr_tb <= rom_out_tb;
            wait for period_time;

            instr_tb <= rom_out_tb;
            wait for period_time;

            instr_tb <= rom_out_tb;
            wait for period_time;

            instr_tb <= rom_out_tb;
            wait for period_time;

            instr_tb <= rom_out_tb;
            wait for period_time;

            instr_tb <= rom_out_tb;
            wait for period_time;

            instr_tb <= rom_out_tb;
            wait for period_time;

            instr_tb <= rom_out_tb;
            wait for period_time;

            instr_tb <= rom_out_tb;
            wait for period_time;

            instr_tb <= rom_out_tb;
            wait for period_time;

            instr_tb <= rom_out_tb;
            wait for period_time;

            instr_tb <= rom_out_tb;
            wait for period_time;

            instr_tb <= rom_out_tb;
            wait for period_time;

            instr_tb <= rom_out_tb;
            wait for period_time;

            instr_tb <= rom_out_tb;
            wait for period_time;

            instr_tb <= rom_out_tb;
            wait for period_time;

            instr_tb <= rom_out_tb;
            wait for period_time;

            instr_tb <= rom_out_tb;
            wait for period_time;

            instr_tb <= rom_out_tb;
            wait for period_time;

            instr_tb <= rom_out_tb;
            wait for period_time;

            instr_tb <= rom_out_tb;
            wait for period_time;

            wait;
        end process testing_process;
end architecture a_uc_tb;
		