library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity proto_uc is
    port(
        clk, wr_en, rst             : in std_logic;
        rom_out                     : out unsigned(18 downto 0) 
    );
end entity proto_uc;

architecture a_proto_uc of proto_uc is
    
    component program_counter is
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
            clk     : in std_logic;
            address     : in unsigned(6 downto 0);
            output      : out unsigned(18 downto 0) 
		);
	end component;
    
    signal pc_data_in, pc_data_out : unsigned(6 downto 0);

begin

    pc : program_counter port map (
        clk => clk, 
        rst => rst , 
        wr_en => wr_en, 
        data_in => pc_data_in, 
        data_out => pc_data_out
    );

    readonlymem : ROM port map(
        clk     => clk,
        address => pc_data_out,
        output  => rom_out
    );

    pc_data_in <= pc_data_out + "0000001";
    
end a_proto_uc;
