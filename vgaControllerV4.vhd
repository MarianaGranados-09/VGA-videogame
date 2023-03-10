library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.STD_LOGIC_ARITH.all; 

entity vgaControllerV1 is
	port( 
	clk : in std_logic;
	hs	: out std_logic;
	vs  : out std_logic;
	juego9 : in std_logic; --sw to start game with 9 spaces
	juego25: in std_logic; --sw to start game with 25 spaces
	start :  in std_logic; --sw to start game (start screen loading)
	--switches for direction
	swUp : in std_logic; --sw to choose up
	swDown : in std_logic; --sw to choose down 
	swLeft : in std_logic; --sw to choose left
	swRight : in std_logic; --sw to choose right
	btnMove : in std_logic;	--sw to move
	red	: out std_logic_vector(3 downto 0);
	green : out std_logic_vector(3 downto 0);
	blue  : out std_logic_vector(3 downto 0)
	);
end vgaControllerV1;

architecture Behavioral of vgaControllerV1 is

constant hpixels : integer := 800; 
constant vlines : integer := 630; 

constant hbp : integer := 33; --hback porch
constant hfp : integer := 784; --hfront porch
constant vbp : integer := 33; --vback porch
constant vfp : integer := 784; --vfront porch

signal xplus : integer := 0;
signal yplus : integer := 0;

signal countRight : integer := 0;
signal countR : std_logic_vector(2 downto 0);
										  
signal hc, vc : std_logic_vector(9 downto 0); --contador vertical y horizontal
signal clk25 : std_logic; --divisor de reloj para 25M
signal videoON : std_logic; --flag para encender video
signal VSenable : std_logic; --enable para contador vertical

begin 
	process(clk)
		begin
		   if(clk = '1' and clk'EVENT) then
			   clk25 <= not clk25;
		   end if;
	end process;
	
	process(clk25)
	begin 
		if(clk25 = '1' and clk25'EVENT) then
			if hc = hpixels then -- 800 value if counter has reached end, restart count
			   hc <= "0000000000"; --reset counter
			   VSenable <= '1'; --enable vertical count ++
			else
				hc <= hc + 1;	 --increment hz counter
				VSenable <= '0'; --VS enable off
			end if;
		end if;		  	
	end process;
	
	hs <= '1' when hc(9 downto 7) = "000" else '0';
		
	process(clk25, VSenable)
	begin 
		if(clk25 = '1' and clk25'EVENT and VSenable = '1') then
			if vc = vlines then
				vc <= "0000000000";
			else vc <= vc + 1;
			end if;
		end if;
	end process;
	
	
	process(vc)
	begin 
		if(vc = "0000000000") then
			vs <= '1';
		else
			vs <= '0';
		end if;
	end process;
	
	--process(start)
	
	--visible area is 640 - 480
	gameboard: process(hc, vc, videoON, countR)
	begin
		if((vc > 200 and vc < 300 and hc > 200 and hc < 290 and videoON = '1' and countR(0) = '0')) then
			red <= "1111";
			blue <= "0000";
			green <= "0000";
		elsif((vc > 200 and vc < 300 and hc > 350 and hc < 420 and videoON = '1' and countR(0) = '1')) then
			red <= "1111";
			blue <= "0000";
			green <= "0000";
		--elsif((vc > 200 and vc < 300 and hc > 350 and hc < 500 and videoON = '1' and countRight = 1)) then
--			red <= "1111";
--			blue <= "0000";
--			green <= "0000";
--		elsif((vc > 200 and vc < 300 and hc > 550 and hc < 750 and videoON = '1' and countRight = 2)) then
--			red <= "1111";
--			blue <= "0000";
--			green <= "0000";
		else
			red <= "0000";
			green <= "0000";
			blue <= "0000";
		end if;
	end process; 
	
	animacion : process(swRight, swUp, swDown, swLeft, btnMove, countRight)
	begin
		if(swRight = '1' and swLeft = '0' and swUp = '0' and swDown = '0' and btnMove = '0') then
			--pos 1x1 en 1, pos 1x2 en 2, pos 1x3 en 3
			countR(0) <= '1';
		else
			countR(0) <= '0';
		end if;
	end process;
									 
	process(hc, vc)
	begin 
		if(((hc < hfp) and (hc > hbp)) or ((vc < vfp) and (vc > vbp))) then
			videoON <= '1';
		else
			videoON <= '0';
		end if;
	end process;
end Behavioral;
