library IEEE;
use IEEE.std_logic_1164.all;

entity d_flipflop is
port(
	D,clk: in std_logic;
    Q: out std_logic;
);
end entity d_flipflop;

architecture d of d_flipflop is
begin

	p: process (clk) is
    variable nextQ: std_logic;
    begin
    	nextQ := Q;
    	if(clk'event and clk = '0') then
            nextQ := D;
        end if;
        Q <= nextQ;
    end process p;

end architecture d;

------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity brojac is
generic( n: integer );
port(
	upis: in std_logic_vector(n-1 downto 0);
    we: in std_logic;
    reset: in std_logic;
    output: out std_logic_vector(n-1 downto 0);
    clk: in std_logic;
);
end entity brojac;

architecture b of brojac is
begin

pr: process(clk) is
variable nextSt: integer range 0 to n-1;
variable smer: bit;
begin
	
    if(clk'event and clk = '1') then
    
    	if(reset = '1') then
        	nextSt := 0;
            smer := '1';
        else
          	if(we = '1') then
        		nextSt := to_integer(unsigned(upis));
        	elsif(we = '0') then
            	if(smer = '1') then
            		if(nextSt >= ((2**n)-1)) then
                    	smer := '0';
                        nextSt := nextSt - 1;
                    else 
        				nextSt := nextSt + 1;
                    end if;
                elsif(smer = '0') then
                	if(nextSt <= 0) then
                    	smer := '1';
                        nextSt := nextSt + 1;
                    else 
        				nextSt := nextSt - 1;
                    end if;
        		end if;
                
        	end if;
        end if;
    	output <= std_logic_vector(to_unsigned(nextSt,output'length));
    end if;

end process pr;

end architecture b;

---
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity kolo is
generic( nn: integer );
port(
	ulaz: in std_logic_vector(nn-1 downto 0);
    we: in std_logic;
    clk: in std_logic;
    reset: in std_logic;
    output: out std_logic_vector(nn-1 downto 0);
);
end entity kolo;

architecture k of kolo is
signal sig_clk, sig_we, sig_reset: std_logic;
signal sig_ulaz, brojac_izlaz: std_logic_vector(nn-1 downto 0);
begin

sig_clk <= clk;
sig_we <= we;
sig_reset <= reset;


br: entity work.brojac(b)
generic map( n => nn)
port map(upis => sig_ulaz,clk => sig_clk, we => sig_we, reset => sig_reset, output => brojac_izlaz);

flipflop: entity work.d_flipflop(d)
port map( D => brojac_izlaz(nn-1), clk => sig_clk, Q => output(nn-1));

g:for i in 0 to nn-2 generate
	output(i) <= brojac_izlaz(i);
end generate g;


end architecture k;

--tb

library IEEE;
use IEEE.std_logic_1164.all;


entity tb is
generic(num:integer := 8);
end entity tb;




architecture tb of tb is
signal ulaz,izlaz: std_logic_vector(num-1 downto 0);
signal sig_we,sig_clk,sig_reset: std_logic;
begin

klk: process is
begin
	sig_clk <= '1' after 100ns, '0' after 200ns;
    wait for 200ns;
end process klk;

en: entity work.kolo(k) 
generic map(nn => num)
port map(ulaz => ulaz, output => izlaz,clk => sig_clk, we => sig_we, reset => sig_reset);

main: process is
begin

	sig_reset <= '1';
    sig_we <= '0';
    ulaz <= "10101100";
    wait for 300 ns;
    sig_reset <= '0';
    wait for 3000 ns;
    sig_we <= '1';
    ulaz <= "10101100";
    wait for 3000 ns;
    

end process main;

end architecture tb;