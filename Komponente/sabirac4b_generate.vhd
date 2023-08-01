library IEEE;
use IEEE.std_logic_1164.all;

entity sabirac4b_generate is port(
	a,b: in std_logic_vector(3 downto 0);
    cin: in std_logic;
    sum: out std_logic_vector(3 downto 0);
    cout: out std_logic;
);
end entity sabirac4b_generate;

architecture s4bg of sabirac4b_generate is
signal cins: std_logic_vector(4 downto 0);
begin
	cins(0) <= cin;
	gen: for i in 0 to 3 generate
    	sum(i) <= a(i) xor b(i) xor cins(i);
        cins(i+1) <= (a(i) and cins(i)) or (b(i) and cins(i)) or (a(i) and b(i));
    end generate;
    cout <= cins(4);
end architecture s4bg;

-- 
-- \ab 00 01 11 10
--Cin |----------
--	0 |0  0  1  0
--	1 |0  1  1  1
--
--Cin = (a and Cin) or (b and Cin) or (a and b)

--tb

library IEEE;
use IEEE.std_logic_1164.all;


entity tb is
end entity tb;

architecture tb of tb is
signal op1,op2,s: std_logic_vector(3 downto 0);
signal sig_cin,sig_cout: std_logic;
begin

en: entity work.sabirac4b_generate(s4bg) port map(
	a => op1, b=> op2, sum => s, cin => sig_cin, cout => sig_cout
);

p: process is
	begin
    
    op1 <= "1010";
    op2 <= "0101";
    sig_cin <= '0';
   	wait for 5 ns;
    op1 <= "1010";
    op2 <= "0111";
    sig_cin <= '0';
   	wait for 5 ns;
    op1 <= "1010";
    op2 <= "0101";
    sig_cin <= '1';
   	wait for 5 ns;
    op1 <= "1000";
    op2 <= "0001";
    sig_cin <= '0';
    wait for 5 ns;
    
    end process p;


end architecture tb;