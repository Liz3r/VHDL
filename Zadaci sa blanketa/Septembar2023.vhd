library IEEE;
use IEEE.std_logic_1164.all;

entity brojac is
generic( n: integer);
port(
	clk,rst: in std_logic;
    output: out std_logic_vector(n-1 downto 0);
);
end entity brojac;

architecture br of brojac is
begin


proc:process(clk) is
variable nextVal: std_logic_vector(n-1 downto 0);
variable check: std_logic_vector(n-1 downto 0);
begin

	
	if(clk'event and clk = '1') then
    	check := (others => '1');
    	if(rst = '1') then
        
        	nextVal := (others => '0');
            nextVal(n-1) := '1';
        
        elsif(rst = '0') then
        
        	if(nextVal = check) then
            	
                nextVal := (others => '0');
            	nextVal(n-1) := '1';
            
            else
            	nextVal := '1' & nextVal(n-1 downto 1);
            
            end if;
        
        end if;
    
    output <= nextVal;
    
    end if;

end process proc;

end architecture br;
-----------tb

library IEEE;
use IEEE.std_logic_1164.all;

entity tb is
generic( num: integer := 8);
end entity tb;

architecture tb of tb is
signal sig_clk,sig_rst: std_logic;
signal sig_out: std_logic_vector(num-1 downto 0);
begin


ent: entity work.brojac(br) 
generic map( n => num)
port map( clk => sig_clk, rst => sig_rst, output => sig_out);

klok: process is
begin
	sig_clk <= '1' after 50ns, '0' after 100ns;
    wait for 100ns;
end process klok;

main: process is
begin

	sig_rst <= '1';
    wait for 100ns;
    sig_rst <= '0';
    wait for 100000ns;

end process main;

end architecture tb;