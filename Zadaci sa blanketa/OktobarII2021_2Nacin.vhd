library IEEE;
use IEEE.std_logic_1164.all;

entity kolo is
generic( n: integer );
port(
	s,a,b: in std_logic_vector(n-1 downto 0);
    clk: in std_logic;
    output: out std_logic_vector(n-1 downto 0);
);
end entity kolo;

architecture k of kolo is
signal mux_out: std_logic_vector(n-1 downto 0);
signal reg: std_logic_vector(n-1 downto 0);
begin

	g1:for i in 0 to n-1 generate
    	ig1: if(i = 0) generate
        	mux_out(i) <= ((not s(i)) and a(i)) or (s(i) and b(i));
        else generate
        	mux_out(i) <= (not (s(i) and b(i-1)) and a(i)) or (s(i) and b(i-1) and b(i));
        end generate ig1;
        p: process(clk) is
        begin
    		if(clk'event and clk = '1') then
            	reg(i) <= mux_out(i); 
        	end if;
        end process p;
        output(i) <= reg(i);
    end generate g1;

end architecture k;

-------------tb

library IEEE;
use IEEE.std_logic_1164.all;

entity tb is
generic(m: integer := 8);
end entity tb;

architecture tb of tb is
signal sig_a,sig_b,sig_s,sig_out: std_logic_vector(m-1 downto 0);
signal sig_clk: std_logic;
begin

klok: process is
begin
	sig_clk <= '1' after 10ns, '0' after 20ns;
    wait for 20 ns;
end process klok;

en: entity work.kolo(k) generic map( n => m )
port map(s => sig_s, a => sig_a, b => sig_b, output => sig_out, clk => sig_clk);

main: process is
begin
	sig_a <= "10110110";
    sig_b <= "00101101";
    sig_s <= "11010110";
    wait for 20ns;
    sig_a <= "11111111";
    sig_b <= "00101101";
    sig_s <= "11010110";
    wait for 20ns;
    sig_a <= "10110110";
    sig_b <= "00000000";
    sig_s <= "11010110";
    wait for 20ns;
    sig_a <= "10110110";
    sig_b <= "00101101";
    sig_s <= "11111111";
    wait for 20ns;
    sig_a <= "10110110";
    sig_b <= "00101101";
    sig_s <= "11111111";
    wait for 20ns;
    sig_a <= "00000000";
    sig_b <= "11111111";
    sig_s <= "11111111";
    wait for 20ns;
    sig_a <= "11111111";
    sig_b <= "00000000";
    sig_s <= "11111111";
    wait for 20ns;

end process main;


end architecture tb;