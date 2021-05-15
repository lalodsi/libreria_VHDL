library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Encoder is port(
		Enc1, Enc2: in STD_LOGIC;
		clk: in STD_LOGIC;
		Sal: out STD_LOGIC_VECTOR(3 downto 0)
	);
end Encoder;

architecture Behavioral of Encoder is
	signal numeroEncoder: STD_LOGIC_VECTOR(3 downto 0) := "0000";
	type Estados is (Idle, Def, edo1, edo2, reg);
	signal Edo_Actual, Next_State: Estados := Idle;
begin
--Parte combinacional
process(Enc1, Enc2, Edo_Actual, numeroEncoder) begin
	case Edo_Actual is
--Estado de espera
		when Idle =>
			if (Enc1 = '1') then
				Next_State <= Def; --Se manda al estado de definición
			else
				Next_State <= Idle;
			end if;
--Estado de definicion			
		when Def =>
			if (Enc2 = '0') then
				Next_State <= edo1;
			else
				Next_State <= edo2;
			end if ;
		when edo1 =>
				Next_State <= reg;
		when edo2 =>
				Next_State <= reg;
		when reg =>
				if (Enc1 = '0' and Enc2 = '0') then
					Next_State <= Idle;
				else
					Next_State <= reg;
				end if ;
	end case;
end process;
--Parte Secuencial
process(clk, Next_State, Edo_Actual) begin
	if clk'event and clk = '1' then
		Edo_Actual <= Next_State;
		if Edo_Actual = edo1 then
			if numeroEncoder = "1001" then
				numeroEncoder <= "0000";
			else
				numeroEncoder <= numeroEncoder + '1';
			end if;
		elsif Edo_Actual = edo2 then
			if numeroEncoder = "0000" then
				numeroEncoder <= "1001";
			else
				numeroEncoder <= numeroEncoder - '1';
			end if;
		end if;
	end if;
	
end process;

		sal <= numeroEncoder;
end Behavioral;

