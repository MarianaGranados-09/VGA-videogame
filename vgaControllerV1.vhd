library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.STD_LOGIC_ARITH.all; 

entity vgaControllerV1 is
	port( 
	clk : in std_logic;
	hs	: out std_logic;
	vs  : out std_logic;
	juego9 : in std_logic; --sw para juego con 9 espacios
	juego25: in std_logic; --sw para juego con 25 espacios
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
	
	--visible area is 640 - 480
	juego9x9: process(hc, vc, videoON, juego9, juego25)
	begin 
		if((vc > 100 and vc <580 and hc > 385 and hc < 390 and videoON = '1' and juego9 = '1')) then  --first hz line
			red <= "0000";
			blue <= "1111";
			green <= "0000";
		elsif((vc > 100 and vc <580 and hc > 530 and hc < 535 and videoON = '1' and juego9 = '1')) then --second hz line
			red <= "0000";
			blue <= "1111";
			green <= "0000";
		elsif((vc > 245 and vc <250 and hc > 240 and hc < 660 and videoON = '1' and juego9 = '1')) then	--first vt line
			red <= "0000";
			blue <= "1111";
			green <= "0000";
		elsif((vc > 420 and vc <425 and hc > 240 and hc < 660 and videoON = '1' and juego9 = '1')) then	--second vt line
			red <= "0000";
			blue <= "1111";
			green <= "0000";
		elsif((vc > 100 and vc <105 and hc > 240 and hc < 660 and videoON = '1' and juego9 = '1')) then	 --margin hz top
			red <= "0000";
			blue <= "1111";
			green <= "0000";
		elsif((vc > 580 and vc <585 and hc > 240 and hc < 660 and videoON = '1' and juego9 = '1')) then	--margin hz bottom
			red <= "0000";
			blue <= "1111";
			green <= "0000";
		elsif((vc > 100 and vc <585 and hc > 240 and hc < 245 and videoON = '1' and juego9 = '1')) then	--margin vt top
			red <= "0000";
			blue <= "1111";
			green <= "0000";
		elsif((vc > 100 and vc <585 and hc > 655 and hc < 660 and videoON = '1' and juego9 = '1')) then	--margin vt bottom
			red <= "0000";
			blue <= "1111";
			green <= "0000";
			
		else
			red <= "0000";
			green <= "0000";
			blue <= "0000";
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
														

