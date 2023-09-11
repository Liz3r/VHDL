library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity registar is
port(
	din: in std_logic_vector(7 downto 0);
    clk,rst,enable: in std_logic;
    dout: out std_logic_vector(7 downto 0);
    enableNext: out std_logic;
    valueOut: out std_logic_vector(7 downto 0);
);
end entity registar;

architecture reg of registar is
begin

pr: process(clk) is
variable trenutno,ulaz: integer;
begin

	if(clk'event and clk = '1') then
    	if(rst = '1') then
        	trenutno := 0;
        else
        	if(enable = '1') then
            	ulaz := to_integer(unsigned(din));
                if(trenutno = 0) then
                	trenutno := ulaz;
                    enableNext <= '0';
        		elsif(ulaz > trenutno) then
                	trenutno := ulaz;
                    enableNext <= '1';
                    dout <= std_logic_vector(to_unsigned(trenutno,dout'length));
                elsif(ulaz < trenutno) then
                    enableNext <= '1';
                    dout <= din;
                end if;
            elsif(enable = '0') then
            	enableNext <= '0';
        	end if;
        end if;
        valueOut <= std_logic_vector(to_unsigned(trenutno, valueOut'length));
    end if;

end process pr;

end architecture reg;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity brojac is
generic( n: integer range 0 to 255 );
port(
	en,clk,rst: in std_logic;
    output: out std_logic_vector(7 downto 0);
    overflow: out std_logic;
);
end entity brojac;

architecture br of  brojac is
begin

pr: process(clk) is
variable trenutno: integer range 0 to 255;
variable granica: integer;
begin

	if(clk'event and clk = '1') then
    	granica := n;
    	if(rst = '1') then
        	trenutno := 0;
            overflow <= '0';
        else
    		if(en = '1') then
        		if(trenutno < granica) then
                	trenutno := trenutno +1;
                else
                	overflow <= '1';
                end if;
            end if;
        end if;
    	output <= std_logic_vector(to_unsigned(trenutno,output'length));
    end if;

end process pr;

end architecture br;


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity kolo is
generic( m: integer );
port(
	clk,rst,enable: in std_logic;
    dout: out std_logic_vector(7 downto 0);
    doutParallel: out std_logic_vector(m*8-1 downto 0);
);
end entity kolo;

architecture k of kolo is
type rtr is array (m-1 downto 0) of std_logic_vector(7 downto 0);
signal brojacOut: std_logic_vector(7 downto 0);
signal regToReg: rtr;
signal enableNextReg: std_logic_vector(m-1 downto 0);
begin

	b: entity work.brojac(br) 
    generic map( n => 152)
    port map(en => enable, clk => clk, rst => rst, output => brojacOut);
    
    g1:for i in 1 to m-1 generate
    
    	ig1:if( i = m-1 ) generate
    		r: entity work.registar(reg)
        	port map(din => regToReg(i-1), clk => clk, rst => rst, enable => enableNextReg(i-1), dout => dout,
            enableNext => enableNextReg(i),valueOut => doutParallel(i*8-1 downto i*8-8));
        elsif(i = 1) generate
        	r: entity work.registar(reg)
        	port map(din => brojacOut, clk => clk, rst => rst, enable => enable, dout => regToReg(i),
            enableNext => enableNextReg(i),valueOut => doutParallel(i*8-1 downto i*8-8));
    	else generate
        	r: entity work.registar(reg)
        	port map(din => regToReg(i-1), clk => clk, rst => rst, enable => enableNextReg(i-1), dout => regToReg(i),
            enableNext => enableNextReg(i),valueOut => doutParallel(i*8-1 downto i*8-8));
        
        end generate ig1;
    end generate g1;

end architecture k;

--------------tb

library IEEE;
use IEEE.std_logic_1164.all;

entity tb is
end entity tb;


architecture tb  of tb is
signal sig_clk,sig_rst,sig_en: std_logic;
signal sig_dout: std_logic_vector(7 downto 0);
signal sig_doutParallel: std_logic_vector(5*8-1 downto 0);
begin

klok: process is
begin
	sig_clk <= '1' after 10ns, '0' after 20ns;
    wait for 20ns;
end process klok;

k: entity work.kolo(k) 
    generic map(m => 5)
    port map(clk => sig_clk, rst => sig_rst, enable => sig_en, dout => sig_dout, doutParallel => sig_doutParallel);

main: process is
begin

	sig_rst <= '1';
    sig_en <= '1';
    wait for 100ns;
    sig_rst <= '0';
    wait for 100000ns;

end process main;

end architecture tb;