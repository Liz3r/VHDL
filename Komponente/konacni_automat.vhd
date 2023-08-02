library IEEE;
use IEEE.std_logic_1164.all;

entity tb is
end entity tb;


architecture tb of tb is
signal sig_clk, counter_reset: std_logic;
signal counter_output: integer range 0 to 255 ;
begin

	e:entity work.counter(count_arh) port map(clk => sig_clk, reset => counter_reset);
    
    ----------------klok
    klok: process is
    	begin
        	sig_clk <= '1' after 1 ns, '0' after 2 ns;
        	wait for 2 ns;
    end process klok;
    --------------------
    
    
    
    main: process is
    	begin
        if(not counter_reset = '1' and not counter_reset = '0') then
        	counter_reset <= '1';
        end if;
        --u prvom prolazu se salje reset counteru
        counter_reset <= '0';
        wait for 1 ns;
        
        
        
        end process main;


end architecture tb;

-------------------------

library IEEE;
use IEEE.std_logic_1164.all;




------------------------------brojac
--mora prvo da se resetuje--

entity counter is port(
	clk: in std_logic;
	reset: in std_logic;
	output: out integer range 0 to 255;
);
end entity counter;


architecture count_arh of counter is
begin

cp: process(clk,reset) is
	variable current: integer range 0 to 255;
	begin
    
    if(reset = '1') then
    	current := 0;
    elsif(clk'event and clk = '1') then
    	if(current = 255) then
        	current := 0;
       	else
    		current := current +1;
        end if;
    end if;
    output <= current;
    
    end process cp;
end architecture count_arh;

------------------------------memorija

entity memorija is port(
	clk: in std_logic;
	wr: in std_logic;
	data: in std_logic_vector(7 downto 0);
	adr: in integer;
    q: out std_logic_vector(7 downto 0);
);
end entity memorija;

architecture mem_arh of memorija is
type ram is array 0 to 255 of std_logic_vector(7 downto 0);
signal mem: ram;
begin

	mp: process is
    begin
    
    
    
    end process mp;

end architecture mem_arh;

------------------------------automat
entity automat is
end entity automat;
architecture auto_arh of automat is
begin

end architecture auto_arh;