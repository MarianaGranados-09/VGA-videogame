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
	btnRestart : in std_logic; --sw to restart position 
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

signal xplus11 : integer := 250;
signal xplus12 : integer := 300;

signal xplus21 : integer := 0;
signal xplus22 : integer := 0;

signal yplus11 : integer := 100;
signal yplus12 : integer := 150;

signal yplus21 : integer := 0;
signal yplus22 : integer := 0;


signal count1R : std_logic_vector(2 downto 0) := (others => '0');
										  
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
	gameboard: process(hc, vc, videoON, xplus11, xplus12, xplus21, xplus22, yplus11, yplus12, yplus21, yplus22)
	begin
		if((vc > yplus11 + yplus21) and (vc < yplus12 + yplus22) and (hc > xplus11 + xplus21) and (hc < xplus12 + xplus22) and videoON = '1') then
			count1R(0) <= '1';
			red <= "1111";
			blue <= "0000";
			green <= "0000";
		else
			red <= "0000";
			green <= "0000";
			blue <= "0000";
		end if;
	end process; 
	
	animacionHZ : process(swRight, count1R, xplus11, xplus12, xplus21, xplus22, btnMove)
	begin
		if(swRight = '1') then 
			if(xplus21 < 351 and xplus22 < 401 and count1R(0) = '1') then
				if(btnMove'EVENT and btnMove = '0') then
					xplus21 <= xplus21 + 100;
					xplus22 <= xplus22 + 100;
				else 
					xplus21 <= xplus21;
					xplus22 <= xplus22;
				end if;
			elsif(btnRestart'EVENT and btnRestart = '0') then
					xplus11	<= 250;
					xplus12 <= 300;
					xplus21 <= 0;
					xplus22 <= 0;
			else
				xplus21 <= 0;
				xplus22 <= 0;
			end if;
		end if;
	end process;
	
	animacionVT : process(swDown, count1R, yplus11, yplus12, yplus21, yplus22, btnMove)
	begin
		if(swDown = '1') then 
			if(yplus21 < 351 and yplus22 < 401 and count1R(0) = '1') then
				if(btnMove'EVENT and btnMove = '0') then
					yplus21 <= yplus21 + 100;
					yplus22 <= yplus22 + 100;
				else 
					yplus21 <= yplus21;
					yplus22 <= yplus22;
				end if;
			elsif(btnRestart'EVENT and btnRestart = '0') then
					yplus11	<= 200;
					yplus12 <= 250;
					yplus21 <= 0;
					yplus22 <= 0;
			else
				yplus21 <= 0;
				yplus22 <= 0;
			end if;
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
