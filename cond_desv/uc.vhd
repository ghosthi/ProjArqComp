library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc is
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
end entity uc;

architecture a_uc of uc is

    signal endereco_prox_instr      : unsigned(6 downto 0);
    signal saida_rom                : unsigned(18 downto 0);
    signal opcode                   : unsigned(3 downto 0);
    signal jump_inc                 : std_logic := '0';
    signal jump_cond                : std_logic := '0';
    signal usa_imm                  : std_logic := '0';

begin

    opcode <= instr(3 downto 0);

    -- CALCULAR AQ CASO BNE OU BVS    
    jump_cond <= '1' WHEN opcode = "1010" AND ovfl_ula = '1' AND instr_fetch = "01" ELSE
                 '1' WHEN opcode = "1100" AND zero_ula = '0' AND instr_fetch = "01" ELSE
                 '0';

    jump_inc <=  '1' WHEN opcode="1111" ELSE '0';

    -- CALCULAR AQ CASO BNE OU BVS ( PC + DELTA )
    endereco_prox_instr <= instr(13 downto 7) WHEN jump_inc = '1' ELSE 
                pc_data - "0000001" + instr(13 downto 7) WHEN jump_cond = '1' ELSE
                pc_data; -- PC_DATA é END INSTR ATUAL + 1 NA LEITURA

    mem_read <= endereco_prox_instr;
    
    acumulador_wr_en <= '1' WHEN (opcode = "0010" OR opcode = "0100" OR 
                    opcode = "0111" OR opcode = "0001" OR
                    opcode = "0101" OR opcode = "1011"
                    ) AND instr_fetch = "10"
                    ELSE '0';

    pc_wr_en <= '1' WHEN instr_fetch = "01" ELSE '0'; -- ESTADO 1 ou tendo JMP

    -- LD 
    wr_reg <= '1' WHEN opcode = "1000" OR opcode = "1101" ELSE '0';
    reg_write <= instr(6 downto 4) WHEN opcode = "1000" OR opcode = "1101" ELSE "000";

    -- LD, JMP ou SUBI
    usa_imm <= '1' WHEN opcode = "0101" OR opcode = "1101" OR opcode = "1000" OR opcode = "1111" ELSE '0';

    -- CASO JMP
    imm <= a_out WHEN usa_imm = '1' AND opcode = "1101" ELSE
            instr(18) & instr(18) & instr(18) & instr(18) & instr(18 downto 7) WHEN usa_imm = '1' ELSE
            "0000000000000000";

    read_reg <= instr(6 downto 4) WHEN usa_imm = '0' AND (
                opcode = "0010" OR
                opcode = "0100" OR
                opcode = "0101" OR
                opcode = "1000" OR
                opcode = "1100" OR 
                opcode = "1010" OR 
                opcode = "1011"
            ) ELSE "000";

    ula_opt <= "001" WHEN opcode = "0010" ELSE -- ADD OPS
                "010" WHEN opcode = "0111" 
                    OR opcode = "0101" 
                    OR opcode = "1010" 
                    OR opcode = "1100"
                    OR opcode = "0100" ELSE
                "011" WHEN opcode = "0001" ELSE
                "100" WHEN opcode = "1011" ELSE 
                "000";
                

    exception <= 
        "10" WHEN opcode = "0011" OR opcode = "0110" OR 
                opcode = "1001" OR opcode = "1110" 
        ELSE "01" WHEN endereco_prox_instr(6) = '1'
        ELSE "00";

end a_uc;
