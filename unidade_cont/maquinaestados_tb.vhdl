library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity maquinaestados_tb is
end entity;

architecture teste of maquinaestados_tb is
	component maquinaestados
		port(
			clk     : in std_logic;
			rst     : in std_logic;
			data_out  : out std_logic
		);
	end component;
	
	signal clk_tb, rst_tb, estado_tb    : std_logic;
	signal finished                     : std_logic := '0';
	constant period_time                : time := 100 ns;
	
	begin
		
	maq_estados : maquinaestados
	port map(
		clk     => clk_tb,
		rst     => rst_tb,
		data_out  => estado_tb
    );
	
	reset_global : process begin 
		rst_tb <= '1';
		wait for period_time*2;
		rst_tb <= '0';
		wait;
	end process reset_global;
		
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
		wait for period_time;
		rst_tb <= '0';
		wait for period_time*4;
		wait;
	end process testing_process;
end architecture teste;