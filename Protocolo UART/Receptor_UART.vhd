library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity Cserial is  
	generic (
		Datos_recibir: integer := 8;
		--Relojxbit: la cantidad de ciclos de reloj en un bit recibido
		-- relojxbit = (frecuencia del reloj) / (Tasa de baudios)
		relojxbit: integer := 5208
		);  
	port(
	Rx, clk: in std_logic;
	In_Data: out std_logic_vector (7 downto 0)--Datos que recibe el módulo de la computadora
	); 
end cserial;

architecture func of Cserial is 
-- Comunicación a 9600 baudios

	--
	--Señales para la comunicación UART
	--
	type estados is (Descanso, Rx_bit_inicio, Rx_bit_datos, Rx_bit_paro, Limpieza);
	signal edo_actual: estados := Descanso;
	signal rx_datos: std_logic;
	signal Done_S: std_logic;
	signal clk_conteo: integer range 0  to relojxbit-1 := 0;
	signal Numero_bit: integer range 0 to datos_recibir-1 :=0;
	signal datos: std_logic_vector(7 downto 0) := "00000000";

begin
--
-- Asignar entrada a señales internas
--
--process(rx) begin
	rx_datos <= rx;
	--Done <= Done_S;
--end process;

process(clk) begin

if clk'event and clk = '1' then

	case edo_actual is
		
		--
		-- Descanso: El sistema estará esperando un bit de 
		--				inicio para pasar al siguiente estado
		--
		when descanso =>
			if rx_datos = '0' then 
				edo_actual <= Rx_bit_inicio;
			else
				edo_actual <= descanso;
			end if;
				
		--
		-- RX_bit_inicio: El sistema ha recibido un cero lógico y estará 
		--						en espera para encontrar la mitad del
		-- 					bit recibido
		--
		when Rx_bit_inicio =>
			if rx_datos = '0' then
				if clk_conteo = (relojxbit-1)/2 then
					edo_actual <= Rx_bit_datos;
					clk_conteo <= 0;
				else
					edo_actual <= rx_bit_inicio;
					clk_conteo <= clk_conteo + 1;
				end if;
			else
				edo_actual <= descanso;
				clk_conteo <= 0;
			end if;
			
		--
		-- Rx_bit_datos: Una vez encontrada la mitad del bit recibido, 
		--						el estado de recepción de datos asigna los bits
		--						recibidos a un vector final mientras cuenta hasta 8
		--
		when Rx_bit_datos =>
			if clk_conteo < relojxbit-1 then
				clk_conteo <= clk_conteo + 1;
				edo_actual <= rx_bit_datos;
			else
				clk_conteo <= 0;
				datos(Numero_bit) <= rx_datos;
				if Numero_bit < datos_recibir-1 then
					edo_actual <= rx_bit_datos;
					numero_bit <= numero_bit + 1;
				else
					edo_actual <= rx_bit_paro;
					numero_bit <= 0;
				end if;
			end if;
		--
		-- Rx_bit_paro: Espera un ciclo para detener la recepción de datos
		--
		when Rx_bit_paro =>
			if clk_conteo < relojxbit-1 then
				clk_conteo <= clk_conteo + 1;
				edo_actual <= rx_bit_paro;
			else
				clk_conteo <= 0;
				edo_actual <= limpieza;
			end if;
		--
		-- Limpieza: Espera un ciclo de reloj y se va a descanso.
		--
		when Limpieza =>
			In_Data <= datos;
			edo_actual <= descanso;
		--
		--	Default
		--
		when others =>
			edo_actual <= descanso;
		
	end case;
	
	--data <= datos;
	
end if;

end process;



end func;