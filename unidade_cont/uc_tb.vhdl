library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc_tb is
end entity;

architecture a_uc_tb of uc_tb is
	component uc is
        port(
            clk, rst                    : in std_logic;
            instr                       : in unsigned(18 downto 0);
            pc_data                     : in unsigned(6 downto 0);
            pc_wr_en, ula_op, wr_reg    : out std_logic;
            mem_read                    : out unsigned(6 downto 0);
            reg_write                   : out unsigned(2 downto 0);
            ula_src                     : out unsigned(2 downto 0);
            exception                   : out unsigned(1 downto 0) := "00";
            instr_fetch                 : in std_logic
        );
	end component;
    
    component pc_soma is
        port(
            clk  	 : in std_logic;
            wr_en 	 : in std_logic;
            rst      : in std_logic;
            data_in   : in  unsigned(6 downto 0) := "0000000";
            data_out  : out unsigned(6 downto 0) := "0000000"
        );
    end component;

    component rom is
		port(	
            clk         : in std_logic;
            address     : in unsigned(6 downto 0);
            output      : out unsigned(18 downto 0) 
		);
	end component;
	
    component maquinaestados
        port(
            clk     : in std_logic;
            rst     : in std_logic;
            data_out  : out std_logic
        );
    end component;

    signal rom_out_tb, instr_tb         : unsigned(18 downto 0):= "0000000000000000000";
    signal mem_read_tb                  : unsigned(6 downto 0) := "0000000";
	signal clk_tb, rst_tb               : std_logic;
	signal finished                     : std_logic := '0';
    signal exception_tb                 : unsigned(1 downto 0) := "00";
    signal ula_op_tb                    : std_logic;
    signal wr_reg_tb                    : std_logic;
    signal pc_wr_en_tb                  : std_logic;
    signal ula_src_tb                   : unsigned(2 downto 0);
    signal pc_data_in, pc_data_out      : unsigned(6 downto 0) := "0000000";
    signal estado                       : std_logic := '0';

	constant period_time    : time := 1000 ms;
	
    begin
        maq_estados : maquinaestados port map(
            clk     => clk_tb,
            rst     => rst_tb,
            data_out  => estado
        );

        pc : pc_soma port map (
            clk => clk_tb, 
            rst => rst_tb , 
            wr_en => pc_wr_en_tb, 
            data_in => pc_data_out,
            data_out => pc_data_out
        );
        
        readonlymem : ROM port map(
            clk     => clk_tb,
            address => mem_read_tb,
            output  => instr_tb
        );

        u_controle : uc port map(
            clk => clk_tb,
            rst => rst_tb,
            instr => instr_tb,
            pc_wr_en => pc_wr_en_tb, 
            ula_op => ula_op_tb, 
            wr_reg => wr_reg_tb,
            mem_read => mem_read_tb,
            ula_src => ula_src_tb,
            exception => exception_tb, 
            pc_data => pc_data_out,
            instr_fetch => estado
        );
        
        sim_time_proc : process begin
            wait for period_time * 20;
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
            wait for period_time*1000;
            rst_tb <= '1';

            wait;
        end process testing_process;
end architecture a_uc_tb;
		