library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity display is port(
	uni,dec,cen: in STD_LOGIC_VECTOR(3 downto 0);
	clk: in STD_LOGIC; --Se recomienda de 400Hz
	segmentos: out STD_LOGIC_VECTOR(7 downto 0);
	anodos: out STD_LOGIC_VECTOR(7 downto 0)
	);
end display;

architecture Behavioral of display is
	signal barrido: STD_LOGIC_VECTOR(1 downto 0);
	signal numero: STD_LOGIC_VECTOR(3 downto 0);
begin

Multiplexor : process( clk, barrido, uni, dec, cen )
begin
	if clk'event and clk = '1' then barrido <= barrido + "01";
	end if ;
	case( barrido ) is
		when "00" =>	numero <= uni;		anodos <= "11111110";
		when "01" =>	numero <= dec;		anodos <= "11111101";
		when "10" =>	numero <= cen;		anodos <= "11111011";
		when others =>	numero <= "1111";	anodos <= "11111111";
	end case ;
end process ; -- Multiplexor


Codificador_display : process( numero )
begin
	case( numero ) is
		when X"0" => segmentos <= "00000011";
		when X"1" => segmentos <= "10011111";
		when X"2" => segmentos <= "00100101";
		when X"3" => segmentos <= "00001101";
		when X"4" => segmentos <= "10011001";
		when X"5" => segmentos <= "01001001";
		when X"6" => segmentos <= "01000001";
		when X"7" => segmentos <= "00011111";
		when X"8" => segmentos <= "00000001";
		when X"9" => segmentos <= "00011001";
		when others => segmentos <= "11111111";
	end case ;
end process ; -- Codificador_display

end Behavioral;

