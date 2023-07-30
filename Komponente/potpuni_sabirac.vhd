library IEEE;
use IEEE.std_logic_1164.all;

entity sabirac is
	port(
    a,b,c_in: in bit;
    c_out,sum: out bit
    );
end entity sabirac;

architecture sabirac_arh of sabirac is
subtype bv3 is bit_vector(2 downto 0);
begin
	with bv3'(a,b,c_in) select 
    (c_out,sum)<= 
    	BIT_VECTOR'("00")when"000",
    	BIT_VECTOR'("01")when"001",
        BIT_VECTOR'("01")when"010",
        BIT_VECTOR'("10")when"011",
        BIT_VECTOR'("01")when"100",
        BIT_VECTOR'("10")when"101",
        BIT_VECTOR'("10")when"110",
        BIT_VECTOR'("11")when"111";
end architecture sabirac_arh;


///-----------testbench

-- Code your testbench here
library IEEE;
use IEEE.std_logic_1164.all;

entity sabirac_tb is
end entity sabirac_tb;

architecture sabirac_tb of sabirac_tb is
	signal sig_a,sig_b,sig_cin,sig_cout,sig_sum : bit;
    
begin

	sab: entity work.sabirac(sabirac_arh) 
    port map(
    a=>sig_a,b=>sig_b,c_in=>sig_cin
    ,c_out=>sig_cout,sum=>sig_sum); 

	stimu: process
    begin
    sig_a<='1';
    sig_b<='0';
    sig_cin<='0';
    wait for 1 ns;
    sig_a<='1';
    sig_b<='1';
    sig_cin<='0';
    wait for 1 ns;
    sig_a<='1';
    sig_b<='1';
    sig_cin<='1';
    wait for 1 ns;
    sig_a<='0';
    sig_b<='0';
    sig_cin<='0';
    end process stimu;
end architecture sabirac_tb;

