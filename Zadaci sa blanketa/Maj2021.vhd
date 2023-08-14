library IEEE;
use IEEE.std_logic_1164.all;

entity pomreg is
port(
	din,clk,clr,in_enable: in std_logic;
    dout: out std_logic;
);
end entity pomreg;

architecture pr of pomreg is
begin

	proc: process(clk,clr) is
    variable value: std_logic;
    begin
    	if(clr'event and clr = '1') then
        	value := '0';
        elsif(clk'event and clk = '1') then
        	if(in_enable = '1') then
            	dout <= value;
            	value := din;
        	elsif(in_enable = '0') then
            	dout <= value;
                value := '0';
            end if;
        end if;
        
    end process proc;
end architecture pr;
--------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity kolo is
generic(n,m: integer);
port(
	clk,clr,WR: in std_logic;
    din,dout: out std_logic_vector(m-1 downto 0);
);
end entity kolo;

architecture k of kolo is
type mv_type is array (0 to n-1,m-1 downto 0) of std_logic;
signal medjuveze: mv_type;
signal sig_clk,sig_clr,sig_wr: std_logic;
signal sig_din: std_logic_vector(m-1 downto 0);
begin


sig_clk <= clk;
sig_clr <= clr;
sig_wr <= WR;
sig_din <= din;


g:for j in 0 to n-1 generate

	ii1:if(j = 0) generate
		g1:for i in 0 to m-1 generate
    		e1: entity work.pomreg(pr)
        	port map(clk => sig_clk, clr => sig_clr, in_enable => sig_wr,din => sig_din(i),
        	dout => medjuveze(j,i));
		end generate g1;
    else generate
    	g2:for i in 0 to m-1 generate
    		e2: entity work.pomreg(pr)
        	port map(clk => sig_clk, clr => sig_clr, in_enable => sig_wr,din => medjuveze(j-1,i),
        	dout => medjuveze(j,i));
		end generate g2;
    end generate ii1;
    
    g3:for k in 0 to m-1 generate
    	dout(k) <= medjuveze(n-1, k);
    end generate g3;
end generate g;

end architecture k;

----tb

library IEEE;
use IEEE.std_logic_1164.all;


entity tb is
generic(nn: integer := 6; mm: integer := 8);
end entity tb;

architecture tb of tb is
signal sig_clk,sig_clr,sig_wr: std_logic;
signal sig_din, sig_dout: std_logic_vector(mm-1 downto 0);
begin

k: process is
begin
	sig_clk <= '1' after 10ns, '0' after 20ns;
	wait for 20ns;
end process k;

en: entity work.kolo(k)
generic map( n=>nn,m=>mm)
port map( clk => sig_clk, clr => sig_clr, WR => sig_wr,din => sig_din, dout => sig_dout);

main: process is
begin

	sig_clr <= '1';
    sig_wr <= '1';
    sig_din <= "10110011";
    wait for 30ns;
    sig_clr <= '0';
    sig_wr <= '1';
    sig_din <= "10110011";
    wait for 3000ns;

end process main;

end architecture tb;