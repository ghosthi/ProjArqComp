library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity program_counter_tb is
end entity;

architecture a_program_counter_tb of program_counter_tb is
	component program_counter is
		port( 
            clk, rst, wr_en : in std_logic;
            data_in         : in unsigned(6 downto 0);
            data_out        : out unsigned(6 downto 0)
        );
	end component;
	
	signal clk_tb, rst_tb, wr_en_tb    : std_logic;
    signal data_in_tb               : unsigned(6 downto 0) := "0000000";
    signal data_out_tb              : unsigned(6 downto 0) := "0000000";
	signal finished                 : std_logic := '0';

	constant period_time    : time := 100 ns;
	
    begin
        program_c : program_counter port map(
            rst => rst_tb,
            data_in => data_in_tb,
            data_out => data_out_tb,
            clk     => clk_tb,
            wr_en => wr_en_tb
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
            wait for period_time* 2;
            rst_tb <= '0';
            
            wait for period_time * 2;
            data_in_tb <= data_out_tb + "0000001";
            wait for period_time * 2;
            data_in_tb <= data_out_tb + "0000001";
            wait for period_time * 2;
            data_in_tb <= data_out_tb + "0000001";
            wait for period_time * 2;
            data_in_tb <= data_out_tb + "0000001";
            wait for period_time * 2;
            data_in_tb <= data_out_tb + "0000001";
            wait for period_time * 2;
            data_in_tb <= data_out_tb + "0000001";
            wait for period_time * 2;
            data_in_tb <= data_out_tb + "0000001";
            wait for period_time * 2;
            data_in_tb <= data_out_tb + "0000001";
            wait for period_time * 2;
            data_in_tb <= data_out_tb + "0000001";
            wait for period_time * 2;
            data_in_tb <= data_out_tb + "0000001";
            wait for period_time * 2;
            data_in_tb <= data_out_tb + "0000001";
            wait for period_time * 2;
            data_in_tb <= data_out_tb + "0000001";
            wait for period_time * 2;
            data_in_tb <= data_out_tb + "0000001";
            wait;
        end process testing_process;
end architecture a_program_counter_tb;
		