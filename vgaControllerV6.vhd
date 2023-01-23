library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.STD_LOGIC_ARITH.all; 

entity VGAController is
	port( 
	clk : in std_logic;
	hs	: out std_logic;
	vs  : out std_logic;
	juego9 : in std_logic; --sw to start game with 9 spaces
	juego25: in std_logic; --sw to start game with 25 spaces
	start :  in std_logic; --sw to start game (start screen loading)
	--switches for directio
	swDown : in std_logic; --sw to choose down 
	swRight : in std_logic; --sw to choose right
	btnMove : in std_logic;	--sw to move 
	-- RGB to VGA
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

-- Starting position in X of the game
signal X1_Origin : integer := 455;
signal X2_Origin : integer := 270;
-- Starting position in Y of the game
signal Y1_Origin : integer := 110;
signal Y2_Origin : integer := 200;
-- Increment in X and Y
signal XRise : integer := 0;
signal YRise : integer := 0;

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
	Starting_screen: process(hc, vc, videoON, juego9, juego25, start, X1_Origin, Y1_Origin, XRise, YRise)
	begin
		-- Home screen borders
		if((hc > 290 and hc < 648 and vc > 80 and vc < 100 and videoON = '1' and juego25 = '0' and juego9 = '0' and start ='1')) then -- Edge
			red <= "1100";		-- Pink
			blue <= "1110";
			green <= "0000";
		elsif((hc > 290 and hc < 648 and vc > 210 and vc < 230 and videoon = '1' and juego25 = '0' and juego9 = '0' and start ='1')) then -- Edge
			red <= "1100"; 		-- Yellow
			blue <= "0000";
			green <= "1100"; 

		-- Mouse graphic
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
			
		-- Cat graphic
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

		-- Start message "Press" right side
		elsif((((hc >= 216 and hc <= 240)  and (vc >= 250 and vc <= 260)) or
			(((hc >= 216 and hc <= 222) or  (hc >= 240 and hc <= 246))	and (vc >= 260 and vc <= 270))  or
			(((hc >= 216 and hc <= 240) or  (hc >= 252 and hc <= 258)	or	(hc >= 264 and hc <= 270)	or	(hc >= 288 and hc <= 300)	or	(hc >= 324 and hc <= 342)	or	(hc >= 360 and hc <= 378)) 	and (vc >= 270 and vc <= 280))  or 
			(((hc >= 216 and hc <= 222) or  (hc >= 252 and hc <= 264)	or	(hc >= 282 and hc <= 288)	or	(hc >= 300 and hc <= 306)	or	(hc >= 318 and hc <= 324)	or	(hc >= 354 and hc <= 360))	and (vc >= 280 and vc <= 290))  or 
			(((hc >= 216 and hc <= 222) or  (hc >= 252 and hc <= 258)	or	(hc >= 282 and hc <= 306)	or	(hc >= 324 and hc <= 336)	or	(hc >= 360 and hc <= 372)) 	and (vc >= 290 and vc <= 300))  or 
			(((hc >= 216 and hc <= 222) or  (hc >= 252 and hc <= 258)	or	(hc >= 282 and hc <= 288)	or	(hc >= 336 and hc <= 342)	or	(hc >= 372 and hc <= 378))	and (vc >= 300 and vc <= 310))  or 
			(((hc >= 216 and hc <= 222) or  (hc >= 252 and hc <= 258)	or	(hc >= 282 and hc <= 288)	or	(hc >= 300 and hc <= 306)	or	(hc >= 336 and hc <= 342)	or	(hc >= 372 and hc <= 378))	and (vc >= 310 and vc <= 320))  or 
			(((hc >= 216 and hc <= 222) or  (hc >= 252 and hc <= 258)	or	(hc >= 288 and hc <= 306)	or	(hc >= 318 and hc <= 336)	or	(hc >= 354 and hc <= 372))	and (vc >= 320 and vc <= 330)))
			and videoON = '1' and juego25 = '0' and juego9 = '0' and start ='1') then
			red <= "1111";
			blue <= "1111";
			green <= "1111";
			
		-- Start message "SW1 for"
		elsif(((((hc >= 204 and hc <= 228) or (hc >= 234 and hc <= 240) or (hc >= 258 and hc <= 264) or (hc >= 276 and hc <= 288) or (hc >= 324 and hc <= 342)) and (vc >= 360 and vc <= 370)) or
			(((hc >= 198 and hc <= 204) or  (hc >= 234 and hc <= 240)   or  (hc >= 258 and hc <= 264)	or  (hc >= 270 and hc <= 276)	or 	(hc >= 282 and hc <= 288)	or	(hc >= 324 and hc <= 330))  and (vc >= 370 and vc <= 380))  or
			(((hc >= 198 and hc <= 204) or  (hc >= 234 and hc <= 240)	or	(hc >= 258 and hc <= 264)	or	(hc >= 282 and hc <= 288)	or	(hc >= 318 and hc <= 342)	or	(hc >= 354 and hc <= 366)	or	(hc >= 378 and hc <= 384)	or	(hc >= 390 and hc <= 396)) 	and (vc >= 380 and vc <= 390))  or 
			(((hc >= 204 and hc <= 222) or  (hc >= 234 and hc <= 240)	or	(hc >= 258 and hc <= 264)	or	(hc >= 282 and hc <= 288)	or	(hc >= 324 and hc <= 330)	or	(hc >= 348 and hc <= 354)	or	(hc >= 366 and hc <= 372)	or	(hc >= 378 and hc <= 390)) 	and (vc >= 390 and vc <= 400))  or 
			(((hc >= 222 and hc <= 228) or  (hc >= 234 and hc <= 240)	or	(hc >= 258 and hc <= 264)	or	(hc >= 282 and hc <= 288)	or	(hc >= 324 and hc <= 330)	or	(hc >= 348 and hc <= 354)	or	(hc >= 366 and hc <= 372)	or	(hc >= 378 and hc <= 384)) 	and (vc >= 400 and vc <= 410))  or 
			(((hc >= 222 and hc <= 228) or  (hc >= 234 and hc <= 240)	or	(hc >= 246 and hc <= 252)	or	(hc >= 258 and hc <= 264)	or	(hc >= 282 and hc <= 288)	or	(hc >= 324 and hc <= 330)	or	(hc >= 348 and hc <= 354)	or	(hc >= 366 and hc <= 372)	or	(hc >= 378 and hc <= 384)) 	and (vc >= 410 and vc <= 420))  or 
			(((hc >= 222 and hc <= 228) or  (hc >= 234 and hc <= 246)	or	(hc >= 252 and hc <= 264)	or	(hc >= 282 and hc <= 288)	or	(hc >= 324 and hc <= 330)	or	(hc >= 348 and hc <= 354)	or	(hc >= 366 and hc <= 372)	or	(hc >= 378 and hc <= 384)) 	and (vc >= 420 and vc <= 430))  or 
			(((hc >= 198 and hc <= 222) or  (hc >= 234 and hc <= 240)	or	(hc >= 258 and hc <= 264)	or	(hc >= 270 and hc <= 300)	or	(hc >= 324 and hc <= 330)	or	(hc >= 354 and hc <= 366)	or	(hc >= 378 and hc <= 384)) 	and (vc >= 430 and vc <= 440)))
			and videoON = '1' and juego25 = '0' and juego9 = '0' and start ='1') then
			red <= "1111";
			blue <= "1111";
			green <= "1111";

		-- Start message "3x3"
		elsif(((((hc >= 240 and hc <= 258) or  (hc >= 276 and hc <= 282) or  (hc >= 300 and hc <= 306) or  (hc >= 324 and hc <= 342))  and (vc >= 470 and vc <= 480)) or
			(((hc >= 234 and hc <= 240) or  (hc >= 258 and hc <= 264)	or  (hc >= 276 and hc <= 282)	or  (hc >= 300 and hc <= 306)	or  (hc >= 318 and hc <= 324)   or  (hc >= 342 and hc <= 348))	and (vc >= 480 and vc <= 490))  or
			(((hc >= 258 and hc <= 264) or  (hc >= 282 and hc <= 288)	or	(hc >= 294 and hc <= 300)	or	(hc >= 342 and hc <= 348)) 	and (vc >= 490 and vc <= 500))  or 
			(((hc >= 246 and hc <= 258) or  (hc >= 288 and hc <= 294)	or	(hc >= 330 and hc <= 342))	and (vc >= 500 and vc <= 510))  or 
			(((hc >= 258 and hc <= 264) or  (hc >= 282 and hc <= 288)	or	(hc >= 294 and hc <= 300)	or	(hc >= 342 and hc <= 348)) 	and (vc >= 510 and vc <= 520))  or 
			(((hc >= 234 and hc <= 240) or  (hc >= 258 and hc <= 264)	or  (hc >= 276 and hc <= 282)	or  (hc >= 300 and hc <= 306)	or  (hc >= 318 and hc <= 324)   or  (hc >= 342 and hc <= 348))	and (vc >= 520 and vc <= 530))  or 
			(((hc >= 234 and hc <= 240) or  (hc >= 258 and hc <= 264)	or  (hc >= 276 and hc <= 282)	or  (hc >= 300 and hc <= 306)	or  (hc >= 318 and hc <= 324)   or  (hc >= 342 and hc <= 348))	and (vc >= 530 and vc <= 540))  or 
			(((hc >= 240 and hc <= 258) or  (hc >= 276 and hc <= 282) or  (hc >= 300 and hc <= 306) or  (hc >= 324 and hc <= 342))  and (vc >= 540 and vc <= 550)))
			and videoON = '1' and juego25 = '0' and juego9 = '0' and start ='1') then
			red <= "1111";
			blue <= "1111";
			green <= "1111";
		
		-- Start message "Press" left side
		elsif((((hc >= 516 and hc <= 540)  and (vc >= 250 and vc <= 260)) or
			(((hc >= 516 and hc <= 522) or  (hc >= 540 and hc <= 546))	and (vc >= 260 and vc <= 270))  or
			(((hc >= 516 and hc <= 540) or  (hc >= 552 and hc <= 558)	or	(hc >= 564 and hc <= 570)	or	(hc >= 588 and hc <= 600)	or	(hc >= 624 and hc <= 642)	or	(hc >= 660 and hc <= 678)) 	and (vc >= 270 and vc <= 280))  or 
			(((hc >= 516 and hc <= 522) or  (hc >= 552 and hc <= 564)	or	(hc >= 582 and hc <= 588)	or	(hc >= 600 and hc <= 606)	or	(hc >= 618 and hc <= 624)	or	(hc >= 654 and hc <= 660))	and (vc >= 280 and vc <= 290))  or 
			(((hc >= 516 and hc <= 522) or  (hc >= 552 and hc <= 558)	or	(hc >= 582 and hc <= 606)	or	(hc >= 624 and hc <= 636)	or	(hc >= 660 and hc <= 672)) 	and (vc >= 290 and vc <= 300))  or 
			(((hc >= 516 and hc <= 522) or  (hc >= 552 and hc <= 558)	or	(hc >= 582 and hc <= 588)	or	(hc >= 636 and hc <= 642)	or	(hc >= 672 and hc <= 678))	and (vc >= 300 and vc <= 310))  or 
			(((hc >= 516 and hc <= 522) or  (hc >= 552 and hc <= 558)	or	(hc >= 582 and hc <= 588)	or	(hc >= 600 and hc <= 606)	or	(hc >= 636 and hc <= 642)	or	(hc >= 672 and hc <= 678))	and (vc >= 310 and vc <= 320))  or 
			(((hc >= 516 and hc <= 522) or  (hc >= 552 and hc <= 558)	or	(hc >= 588 and hc <= 606)	or	(hc >= 618 and hc <= 636)	or	(hc >= 654 and hc <= 672))	and (vc >= 320 and vc <= 330)))
			and videoON = '1' and juego25 = '0' and juego9 = '0' and start ='1') then
			red <= "1111";
			blue <= "1111";
			green <= "1111";
		
		-- Start message "SW2 for"
		elsif(((((hc >= 504 and hc <= 528) or (hc >= 534 and hc <= 540) or (hc >= 558 and hc <= 564) or (hc >= 576 and hc <= 594) or (hc >= 624 and hc <= 642)) and (vc >= 360 and vc <= 370)) or
			(((hc >= 498 and hc <= 504) or  (hc >= 534 and hc <= 540)   or  (hc >= 558 and hc <= 564)	or  (hc >= 570 and hc <= 576)	or 	(hc >= 594 and hc <= 600)	or	(hc >= 624 and hc <= 630))  and (vc >= 370 and vc <= 380))  or
			(((hc >= 498 and hc <= 504) or  (hc >= 534 and hc <= 540)	or	(hc >= 558 and hc <= 564)	or	(hc >= 594 and hc <= 600)	or	(hc >= 618 and hc <= 642)	or	(hc >= 654 and hc <= 666)	or	(hc >= 678 and hc <= 684)	or	(hc >= 690 and hc <= 696)) 	and (vc >= 380 and vc <= 390))  or 
			(((hc >= 504 and hc <= 522) or  (hc >= 534 and hc <= 540)	or	(hc >= 558 and hc <= 564)	or	(hc >= 588 and hc <= 594)	or	(hc >= 624 and hc <= 630)	or	(hc >= 648 and hc <= 654)	or	(hc >= 666 and hc <= 672)	or	(hc >= 678 and hc <= 690)) 	and (vc >= 390 and vc <= 400))  or 
			(((hc >= 522 and hc <= 528) or  (hc >= 534 and hc <= 540)	or	(hc >= 558 and hc <= 564)	or	(hc >= 582 and hc <= 588)	or	(hc >= 624 and hc <= 630)	or	(hc >= 648 and hc <= 654)	or	(hc >= 666 and hc <= 672)	or	(hc >= 678 and hc <= 684)) 	and (vc >= 400 and vc <= 410))  or 
			(((hc >= 522 and hc <= 528) or  (hc >= 534 and hc <= 540)	or	(hc >= 546 and hc <= 552)	or	(hc >= 558 and hc <= 564)	or	(hc >= 576 and hc <= 582)	or	(hc >= 624 and hc <= 630)	or	(hc >= 648 and hc <= 654)	or	(hc >= 666 and hc <= 672)	or	(hc >= 678 and hc <= 684)) 	and (vc >= 410 and vc <= 420))  or 
			(((hc >= 522 and hc <= 528) or  (hc >= 534 and hc <= 546)	or	(hc >= 552 and hc <= 564)	or	(hc >= 570 and hc <= 576)	or	(hc >= 624 and hc <= 630)	or	(hc >= 648 and hc <= 654)	or	(hc >= 666 and hc <= 672)	or	(hc >= 678 and hc <= 684)) 	and (vc >= 420 and vc <= 430))  or 
			(((hc >= 498 and hc <= 522) or  (hc >= 534 and hc <= 540)	or	(hc >= 558 and hc <= 564)	or	(hc >= 570 and hc <= 600)	or	(hc >= 624 and hc <= 630)	or	(hc >= 654 and hc <= 666)	or	(hc >= 678 and hc <= 684)) 	and (vc >= 430 and vc <= 440)))
			and videoON = '1' and juego25 = '0' and juego9 = '0' and start ='1') then
			red <= "1111";
			blue <= "1111";
			green <= "1111";

		-- Start message "5x5"
		elsif(((((hc >= 534 and hc <= 564) or  (hc >= 576 and hc <= 582) or  (hc >= 600 and hc <= 606) or  (hc >= 618 and hc <= 648))  and (vc >= 470 and vc <= 480)) or
			(((hc >= 534 and hc <= 540) or  (hc >= 576 and hc <= 582)	or  (hc >= 600 and hc <= 606)	or  (hc >= 618 and hc <= 624))   and (vc >= 480 and vc <= 490))  or
			(((hc >= 534 and hc <= 540) or  (hc >= 582 and hc <= 588)	or	(hc >= 594 and hc <= 600)	or	(hc >= 618 and hc <= 624)) 	and (vc >= 490 and vc <= 500))  or 
			(((hc >= 540 and hc <= 558) or  (hc >= 588 and hc <= 594)	or	(hc >= 624 and hc <= 642))	and (vc >= 500 and vc <= 510))  or 
			(((hc >= 558 and hc <= 564) or  (hc >= 582 and hc <= 588)	or	(hc >= 594 and hc <= 600)	or	(hc >= 642 and hc <= 648)) 	and (vc >= 510 and vc <= 520))  or 
			(((hc >= 558 and hc <= 564)	or  (hc >= 576 and hc <= 582)	or  (hc >= 600 and hc <= 606)	or  (hc >= 642 and hc <= 648))	and (vc >= 520 and vc <= 530))  or 
			(((hc >= 534 and hc <= 540) or  (hc >= 558 and hc <= 564)	or  (hc >= 576 and hc <= 582)	or  (hc >= 600 and hc <= 606)	or  (hc >= 618 and hc <= 624)   or  (hc >= 642 and hc <= 648))	and (vc >= 530 and vc <= 540))  or 
			(((hc >= 540 and hc <= 558) or  (hc >= 576 and hc <= 582)	or  (hc >= 600 and hc <= 606)	or  (hc >= 624 and hc <= 642))  and (vc >= 540 and vc <= 550)))
			and videoON = '1' and juego25 = '0' and juego9 = '0' and start ='1') then
			red <= "1111";
			blue <= "1111";
			green <= "1111";
		
		-- 3x3 game
		elsif((((hc >= 450 and hc <= 680) and (vc >= 100 and vc <= 110)) or
			(((hc >= 450 and hc <= 455) or  (hc >= 525 and hc <= 530)	or  (hc >= 600 and hc <= 605)	or  (hc >= 675 and hc <= 680))  and (vc >= 110 and vc <= 220))  or
			 ((hc >= 450 and hc <= 680) and (vc >= 220 and vc <= 230))  or 
			(((hc >= 450 and hc <= 455) or  (hc >= 525 and hc <= 530)	or  (hc >= 600 and hc <= 605)	or  (hc >= 675 and hc <= 680))  and (vc >= 230 and vc <= 340))  or 
			 ((hc >= 450 and hc <= 680) and (vc >= 340 and vc <= 350))  or 
			(((hc >= 450 and hc <= 455) or  (hc >= 525 and hc <= 530)	or  (hc >= 600 and hc <= 605)	or  (hc >= 675 and hc <= 680))  and (vc >= 350 and vc <= 460))  or 
			 ((hc >= 450 and hc <= 680) and (vc >= 460 and vc <= 470)))
			and videoON = '1' and juego25 = '0' and juego9 = '1') then
			red <= "0000";
			blue <= "1111";
			green <= "0000";
		
		-- Mouse movement animation 3x3	
--		elsif ((((hc >= 30 + X1_Origin + XRise and hc <= 36 + X1_Origin + XRise) and (vc >= 10 + Y1_Origin + YRise	and vc <= 20 + Y1_Origin + YRise))	or
--			(((hc >= 12 + X1_Origin + XRise and hc <= 18 + X1_Origin + XRise) or  (hc >= 30	+ X1_Origin + XRise	and hc <= 36 + X1_Origin + XRise)	or  (hc >= 48 + X1_Origin + XRise and hc <= 54 + X1_Origin + XRise))	and (vc >= 20 + Y1_Origin + YRise and vc <= 30 + Y1_Origin + YRise)) or
--			(((hc >= 18 + X1_Origin + XRise and hc <= 24 + X1_Origin + XRise) or  (hc >= 42 + X1_Origin + XRise	and hc <= 48 + X1_Origin + XRise)) and	(vc >= 30 + Y1_Origin + YRise and vc <= 40 + Y1_Origin + YRise))	or 
--			 ((hc >= 12 + X1_Origin + XRise and hc <= 54 + X1_Origin + XRise) and (vc >= 40 + Y1_Origin + YRise	and vc <  50 + Y1_Origin + YRise))	or
--			(((hc >  6	+ X1_Origin + XRise and hc <  18 + X1_Origin + XRise) or  (hc > 24  + X1_Origin + XRise	and hc <  42 + X1_Origin + XRise) 	or  (hc >  48 + X1_Origin + XRise and hc <  60 + X1_Origin + XRise))	and (vc >= 50 + Y1_Origin + YRise and vc <= 60 + Y1_Origin + YRise)) or
--			 ((hc >= 12 + X1_Origin + XRise and hc <= 54 + X1_Origin + XRise) and (vc > 60  + Y1_Origin + YRise	and vc <= 70 + Y1_Origin + YRise))	or
--			(((hc >= 24 + X1_Origin + XRise and hc <  30 + X1_Origin + XRise) or  (hc > 36  + X1_Origin + XRise	and hc <= 42 + X1_Origin + XRise)) and	(vc >= 70 + Y1_Origin + YRise and vc <= 80 + Y1_Origin + YRise))	or
--			(((hc >= 12 + X1_Origin + XRise and hc <= 24 + X1_Origin + XRise) or  (hc >= 30 + X1_Origin + XRise	and hc <= 36 + X1_Origin + XRise) 	or  (hc >= 42 + X1_Origin + XRise and hc <= 54 + X1_Origin + XRise))	and (vc >= 80 + Y1_Origin + YRise and vc <= 90 + Y1_Origin + YRise)) or
--			(((hc >= 18 + X1_Origin + XRise and hc <= 24 + X1_Origin + XRise) or  (hc >= 42 + X1_Origin + XRise	and hc <= 48 + X1_Origin + XRise)) and	(vc >= 90 + Y1_Origin + YRise and vc <= 100 + Y1_Origin + YRise))	or
--			 ((hc >= 30 + X1_Origin + XRise and hc <= 36 + X1_Origin + XRise) and (vc >= 100 + Y1_Origin + YRise and vc <= 110 + Y1_Origin + YRise)))
--			and videoON = '1' and juego25 = '0' and juego9 = '1') then
--			count1R(0) <= '1';
--			red <= "1111";
--			blue <= "1111";
--			green <= "1111"; 
		
		-- Mouse movement animation 3x3		
		elsif((((hc >= 33 + X1_Origin + XRise and hc <= 39 + X1_Origin + XRise) and (vc >= 10 + Y1_Origin + YRise and vc <= 20 + Y1_Origin + YRise)) or
			(((hc >= 15 + X1_Origin + XRise and hc <= 21 + X1_Origin + XRise) or  (hc >= 33 + X1_Origin + XRise and hc <= 39 + X1_Origin + XRise) 	or  (hc >= 51 + X1_Origin + XRise and hc <= 57 + X1_Origin + XRise)) and (vc >= 20 + Y1_Origin + YRise and vc < 30 + Y1_Origin + YRise))  	or
			(((hc >= 21 + X1_Origin + XRise and hc <  33 + X1_Origin + XRise) or  (hc >  39 + X1_Origin + XRise and hc <= 51 + X1_Origin + XRise))	and (vc >= 30 + Y1_Origin + YRise and vc <= 40 + Y1_Origin + YRise)) or 
			(((hc >  3  + X1_Origin + XRise and hc <  9  + X1_Origin + XRise) or  (hc >  15 + X1_Origin + XRise and hc <  57 + X1_Origin + XRise) 	or  (hc >  63 + X1_Origin + XRise and hc <  69 + X1_Origin + XRise)) and (vc >  40 + Y1_Origin + YRise and vc < 50 + Y1_Origin + YRise)) 	or
			(((hc >  3  + X1_Origin + XRise and hc <  21 + X1_Origin + XRise) or  (hc >  27 + X1_Origin + XRise and hc <  45 + X1_Origin + XRise) 	or  (hc >  51 + X1_Origin + XRise and hc <  69 + X1_Origin + XRise)) and (vc >= 50 + Y1_Origin + YRise and vc <= 60 + Y1_Origin + YRise))  or
			 ((hc >= 15 + X1_Origin + XRise and hc <= 57 + X1_Origin + XRise) and (vc >  60 + Y1_Origin + YRise and vc <  70 + Y1_Origin + YRise))or
			(((hc >  9  + X1_Origin + XRise and hc <  15 + X1_Origin + XRise) or  (hc >= 21 + X1_Origin + XRise and hc <  27 + X1_Origin + XRise)	or	(hc >= 33 + X1_Origin + XRise and hc <  39 + X1_Origin + XRise)	 or (hc >= 45 + X1_Origin + XRise and hc < 51 + X1_Origin + XRise)	or	(hc > 57 + X1_Origin + XRise and hc < 63 + X1_Origin + XRise))	and (vc >= 70 + Y1_Origin + YRise and vc <= 80 + Y1_Origin + YRise)) or
			(((hc >  9  + X1_Origin + XRise and hc <  15 + X1_Origin + XRise) or  (hc >  57 + X1_Origin + XRise and hc <  63 + X1_Origin + XRise))  and (vc >  80 + Y1_Origin + YRise and vc <  90 + Y1_Origin + YRise)) or
			(((hc >= 15 + X1_Origin + XRise and hc <= 21 + X1_Origin + XRise) or  (hc >= 51 + X1_Origin + XRise and hc <= 57 + X1_Origin + XRise)) 	and (vc >= 90 + Y1_Origin + YRise and vc < 100 + Y1_Origin + YRise)))
			and videoON = '1' and juego25 = '0' and juego9 = '1') then
			red <= "1111";
			blue <= "1111";
			green <= "1111";
		
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
		
	AnimationHZ3x3: process(swRight, XRise, YRise, btnMove)
	begin
		if(swRight = '1') then 
			if(XRise < 225) then
				if(btnMove'EVENT and btnMove = '0') then
					XRise <= XRise + 75;
				else 
					XRise <= XRise;
				end if;
			else 
				XRise <= 0;
			end if;
		end if;
	end process;
	
	AnimationVT3x3: process(swDown, YRise, btnMove)
	begin
		if(swDown = '1') then 
			if(YRise < 360) then
				if(btnMove'EVENT and btnMove = '0') then
					YRise <= YRise + 120;
				else 
					YRise <= YRise;
				end if;
			else
				YRise <= 0;
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
