
library IEEE;
use IEEE.std_logic_1164.all;

entity count_zeros is 
generic(
	n: integer;
);
port (
	data: in std_logic_vector(n-1 downto 0);
	zeros: out integer;
);
end entity count_zeros;

architecture cz of count_zeros is
begin

	proc: process(data) is
    variable counter: integer;
    variable res: integer;
    begin
    	counter := 0;
    	for i in data'range loop
        
       		if data(i) = '0' then
            	counter := counter + 1;
            else
            	if counter > res then
                	res := counter;
                end if;
                counter := 0;
            end if;
            exit when i = data'right;
        end loop;
        zeros <= res;
    
    end process proc;

end architecture cz;

--tb


library IEEE;
use IEEE.std_logic_1164.all;


entity tb is
generic( num:integer := 10);
end entity tb;

architecture tb of tb is
signal sig_data: std_logic_vector(num-1 downto 0);
signal sig_zeros: integer;
begin

zc: entity work.count_zeros(cz) 
generic map( n => num)
port map( data=>sig_data,zeros=>sig_zeros);

p: process is
	begin
    
    sig_data <= "0000100111";
    wait for 3 ns;
    sig_data <= "0000000111";
    wait for 3 ns;
    sig_data <= "0000000011";
    wait for 3 ns;
    sig_data <= "0000000001";
    wait for 3 ns;
    
    end process p;

end architecture tb;