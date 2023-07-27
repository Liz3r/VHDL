--design
library IEEE;
use IEEE.std_logic_1164.all;

entity brojac is 
port(
	clk, clr: in bit;
	q: out bit_vector(3 downto 0);
);
end entity brojac;

architecture brojac_arh of brojac is
begin

	cl: process (clk,clr)
    variable druga: bit;
    variable q_tr: bit_vector(3 downto 0);
	begin
		if (clr'event and clr='1') then
        	q_tr := "0000";
            druga:='0';
        elsif (clk'event and clk='1') then
        	druga := not druga;
        	if (druga = '1') then
            	case q_tr is
                	when "0000" => q_tr := "0001";
                    when "0001" => q_tr := "0010";
                    when "0010" => q_tr := "0011";
                    when "0011" => q_tr := "0100";
                    when "0100" => q_tr := "0101";
                    when "0101" => q_tr := "0110";
					when "0110" => q_tr := "0111";
                    when "0111" => q_tr := "1000";
                    when "1000" => q_tr := "1001";
                    when others => q_tr := "0000";
                end case;
          	end if;
       	end if;
        q<=q_tr;
	end process cl;

end architecture brojac_arh;

--testbench


library IEEE;
use IEEE.std_logic_1164.all;

entity tb is
end entity tb;

architecture tb of tb is
signal sig_clk,sig_clr: bit;
signal sig_q: bit_vector(3 downto 0);
begin

	brojac: entity work.brojac(brojac_arh) port map(
    	clk=>sig_clk,
        clr=>sig_clr,
        q=>sig_q
    );
    
    klokenzi: process
    begin
    	sig_clk <= '1' after 1 ns, '0' after 2 ns;
        wait for 2 ns;
    end process klokenzi;
    
    
	

end architecture tb;

