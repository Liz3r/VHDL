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
use IEEE.std_logic_arith.all;

entity brojac is 
generic( n: integer );
port(
	smer_in: inout std_logic;
    reset,clk: in std_logic;
    output: out std_logic_vector(n-1 downto 0);
);
end entity brojac;

architecture b of brojac is
begin

 bp: process(clk) is
 variable smer: std_logic;
 variable value: integer range 0 to n**2-1;
 begin
 
 	if(clk'event and clk = '1') then
    
    	if(reset = '1') then
        	smer:= '1';
            value := 0;
        elsif(reset = '0') then
        	if(smer_in = '1' or smer_in = '0') then
            	smer := smer_in;
            end if;
            
            if(smer = '1') then
            
            	if(value = n**2-1) then
                	value := 0;
                else
                	value := value + 1;
                end if;
            elsif(smer = '0') then
            	if(value = 0) then
                	value := n**2-1;
                else
                	value := value - 1;
                end if;
            end if;
        end if;
    	output <= conv_std_logic_vector(value,output'length);
        smer_in <= smer;
    end if;
 
 end process bp;
end architecture b;


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity kolo is 
generic(
	num: integer;
);
port(
	k_clk,k_reset: in std_logic;
    k_smer: inout std_logic;
    final: out std_logic_vector(num-1 downto 0);
    
);
end entity kolo;

architecture k of kolo is
signal counter_flipflop: std_logic_vector(num/2-1 downto 0);
signal sig_reset,sig_smer: std_logic;
signal sig_clk: std_logic;
signal sig_output: std_logic_vector(num-1 downto 0);
begin

	broj: entity work.brojac(b)
    generic map( n => num)
    port map(clk => k_clk, reset => k_reset, smer_in => k_smer, 
    output => sig_output);

    counter_flipflop <= sig_output(num/2-1 downto 0);
    final(num-1 downto num/2) <= sig_output(num-1 downto num/2);

	g1: for i in 0 to num/2-1 generate
    signal final_output: std_logic_vector(num-1 downto 0);
   	begin
    	
    	e:entity work.d_flipflop(d) 
        port map(D => counter_flipflop(i), Q => final_output(i), clk => k_clk);
        
    
    end generate;


end architecture k;

--tb

library IEEE;
use IEEE.std_logic_1164.all;

entity tb is generic( numm: integer := 4);
end entity tb;

architecture tb of tb is
signal sig_reset,sig_smer: std_logic;
signal sig_clk: std_logic;
signal sig_output: std_logic_vector(numm-1 downto 0);
begin


	ent: entity work.kolo(k) 
    generic map( num => numm)
    port map(k_clk => sig_clk, k_reset => sig_reset, k_smer => sig_smer, final => sig_output);

klok: process is
begin
	sig_clk <= '1' after 2 ns, '0' after 4 ns;
	wait for 4 ns;
end process klok;

main: process is
begin

	sig_reset <= '1';
    wait for 6 ns;
    sig_reset <= '0';
    wait for 300ns;

end process main;

end architecture tb;