library IEEE;
use IEEE.std_logic_1164.all;

entity mux2x1 is
port(
	a,b,s: in std_logic;
    output: out std_logic;
);
end entity mux2x1;

architecture mux_arh of mux2x1 is
begin

	with s select output <=
    	a when '0',
        b when '1',
        'Z' when others;
        
end architecture;

library IEEE;
use IEEE.std_logic_1164.all;

entity reg is
generic( num_ports: integer );
port(
	input: in std_logic_vector(num_ports-1 downto 0);
    output: out std_logic_vector(num_ports-1 downto 0);
    clk: in std_logic;
    clr: in std_logic;
);
end entity reg;

architecture reg_arh of reg is
begin

	pr: process(clk) is
    variable current: std_logic_vector(num_ports-1 downto 0);
    begin
    	
        if(clr'event and clr = '0') then
        	current := (others => '0');
        end if;
        
        if(clk'event and clk = '1' and clr /= '0') then
            current := input;
        end if;
       	
        output <= current;
    end process pr;

end architecture reg_arh;

library IEEE;
use IEEE.std_logic_1164.all;

entity kolo is 
generic(n: integer);
port(
	a_in: in std_logic_vector(n-1 downto 0);
    b_in: in std_logic_vector(n-1 downto 0);
    s_in: in std_logic_vector(n-1 downto 0);
    output: out std_logic_vector(n-1 downto 0);
    clk,clr: in std_logic;
);
end entity kolo;

architecture k of kolo is
signal bs_conn: std_logic_vector(n-1 downto 0);
signal b_and_s: std_logic_vector(n-1 downto 0);
signal mux_to_reg: std_logic_vector(n-1 downto 0);
signal reg_to_out: std_logic_Vector(n-1 downto 0);
begin

r: entity work.reg(reg_arh)
generic map(num_ports => n)
port map(input => mux_to_reg, output => reg_to_out, clk => clk, clr => clr);

	g:for i in 0 to n-1 generate
    
    	ig:if(i = 0) generate
    		m0: entity work.mux2x1(mux_arh) 
            port map( a => a_in(i), b => b_in(i), s => s_in(i), output => mux_to_reg(i));
            bs_conn(i) <= b_in(i);
    	else generate
        
        	bs_conn(i) <= b_in(i);
            b_and_s(i) <= bs_conn(i-1) and s_in(i);
        	
        	m: entity work.mux2x1(mux_arh) 
            port map( a => a_in(i), b => b_in(i), s => b_and_s(i), output => mux_to_reg(i));
        
    	end generate ig;
    
    
    end generate g;
	output <= reg_to_out;
end architecture k;


--tb


library IEEE;
use IEEE.std_logic_1164.all;

entity tb is
generic(num:integer := 8);
end entity tb;

architecture tb of tb is
signal sig_clk,sig_clr: std_logic;
signal sig_a,sig_b,sig_s,sig_out: std_logic_vector(num-1 downto 0);
begin

e: entity work.kolo(k)
generic map(n => num)
port map(a_in => sig_a, b_in => sig_b, s_in => sig_s, output => sig_out,clk => sig_clk, clr => sig_clr);

klk: process is
begin
	sig_clk <= '1' after 5ns, '0' after 10ns;
    wait for 10 ns;
end process klk;

main: process is
begin
	sig_clr <= '0';
    sig_a <= "11001101";
    sig_b <= "11111111";
    sig_s <= "10001001";
    wait for 5 ns;
    sig_clr <= '1';
    sig_a <= "11001111";
    sig_b <= "00000000";
    sig_s <= "11001111";
    wait for 5 ns;
    sig_a <= "11001111";
    sig_b <= "11111111";
    sig_s <= "00000011";
    wait for 5 ns;
    sig_a <= "11001111";
    sig_b <= "11001111";
    sig_s <= "11001111";
    wait for 5 ns;
    wait for 5000ns;
	

end process main;

end architecture tb;