library IEEE;
use IEEE.std_logic_1164.all;

entity automat is
port(
	clk, rst, X: in std_logic;
    Z: out std_logic;
);
end entity automat;

architecture ka of automat is
type state_type is (S0,S1,S2,S3);
begin

proc: process(clk) is
variable state: state_type;
variable output: std_logic;
begin

	if(clk'event and clk = '1') then
    
    	if(rst = '1') then
        	state := S0;
        elsif(rst = '0') then
        
        	output := '1' when state = S3 and X = '1' else '0';
        	
        	case state is
            	when S0 => 
                	state := S1 when X = '1' else S0 when X = '0';
          		when S1 =>
                	state := S2 when X = '0' else S1 when X = '1';
          		when S2 =>
                	state := S3 when X = '1' else S0 when X = '0';
          		when S3 =>
                	state := S1 when X = '1' else S2 when X = '0';
          	end case;
            
            
        end if;
    	
        Z <= output;
    end if;


end process proc;


end architecture ka;


------------------tb

library IEEE;
use IEEE.std_logic_1164.all;

entity tb is
end entity tb;


architecture tb of tb is
signal sig_clk,sig_reset,sig_x,sig_z: std_logic;
begin

k: process is
begin
	sig_clk <= '1' after 10 ns, '0' after 20 ns;
    wait for 20 ns;
end process k;

en: entity work.automat(ka) 
port map( clk => sig_clk, rst => sig_reset, X => sig_x, Z => sig_z);

main:process is
begin

	sig_reset <= '1';
    wait for 50ns;
    sig_reset <= '0';
    sig_x <= '1';
    wait for 20ns;
    sig_x <= '1';
    wait for 20ns;
    sig_x <= '1';
    wait for 20ns;
    sig_x <= '1';
    wait for 20ns;
    sig_x <= '1';
    wait for 20ns;
    sig_x <= '0';
    wait for 20ns;
    sig_x <= '1';
    wait for 20ns;
    sig_x <= '1';
    wait for 50ns;

end process main;

end architecture tb;
