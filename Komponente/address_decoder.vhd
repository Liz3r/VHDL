
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity address_decoder is 
generic(
	n: integer;
);
port(
	EN: in std_logic;
    adr: in unsigned( n-1 downto 0);
    adr_out: out std_logic_vector(2**n-1 downto 0);
);
end entity address_decoder;

architecture ad of address_decoder is
begin
	pr: process(EN, adr) is
    variable output: std_logic_vector(2**n-1 downto 0);
    variable sel: integer range 0 to 2**n-1;
    begin
        output := (others => '1');
        if(EN = '1') then
        	sel := to_integer(adr);
            output(sel) := '0';
       	end if;
       	adr_out <= output;
    end process pr;
end architecture ad;


--tb



library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity tb is
generic( num: integer := 4);
end entity tb;

architecture tb of tb is
signal sig_en: std_logic;
signal sig_adr: unsigned(num-1 downto 0);
signal sig_adr_out: std_logic_vector(2**num-1 downto 0);
begin
    
    adc: entity work.address_decoder(ad) 
    generic map(n=> num)
    port map( EN => sig_en, adr => sig_adr, adr_out => sig_adr_out);
    
    p: process is
    begin
    	sig_en <= '1';
        sig_adr <= "1010";
    	wait for 2 ns;
        sig_adr <= "1110";
        wait for 2 ns;
    	sig_adr <= "1111";
        wait for 2 ns;
        sig_adr <= "0000";
        wait for 2 ns;
        sig_en <= '0';
        wait for 2 ns;
    end process p;
    
end architecture tb;