library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity Transmisor is 
generic (
		--Relojxbit: la cantidad de ciclos de reloj en un bit recibido
		-- relojxbit = (frecuencia del reloj) / (Tasa de baudios)
		relojxbit: integer := 5208
		);  
port (
	clk: in std_logic;
	tx: out std_logic;
	Out_Data: in std_logic_vector(7 downto 0)
);
end Transmisor;

architecture Behavioral of Transmisor is

signal clk_envio: integer range 0 to relojxbit-1 := 0;
signal contador_datos: integer range 0 to 80 := 0;

begin


--
--														TRANSMISOR
--


process(clk) begin
	if clk'event and clk = '1' then	
		if clk_envio = relojxbit-1 then
			contador_datos <= contador_datos + 1;
			clk_envio <= 0;
		else
			clk_envio <= clk_envio + 1;
		end if;
	end if;
end process;

process(contador_datos, Out_Data) begin
case(contador_datos) is
	when 0	=>		tx <= '1';--Estado de reposo
	when 1	=>		tx <= '0';--Bit de inicio
	when 2	=>		tx <= Out_Data(0);
	when 3	=>		tx <= Out_Data(1);
	when 4	=>		tx <= Out_Data(2);
	when 5	=>		tx <= Out_Data(3);
	when 6	=>		tx <= Out_Data(4);
	when 7	=>		tx <= Out_Data(5);
	when 8	=>		tx <= Out_Data(6);
	when 9	=>		tx <= Out_Data(7);
	when 10 	=>		tx <= '1';
	when others =>	tx <= '1';
end case;
end process;


end Behavioral;

