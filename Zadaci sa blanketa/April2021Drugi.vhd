library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity brojac is
port(
	clk: in std_logic;
    rst: in std_logic;
    en: in std_logic;
    output: out std_logic_vector(3 downto 0);
);
end entity brojac;

architecture br of brojac is
begin

	pr: process(clk) is
    variable trenutno: integer range 0 to 9;
    begin
    
    if(clk'event and clk = '1') then
    	if(rst = '1') then
        	trenutno := 0;
        else
    		if(en = '1') then
        		if(trenutno <= 9) then
                	trenutno := trenutno +1;
                else
                	trenutno := 0;
        		end if;
        	end if;
    	end if;
    end if;
    
    output <= std_logic_vector(to_unsigned(trenutno,output'length));
    
    end process pr;

end architecture br;

library IEEE;
use IEEE.std_logic_1164.all;

entity dekoder is
port(
	input: in std_logic_vector(3 downto 0);
    zero: in std_logic;
    output: out std_logic_vector(6 downto 0); --abcdefg
);

--     a
--    ---
-- f |   | b
--    -g-
-- e |   | c
--    ---
--     d
end entity dekoder;

architecture bcd of dekoder is
begin

	proc: process(input) is
    begin
    if(zero = '1') then
    	output <= "0000000";
    else
    	case input is
        	when "0000" => output <= "1111110";
    		when "0001" => output <= "0110000";
    		when "0010" => output <= "1101101";
    		when "0011" => output <= "0110011";
    		when "0100" => output <= "1011011";
    		when "0101" => output <= "1011111";
    		when "0110" => output <= "1110000";
    		when "0111" => output <= "1111111";
    		when "1000" => output <= "1111011";
            when others => output <= "0000000";
    	end case;
    end if;
	end process proc;

end architecture bcd;

library IEEE;
use IEEE.std_logic_1164.all;

entity kolo is
generic( n: integer);
port(
EN,RST,CLK: in std_logic;
output: out std_logic_vector(n*7-1 downto 0);
);
end entity kolo;

architecture k of kolo is
signal brojac_dekoder: std_logic_vector(3 downto 0);
signal sig_zero: std_logic;
begin

	br1: entity work.brojac(br) port map(en => EN, rst => RST, clk => CLK, output => brojac_dekoder);
    
    
	g1: for i in n downto 1 generate
    	d1: entity work.dekoder(bcd) port map(input => brojac_dekoder, zero => sig_zero, 
    	output => output(i*7-1 downto i*7-7));
    end generate g1;

end architecture k;

------------------------tb

library IEEE;
use IEEE.std_logic_1164.all;

entity tb is
end entity tb;


architecture tb of tb is
signal sig_clk,sig_rst,sig_en: std_logic;
signal sig_out: std_logic_vector(8*7-1 downto 0);
begin

klok: process is
begin
sig_clk <= '1' after 10ns, '0' after 20ns;
wait for 20ns;
end process klok;

	en: entity work.kolo(k) 
    generic map( n => 8)
    port map(CLK => sig_clk, EN => sig_en, RST => sig_rst, output => sig_out);

main: process is
begin

	sig_rst <= '1';
    sig_en <= '1';
    wait for 100 ns;
    sig_rst <= '0';
    wait for 1000ns;

end process main;

end architecture tb;