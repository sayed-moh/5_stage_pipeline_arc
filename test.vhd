LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
ENTITY test IS
Port(
clk:In std_logic;
Rst:In std_logic
);
end Entity;
ARCHITECTURE a_test OF test
IS
    Component nReg IS
        GENERIC ( n : integer := 32);
        PORT( Clk,Rst : IN std_logic;
        in_reg : IN std_logic_vector(n-1 DOWNTO 0);
        enable:IN std_logic;
        out_reg : OUT std_logic_vector(n-1 DOWNTO 0));
    END Component;
signal x:std_logic_vector(115 Downto 0);
signal y:std_logic_vector(115 DOWNTO 0);
begin
RegF:nReg generic map(116) port map(clk,Rst,x,'1',y);

end ARCHITECTURE;
