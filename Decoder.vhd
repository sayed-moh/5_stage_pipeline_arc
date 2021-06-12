LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
ENTITY Decod IS
PORT(   out_decod : out std_logic_vector(7 DOWNTO 0);
	enable:in std_logic;
	in_decod: in std_logic_vector(2 DOWNTO 0)
	);
END Decod;
ARCHITECTURE a_decoder OF Decod IS
BEGIN
	out_decod(0)<='1' when in_decod="000" AND enable='1'
	ELSE '0';
	out_decod(1)<='1' when in_decod="001" AND enable='1'
	ELSE '0';
	out_decod(2)<='1' when in_decod="010" AND enable='1'
	ELSE '0';
	out_decod(3)<='1' when in_decod="011" AND enable='1'
	ELSE '0';
	out_decod(4)<='1' when in_decod="100" AND enable='1'
	ELSE '0';
	out_decod(5)<='1' when in_decod="101" AND enable='1'
	ELSE '0';
	out_decod(6)<='1' when in_decod="110" AND enable='1'
	ELSE '0';
	out_decod(7)<='1' when in_decod="111" AND enable='1'
	ELSE '0';
END a_decoder;

