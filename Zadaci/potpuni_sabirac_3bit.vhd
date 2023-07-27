--design:
-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;

entity sabirac is
	port(
    in1,in2,c_in: in bit;
    c_out,sum: out bit
    );
end entity sabirac;

architecture sabirac_arh of sabirac is
begin
	pr: process(in1,in2,c_in)
    begin
    	case bit_vector'(in1,in2,c_in) is
        	when "000" =>
            	c_out <= '0';
                sum <= '0';
            when "001" =>
            	c_out <= '0';
                sum <= '1';
            when "010" =>
            	c_out <= '0';
                sum <= '1';
            when "011" =>
            	c_out <= '1';
                sum <= '0';
            when "100" =>
            	c_out <= '0';
                sum <= '1';
            when "101" =>
            	c_out <= '1';
                sum <= '0';
            when "110" =>
            	c_out <= '1';
                sum <= '0';
            when "111" =>
            	c_out <= '1';
                sum <= '1';
        end case;
    end process pr;
        
end architecture sabirac_arh;

entity sabirac3b is port(
	op1,op2: in bit_vector(2 downto 0);
    cin: in bit;
    s: out bit_vector(2 downto 0);
    cout: out bit;
);
end entity sabirac3b;

architecture sabirac3b_arh of sabirac3b is
signal c01,c12: bit;
begin

s1: entity work.sabirac(sabirac_arh) port map(
	in1=>op1(0),
    in2=>op2(0),
    c_in=>cin,
    sum=>s(0),
    c_out=>c01
);

s2: entity work.sabirac(sabirac_arh) port map(
	in1=>op1(1),
    in2=>op2(1),
    c_in=>c01,
    sum=>s(1),
    c_out=>c12
);

s3: entity work.sabirac(sabirac_arh) port map(
	in1=>op1(2),
    in2=>op2(2),
    c_in=>c12,
    sum=>s(2),
    c_out=>cout
);

end architecture sabirac3b_arh;

--testbench:

-- Code your testbench here
library IEEE;
use IEEE.std_logic_1164.all;

entity sabirac_tb is
end entity sabirac_tb;

architecture sabirac_tb of sabirac_tb is
	signal sig_op1,sig_op2,sig_sum: bit_vector(2 downto 0);
    signal sig_cin,sig_cout: bit;
begin

	s: entity work.sabirac3b(sabirac3b_arh) port map(
    	op1=>sig_op1,
        op2=>sig_op2,
        s=>sig_sum,
        cin=>sig_cin,
        cout=>sig_cout
    );
    
    proc: process
    begin
    	sig_op1<= "001";
        sig_op2<= "110";
        sig_cin<= '1';
        wait for 1 ns;
        sig_op1<= "001";
        sig_op2<= "100";
        sig_cin<= '1';
        wait for 1 ns;
        sig_op1<= "001";
        sig_op2<= "110";
        sig_cin<= '0';
        wait for 1 ns;
        sig_op1<= "101";
        sig_op2<= "110";
        sig_cin<= '0';
        wait for 1 ns;
        sig_op1<= "101";
        sig_op2<= "010";
        sig_cin<= '0';
        wait for 1 ns;
    end process proc;
    
end architecture sabirac_tb;

