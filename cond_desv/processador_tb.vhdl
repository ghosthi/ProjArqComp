library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador_tb is
end entity;

architecture a_processador_tb of processador_tb is
	component uc is
        port(
            clk, rst                    : in std_logic;
            instr                       : in unsigned(18 downto 0);
            pc_data                     : in unsigned(6 downto 0);
            pc_wr_en, wr_reg            : out std_logic;
            mem_read                    : out unsigned(6 downto 0);
            reg_write                   : out unsigned(2 downto 0);
            exception                   : out unsigned(1 downto 0) := "00";
            instr_fetch                 : in unsigned(1 downto 0) := "00";
            imm                         : out unsigned(15 downto 0):= "0000000000000000"; 
            read_reg                    : out unsigned(2 downto 0);
            ula_opt                     : out unsigned(2 downto 0);
            acumulador_wr_en            : out std_logic;
            a_out                       : in unsigned(15 downto 0);
            zero_ula, ovfl_ula          : in std_logic
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
            clk, rst    : in std_logic;
            address     : in unsigned(6 downto 0);
            output      : out unsigned(18 downto 0);
            estado      : in unsigned(1 downto 0)
		);
	end component;
	
    component maquinaestados
        port(
            clk     : in std_logic;
            rst     : in std_logic;
            data_out  : out unsigned(1 downto 0)
        );
    end component;

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
            ent1, ent2: in unsigned(15 downto 0);
            uopt: in unsigned(2 downto 0);
            uout: out unsigned(15 downto 0);
            ovfl: out std_logic;
            zero: out std_logic
        );
    end component;

    component reg16bits is
        port(
            clk, rst, wr_en : in std_logic;
            data_in : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;


    signal instr_tb                     : unsigned(18 downto 0):= "0000000000000000000";
    signal mem_read_tb                  : unsigned(6 downto 0) := "0000000";
	signal clk_tb, rst_tb               : std_logic;
	signal finished                     : std_logic := '0';
    signal exception_tb                 : unsigned(1 downto 0) := "00";
    signal wr_reg_tb                    : std_logic;
    signal pc_wr_en_tb                  : std_logic;
    signal pc_data_out                  : unsigned(6 downto 0) := "0000000";
    signal estado                       : unsigned(1 downto 0) := "00";
    signal acumulador_wr_en_tb          : std_logic;
    signal zero_ula_tb, ovfl_ula_tb     : std_logic := '0';
    signal a_data_in, a_data_out        : unsigned(15 downto 0);
    signal breg_dataout                 : unsigned(15 downto 0);
    signal reg_write_tb                 : unsigned(2 downto 0);
    signal read_reg_tb                  : unsigned(2 downto 0);
    signal imm_tb                       : unsigned(15 downto 0):= "0000000000000000"; 
    signal ula_opt_tb                   : unsigned(2 downto 0);

	constant period_time    : time := 100 ns;
	
    begin    
        a : reg16bits port map(
            clk => clk_tb, 
            rst => rst_tb, 
            wr_en => acumulador_wr_en_tb,  
            data_in => a_data_in,     
            data_out => a_data_out
        );

        maq_estados : maquinaestados port map(
            clk     => clk_tb,
            rst     => rst_tb,
            data_out  => estado
        );

        pc : pc_soma port map (
            clk => clk_tb, 
            rst => rst_tb , 
            wr_en => pc_wr_en_tb, 
            data_in => mem_read_tb,
            data_out => pc_data_out
        );
        
        readonlymem : ROM port map(
            clk     => clk_tb,
            address => mem_read_tb,
            output  => instr_tb,
            rst => rst_tb,
            estado => estado
        );

        u_controle : uc port map(
            clk => clk_tb,
            rst => rst_tb,
            instr => instr_tb,
            pc_wr_en => pc_wr_en_tb, 
            ula_opt => ula_opt_tb, 
            wr_reg => wr_reg_tb,
            mem_read => mem_read_tb,
            exception => exception_tb, 
            pc_data => pc_data_out,
            instr_fetch => estado,
            reg_write => reg_write_tb,
            read_reg => read_reg_tb,
            imm => imm_tb,
            acumulador_wr_en => acumulador_wr_en_tb,
            a_out => a_data_out,
            zero_ula => zero_ula_tb, 
            ovfl_ula => ovfl_ula_tb
        );

        uut: bancoreg16bits port map(
            readreg => read_reg_tb, 
            wr_reg => reg_write_tb, 
            data_in => imm_tb,
            data_out => breg_dataout,
            wr_en => wr_reg_tb, 
            rst => rst_tb, 
            clk => clk_tb
        );
        
        ula_inst: ula port map (
            ent1 => a_data_out,
            ent2 => breg_dataout,
            uopt => ula_opt_tb,
            uout => a_data_in,
            ovfl => ovfl_ula_tb,
            zero => zero_ula_tb
        );

        sim_time_proc : process begin
            wait for period_time * 2000;
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
            wait for period_time*4;
            rst_tb <= '0'; 
            wait for period_time * 2000;
            rst_tb <= '1';

            wait;
        end process testing_process;
end architecture a_processador_tb;
		