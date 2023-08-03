library IEEE;
use IEEE.std_logic_1164.all;

entity mask_kolo is
generic(
	n: integer
);
port(
	din: in std_logic_vector(n-1 downto 0);
    msk_in: in std_logic;
    op: in std_logic_vector(1 downto 0);
    clk: in std_logic;
    output: out std_logic_vector(n-1 downto 0);
);
end entity mask_kolo;

architecture mk of mask_kolo is
begin

     g: for i in 0 to n-1 generate
     	signal mask: std_logic_vector(n-1 downto 0);
		signal operation: std_logic_vector(1 downto 0);
        begin
    
    	proc: process(clk) is
    	begin
    
    		if(clk'event and clk = '1') then
    			if(msk_in = '1') then
        			mask(i) <= din(i);
            		operation <= op;
            		output(i) <= 'Z';
                else
                	case operation is
        				when "00" =>
            				output(i) <= mask(i) and din(i);
            			when "01" =>
            				output(i) <= mask(i) or din(i);
            			when "10" =>
            				output(i) <= mask(i) xor din(i);
           				when others =>
            				output(i) <= 'Z';
                	end case;
       			end if;
    		end if;
        end process proc;
    	
    end generate g;

end architecture mk;


--tb

library IEEE;
use IEEE.std_logic_1164.all;

entity tb is
generic( num: integer := 8);
end entity tb;

architecture tb of tb is
signal sig_din,sig_output: std_logic_vector(num-1 downto 0);
signal sig_msk_in: std_logic;
signal sig_op: std_logic_vector(1 downto 0);
signal sig_clk: std_logic;
begin

test: entity work.mask_kolo(mk) 
generic map( n => num)
port map( din => sig_din, msk_in => sig_msk_in, op => sig_op, output => sig_output, clk => sig_clk);

klok: process is 
	begin
    	sig_clk <= '1' after 10 ns, '0' after 20ns;
        wait for 20 ns;
    end process klok;

main: process is
	begin
    sig_clk <= 'Z';
    sig_din <= (others => 'Z');
    sig_output <= (others => 'Z');
    sig_op <= (others => 'Z');
    sig_msk_in <= 'Z';    
    wait for 10 ns;
    sig_msk_in <= '1';
    sig_din <= "11000011";
    sig_op <= "10";
    wait for 20 ns;
    sig_msk_in <= '0';
    sig_din <= "00111100";
    wait for 2000ns;
	-- .
	-- .	
	-- .
    
    end process main;
    
end architecture tb;


