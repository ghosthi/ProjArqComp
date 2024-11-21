library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc is
    port(
        clk, wr_en, rst             : in std_logic;
        instr                       : in unsigned(18 downto 0);
        rom_out                     : out unsigned(18 downto 0);
        exception                   : out unsigned(1 downto 0) := "00"
    );
end entity uc;

architecture a_uc of uc is
    component maquinaestados
        port(
            clk     : in std_logic;
            rst     : in std_logic;
            data_out  : out std_logic
        );
    end component;

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
            clk         : in std_logic;
            address     : in unsigned(6 downto 0);
            output      : out unsigned(18 downto 0) 
		);
	end component;
    
    signal pc_data_in, pc_data_out  : unsigned(6 downto 0) := "0000000";
    signal address                  : unsigned(6 downto 0);
    signal estado                   : std_logic := '0';
    signal saida_rom                : unsigned(18 downto 0);
    signal opcode                   : unsigned(3 downto 0);
    signal jump_en                  : std_logic := '0';

begin
    opcode <= instr(3 downto 0);

    exception <= 
        "10" WHEN 
            opcode = "0011" OR opcode = "0110" OR 
            opcode = "1001" OR opcode = "1011" OR 
            opcode = "1101" OR opcode = "1110"
        ELSE "00";
    
    jump_en <=  '1' WHEN opcode="1111" ELSE '0';

    address <= instr(10 downto 4) WHEN jump_en = '1' ELSE pc_data_out;

    pc : program_counter port map (
        clk => clk, 
        rst => rst , 
        wr_en => wr_en, 
        data_in => pc_data_in, 
        data_out => pc_data_out
    );

    readonlymem : ROM port map(
        clk     => clk,
        address => address,
        output  => saida_rom
    );

    maq_estados : maquinaestados port map(
		clk     => clk,
		rst     => rst,
		data_out  => estado
    );

    pc_data_in <= 
        pc_data_out + "0000001" WHEN estado = '1' AND jump_en = '0' ELSE
        address WHEN estado = '1' AND jump_en <= '1' ELSE
        pc_data_in;

    rom_out <= saida_rom WHEN estado = '0' ELSE "0000000000000000000";
    
end a_uc;
