library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_tb is
end ula_tb;

architecture testbench_ula of ula_tb is
	-- componentes tesbench ULA
    signal ent1_tb, ent2_tb, uout_tb : unsigned(15 downto 0);
    signal uopt_tb : unsigned(2 downto 0); 
    signal zero_tb, ovfl_tb : std_logic;

    -- CONSTANTES PARA CADA OPERAÇÃO DA ULA OPT
	constant soma: unsigned(2 downto 0):= "001";
	constant subt: unsigned(2 downto 0):= "010";
    constant dec: unsigned(2 downto 0):= "011";
    constant mult: unsigned(2 downto 0):= "100";

	--componentes ULA
    component ula is
        port (
            ent1, ent2: in unsigned(15 downto 0);   -- entadas de valores
            uopt: in unsigned(2 downto 0);          -- entada do seletor de operação
            uout: out unsigned(15 downto 0);        -- saida da ula
            ovfl: out std_logic;                    -- ocorreu overflow
            zero: out std_logic                    -- ocorreu overflow
        );
	end component;

begin

	ula_inst: ula
	port map (
		ent1 => ent1_tb,
		ent2 => ent2_tb,
		uopt => uopt_tb,
		uout => uout_tb,
		ovfl => ovfl_tb,
		zero => zero_tb
	);
	
	process
		begin
			uopt_tb <= soma;
            -- ================================================================================
            --                                      SOMAS                                      
            -- ================================================================================ 
			ent1_tb <= "0000000000001010"; -- 10 + 1
			ent2_tb <= "0000000000000001";
			wait for 10 ns;

			ent1_tb <= "1111111111110110"; -- -10 + 1
			ent2_tb <= "0000000000000001";
			wait for 10 ns;
            
			ent1_tb <= "0111111111111111"; -- 32767 + 32767
			ent2_tb <= "0111111111111111";
			wait for 10 ns;

			ent1_tb <= "1111111111110110"; -- -10 + (-10)
			ent2_tb <= "1111111111110110";
			wait for 10 ns;

			uopt_tb <= subt;
            -- ================================================================================
            --                                      SUBTRACAO                                      
            -- ================================================================================ 
			ent1_tb <= "0000000000001011"; -- 11 - 1
			ent2_tb <= "0000000000000001";
			wait for 10 ns;

			ent1_tb <= "1111111111110110"; -- -10 - (-10)
			ent2_tb <= "1111111111110110";
			wait for 10 ns;
            
			ent1_tb <= "1111111111110001"; -- -15 - 17
			ent2_tb <= "0000000000010001";
			wait for 10 ns;

			ent1_tb <= "1111111111110110"; -- -10 - (-16385)
			ent2_tb <= "1011111111111111";
			wait for 10 ns;

            uopt_tb <= dec;
			ent2_tb <= "0000000000000000";
            -- ================================================================================
            --                                      DEC                                      
            -- ================================================================================ 
			ent1_tb <= "0000000000000101";  -- 4
			wait for 10 ns;

			ent1_tb <= uout_tb;             -- 3
			wait for 10 ns;

			ent1_tb <= uout_tb;             -- 2
			wait for 10 ns;

			ent1_tb <= uout_tb;             -- 1
			wait for 10 ns;

			ent1_tb <= uout_tb;             -- 0
			wait for 10 ns;

            uopt_tb <= mult;
            -- ================================================================================
            --                                   MULTIPLICAÇÂO                                      
            -- ================================================================================ 
			ent1_tb <= "0000000000001011"; -- 11 * 1
			ent2_tb <= "0000000000000001";
			wait for 10 ns;

			ent1_tb <= "1111111111101100"; -- -10 * (-10)
			ent2_tb <= "1111111111110110";
			wait for 10 ns;
            
			ent1_tb <= "0000000000000100"; -- 4 * -4
			ent2_tb <= "1111111111111100";
			wait for 10 ns;

			ent1_tb <= "1111111111111100"; -- -4 * 2
			ent2_tb <= "0000000000000010";
			wait for 10 ns;
			wait;
		end process;
        
end architecture testbench_ula;