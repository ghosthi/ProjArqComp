library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity proto_uc_tb is
end entity;

architecture a_proto_uc_tb of proto_uc_tb is
	component proto_uc is
		port( 
            clk, wr_en, rst           : in std_logic;
            rom_out                   : out unsigned(18 downto 0)
        );
	end component;
	
    signal rom_out_tb                   : unsigned(18 downto 0);
	signal clk_tb, rst_tb, wr_en_tb     : std_logic;
	signal finished                     : std_logic := '0';

	constant period_time    : time := 100 ns;
	
    begin
        program_c : proto_uc port map(
            rst => rst_tb,
            clk     => clk_tb,
            wr_en => wr_en_tb,
            rom_out => rom_out_tb
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
            
            wait for period_time * 10;
            wait;
        end process testing_process;
end architecture a_proto_uc_tb;
		