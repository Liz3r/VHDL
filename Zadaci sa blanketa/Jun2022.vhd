library IEEE;
use IEEE.std_logic_1164.all;

entity d_flipflop is port(
	D,clk: in std_logic;
    Q: out std_logic;
);
end entity d_flipflop;

architecture d of d_flipflop is
begin

	pr: process(clk) is
    variable nextQ: std_logic;
    begin
    	if(clk'event and clk = '1') then
        
        	if(D = '1') then
            	nextQ := '1';
            elsif(D = '0') then
            	nextQ := '0';
            end if;
        Q <= nextQ;
        end if;
    end process pr;

end architecture d;

library IEEE;
use IEEE.std_logic_1164.all;

entity kolo is 
generic(
	n: integer
);
port(
	in1: in std_logic_vector(n-1 downto 0);
    in2: in std_logic_vector(n-1 downto 0);
    inOr: in std_logic;
    k_clk: in std_logic;
    output: out std_logic_vector(n-1 downto 0);
);
end entity kolo;


architecture kol of kolo is
signal sig_out: std_logic_vector(n-1 downto 0);
signal sig_or_input: std_logic_vector(n-1 downto 0);
begin

	
    sig_or_input(0) <= inOr;
    
    g:for i in 0 to n-1 generate
    
    	
    	sig_out(i) <= (in1(i) and in2(i)) or sig_or_input(i);
        output <= sig_out;
    
    	i1: if i /= n-1 generate
    
    			dff: entity work.d_flipflop(d) 
        		port map( D => sig_out(i), Q => sig_or_input(i+1), clk => k_clk);

    	end generate i1;
        
    end generate g;


end architecture kol;


--tb

library IEEE;
use IEEE.std_logic_1164.all;


entity tb is generic( num: integer := 4);
end entity tb;


architecture tb of tb is
signal sig_clk: std_logic;
signal sig_in1,sig_in2: std_logic_vector(num-1 downto 0);
signal sig_inOr: std_logic;
signal sig_out: std_logic_vector(num-1 downto 0);
begin


klok: process is
begin
    sig_clk <= '1' after 2ns, '0' after 4ns;
    wait for 4ns;
end process klok;


k: entity work.kolo(kol) generic map(n => num)
    port map(in1 => sig_in1, in2 => sig_in2, inOr => sig_inOr, k_clk => sig_clk, output => sig_out);

main: process is
begin
	if(sig_inOr /= '0' and sig_inOr /= '1') then
	wait for 2 ns;
		sig_in1 <= "0011";
    	sig_in2 <= "1010";
    	sig_inOr <= '0';
    	wait for 32 ns;
    end if;
    sig_in1 <= "0011";
    sig_in2 <= "1010";
    sig_inOr <= '1';
    wait for 8 ns;
    sig_in1 <= "0011";
    sig_in2 <= "1100";
    sig_inOr <= '0';
    wait for 8 ns;

end process main;


end architecture tb;