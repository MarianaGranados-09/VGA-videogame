library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.STD_LOGIC_ARITH.all;

entity VGA_Control is
	port(
	    CLK		: in std_logic;  -- Señal de reloj (FPGA).
		RST		: in std_logic;  -- Reset.
		H 		: in std_logic;	 -- Habilitador.
		HSYNC 	: out std_logic; --Sincronizador Horiz 
		VSYNC 	: out std_logic; --Sincronizador Vert
		RGB		: out std_logic_vector(2 downto 0)
	);
end entity VGA_Control;



architecture union of VGA_Control is
signal baud : std_logic;
signal clk25M : std_logic := '0';

constant HD :  integer := 639; --Display Horiz 640
constant VD :  integer := 479; -- Display Vert 480

constant HFP : integer := 16; --front porch horizontal
constant VFP : integer := 10; --front porch vertical

constant HBP : integer := 48; --back porch horizontal
constant VBP : integer := 33; --back porch vertical

constant HSP : integer := 96; --pulso de sync horiz
constant VSP : integer := 2; --pulso de sync vert

signal HzPos : integer := 0; --contador de posicion horizontal
signal VtPos : integer := 0; --contador de posicion vertical

begin	
	C1 : entity work.BaseDeTiempo generic map(50000000,27)port map(CLK, RST, H, baud);
	
		
Div:process(CLK)
begin
	if(CLK'event and CLK ='1')then
		clk25M <= not clk25M;
	end if;
end process;

contadorPosicionHz:process(clk25M, RST)
begin 
	if(RST = '1') then
		HzPos <= 0;
	elsif(clk25M'event and clk25M = '1') then
		if(HzPos = (HD + HFP + HBP + HSP))then
			HzPos <= 0;	--reiniciar contador
		else
			HzPos <= HzPos + 1; --seguir contador si no se ha pasado del margen/presionado el RST
		end if;
	end if;
end process;

contadorPosicionVt:process(clk25M, RST)
begin 
	if(RST = '1') then
		VtPos <= 0;
	elsif(clk25M'event and clk25M = '1') then
		if(HzPos = (HD + HFP + HBP + HSP))then
			if(VtPos = (VD + VFP + VBP + VSP))then
				VtPos <= 0;	--reiniciar contador
			else
				VtPos <= VtPos + 1; --seguir contador si no se ha pasado del margen/presionado el RST
			end if;
		end if;
	end if;
end process;
end architecture union;  

