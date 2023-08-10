library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity brojac is 
generic(
	n: integer;
);
port(
	clk: in std_logic;
    we: in std_logic;
    parallel_in: in std_logic_vector(n-1 downto 0);
    output: out std_logic_vector(n-1 downto 0);
);
end entity brojac;

architecture b of brojac is
begin


proc: process(clk) is
	variable smer: bit;
    variable vrednost: natural;
	begin
	
    if(clk'event and clk = '1') then
    
    	if(we = '1') then
        
        	for i in parallel_in'range loop
            	if(parallel_in(i) /= '0' and parallel_in(i) /= '1') then
                	smer := '1';
                    vrednost := 0;
                    exit;
                end if;
            end loop;
    		
            if(to_integer(unsigned(parallel_in)) < n and to_integer(unsigned(parallel_in)) > 0) then
            	vrednost := to_integer(unsigned(parallel_in));
            end if;
        elsif(we = '0') then
        
        	if(smer = '1') then
            
            	if(vrednost = n) then
                	smer:= not smer;
                else
                	vrednost :=  vrednost + 1;
                end if;
                
            elsif(smer = '0') then
            
            	if(vrednost = 0) then
                	smer:= not smer;
                else
                	vrednost :=  vrednost - 1;
                end if;
                
                
            end if;
        
    	end if;
    
    end if;
	
    output <= std_logic_vector(to_unsigned(vrednost, output'length));
	end process proc;

end architecture b;

--tb

library IEEE;
use IEEE.std_logic_1164.all;


entity tb is generic( num:integer := 8);
end entity tb;

architecture tb of tb is
signal sig_clk,sig_we: std_logic;
signal sig_in,sig_out: std_logic_vector(num-1 downto 0);
begin


e: entity work.brojac(b) generic map (n => num) port map( clk => sig_clk, we => sig_we, parallel_in => sig_in, output => sig_out);
p: process is
   	begin
        
        sig_we <= '1';
        wait for 1 ns;
        sig_we <= '0';
        wait for 300 ns;
        
        
    end process p;

	klok: process is
   	begin
    	sig_clk <= '1' after 1 ns, '0' after 2 ns;
    	wait for 2 ns;
    end process klok;
    
    
	

	
end architecture tb;