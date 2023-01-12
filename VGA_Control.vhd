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
		RGB		: out std_logic_vector(11 downto 0) --bits de RGB 
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

signal videoEN : std_logic :='0';

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

horizontal_sync:process(clk25M, RST, HzPos)
begin
	if(RST = '1')then
		HSYNC <= '0';
	elsif(clk25M'event and clk25M = '1')then
		if((HzPos <= (HD + HFP)) OR (HzPos > HD + HFP + HSP))then
			HSYNC <= '1';
		else 
			HSYNC <= '0';
		end if;
	end if;
end process;

vertical_sync:process(clk25M, RST, VtPos)
begin
	if(RST = '1')then
		VSYNC <= '0';
	elsif(clk25M'event and clk25M = '1')then
		if((VtPos <= (VD + VFP)) OR (VtPos > VD + VFP + VSP))then
			VSYNC <= '1';
		else 
			VSYNC <= '0';
		end if;
	end if;
end process;

videoEncendido:process(clk25M, RST, HzPos, VtPos)
begin 
	if(RST = '1')then  --enciende el reset entonces videoEN apagado
		videoEN <= '0';
	elsif(clk25M'event and clk25M = '1')then
		if(HzPos <= HD and VtPos <= VD)then	--si se encuentra dentro de los limites del display de 640x480, entonces videoEN = 1
			videoEN <= '1';
		else
			videoEN <= '0';
		end if;
	end if;
end process;

dibujar:process(clk25M, HzPos, VtPos, videoEN)
begin
	if(RST = '1')then
		RGB <= "000000000000";
	elsif(clk25M'event and clk25M = '1')then
		if(videoEN = '1')then
			if((HzPos >= 10 and HzPos <= 60) and (VtPos >= 10 and VtPos <= 60))then
				RGB <= "111111111111";
			else
				RGB <= "000000000000";
			end if;
		else
			RGB <= "000000000000";
		end if;
	end if;
end process;
end architecture union;  

