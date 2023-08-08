library IEEE;
use IEEE.std_logic_1164.all;


entity konacni_automat is
generic
(
	n: integer
);
port(
	input: in std_logic;
	clk: in std_logic;
    wr: in std_logic;
	output: out std_logic_vector(n-1 downto 0);
);
end entity konacni_automat;

architecture ka of konacni_automat is
type state_type is (S0,S1);
begin

pr: process(clk) is
variable tmp: std_logic_vector(n-1 downto 0);
variable state_change_counter: integer := 0;
variable value: std_logic_vector(n-1 downto 0);
begin
	

	if(clk'event and clk = '1') then
    
    	if(wr = '1') then
        	value := input & value(n-1 downto 1);
        	state_change_counter := state_change_counter + 1;
            output <= (others => 'Z');
        elsif(wr = '0') then
        	if(state_change_counter > (n-1)) then
            	output <= value;
            else
            	output <= (others => 'Z');
            end if;
        end if;
    
    end if;

end process pr;


end architecture ka;

--tb

library IEEE;
use IEEE.std_logic_1164.all;


entity tb is generic( num: integer := 8);
end entity tb;

architecture tb of tb is
signal sig_clk,sig_in,sig_wr: std_logic;
signal sig_out: std_logic_vector(num-1 downto 0);
begin

en: entity work.konacni_automat(ka) generic map ( n => num)
port map(clk => sig_clk, input => sig_in, output => sig_out, wr => sig_wr);

klok: process is
begin
	sig_clk <= '1' after 5 ns, '0' after 10 ns;
    wait for 10 ns;
end process klok;

main: process is
begin

	sig_wr <= '1';
    sig_in <= '0';
    wait for 10 ns;
    
    sig_in <= '0';
    wait for 10 ns;
    
    sig_in <= '0';
    wait for 10 ns;
    
    sig_in <= '1';
    wait for 10 ns;
    
    sig_in <= '1';
    wait for 10 ns;
    
    sig_in <= '0';
    wait for 10 ns;
    
    sig_in <= '1';
    wait for 10 ns;
    
    sig_in <= '1';
    wait for 10 ns;
    
    sig_in <= '1';
    wait for 10 ns;

	sig_wr <= '0';
    sig_in <= '1';
    wait for 100 ns;
    
    sig_wr <= '1';
    sig_in <= '1';
    wait for 10 ns;
    
    sig_in <= '0';
    wait for 10 ns;
    
    sig_in <= '0';
    wait for 10 ns;
    
    sig_in <= '1';
    wait for 10 ns;
    
    sig_in <= '1';
    wait for 10 ns;
    
    sig_in <= '1';
    wait for 10 ns;
    
    sig_in <= '1';
    wait for 10 ns;
    
    sig_in <= '1';
    wait for 10 ns;
    
    sig_in <= '1';
    wait for 10 ns;

    
end process main;

end architecture tb;