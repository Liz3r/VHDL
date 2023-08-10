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
    	if(clk'event and clk = '0') then
        
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

entity brojac is port(
	digit0,digit1: out std_logic_vector(3 downto 0);
    parallel_in: in std_logic_vector(7 downto 0);
    clk: in std_logic;
    we: in std_logic;
);
end entity brojac;

architecture b of brojac is
begin

 bp: process(clk) is
 variable smer: std_logic;
 variable val0, val1: std_logic_vector(3 downto 0);
 variable valid: bit;
 begin
 
 	if(clk'event and clk = '0') then
    
    	if(we = '1') then
        
        	for i in parallel_in'range loop
            	if(parallel_in(i) /= '1' and parallel_in(i) /= '0') then
                    valid := '0';
                    exit;
                end if;
            end loop;
        
        	if(valid = '0') then
            	val1 := (others => '0');
                val0 := (others => '0');
                smer := '1';
            else
            	val1 := parallel_in(7 downto 4);
                val0 := parallel_in(3 downto 0);
            end if;
        	
            digit1 <= val1;
            digit0 <= val0;
        
        elsif(we = '0') then
        
        	if(smer = '1') then
            
            	case val0 is
                	when "0000" => val0 := "0001";
                    when "0001" => val0 := "0010";
                    when "0010" => val0 := "0011";
                    when "0011" => val0 := "0100";
                    when "0100" => val0 := "0101";
                    when "0101" => val0 := "0110";
                    when "0110" => val0 := "0111";
                    when "0111" => val0 := "1000";
                    when "1000" => val0 := "1001";
                    when others =>
                    	val0 := "0000";
                    	case val1 is
                        	when "0000" => val1 := "0001";
                    		when "0001" => val1 := "0010";
                    		when "0010" => val1 := "0011";
                    		when "0011" => val1 := "0100";
                    		when "0100" => val1 := "0101";
                    		when "0101" => val1 := "0110";
                    		when "0110" => val1 := "0111";
                    		when "0111" => val1 := "1000";
                      		when "1000" => val1 := "1001";
                            when others => val1 := "0000";
                        end case;
                end case;
                digit0 <= val0;
                digit1 <= val1;
                    
            
            elsif(smer = '0') then
            
            	case val0 is
                	when "1001" => val0 := "1000";
                    when "1000" => val0 := "0111";
                    when "0111" => val0 := "0110";
                    when "0110" => val0 := "0101";
                    when "0101" => val0 := "0100";
                    when "0100" => val0 := "0011";
                    when "0011" => val0 := "0010";
                    when "0010" => val0 := "0001";
                    when "0001" => val0 := "0000";
                    when others =>
                    	val0 := "1001";
                    	case val1 is
                        	when "1001" => val1 := "1000";
                    		when "1000" => val1 := "0111";
                    		when "0111" => val1 := "0110";
                    		when "0110" => val1 := "0101";
                    		when "0101" => val1 := "0100";
                    		when "0100" => val1 := "0011";
                    		when "0011" => val1 := "0010";
                    		when "0010" => val1 := "0001";
                    		when "0001" => val1 := "0000";
                            when others => val1 := "1001";
                        end case;
                end case;
                digit0 <= val0;
                digit1 <= val1;
            
            end if;
        
        end if;
    
    
    end if;
 
 end process bp;
end architecture b;


--tb

library IEEE;
use IEEE.std_logic_1164.all;

entity tb is
end entity tb;

architecture tb of tb is
signal sig_dig1,sig_dig0: std_logic_vector(3 downto 0);
signal sig_parallel: std_logic_vector(7 downto 0);
signal sig_clk: std_logic;
signal sig_we: std_logic;
begin


en: entity work.brojac(b) port map(clk => sig_clk, we => sig_we, digit0 => sig_dig0, digit1 => sig_dig1, parallel_in => sig_parallel);

klok: process is
begin
	sig_clk <= '1' after 2 ns, '0' after 4 ns;
	wait for 4 ns;
end process klok;

main: process is
begin

	sig_we <= '1';
    wait for 6 ns;
    sig_we <= '0';
    wait for 300ns;

end process main;

end architecture tb;