library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_soma is
    port(
        data_in                  : in unsigned(6 downto 0);
        data_out                 : out unsigned(6 downto 0);
        clk, wr_en, rst             : in std_logic
    );
end entity pc_soma;

architecture a_pc_soma of pc_soma is
    
    component program_counter is
        port(
            clk  	 : in std_logic;
            wr_en 	 : in std_logic;
            rst      : in std_logic;
            data_in   : in  unsigned(6 downto 0) := "0000000";
            data_out  : out unsigned(6 downto 0) := "0000000"
        );
    end component;
    
    signal pc_in, pc_out : unsigned(6 downto 0) := "0000000";

begin
    pc_in <= data_in;

    pc : program_counter port map (
        clk => clk, 
        rst => rst , 
        wr_en => wr_en, 
        data_in => pc_in, 
        data_out => pc_out
    );

    data_out <= pc_out + "0000001" WHEN wr_en = '1' ELSE pc_out;

end a_pc_soma;
