library IEEE;
use IEEE.std_logic_1164.all;

entity brojac is
port(
	clk: in std_logic;
    rst: in std_logic;
    EN: in std_logic;
    output: out std_logic_vector(3 downto 0);
);
end entity brojac;

architecture b of brojac is
begin


pr: process(clk) is
variable current: integer range 0 to 9;
begin

	if(clk'event and clk = '1') then
    
    	if(rst = '1') then
        	current := 0;
        elsif(EN = '1') then
        	if(current < 9) then
            	current := current + 1;
            elsif(current >= 9) then
            	current := 0;
            end if;
        end if;
        
        case current is
        	when 0 => output <= "0000";
            when 1 => output <= "0001";
            when 2 => output <= "0010";
            when 3 => output <= "0011";
            when 4 => output <= "0100";
            when 5 => output <= "0101";
            when 6 => output <= "0110";
            when 7 => output <= "0111";
            when 8 => output <= "1000";
            when 9 => output <= "1001";
            when others => output <= "0000";
        end case;
            
        
    end if;

end process pr;
end architecture b;
----------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity dekoder is
port(
	input: in std_logic_vector(3 downto 0);
    output: out std_logic_vector(6 downto 0);--abcdefg
    ZERO: in std_logic;
);
end entity dekoder;

architecture d of dekoder is
begin

proc: process(input,ZERO) is
begin

	if(ZERO = '1') then
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

end process;
end architecture d;
---------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity kolo is
generic( n: integer);
port(
	EN,RESET: in std_logic;
    clk: in std_logic;
 	output_k: out std_logic_vector(n*6 downto 0);
);
end entity kolo;

architecture k of kolo is
signal brojac_out: std_logic_vector(3 downto 0);
signal sig_clk, sig_en, sig_res: std_logic;
begin

sig_clk <= clk;
sig_res <= RESET;
sig_en <= EN;

en3:entity work.brojac(b) port map(clk => sig_clk, rst => sig_res, EN => sig_en, output => brojac_out);
	
    g:for i in 0 to n generate
    	g2:if(i = 0) generate
        
        	en1:entity work.dekoder(d) port map(input => brojac_out, ZERO => sig_res, 
        	output => output_k(6 downto 0));
        
        else generate
    
    		en2:entity work.dekoder(d) port map(input => brojac_out, ZERO => sig_res, 
        	output => output_k(i*6 downto i*6-6));
            
    	end generate;
    end generate;

end architecture k;


------tb

library IEEE;
use IEEE.std_logic_1164.all;

entity tb is
generic( num: integer := 5);
end entity tb;

architecture tb of tb is
signal sig_clk,sig_en,sig_res: std_logic;
signal sig_out: std_logic_vector(num*6 downto 0);
begin

k: process is
begin
	sig_clk <= '1' after 10 ns, '0' after 20 ns;
    wait for 20 ns;
end process k;

	en:entity work.kolo(k) 
    generic map( n => num )
    port map( clk => sig_clk, EN => sig_en, RESET => sig_res, output_k => sig_out );

main: process is
begin
	
    sig_res <= '1';
    sig_en <= '1';
    wait for 50 ns;
    sig_res <= '0';
    wait for 3000 ns;

end process main;


end architecture tb;