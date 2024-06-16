library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity reg8b is port (
	GENERIC (
	B : POSITIVE := 8;
	);
    D     : in  std_logic_vector(B-1 downto 0);
    Enable: in  std_logic;
    CLK   : in  std_logic;
    Q     : out std_logic_vector(B-1 downto 0));
end reg8b;
        
architecture arqdtp of reg8b is
    begin
    process(CLK)
    begin
        if(enable = '1') then
            if (CLK'event AND CLK = '1') then
    				q <= d;		
            end if;
        end if;
    end process;
end arqdtp;