LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

--Siglas:
--en = enable
--reg = registrador
--mux = multiplexador

ENTITY BC IS
	PORT (
		clk : IN STD_LOGIC;
		iniciar : IN STD_LOGIC;
		reset : IN STD_LOGIC;
		menor : OUT std_LOGIC; --sinal de que iteração chegou ao fim
		pronto : OUT STD_LOGIC; --end
		read_mem : OUT STD_LOGIC; --Read
		enRegA,enRegB,enRegPotenciacao,enRegSubtracao,EnRegSomaGeral,enRegResultado : OUT STD_LOGIC; --Sinais de controles de registradores
		enMuxSoma,enMuxIncrementador : OUT std_logic --Sinais de controle de multiplexadores
	);
END ENTITY; -- BC

ARCHITECTURE arch OF BC IS
TYPE Tipo_estado IS (S0, S1, S2, S3, S4, S5);
signal EA, PE : Tipo_estado;

BEGIN
	PROCESS(reset, clk)
	begin
	if reset = '1' then
		EA <= S0;
	elsif (rising_edge(clk)) then
		EA<=PE;
	end if;
	end process;
	
	PROCESS(iniciar, EA,menor)
	BEGIN
		CASE EA is
			--Estado de reset
			when S0 =>
				pronto <= '1';
				read_mem <= '0';
				enRegA <= '0';
				enRegB <= '0';
				enRegPotenciacao <= '0';
				EnRegSomaGeral <= '0';
				enRegResultado <= '0'; 
				enMuxSoma  <= '0';
				enMuxIncrementador  <= '0';			
				enRegSubtracao <= '0';

				
				if iniciar = '0' then
					PE <= S0;
				else 
					PE <= S1;
				end if;					
					
			--Estado de configuração dos registradores (reset)
			when s1 =>
				pronto <= '0';
				read_mem <= '0';
				enRegA <= '0';
				enRegB <= '0';
				enRegPotenciacao <= '0';
				EnRegSomaGeral <= '0';
				enRegResultado <= '0'; 
				enMuxSoma  <= '0';
				enMuxIncrementador  <= '1';					
				enRegSubtracao <= '0';

				
				PE <= S2;
					
			--Estado de verificação do iterador
			when s2 =>
				pronto <= '0';
				read_mem <= '0';
				enRegA <= '0';
				enRegB <= '0';
				enRegPotenciacao <= '0';
				EnRegSomaGeral <= '0';
				enRegResultado <= '0'; 
				enMuxSoma  <= '0';
				enMuxIncrementador  <= '0';				
				enRegSubtracao <= '0';

			
				if menor = '1' then
					pe <= s3;
				else
					pe <= s5;
				end if;

					
			--Estado de leitura de memórias
			when s3 =>
				pronto <= '0';
				read_mem <= '1';
				enRegA <= '1';
				enRegB <= '1';
				enRegPotenciacao <= '0';
				enRegSubtracao <= '0';
				EnRegSomaGeral <= '0';
				enRegResultado <= '0'; 
				enMuxSoma  <= '0';
				enMuxIncrementador  <= '0';			

				PE <= S4;	
				
			--Estado de subtração dos valores lidos
			when s4 =>
				pronto <= '0';
				read_mem <= '0';
				enRegA <= '0';
				enRegB <= '0';
				enRegPotenciacao <= '0';
				enRegSubtracao <= '1';
				EnRegSomaGeral <= '0';
				enRegResultado <= '0'; 
				enMuxSoma  <= '0';
				enMuxIncrementador  <= '0';			
				
				PE <= s5;

			--Estado de potenciação da subtração e incrementação da soma total
			--Realiza potência de 2, concatena bits restantes e e realiza a adição
			when s5 =>
				pronto <= '0';
				read_mem <= '0';
				enRegA <= '0';
				enRegB <= '0';
				enRegPotenciacao <= '1';
				EnRegSomaGeral <= '1';
				enRegResultado <= '0'; 
				enMuxSoma  <= '0';
				enMuxIncrementador  <= '0';			
				enRegSubtracao <= '0';

		
			PE <= S2;
				
			--Estado de divisão da potenciação das subtrações pelo tamanho da matriz
			when s6 =>
				pronto <= '0';
				read_mem <= '0';
				enRegA <= '0';
				enRegB <= '0';
				enRegPotenciacao <= '0';
				EnRegSomaGeral <= '0';
				enRegResultado <= '1'; 
				enMuxSoma  <= '0';
				enMuxIncrementador  <= '0';			
				enRegSubtracao <= '0';

				
				PE <= S0;
				
				
		end case;
	end process;
END ARCHITECTURE; -- arch