library IEEE;
use IEEE.std_logic_1164.all;

entity int_to_7seg is
port(
	output: out std_logic_vector(6 downto 0);--abcdefg (6 5 4 3 2 1 0)
    input: in integer;
);
end entity int_to_7seg;

architecture dec of int_to_7seg is
begin

	with input select output <=
    	"1111110" when 0,
        "0110000" when 1,
        "0110111" when 2,
        "0011111" when 3,
        "1011101" when 4,
        "1011011" when 5,
        "1111101" when 6,
        "0001110" when 7,
        "0000000" when others;

end architecture dec;
------
library IEEE;
use IEEE.std_logic_1164.all;

entity brojac is
port(
	reset: in std_logic;
    ce: in std_logic;
    clk: in std_logic;
    output: out integer;
);
end entity brojac;

architecture b of brojac is
begin

	pr: process(clk) is
    variable current: integer range 0 to 99;
    begin
    
    	if(clk'event and clk = '1') then
        
           if(reset = '1') then
           		current := 0;
           elsif(reset = '0') then
                if(ce = '1') then
                    if(current = 99) then
                    	current := 0;
                    else
                    	current :=  current + 1;
                    end if;
                end if;
           end if;
           output <= current;
        end if;
   
    end process pr;

end architecture b;
-----
library IEEE;
use IEEE.std_logic_1164.all;

entity delitelj is
port(
	ulazni_broj: in integer;
    cifra_za_prikaz: out integer;
    indikator_c1,indikator_c10: out std_logic;
    clk: in std_logic;
);
end entity delitelj;

architecture d of delitelj is
begin

	p: process(clk) is
    variable trenutna_cifra: bit := '0';
    variable prikaz: integer;
    begin
    
    if(clk'event and clk = '0') then
    	
        if(trenutna_cifra = '0') then
        	indikator_c1 <= '1';
            indikator_c10 <= '0';
            prikaz := ulazni_broj/10;
        elsif(trenutna_cifra = '1') then
        	indikator_c1 <= '0';
            indikator_c10 <= '1';
            prikaz := ulazni_broj mod 10;
    	end if;
    
    	cifra_za_prikaz <= prikaz;
        trenutna_cifra := not trenutna_cifra;
        
    end if;
    
    end process p;

end architecture d;

-----
library IEEE;
use IEEE.std_logic_1164.all;

entity kolo is
port(
	clk_b,clk_c: in std_logic;
    reset: in std_logic;
    ce: in std_logic;
    output1,output2: out std_logic_vector(6 downto 0);
);
end entity kolo;

architecture k of kolo is
signal brojac_out: integer;
signal delitelj_out: integer;
signal delitelj_indikator1,delitelj_indikator2: std_logic;
signal cif1,cif10: integer;
begin

	br: entity work.brojac(b)
    port map(clk => clk_b,reset => reset, ce => ce, output => brojac_out);
    
    del: entity work.delitelj(d)
    port map(clk => clk_c, ulazni_broj => brojac_out, cifra_za_prikaz => delitelj_out,
    indikator_c1 => delitelj_indikator1, indikator_c10 => delitelj_indikator2);
    
    kon: process(clk_b,clk_c) is
    begin
    	if(delitelj_indikator1 = '1' and delitelj_indikator2 = '0') then
        	cif1 <= delitelj_out;
        elsif(delitelj_indikator2 = '1' and delitelj_indikator1 = '0') then
        	cif10 <= delitelj_out;
        end if;
    end process kon;

	dec1: entity work.int_to_7seg(dec)
    port map(input => cif1, output => output1);
    
    dec2: entity work.int_to_7seg(dec)
    port map(input => cif10, output => output2);

end architecture k;
-----tb

library IEEE;
use IEEE.std_logic_1164.all;

entity tb is
end entity tb;

architecture tb of tb is
signal clk1,clk2: std_logic;
signal sig_reset: std_logic;
signal sig_ce: std_logic;
signal out1,out2: std_logic_vector(6 downto 0);
begin

	en: entity work.kolo(k)
    port map(clk_b => clk1, clk_c => clk2, reset => sig_reset, ce => sig_ce, 
    output1 => out1, output2 => out2);
    
    
	klok1: process is
    begin
    	clk1 <= '1' after 5ns, '0' after 10ns;
        wait for 10ns;
    end process klok1;
    
    klok2: process is
    begin
    	clk2 <= '1' after 12ns, '0' after 24ns;
        wait for 24ns;
    end process klok2;

	main: process is
    begin
    
    	sig_reset <= '1';
        sig_ce <= '0';
        wait for 30ns;
        sig_reset <= '0';
        sig_ce <= '1';
        wait for 3000ns;
        
    
    end process main;

end architecture tb;