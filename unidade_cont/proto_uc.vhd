library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity proto_uc is
    port(
        pc_data_in                  : in unsigned(6 downto 0);
        pc_data_out                 : out unsigned(6 downto 0);
        clk, wr_en, rst             : in std_logic
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
    
    signal pc_in, pc_out : unsigned(6 downto 0);

begin
    pc_in <= pc_data_in;

    pc : program_counter port map (
        clk => clk, 
        rst => rst , 
        wr_en => wr_en, 
        data_in => pc_in, 
        data_out => pc_out
    );

    pc_data_out <= pc_in + "0000001";
    
end a_proto_uc;
