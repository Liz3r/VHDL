
library IEEE;
use IEEE.std_logic_1164.all;




------------------------------brojac
--mora prvo da se resetuje--

entity counter is port(
	clk: in std_logic;
	reset: in std_logic;
	output: out integer range 0 to 255;
);
end entity counter;


architecture count_arh of counter is
begin

cp: process(clk,reset) is
	variable current: integer range 0 to 255;
	begin
    
    if(reset'event and reset = '1') then
    	current := 0;
    elsif(clk'event and clk = '1') then
    	if(current = 255) then
        	current := 0;
       	else
    		current := current +1;
        end if;
    end if;
    output <= current;
    
    end process cp;
end architecture count_arh;

------------------------------memorija
library IEEE;
use IEEE.std_logic_1164.all;

entity memorija is port(
	clk: in std_logic;
	we: in std_logic;
	data: in std_logic_vector(7 downto 0);
	adr: in integer range 0 to 255;
    q: out std_logic_vector(7 downto 0);
);
end entity memorija;

architecture mem_arh of memorija is
type ram is array(0 to 255) of std_logic_vector(7 downto 0);
signal mem: ram;
begin
	-- u svkom kloku ce se citati podatak sa zadate adrese
    --a upis se vrsi samo ako je we = '1'
	mp: process(clk) is
    begin
    
    if(clk'event and clk = '1' and we = '1') then
        mem(adr) <= data;
    end if;
    q <= mem(adr);
    end process mp;

end architecture mem_arh;
------------------------------sabirac
library IEEE;
use IEEE.std_logic_1164.all;

entity sabirac is port(
	a,b: in std_logic_vector(7 downto 0);
    cin: in std_logic;
    sum: out std_logic_vector(7 downto 0);
    cout: out std_logic;
);
end entity sabirac;

architecture sab of sabirac is
signal cins: std_logic_vector(8 downto 0);
begin
	cins(0) <= cin;
	g: for i in 0 to 7 generate
    
    sum(i) <= a(i) xor b(i) xor cins(i);
    cins(i+1) <= (a(i) and cins(i)) or (b(i) and cins(i)) or (a(i) and b(i));
    end generate;
	cout <= cins(8);
end architecture sab;
------------------------------buffer
library IEEE;
use IEEE.std_logic_1164.all;

entity buff is port(
	we: in std_logic;
    data_in: in std_logic_vector(7 downto 0);
    data_out: out std_logic_vector(7 downto 0);
    clk: in std_logic;
);
end entity buff;

architecture buff_arh of buff is
signal data: std_logic_vector(7 downto 0);
begin

	bp: process(clk) is
    	begin
        	if(clk'event and clk = '1') then
            	if(we = '1') then
            		data <= data_in;
                end if;
                data_out <= data;
            end if;
        
        end process bp;

end architecture buff_arh;
------------------------------control
library IEEE;
use IEEE.std_logic_1164.all;

entity control is port(
	we: in std_logic;
    clk: in std_logic;
    ctrl_rst: in std_logic;
    rst_adr: out std_logic;
    upis1: out std_logic;
    upis2: out std_logic;
);
end entity control;

architecture ctrl of control is
begin

	cproc: process(we,clk, ctrl_rst) is
    	variable buffToWriteInto: bit;
    	begin
        
        if(we'event or (ctrl_rst'event and ctrl_rst = '1')) then
        	rst_adr <= '1';
            buffToWriteInto := '0';
            rst_adr <= '0';
        end if;
        if(clk'event and clk = '1') then
        
        	if(we = '0') then
            	if(buffToWriteInto = '0') then
                	upis1 <= '1';
                    upis2 <= '0';
                else
                	upis2 <= '1';
                    upis1 <= '0';
                end if;
                buffToWriteInto := not buffToWriteInto;
            elsif(we = '1') then
            	upis1 <= '0';
                upis2 <= '0';
            end if;
        
        end if;
        
        end process cproc;

end architecture ctrl;

----------------------sistem
library IEEE;
use IEEE.std_logic_1164.all;

entity sistem is port(
	clk,we,rst: in std_logic;
    mem_input: in std_logic_vector(7 downto 0);
    output: out std_logic_vector(7 downto 0);
);
end entity sistem;

architecture sis of sistem is
signal sig_ctrl_rst,sig_adr_rst,sig_upis1,sig_upis2: std_logic;
signal sig_adr_counter_to_mem: integer;
signal data_out_mem: std_logic_vector(7 downto 0);
signal data_out_buff1, data_out_buff2: std_logic_vector(7 downto 0);
signal sab_cin: std_logic;
begin

	ctrl: entity work.control(ctrl) 
    port map( we => we,clk => clk, ctrl_rst => rst, rst_adr => sig_adr_rst,
    upis1 => sig_upis1, upis2 => sig_upis2);
    
    mem: entity work.memorija(mem_arh)
    port map( clk => clk, we => we, adr => sig_adr_counter_to_mem, data => mem_input,
    Q => data_out_mem);
    
    buf1: entity work.buff(buff_arh) 
    port map(clk => clk, data_in => data_out_mem, data_out => data_out_buff1, we => sig_upis1);
    
    buf2: entity work.buff(buff_arh) 
    port map(clk => clk, data_in => data_out_mem, data_out => data_out_buff2, we => sig_upis2);
    
    sab: entity work.sabirac(sab)
    port map(a => data_out_buff1, b => data_out_buff2, cin => sab_cin, sum => output);
 

end architecture sis;

--------------tb


library IEEE;
use IEEE.std_logic_1164.all;

entity tb is
end entity tb;


architecture tb of tb is
signal sig_clk, counter_reset: std_logic;
signal sig_we: std_logic;
signal sig_out: std_logic_vector(7 downto 0);
signal counter_output: integer range 0 to 255 ;
signal sig_input: std_logic_vector(7 downto 0);
begin

    
    sistem: entity work.sistem(sis) port map(clk => sig_clk, we => sig_we, output => sig_out, 
    rst => counter_reset, mem_input => sig_input);
    
    ----------------klok
    klok: process is
    	begin
        	sig_clk <= '1' after 1 ns, '0' after 2 ns;
        	wait for 2 ns;
    end process klok;
    --------------------
    
    
    
    main: process is
    	begin
        if(counter_reset /= '1' and counter_reset /= '0') then
        	counter_reset <= '1';
        end if;
        --u prvom prolazu se salje reset counteru
        wait for 3 ns;
        counter_reset <= '0';
        wait for 1 ns;
        -------------
        sig_we <= '1';
        
        sig_input <= "11000000";
        wait for 1 ns;
        sig_input <= "11010000";
        wait for 1 ns;
        sig_input <= "11001100";
        wait for 1 ns;
        sig_input <= "11000111";
        wait for 1 ns;
        sig_input <= "11111100";
        wait for 1 ns;
        sig_input <= "11111110";
        wait for 1 ns;
        sig_input <= "11111111";
        wait for 1 ns;
        
        
        end process main;


end architecture tb;