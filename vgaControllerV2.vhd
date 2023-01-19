library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.STD_LOGIC_ARITH.all; 

entity VGAController is
	port( 
	clk : in std_logic;
	hs	: out std_logic;
	vs  : out std_logic;
	juego9 : in std_logic; --sw para juego con 9 espacios
	juego25: in std_logic; --sw para juego con 25 espacios
	start :  in std_logic; --sw para inciar juego
	red	: out std_logic_vector(3 downto 0);
	green : out std_logic_vector(3 downto 0);
	blue  : out std_logic_vector(3 downto 0)
	);
end VGAController;

architecture Behavioral of VGAController is

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
	
	--process(start)
	
	--visible area is 640 - 480
	gameboard: process(hc, vc, videoON, juego9, juego25, start)
	begin
		--starting screen
		if((hc > 290 and hc < 648 and vc > 80 and vc < 100 and videoON = '1' and juego25 = '0' and juego9 = '0' and start ='1')) then -- Edge
			red <= "1100";		-- Pink.
			blue <= "1110";
			green <= "0000";
		elsif((hc > 290 and hc < 648 and vc > 210 and vc < 230 and videoon = '1' and juego25 = '0' and juego9 = '0' and start ='1')) then -- Edge
			red <= "1100"; 		-- Yellow.
			blue <= "0000";
			green <= "1100"; 
		-- Edges finished 
		elsif((((hc >= 240 and hc <= 246) and (vc >= 110 and vc <= 120)) or
			(((hc >= 222 and hc <= 228) or  (hc >= 240 and hc <= 246) 	or  (hc >= 258 and hc <= 264)) and (vc >= 120 and vc <= 130)) or
			(((hc >= 228 and hc <= 234) or  (hc >= 252 and hc <= 258)) 	and (vc >= 130 and vc <= 140)) or 
			 ((hc >= 222 and hc <= 264) and (vc >= 140 and vc < 150)) 	or
			(((hc > 216  and hc < 228) 	or  (hc > 234  and hc < 252) 	or  (hc > 258 and hc < 270))   and (vc >= 150 and vc <= 160)) or
			 ((hc >= 222 and hc <= 264) and (vc > 160  and vc <= 170)) 	or
			(((hc >= 234 and hc < 240)  or  (hc > 246  and hc <= 252)) 	and (vc >= 170 and vc <= 180)) or
			(((hc >= 222 and hc <= 234) or  (hc >= 240 and hc <= 246) 	or  (hc >= 252 and hc <= 264)) and (vc >= 180 and vc <= 190)) or
			(((hc >= 228 and hc <= 234) or  (hc >= 252 and hc <= 258)) 	and (vc >= 190 and vc <= 200)) or
			 ((hc >= 240 and hc <= 246) and (vc >= 200 and vc <= 210)))
			and videoON = '1' and juego25 = '0' and juego9 = '0' and start ='1') then
			red <= "1111";
			blue <= "1111";
			green <= "1111";
			
		-- Mouse finished
		elsif((((hc >= 704 and hc <= 710) and (vc >= 110 and vc <= 120)) or
			(((hc >= 686 and hc <= 692) or  (hc >= 704 and hc <= 710) 	or  (hc >= 722 and hc <= 728))  and (vc >= 120 and vc < 130))  	or
			(((hc >= 692 and hc < 704) 	or  (hc > 710  and hc <= 722)) 	and (vc >= 130 and vc <= 140))  or 
			(((hc > 674  and hc < 680)	or  (hc > 686  and hc < 728) 	or  (hc > 734  and hc < 740))   and (vc > 140  and vc < 150)) 	or
			(((hc > 674  and hc < 692)	or  (hc > 698  and hc < 716) 	or  (hc > 722  and hc < 740))   and (vc >= 150 and vc <= 160))  or
			 ((hc >= 686 and hc <= 728) and (vc > 160  and vc < 170)) 	or
			(((hc > 680  and hc < 686) 	or  (hc >= 692 and hc < 698)	or	(hc >= 704 and hc < 710) 	or	(hc >= 716 and hc < 722)	or	(hc > 728 and hc < 734))	and (vc >= 170 and vc <= 180)) or
			(((hc > 680  and hc < 686) 	or  (hc > 728  and hc < 734))  	and (vc > 180  and vc < 190))   or
			(((hc >= 686 and hc <= 692) or  (hc >= 722 and hc <= 728)) 	and (vc >= 190 and vc < 200)))
			and videoON = '1' and juego25 = '0' and juego9 = '0' and start ='1') then
			red <= "1111";
			blue <= "1111";
			green <= "1111";
		-- Cat finished
			
		elsif((hc > 290 and hc < 340 and vc > 110 and vc < 125 and videoON = '1' and start = '1' and juego25 = '0' and juego9 = '0')) then --horiz T line 
			red <= "1000";		-- Purple.
			blue <= "1110";
			green <= "0000";
		elsif((hc > 308 and hc < 322 and vc > 115 and vc < 200 and videoON = '1' and start = '1' and juego25 = '0' and juego9 = '0')) then --vert T line
			red <= "1000";		-- Purple.
			blue <= "1110";
			green <= "0000";
		elsif((hc > 340 and hc < 351 and vc > 160 and vc < 200 and videoON = '1' and start = '1' and juego25 = '0' and juego9 = '0')) then --vert i line 
			red <= "1111";
			blue <= "1111";
			green <= "1111";
		elsif((hc > 340 and hc < 351 and vc > 140 and vc < 155 and videoON = '1' and start = '1' and juego25 = '0' and juego9 = '0')) then --dot for i
			red <= "1111";
			blue <= "1111";
			green <= "1111";
		elsif((hc > 362 and hc < 373 and vc > 150 and vc < 200 and videoON = '1' and start = '1' and juego25 = '0' and juego9 = '0')) then --c
			red <= "1111";
			blue <= "1111";
			green <= "1111";
		elsif((hc > 372 and hc < 390 and vc > 145 and vc < 151 and videoON = '1' and start = '1' and juego25 = '0' and juego9 = '0')) then --c
			red <= "1111";
			blue <= "1111";
			green <= "1111";
		elsif((hc > 372 and hc < 390 and vc > 194 and vc < 200 and videoON = '1' and start = '1' and juego25 = '0' and juego9 = '0')) then --c
			red <= "1111";
			blue <= "1111";
			green <= "1111";
		--word tic finished
		elsif((hc > 408 and hc < 458 and vc > 110 and vc < 125 and videoON = '1' and start = '1' and juego25 = '0' and juego9 = '0')) then --horiz T line 
			red <= "0000";  -- Green
			blue <= "1000";	
			green <= "1100";
		elsif((hc > 426 and hc < 438 and vc > 115 and vc < 200 and videoON = '1' and start = '1' and juego25 = '0' and juego9 = '0')) then --vert T line
			red <= "0000";  -- Green
			blue <= "1000";
			green <= "1100";
		elsif((hc > 451 and hc < 460 and vc > 150 and vc < 200 and videoON = '1' and start = '1' and juego25 = '0' and juego9 = '0')) then --a
			red <= "1111";
			blue <= "1111";
			green <= "1111";
		elsif((hc > 459 and hc < 480 and vc > 145 and vc < 151 and videoON = '1' and start = '1' and juego25 = '0' and juego9 = '0')) then --a
			red <= "1111";
			blue <= "1111";
			green <= "1111";
		elsif((hc > 459 and hc < 480 and vc > 165 and vc < 175 and videoON = '1' and start = '1' and juego25 = '0' and juego9 = '0')) then --a
			red <= "1111";
			blue <= "1111";
			green <= "1111";
		elsif((hc > 479 and hc < 488 and vc > 150 and vc < 200 and videoON = '1' and start = '1' and juego25 = '0' and juego9 = '0')) then --a
			red <= "1111";
			blue <= "1111";
			green <= "1111";
		elsif((hc > 498 and hc < 507 and vc > 150 and vc < 200 and videoON = '1' and start = '1' and juego25 = '0' and juego9 = '0')) then --c
			red <= "1111";
			blue <= "1111";
			green <= "1111";
		elsif((hc > 506 and hc < 525 and vc > 145 and vc < 151 and videoON = '1' and start = '1' and juego25 = '0' and juego9 = '0')) then --c
			red <= "1111";
			blue <= "1111";
			green <= "1111";
		elsif((hc > 506 and hc < 525 and vc > 194 and vc < 200 and videoON = '1' and start = '1' and juego25 = '0' and juego9 = '0')) then --c
			red <= "1111";
			blue <= "1111";
			green <= "1111"; 
		--tac word finished
		elsif((hc > 542 and hc < 595 and vc > 110 and vc < 125 and videoON = '1' and start = '1' and juego25 = '0' and juego9 = '0')) then --horiz T line 
			red <= "1110"; 		-- Orange
			blue <= "0100";
			green <= "1010";
		elsif((hc > 563 and hc < 575 and vc > 115 and vc < 200 and videoON = '1' and start = '1' and juego25 = '0' and juego9 = '0')) then --vert T line
			red <= "1110"; 		-- Orange
			blue <= "0100";
			green <= "1010";
		elsif((hc > 585 and hc < 591 and vc > 150 and vc < 200 and videoON = '1' and start = '1' and juego25 = '0' and juego9 = '0')) then --o
			red <= "1111";
			blue <= "1111";
			green <= "1111";
		elsif((hc > 590 and hc < 612 and vc > 145 and vc < 151 and videoON = '1' and start = '1' and juego25 = '0' and juego9 = '0')) then --o
			red <= "1111";
			blue <= "1111";
			green <= "1111";
		elsif((hc > 590 and hc < 612 and vc > 194 and vc < 200 and videoON = '1' and start = '1' and juego25 = '0' and juego9 = '0')) then --o
			red <= "1111";
			blue <= "1111";
			green <= "1111";
		elsif((hc > 611 and hc < 617 and vc > 150 and vc < 200 and videoON = '1' and start = '1' and juego25 = '0' and juego9 = '0')) then --o
			red <= "1111";
			blue <= "1111";
			green <= "1111";
		elsif((hc > 625 and hc < 631 and vc > 145 and vc < 200 and videoON = '1' and start = '1' and juego25 = '0' and juego9 = '0')) then --e
			red <= "1111";
			blue <= "1111";
			green <= "1111";
		elsif((hc > 630 and hc < 648 and vc > 145 and vc < 151 and videoON = '1' and start = '1' and juego25 = '0' and juego9 = '0')) then --e
			red <= "1111";
			blue <= "1111";
			green <= "1111";
		elsif((hc > 630 and hc < 648 and vc > 165 and vc < 172 and videoON = '1' and start = '1' and juego25 = '0' and juego9 = '0')) then --e
			red <= "1111";
			blue <= "1111";
			green <= "1111";
		elsif((hc > 630 and hc < 648 and vc > 194 and vc < 200 and videoON = '1' and start = '1' and juego25 = '0' and juego9 = '0')) then --e
			red <= "1111";
			blue <= "1111";
			green <= "1111";
			--toe finished
		

		--3x3 game
		elsif((vc > 100 and vc <580 and hc > 385 and hc < 390 and videoON = '1' and juego9 = '1' and juego25 = '0')) then  --first hz line
			red <= "0000";
			blue <= "1111";
			green <= "0000";
		elsif((vc > 100 and vc <580 and hc > 530 and hc < 535 and videoON = '1' and juego9 = '1' and juego25 = '0')) then --second hz line
			red <= "0000";
			blue <= "1111";
			green <= "0000";
		elsif((vc > 245 and vc <250 and hc > 240 and hc < 660 and videoON = '1' and juego9 = '1' and juego25 = '0')) then	--first vt line
			red <= "0000";
			blue <= "1111";
			green <= "0000";
		elsif((vc > 420 and vc <425 and hc > 240 and hc < 660 and videoON = '1' and juego9 = '1' and juego25 = '0')) then	--second vt line
			red <= "0000";
			blue <= "1111";
			green <= "0000";
		elsif((vc > 100 and vc <105 and hc > 240 and hc < 660 and videoON = '1' and juego9 = '1' and juego25 = '0')) then	 --margin hz top
			red <= "0000";
			blue <= "1111";
			green <= "0000";
		elsif((vc > 580 and vc <585 and hc > 240 and hc < 660 and videoON = '1' and juego9 = '1' and juego25 = '0')) then	--margin hz bottom
			red <= "0000";
			blue <= "1111";
			green <= "0000";
		elsif((vc > 100 and vc <585 and hc > 240 and hc < 245 and videoON = '1' and juego9 = '1' and juego25 = '0')) then	--margin vt top
			red <= "0000";
			blue <= "1111";
			green <= "0000";
		elsif((vc > 100 and vc <585 and hc > 655 and hc < 660 and videoON = '1' and juego9 = '1' and juego25 = '0')) then	--margin vt bottom
			red <= "0000";
			blue <= "1111";
			green <= "0000";
		--5x5 game
		elsif((vc > 100 and vc <600 and hc > 325 and hc < 330 and videoON = '1' and juego25 = '1')) then --first hz line
			red <= "0011";
			blue <= "0011";
			green <= "0000";
		elsif((vc > 100 and vc <600 and hc > 420 and hc < 425 and videoON = '1' and juego25 = '1')) then --second hz line
			red <= "0011";
			blue <= "0011";
			green <= "0000";
		elsif((vc > 100 and vc <600 and hc > 510 and hc < 515 and videoON = '1' and juego25 = '1')) then --third hz line
			red <= "0011";
			blue <= "0011";
			green <= "0000";
		elsif((vc > 100 and vc <600 and hc > 600 and hc < 605 and videoON = '1' and juego25 = '1')) then --fourth hz line
			red <= "0011";
			blue <= "0011";
			green <= "0000";
		elsif((vc > 200 and vc <205 and hc > 240 and hc < 680 and videoON = '1' and juego25 = '1')) then --first vt line
			red <= "0011";
			blue <= "0011";
			green <= "0000";
		elsif((vc > 295 and vc <300 and hc > 240 and hc < 680 and videoON = '1' and juego25 = '1' )) then --sec vt line
			red <= "0011";
			blue <= "0011";
			green <= "0000";
		elsif((vc > 395 and vc <400 and hc > 240 and hc < 680 and videoON = '1' and juego25 = '1')) then --third vt line
			red <= "0011";
			blue <= "0011";
			green <= "0000";
		elsif((vc > 495 and vc <500 and hc > 240 and hc < 680 and videoON = '1' and juego25 = '1')) then --fourth vt line
			red <= "0011";
			blue <= "0011";
			green <= "0000";
		elsif((vc > 100 and vc <105 and hc > 240 and hc < 680 and videoON = '1' and juego25 = '1')) then	 --margin hz top
			red <= "0011";
			blue <= "0011";
			green <= "0000";
		elsif((vc > 595 and vc <600 and hc > 240 and hc < 680 and videoON = '1' and juego25 = '1')) then	--margin hz bottom
			red <= "0011";
			blue <= "0011";
			green <= "0000";
		elsif((vc > 100 and vc <600 and hc > 240 and hc < 245 and videoON = '1' and juego25 = '1')) then	--margin vt top
			red <= "0011";
			blue <= "0011";
			green <= "0000";
		elsif((vc > 100 and vc <600 and hc > 675 and hc < 680 and videoON = '1' and juego25 = '1')) then	--margin vt bottom
			red <= "0011";
			blue <= "0011";
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
