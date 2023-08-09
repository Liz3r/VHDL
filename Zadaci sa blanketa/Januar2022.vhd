library IEEE;
use IEEE.std_logic_1164.all;

entity element is
port(
	a,b,c: in std_logic;
    output: out std_logic;
);
end entity element;

architecture A of element is
begin
	output <= (a xor b) and c;
end architecture A;



library IEEE;
use IEEE.std_logic_1164.all;

entity kolo is
generic(
	n: integer;
);
port(
	b_in,c_in: in std_logic_vector(n-1 downto 0);
    a_in: std_logic;
    output_final: out std_logic_vector(n-1 downto 0);
);
end entity kolo;

architecture k of kolo is
signal out_in_connect: std_logic_vector(n-1 downto 0);
begin

    
	g: for i in 0 to n-1 generate
    
    	ig1: if i = 0 generate
        
        	e1: entity work.element(A) port map(a => a_in, b => b_in(i), c => c_in(i), 
            output => out_in_connect(i));
            
        else generate
        
        	e: entity work.element(A) port map(a => out_in_connect(i-1), b => b_in(i), c => c_in(i),
            output => out_in_connect(i));
        
        end generate ig1;
    
    output_final(i) <= out_in_connect(i);
    
    end generate g;


end architecture k;


--tb

library IEEE;
use IEEE.std_logic_1164.all;


entity tb is generic(num:integer := 8);
end entity tb;


architecture tb of tb is
signal sig_b,sig_c,sig_out: std_logic_vector(num-1 downto 0);
signal sig_a: std_logic;
begin


ent: entity work.kolo(k) 
generic map(n => num)
port map( a_in => sig_a, b_in => sig_b, c_in => sig_c, output_final => sig_out);

main: process is
begin


	sig_a <= '1';
    sig_b <= "11010011";
    sig_c <= "11100010";
    wait for 2 ns;
    sig_a <= '1';
    sig_b <= "11010011";
    sig_c <= "11111111";
    wait for 2 ns;
    sig_a <= '1';
    sig_b <= "11010011";
    sig_c <= "00000000";
    wait for 2 ns;
    sig_a <= '0';
    sig_b <= "11010011";
    sig_c <= "10101010";
    wait for 2 ns;
    

end process main;


end architecture tb;