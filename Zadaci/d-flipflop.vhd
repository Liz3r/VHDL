library IEEE;
use IEEE.std_logic_1164.all;

entity d_filpflop is 
port(
	d,q: std_logic;
    clk: bit;
);
end entity d_flipflop;

architecture d_arh of d_flipflop is
begin

	dproc: process
    variable nextQ: std_logic;
    begin
    	if(clk'event and clk = '0') then
        	if(d = '0') then
            	nextQ := '0';
            elsif(d = '1') then
            	nextQ := '1';
            else
            	nextQ := 'X';
            end if;
            q <= nextQ;
        end if;
    
    end process dproc;

end architecture d_arh;