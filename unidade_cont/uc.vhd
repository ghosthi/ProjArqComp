library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc is
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
end entity uc;

architecture a_uc of uc is

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

    mem_read <= instr(10 downto 4) WHEN instr_fetch = '1' AND jump_en <= '1' ELSE pc_data;

    pc_wr_en <= instr_fetch;

    ula_src <= instr(2 downto 0) WHEN 
                opcode = "0010" OR
                opcode = "0100" OR
                opcode = "0101" OR
                opcode = "1000" OR
                opcode = "1100"
            ELSE "000";

    wr_reg <= '1' WHEN opcode = "0001" ELSE '0';

    reg_write <= instr(2 downto 0) WHEN opcode = "0001" ELSE "000";

end a_uc;
