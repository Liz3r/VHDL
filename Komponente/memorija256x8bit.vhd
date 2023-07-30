--design
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;


entity memorija is port(
	clk: in std_logic;
	we: in std_logic;
    adr: in std_logic_vector(7 downto 0);
    data: in std_logic_vector(7 downto 0);
    Q: out std_logic_vector(7 downto 0);
);
end memorija;

architecture mem_arh of memorija is
type mem_type is array (255 downto 0) of std_logic_vector(7 downto 0);
signal mem: mem_type;
begin

pr: process(clk)
	variable adresa: integer range 255 downto 0;
	begin
    
    if(clk'event and clk = '1') then
    	adresa := CONV_INTEGER(adr);
        if(we = '1') then
        	mem(adresa) <= data;
       	end if;
        Q<=mem(adresa);
        
    end if;
    end process pr;

end architecture mem_arh;

--testbench

library IEEE;
use IEEE.std_logic_1164.all;


entity tb is
end tb;

architecture tb of tb is
signal sig_clk, sig_we: std_logic;
signal sig_adr, sig_data, sig_Q: std_logic_vector(7 downto 0);
begin


komp: entity work.memorija(mem_arh) port map(
	clk => sig_clk,
    we => sig_we,
    adr => sig_adr,
    data => sig_data,
    Q => sig_Q
);

klok: process is
	begin
	sig_clk <= '1' after 1 ns, '0' after 2 ns;
    wait for 2 ns;
end process klok;


p: process is
	begin
	sig_we<= '1';
    sig_adr <= "01011001";
    sig_data <= "01111111";
	wait for 5 ns;
    sig_we<= '1';
    sig_adr <= "01011001";
    sig_data <= "01110000";
	wait for 5 ns;
    sig_we<= '1';
    sig_adr <= "01011001";
    sig_data <= "00000000";
	wait for 5 ns;

end process p;


end architecture tb;