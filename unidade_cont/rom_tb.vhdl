library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_tb is
end entity;

architecture a_rom_tb of rom_tb is
	component rom is
		port(	
            clk     : in std_logic;
            address     : in unsigned(6 downto 0);
            output      : out unsigned(18 downto 0) 
		);
	end component;
	
	signal clk_tb        : std_logic;
	signal finished      : std_logic := '0';
	signal addresss_tb   : unsigned(6 downto 0) := "0000000";
	signal output_tb     : unsigned(18 downto 0) := "0000000000000000000";
	
	constant period_time : time := 100 ns;
	
	constant end0 : unsigned(6 downto 0) := "0000000"; -- endereço 0
	constant end1 : unsigned(6 downto 0) := "0000001"; -- endereço 1
	constant end2 : unsigned(6 downto 0) := "0000010"; -- endereço 2
	constant end3 : unsigned(6 downto 0) := "0000011"; -- endereço 3
	constant end4 : unsigned(6 downto 0) := "0000100"; -- endereço 4
	constant end5 : unsigned(6 downto 0) := "0000101"; -- endereço 5
	constant end6 : unsigned(6 downto 0) := "0000110"; -- endereço 6
	
    begin
        rom1 : ROM port map(
            clk     => clk_tb,
            address => addresss_tb,
            output  => output_tb
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
            wait for period_time;
            addresss_tb <= end0;
            wait for period_time*2;
            addresss_tb <= end1;
            wait for period_time*2;
            addresss_tb <= end2;
            wait for period_time*2;
            addresss_tb <= end3;
            wait for period_time*2;
            addresss_tb <= end4;
            wait for period_time*2;
            addresss_tb <= end5;
            wait for period_time*2;
            addresss_tb <= end6;
            wait for period_time*2;
            wait;
        end process testing_process;
end architecture a_rom_tb;
		