library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_soma_tb is
end entity;

architecture a_pc_soma_tb of pc_soma_tb is
	component pc_soma is
		port( 
            pc_data_in                  : in unsigned(6 downto 0);
            pc_data_out                 : out unsigned(6 downto 0);
            clk, wr_en, rst           : in std_logic
        );
	end component;
	
	signal clk_tb, rst_tb, wr_en_tb     : std_logic;
	signal finished                     : std_logic := '0';
    signal pc_in, pc_out : unsigned(6 downto 0) := "0000000";

	constant period_time    : time := 100 ns;
	
    begin
        program_c : pc_soma port map(
            rst => rst_tb,
            clk     => clk_tb,
            wr_en => wr_en_tb,
            pc_data_in => pc_in, 
            pc_data_out => pc_out
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
            wait for period_time* 2;
            rst_tb <= '1';
            wr_en_tb <= '1';
            wait for period_time* 2;
            rst_tb <= '0';
            wr_en_tb <= '1';
            pc_in <= pc_out;
            wait for period_time* 2;
            pc_in <= pc_out;
            wait for period_time* 2;
            pc_in <= pc_out;
            wait for period_time* 2;
            pc_in <= pc_out;
            wait for period_time* 2;
            pc_in <= pc_out;
            wait for period_time* 2;
            pc_in <= pc_out;
            wait for period_time* 2;
            pc_in <= pc_out;
            wait for period_time* 2;
            pc_in <= pc_out;
            wait for period_time* 2;
            pc_in <= pc_out;
            wait for period_time* 2;
            pc_in <= pc_out;
            wait for period_time* 2;
            pc_in <= pc_out;
            wait for period_time* 2;
            pc_in <= pc_out;
            wait for period_time* 2;
            
            wait for period_time * 10;
            wait;
        end process testing_process;
end architecture a_pc_soma_tb;
		