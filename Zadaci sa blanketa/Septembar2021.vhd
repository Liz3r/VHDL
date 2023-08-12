library IEEE;
use IEEE.std_logic_1164.all;

entity proveri_parnost is
generic(
	n: integer := 8;
);
port(
	parnost: out std_logic_vector(n downto 0);
    num: in std_logic_vector(n-1 downto 0);
);
end entity proveri_parnost;

architecture pp of proveri_parnost is
begin

	proc: process(num) is
    variable parno: std_logic;
    begin
    
    parno := '1';
    
    for i in 0 to n-1 loop
    	if(num(i) = '1') then
        	parno := not parno;
        end if;
    end loop;
    
    parnost <= parno & num;
    
    end process proc;

end architecture pp;

-----

library IEEE;
use IEEE.std_logic_1164.all;

entity sabirac is
generic(
	m: integer := 9;
);
port(
    num1,num2: in std_logic_vector(m-1 downto 0);
    output: out std_logic_vector(m-2 downto 0);
    ispravna_parnost: out std_logic;
);
end entity sabirac;

architecture s of sabirac is
signal prenos: std_logic_vector(m-1 downto 0);
signal rezultat: std_logic_vector(m-2 downto 0);
signal pnum_out1, pnum_out2: std_logic_vector(m-1 downto 0);
begin

	g:for i in 0 to m-2 generate
    
    	ig1: if(i = 0) generate
        	rezultat(i) <= num1(i) xor num2(i);
            prenos(i) <= num1(i) and num2(i);
        elsif(i = m-1) generate
        	rezultat(i) <= num1(i) xor num2(i) xor prenos(i-1);
        else generate
        	rezultat(i) <= num1(i) xor num2(i) xor prenos(i-1);
            prenos(i) <= (num1(i) and num2(i)) or (num2(i) and prenos(i-1)) or (num1(i) and prenos(i-1));
        end generate ig1;
    
    end generate g;
    
    output <= rezultat;
    
    en1: entity work.proveri_parnost(pp)
    port map(num => num1(m-2 downto 0), parnost => pnum_out1);
    
    en2: entity work.proveri_parnost(pp)
    port map(num => num2(m-2 downto 0), parnost => pnum_out2);
    
    ispravna_parnost <= '1' when ((pnum_out1(m-1) = num1(m-1)) and (pnum_out2(m-1) = num2(m-1))) else '0';

end architecture s;

---tb

library IEEE;
use IEEE.std_logic_1164.all;

entity tb is
end entity tb;

architecture tb of tb is
signal sig_n1,sig_n2: std_logic_vector(8 downto 0);
signal sig_out: std_logic_vector(7 downto 0);
signal sig_par: std_logic;
begin

ent: entity work.sabirac(s)
port map( num1 => sig_n1, num2 => sig_n2, output => sig_out, ispravna_parnost => sig_par);

main: process is
begin
	
    sig_n1 <= "101010101";
    sig_n2 <= "110100101";
    wait for 10 ns;
    sig_n1 <= "101010001";
    sig_n2 <= "110100101";
    wait for 10 ns;
    sig_n1 <= "001010101";
    sig_n2 <= "110111101";
    wait for 10 ns;
    sig_n1 <= "001010101";
    sig_n2 <= "010100101";
    wait for 10 ns;

end process main;

end architecture tb;