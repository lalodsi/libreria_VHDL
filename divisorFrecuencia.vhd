library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity divisorFrecuencia is port(
	clk: in STD_LOGIC;
	clk_out: inout STD_LOGIC
	);
end divisorFrecuencia;

architecture Behavioral of divisorFrecuencia is
	signal clk_signal: STD_LOGIC := '0';
begin

-- Reloj de 10us
process(clk)
	variable contador: integer;
begin
	if clk'event and clk = '1' then
		if (contador < 250) then
			contador := contador + 1;
		else
			contador := 0;
			clk_signal <= not clk_signal;
		end if;
	end if;
end process;

	clk_sensor <= clk_signal;

end Behavioral;

