library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity Mux2_1x14 is port (
    S     : in  std_logic;
    L0, L1: in  std_logic_vector(13 downto 0);
    D     : out std_logic_vector(13 downto 0));
end Mux2_1x14;
        
architecture arqdtp of Mux2_1x14 is
    begin
    
     D <=  L0   when s <= '0' else
		   L1;	
		   
end arqdtp;	