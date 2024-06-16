LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

ENTITY BO IS
	GENERIC (
		B : POSITIVE := 8; -- número de bits por amostra
	);
	PORT (
		clk : IN STD_LOGIC; -- ck
		sample_ori : IN STD_LOGIC_VECTOR (B-1 DOWNTO 0); -- Mem_A[end] --saida da memoria e 1 byte
		sample_can : IN STD_LOGIC_VECTOR (B-1 DOWNTO 0); -- Mem_B[end]--saida da memoria e 1 byte
		enRegA,enRegB,enRegPotenciacao,enRegSubtracao,EnRegSomaGeral,enRegResultado : IN std_logic; --Entradas de controle de registrador do BC
		enMuxSoma,enMuxIncrementador : IN std_logic; --Entradas de controle de multipleaxador do BC
		address : OUT STD_LOGIC_VECTOR (5 DOWNTO 0); --Endereço a ler na memória
		menor : OUT STD_LOGIC; --Entrada pro BC indicando fim da interação
		
		
		------------------------------------------------------------------------------------------------------------------------
		
		
		--DAQUI PARA BAIXO A DESCRIÇÃO SE REFERE A SAD, CORRIGIR PARA MSE
		
		
		------------------------------------------------------------------------------------------------------------------------

		sad_value : OUT STD_LOGIC_VECTOR (13 DOWNTO 0) -- SAD --Supondo que o abs de cada posicao na matriz seja 255, teremos 255*64 = 16320, necessitando de 14 bit
		
	);
END ENTITY; -- BO

ARCHITECTURE arch OF BO IS
signal saidaPa, saidaPB, saidaABS,saidaREGABS : std_logic_vector(7 downto 0);
signal i : std_logic_vector(6 downto 0);
signal soma: std_logic_vector(13 downto 0);
signal auxAdress : std_logic_vector(6 downto 0);
signal saidaSoma7Bits, saidaMux7Bits, saidaRegI: std_logic_vector(6 downto 0);
signal absConcatenado14Bits,saidaRegSoma14Bits,saidaSoma14Bits, saidaMux14Bits: std_logic_vector(13 downto 0);
	
component Mux2_1x7 is port(
	 S     : in  std_logic;
    L0, L1: in  std_logic_vector(6 downto 0);
    D     : out std_logic_vector(6 downto 0)
	 );
end component;

component reg7b is port (
    D     : in  std_logic_vector(6 downto 0);
    Enable: in  std_logic;
    CLK   : in  std_logic;
    Q     : out std_logic_vector(6 downto 0));
end component;

component reg8b is port (
    D     : in  std_logic_vector(7 downto 0);
    Enable: in  std_logic;
    CLK   : in  std_logic;
    Q     : out std_logic_vector(7 downto 0));
end component;

component Mux2_1x14 is port (
    S     : in  std_logic;
    L0, L1: in  std_logic_vector(13 downto 0);
    D     : out std_logic_vector(13 downto 0));
end component;


component reg14b is port (
    D     : in  std_logic_vector(13 downto 0);
    Enable: in  std_logic;
    CLK   : in  std_logic;
    Q     : out std_logic_vector(13 downto 0));
end component;
        

BEGIN
Mux2x7: Mux2_1x7 port map(zi,saidaSoma7Bits,"0000000",saidaMux7Bits);
regI:  reg7b port map(saidaMux7Bits, '0', ci, clk,saidaRegI);

menor <= (not saidaRegI(6));
auxAdress <= saidaRegI(6 downto 0);

saidaSoma7Bits <= std_logic_vector(signed(auxAdress) + "0000001"); --OR
address <= auxAdress(5 downto 0);

--DEBUG
saidaDebug <= saidaABS;
saidaDebugSomaGeral <= saidaSoma14Bits;
--DEBUG


pa : reg8b port map(sample_ori, '0', cpa, clk, saidaPa);
pb : reg8b port map(sample_can, '0', cpb, clk, saidaPb);
mux14Bits : mux2_1x14 port map(zsoma,saidaSoma14Bits, "00000000000000",saidaMux14Bits);
regSoma : reg14b port map(saidaMux14Bits, '0', csoma, clk,saidaRegSoma14Bits);
sadReg : reg14b port map(saidaRegSoma14Bits, '0', csad_reg, clk, sad_value);


saidaABS <= std_logic_vector(abs(signed(saidaPA) - signed(saidaPB)));
absConcatenado14Bits <= "000000" & saidaABS;
saidaSoma14Bits <= std_logic_vector(signed(absConcatenado14Bits) + signed(saidaRegSoma14Bits)); --Mudou pra teste
END ARCHITECTURE; -- arch