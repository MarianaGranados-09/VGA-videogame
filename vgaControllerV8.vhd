library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.STD_LOGIC_ARITH.all; 

entity VGAControllerV1 is
	port( 
	clk : in std_logic;
	hs	: out std_logic;
	vs  : out std_logic;
	juego9 : in std_logic; --sw to start game with 9 spaces
	juego25: in std_logic; --sw to start game with 25 spaces
	--switches for direction
	swDown : in std_logic; --sw to choose down 
	swRight : in std_logic; --sw to choose right
	btnMove : in std_logic;	--sw to move 
	btnSelect : in std_logic; --sw to select 
	-- RGB to VGA
	red	: out std_logic_vector(3 downto 0);
	green : out std_logic_vector(3 downto 0);
	blue  : out std_logic_vector(3 downto 0)
	);
end VGAControllerV1;

architecture Behavioral of VGAControllerV1 is

constant hpixels : integer := 800; 
constant vlines : integer := 630; 

constant hbp : integer := 33; --hback porch
constant hfp : integer := 784; --hfront porch
constant vbp : integer := 33; --vback porch
constant vfp : integer := 784; --vfront porch  

-- Starting position in X of the game
signal X1_Origin : integer := 455;
signal X2_Origin : integer := 380;
-- Starting position in Y of the game
signal Y1_Origin : integer := 110;
signal Y2_Origin : integer := 35;
-- Increment in X and Y
signal X1_Rise : integer := 0;
signal X2_Rise : integer := 0;

signal Y1_Rise : integer := 0;
signal Y2_Rise : integer := 0;

-- Player 1 or Player 2
signal Turn : std_logic := '1';
signal Turn5 : std_logic := '1';

-- Winner and Draw
signal Winner : integer := 0;
signal Draw : integer := 0;

signal Winner3 : integer := 0;
signal Draw3 : integer := 0;

signal X_Winner : integer := 300;
signal Y_Winner : integer := 200;
signal X_Draw : integer := 0;
signal Y_Draw : integer := 0;

-- Space Player 1 3x3
signal P1_11 : integer := 0;
signal P1_12 : integer := 0;
signal P1_13 : integer := 0;

signal P1_21 : integer := 0;
signal P1_22 : integer := 0;
signal P1_23 : integer := 0;

signal P1_31 : integer := 0;
signal P1_32 : integer := 0;
signal P1_33 : integer := 0;

-- Space Player 2 3x3
signal P2_11 : integer := 0;
signal P2_12 : integer := 0;
signal P2_13 : integer := 0;

signal P2_21 : integer := 0;
signal P2_22 : integer := 0;
signal P2_23 : integer := 0;

signal P2_31 : integer := 0;
signal P2_32 : integer := 0;
signal P2_33 : integer := 0;

-- Space Player 1 5x5
signal M1_11 : integer := 0;
signal M1_12 : integer := 0;
signal M1_13 : integer := 0;
signal M1_14 : integer := 0;
signal M1_15 : integer := 0;

signal M1_21 : integer := 0;
signal M1_22 : integer := 0;
signal M1_23 : integer := 0;
signal M1_24 : integer := 0;
signal M1_25 : integer := 0;
		
signal M1_31 : integer := 0;
signal M1_32 : integer := 0;
signal M1_33 : integer := 0;
signal M1_34 : integer := 0;
signal M1_35 : integer := 0;

signal M1_41 : integer := 0;
signal M1_42 : integer := 0;
signal M1_43 : integer := 0;
signal M1_44 : integer := 0;
signal M1_45 : integer := 0;

signal M1_51 : integer := 0;
signal M1_52 : integer := 0;
signal M1_53 : integer := 0;
signal M1_54 : integer := 0;
signal M1_55 : integer := 0;

-- Space Player 2 5x5
signal M2_11 : integer := 0;
signal M2_12 : integer := 0;
signal M2_13 : integer := 0;
signal M2_14 : integer := 0;
signal M2_15 : integer := 0;

signal M2_21 : integer := 0;
signal M2_22 : integer := 0;
signal M2_23 : integer := 0;
signal M2_24 : integer := 0;
signal M2_25 : integer := 0;
		
signal M2_31 : integer := 0;
signal M2_32 : integer := 0;
signal M2_33 : integer := 0;
signal M2_34 : integer := 0;
signal M2_35 : integer := 0;

signal M2_41 : integer := 0;
signal M2_42 : integer := 0;
signal M2_43 : integer := 0;
signal M2_44 : integer := 0;
signal M2_45 : integer := 0;

signal M2_51 : integer := 0;
signal M2_52 : integer := 0;
signal M2_53 : integer := 0;
signal M2_54 : integer := 0;
signal M2_55 : integer := 0;


-- Printed mouse graphics 3x3
signal X1_Mouse1 : integer := 455;
signal Y1_Mouse1 : integer := 110;

signal X1_Mouse2 : integer := 530;
signal Y1_Mouse2 : integer := 230;

signal X1_Mouse3 : integer := 605;
signal Y1_Mouse3 : integer := 350;

-- Printed mouse graphics 5x5
signal X2_Mouse1 : integer := 380;
signal Y2_Mouse1 : integer := 35;

signal X2_Mouse2 : integer := 455;
signal Y2_Mouse2 : integer := 150;

signal X2_Mouse3 : integer := 530;
signal Y2_Mouse3 : integer := 265;

signal X2_Mouse4 : integer := 605;
signal Y2_Mouse4 : integer := 380;

signal X2_Mouse5 : integer := 680;
signal Y2_Mouse5 : integer := 495; 

-- Printed Cat graphics 5x5
signal X2_Cat1 : integer := 380;
signal Y2_Cat1 : integer := 35;

signal X2_Cat2 : integer := 455;
signal Y2_Cat2 : integer := 150;

signal X2_Cat3 : integer := 530;
signal Y2_Cat3 : integer := 265;

signal X2_Cat4 : integer := 605;
signal Y2_Cat4 : integer := 380;

signal X2_Cat5 : integer := 680;
signal Y2_Cat5 : integer := 495;

-- Printed mouse graphics 3x3
signal X1_Cat1 : integer := 455;
signal Y1_Cat1 : integer := 110;

signal X1_Cat2 : integer := 530;
signal Y1_Cat2 : integer := 230;

signal X1_Cat3 : integer := 605;
signal Y1_Cat3 : integer := 350;
								  
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
	
	Starting_screen: process(hc, vc, videoON, juego9, juego25, X1_Origin, Y1_Origin, X2_Origin, Y2_Origin, X1_Rise, X2_Rise, Y1_Rise, Y2_Rise, Turn, Winner, X_Winner, Y_Winner,
	P1_11, P1_12, P1_13, P1_21, P1_22, P1_23, P1_31, P1_32, P1_33, X1_Mouse1, X1_Mouse2, X1_Mouse3, Y1_Mouse1, Y1_Mouse2, Y1_Mouse3,
	P2_11, P2_12, P2_13, P2_21, P2_22, P2_23, P2_31, P2_32, P2_33, X1_Cat1, X1_Cat2, X1_Cat3, Y1_Cat1, Y1_Cat2, Y1_Cat3,
	M1_11, M1_12, M1_13, M1_14, M1_15, M1_21, M1_22, M1_23, M1_24, M1_25, M1_31, M1_32, M1_33, M1_34, M1_35, M1_41, M1_42, M1_43, M1_44, M1_45, M1_51, M1_52, M1_53, M1_54, M1_55,
	X2_Mouse1, X2_Mouse2, X2_Mouse3, X2_Mouse4, X2_Mouse5, X2_Cat1, X2_Cat2, X2_Cat3, X2_Cat4, X2_Cat5, Y2_Mouse1, Y2_Mouse2, Y2_Mouse3, Y2_Mouse4, Y2_Mouse5, Y2_Cat1, Y2_Cat2, Y2_Cat3, Y2_Cat4, Y2_Cat5,
	M2_11, M2_12, M2_13, M2_14, M2_15, M2_21, M2_22, M2_23, M2_24, M2_25, M2_31, M2_32, M2_33, M2_34, M2_35, M2_41, M2_42, M2_43, M2_44, M2_45, M2_51, M2_52, M2_53, M2_54, M2_55)
	begin
		-- Home screen borders
		if((hc > 290 and hc < 648 and vc > 80 and vc < 100 and videoON = '1' and juego25 = '0' and juego9 = '0')) then -- Edge
			red <= "1100";		-- Pink
			blue <= "1110";
			green <= "0000";
		elsif((hc > 290 and hc < 648 and vc > 210 and vc < 230 and videoon = '1' and juego25 = '0' and juego9 = '0')) then -- Edge
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
			and videoON = '1' and juego25 = '0' and juego9 = '0') then
			red <= "1111";
			blue <= "0000";
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
			and videoON = '1' and juego25 = '0' and juego9 = '0') then
			red <= "0000";
			blue <= "0100";
			green <= "1110";

		-- Start message "Press" right side
		elsif((((hc >= 216 and hc <= 240)  and (vc >= 250 and vc <= 260)) or
			(((hc >= 216 and hc <= 222) or  (hc >= 240 and hc <= 246))	and (vc >= 260 and vc <= 270))  or
			(((hc >= 216 and hc <= 240) or  (hc >= 252 and hc <= 258)	or	(hc >= 264 and hc <= 270)	or	(hc >= 288 and hc <= 300)	or	(hc >= 324 and hc <= 342)	or	(hc >= 360 and hc <= 378)) 	and (vc >= 270 and vc <= 280))  or 
			(((hc >= 216 and hc <= 222) or  (hc >= 252 and hc <= 264)	or	(hc >= 282 and hc <= 288)	or	(hc >= 300 and hc <= 306)	or	(hc >= 318 and hc <= 324)	or	(hc >= 354 and hc <= 360))	and (vc >= 280 and vc <= 290))  or 
			(((hc >= 216 and hc <= 222) or  (hc >= 252 and hc <= 258)	or	(hc >= 282 and hc <= 306)	or	(hc >= 324 and hc <= 336)	or	(hc >= 360 and hc <= 372)) 	and (vc >= 290 and vc <= 300))  or 
			(((hc >= 216 and hc <= 222) or  (hc >= 252 and hc <= 258)	or	(hc >= 282 and hc <= 288)	or	(hc >= 336 and hc <= 342)	or	(hc >= 372 and hc <= 378))	and (vc >= 300 and vc <= 310))  or 
			(((hc >= 216 and hc <= 222) or  (hc >= 252 and hc <= 258)	or	(hc >= 282 and hc <= 288)	or	(hc >= 300 and hc <= 306)	or	(hc >= 336 and hc <= 342)	or	(hc >= 372 and hc <= 378))	and (vc >= 310 and vc <= 320))  or 
			(((hc >= 216 and hc <= 222) or  (hc >= 252 and hc <= 258)	or	(hc >= 288 and hc <= 306)	or	(hc >= 318 and hc <= 336)	or	(hc >= 354 and hc <= 372))	and (vc >= 320 and vc <= 330)))
			and videoON = '1' and juego25 = '0' and juego9 = '0') then
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
			and videoON = '1' and juego25 = '0' and juego9 = '0') then
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
			and videoON = '1' and juego25 = '0' and juego9 = '0') then
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
			and videoON = '1' and juego25 = '0' and juego9 = '0') then
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
			and videoON = '1' and juego25 = '0' and juego9 = '0') then
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
			and videoON = '1' and juego25 = '0' and juego9 = '0') then
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
			and videoON = '1' and juego25 = '0' and juego9 = '1' and Winner3 = 0) then
			red <= "1000";
			blue <= "1100";
			green <= "0000"; 
			
		-- 5x5 game
		elsif((((hc >= 375 and hc <= 755) and (vc >= 30 and vc <= 35)) or
			(((hc >= 375 and hc <= 380) or  (hc >= 450 and hc <= 455)	or  (hc >= 525 and hc <= 530)	or  (hc >= 600 and hc <= 605)	or  (hc >= 675 and hc <= 680)	or  (hc >= 750 and hc <= 755))  and (vc >= 35 and vc <= 145))  or
			 ((hc >= 375 and hc <= 755) and (vc >= 145 and vc <= 150))  or 
			(((hc >= 375 and hc <= 380) or  (hc >= 450 and hc <= 455)	or  (hc >= 525 and hc <= 530)	or  (hc >= 600 and hc <= 605)	or  (hc >= 675 and hc <= 680)	or  (hc >= 750 and hc <= 755))  and (vc >= 150 and vc <= 260))  or 
			 ((hc >= 375 and hc <= 755) and (vc >= 260 and vc <= 265))  or 
			(((hc >= 375 and hc <= 380) or  (hc >= 450 and hc <= 455)	or  (hc >= 525 and hc <= 530)	or  (hc >= 600 and hc <= 605)	or  (hc >= 675 and hc <= 680)	or  (hc >= 750 and hc <= 755))  and (vc >= 265 and vc <= 375))  or
			 ((hc >= 375 and hc <= 755) and (vc >= 375 and vc <= 380))  or 
			(((hc >= 375 and hc <= 380) or  (hc >= 450 and hc <= 455)	or  (hc >= 525 and hc <= 530)	or  (hc >= 600 and hc <= 605)	or  (hc >= 675 and hc <= 680)	or  (hc >= 750 and hc <= 755))  and (vc >= 380 and vc <= 490))  or
			 ((hc >= 375 and hc <= 755) and (vc >= 490 and vc <= 495))  or 
			(((hc >= 375 and hc <= 380) or  (hc >= 450 and hc <= 455)	or  (hc >= 525 and hc <= 530)	or  (hc >= 600 and hc <= 605)	or  (hc >= 675 and hc <= 680)	or  (hc >= 750 and hc <= 755))  and (vc >= 495 and vc <= 605))  or
			 ((hc >= 375 and hc <= 755) and (vc >= 605 and vc <= 610)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and Winner = 0) then
			red <= "1000";
			blue <= "1100";
			green <= "0000";
								 				   
		-- "Choose" Message 3x3
		elsif(((((hc >= 206 and hc <= 224) or (hc >= 236 and hc <= 242)) and (vc >= 110 and vc <= 120)) or
			(((hc >= 200 and hc <= 206) or  (hc >= 224 and hc <= 230)   or  (hc >= 236 and hc <= 242))	and (vc >= 120 and vc <= 130))  or
			(((hc >= 200 and hc <= 206) or  (hc >= 236 and hc <= 242)	or	(hc >= 248 and hc <= 254)	or	(hc >= 272 and hc <= 284)	or	(hc >= 302 and hc <= 314)	or	(hc >= 332 and hc <= 350)	or	(hc >= 362 and hc <= 374)) 	and (vc >= 130 and vc <= 140))  or 
			(((hc >= 200 and hc <= 206) or  (hc >= 236 and hc <= 248)	or	(hc >= 254 and hc <= 260)	or	(hc >= 266 and hc <= 272)	or	(hc >= 284 and hc <= 290)	or	(hc >= 296 and hc <= 302)	or	(hc >= 314 and hc <= 320)	or	(hc >= 326 and hc <= 332)	or	(hc >= 356 and hc <= 362)	or	(hc >= 374 and hc <= 380)) 	and (vc >= 140 and vc <= 150))  or 
			(((hc >= 200 and hc <= 206) or  (hc >= 236 and hc <= 242)	or	(hc >= 254 and hc <= 260)	or	(hc >= 266 and hc <= 272)	or	(hc >= 284 and hc <= 290)	or	(hc >= 296 and hc <= 302)	or	(hc >= 314 and hc <= 320)	or	(hc >= 332 and hc <= 344)	or	(hc >= 356 and hc <= 380)) 	and (vc >= 150 and vc <= 160))  or 
			(((hc >= 200 and hc <= 206) or  (hc >= 236 and hc <= 242)	or	(hc >= 254 and hc <= 260)	or	(hc >= 266 and hc <= 272)	or	(hc >= 284 and hc <= 290)	or	(hc >= 296 and hc <= 302)	or	(hc >= 314 and hc <= 320)	or	(hc >= 344 and hc <= 350)	or	(hc >= 356 and hc <= 362)) 	and (vc >= 160 and vc <= 170))  or 
			(((hc >= 200 and hc <= 206) or  (hc >= 224 and hc <= 230)	or	(hc >= 236 and hc <= 242)	or	(hc >= 254 and hc <= 260)	or	(hc >= 266 and hc <= 272)	or	(hc >= 284 and hc <= 290)	or	(hc >= 296 and hc <= 302)	or	(hc >= 314 and hc <= 320)	or	(hc >= 344 and hc <= 350)	or	(hc >= 356 and hc <= 362)	or	(hc >= 374 and hc <= 380)) 	and (vc >= 170 and vc <= 180))  or 
			(((hc >= 206 and hc <= 224) or  (hc >= 236 and hc <= 242)	or	(hc >= 254 and hc <= 260)	or	(hc >= 272 and hc <= 284)	or	(hc >= 302 and hc <= 314)	or	(hc >= 326 and hc <= 344)	or	(hc >= 362 and hc <= 380)) 	and (vc >= 180 and vc <= 190)))
			and videoON = '1' and juego25 = '0' and juego9 = '1' and Winner3 = 0) then
			red <= "1111";
			blue <= "1111";
			green <= "1111";
			
		-- "a space" Message 3x3
		elsif(((((hc >= 200 and hc <= 218) or (hc >= 248 and hc <= 266) or (hc >= 272 and hc <= 278) or (hc >= 284 and hc <= 290) or (hc >= 302 and hc <= 320) or (hc >= 338 and hc <= 350) or (hc >= 368 and hc <= 380)) and (vc >= 220 and vc <= 230)) or
			(((hc >= 218 and hc <= 224) or  (hc >= 242 and hc <= 248)   or  (hc >= 272 and hc <= 284)   or  (hc >= 290 and hc <= 296)   or  (hc >= 320 and hc <= 326)   or  (hc >= 332 and hc <= 338)   or  (hc >= 350 and hc <= 356)   or  (hc >= 362 and hc <= 368)   or  (hc >= 380 and hc <= 386))	and (vc >= 230 and vc <= 240))  or
			(((hc >= 206 and hc <= 224) or  (hc >= 248 and hc <= 260)	or	(hc >= 272 and hc <= 278)	or	(hc >= 290 and hc <= 296)	or	(hc >= 308 and hc <= 326)	or	(hc >= 332 and hc <= 338)	or	(hc >= 362 and hc <= 386)) 	and (vc >= 240 and vc <= 250))  or 
			(((hc >= 200 and hc <= 206) or  (hc >= 218 and hc <= 224)	or	(hc >= 260 and hc <= 266)	or	(hc >= 272 and hc <= 278)	or	(hc >= 290 and hc <= 296)	or	(hc >= 302 and hc <= 308)	or	(hc >= 320 and hc <= 326)	or	(hc >= 332 and hc <= 338)	or	(hc >= 362 and hc <= 368))	and (vc >= 250 and vc <= 260))  or 
			(((hc >= 200 and hc <= 206) or  (hc >= 218 and hc <= 224)	or	(hc >= 260 and hc <= 266)	or	(hc >= 272 and hc <= 278)	or	(hc >= 290 and hc <= 296)	or	(hc >= 302 and hc <= 308)	or	(hc >= 320 and hc <= 326)	or	(hc >= 332 and hc <= 338)	or	(hc >= 350 and hc <= 356)	or	(hc >= 362 and hc <= 368)	or	(hc >= 380 and hc <= 386)) 	and (vc >= 260 and vc <= 270))  or 
			(((hc >= 206 and hc <= 224) or  (hc >= 242 and hc <= 260)	or	(hc >= 272 and hc <= 290)	or	(hc >= 308 and hc <= 326)	or	(hc >= 338 and hc <= 350)	or	(hc >= 368 and hc <= 386)) 	and (vc >= 270 and vc <= 280))  or 
			 ((hc >= 272 and hc <= 278)	and (vc >= 280 and vc <= 310)))
			and videoON = '1' and juego25 = '0' and juego9 = '1' and Winner3 = 0) then
			red <= "1111";
			blue <= "1111";
			green <= "1111";
			
		-- "Player" Message 3x3
		elsif(((((hc >= 200 and hc <= 224) or (hc >= 236 and hc <= 242)) and (vc >= 320 and vc <= 330)) or
			(((hc >= 200 and hc <= 206) or  (hc >= 224 and hc <= 230)   or  (hc >= 236 and hc <= 242))	and (vc >= 330 and vc <= 340))  or
			(((hc >= 200 and hc <= 224) or  (hc >= 236 and hc <= 242)	or	(hc >= 248 and hc <= 266)	or	(hc >= 278 and hc <= 284)	or	(hc >= 296 and hc <= 302)	or	(hc >= 314 and hc <= 326)	or	(hc >= 338 and hc <= 344)	or	(hc >= 350 and hc <= 356)) 	and (vc >= 340 and vc <= 350))  or 
			(((hc >= 200 and hc <= 206) or  (hc >= 236 and hc <= 242)	or	(hc >= 266 and hc <= 272)	or	(hc >= 278 and hc <= 284)	or	(hc >= 296 and hc <= 302)	or	(hc >= 308 and hc <= 314)	or	(hc >= 326 and hc <= 332)	or	(hc >= 338 and hc <= 350)) 	and (vc >= 350 and vc <= 360))  or 
			(((hc >= 200 and hc <= 206) or  (hc >= 236 and hc <= 242)	or	(hc >= 254 and hc <= 272)	or	(hc >= 278 and hc <= 284)	or	(hc >= 296 and hc <= 302)	or	(hc >= 308 and hc <= 332)	or	(hc >= 338 and hc <= 344)) 	and (vc >= 360 and vc <= 370))  or 
			(((hc >= 200 and hc <= 206) or  (hc >= 236 and hc <= 242)	or	(hc >= 248 and hc <= 254)	or	(hc >= 266 and hc <= 272)	or	(hc >= 278 and hc <= 284)	or	(hc >= 296 and hc <= 302)	or	(hc >= 308 and hc <= 314)	or	(hc >= 338 and hc <= 344)) 	and (vc >= 370 and vc <= 380))  or 
			(((hc >= 200 and hc <= 206) or  (hc >= 236 and hc <= 242)	or	(hc >= 248 and hc <= 254)	or	(hc >= 266 and hc <= 272)	or	(hc >= 278 and hc <= 284)	or	(hc >= 296 and hc <= 302)	or	(hc >= 308 and hc <= 314)	or	(hc >= 326 and hc <= 332)	or	(hc >= 338 and hc <= 344)) 	and (vc >= 380 and vc <= 390))  or 
			(((hc >= 200 and hc <= 206) or  (hc >= 236 and hc <= 242)	or	(hc >= 254 and hc <= 272)	or	(hc >= 284 and hc <= 302)	or	(hc >= 314 and hc <= 332)	or	(hc >= 338 and hc <= 344)) 	and (vc >= 390 and vc <= 400)) 	or
			 ((hc >= 296 and hc <= 302)	and (vc >= 400 and vc <= 420))	or
			 ((hc >= 278 and hc <= 296)	and (vc >= 420 and vc <= 430)))	
			and videoON = '1' and juego25 = '0' and juego9 = '1' and Winner3 = 0) then
			red <= "1111";
			blue <= "1111";
			green <= "1111"; 
		
		-- "No 2" Message 3x3	
		elsif((((hc >= 380 and hc <= 398) and (vc >= 320 and vc <= 330)) or
			(((hc >= 374 and hc <= 380) or  (hc >= 398 and hc <= 404))	and (vc >= 330 and vc <= 340))  	or
			 ((hc >= 398 and hc <= 404) and (vc >= 340 and vc <= 350))  or 
			 ((hc >= 392 and hc <= 398) and (vc >= 350 and vc <= 360)) 	or
			 ((hc >= 386 and hc <= 392) and (vc >= 360 and vc <= 370))  or
			 ((hc >= 380 and hc <= 386) and (vc >= 370 and vc <= 380)) 	or
			 ((hc >= 374 and hc <= 380) and (vc >= 380 and vc <= 390))	or
			 ((hc >= 374 and hc <= 404) and (vc >= 390 and vc <= 400)))
			and videoON = '1' and juego25 = '0' and juego9 = '1' and Turn ='0' and Winner3 = 0) then
			red <= "0000";
			blue <= "0100";
			green <= "1110";
			
		-- "No 1" Message 3x3	
		elsif((((hc >= 380 and hc <= 392) and (vc >= 320 and vc <= 330)) or
			(((hc >= 374 and hc <= 380) or  (hc >= 386 and hc <= 392))	and (vc >= 330 and vc <= 340))  	or
			 ((hc >= 386 and hc <= 392) and (vc >= 340 and vc <= 350))  or 
			 ((hc >= 386 and hc <= 392) and (vc >= 350 and vc <= 360)) 	or
			 ((hc >= 386 and hc <= 392) and (vc >= 360 and vc <= 370))  or
			 ((hc >= 386 and hc <= 392) and (vc >= 370 and vc <= 380)) 	or
			 ((hc >= 386 and hc <= 392) and (vc >= 380 and vc <= 390))	or
			 ((hc >= 374 and hc <= 404) and (vc >= 390 and vc <= 400)))
			and videoON = '1' and juego25 = '0' and juego9 = '1' and Turn ='1' and Winner3 = 0) then
			red <= "1111";
			blue <= "0000";
			green <= "1111";
		
		-- Mouse movement animation 3x3	
		elsif ((((hc >= 30 + X1_Origin + X1_Rise and hc <= 36 + X1_Origin + X1_Rise) and (vc >= 10 + Y1_Origin + Y1_Rise	and vc <= 20 + Y1_Origin + Y1_Rise))	or
			(((hc >= 12 + X1_Origin + X1_Rise and hc <= 18 + X1_Origin + X1_Rise) or  (hc >= 30	+ X1_Origin + X1_Rise	and hc <= 36 + X1_Origin + X1_Rise)	or  (hc >= 48 + X1_Origin + X1_Rise and hc <= 54 + X1_Origin + X1_Rise))	and (vc >= 20 + Y1_Origin + Y1_Rise and vc <= 30 + Y1_Origin + Y1_Rise)) or
			(((hc >= 18 + X1_Origin + X1_Rise and hc <= 24 + X1_Origin + X1_Rise) or  (hc >= 42 + X1_Origin + X1_Rise	and hc <= 48 + X1_Origin + X1_Rise)) and	(vc >= 30 + Y1_Origin + Y1_Rise and vc <= 40 + Y1_Origin + Y1_Rise))	or 
			 ((hc >= 12 + X1_Origin + X1_Rise and hc <= 54 + X1_Origin + X1_Rise) and (vc >= 40 + Y1_Origin + Y1_Rise	and vc <  50 + Y1_Origin + Y1_Rise))	or
			(((hc >  6	+ X1_Origin + X1_Rise and hc <  18 + X1_Origin + X1_Rise) or  (hc > 24  + X1_Origin + X1_Rise	and hc <  42 + X1_Origin + X1_Rise) 	or  (hc >  48 + X1_Origin + X1_Rise and hc <  60 + X1_Origin + X1_Rise))	and (vc >= 50 + Y1_Origin + Y1_Rise and vc <= 60 + Y1_Origin + Y1_Rise)) or
			 ((hc >= 12 + X1_Origin + X1_Rise and hc <= 54 + X1_Origin + X1_Rise) and (vc > 60  + Y1_Origin + Y1_Rise	and vc <= 70 + Y1_Origin + Y1_Rise))	or
			(((hc >= 24 + X1_Origin + X1_Rise and hc <  30 + X1_Origin + X1_Rise) or  (hc > 36  + X1_Origin + X1_Rise	and hc <= 42 + X1_Origin + X1_Rise)) and	(vc >= 70 + Y1_Origin + Y1_Rise and vc <= 80 + Y1_Origin + Y1_Rise))	or
			(((hc >= 12 + X1_Origin + X1_Rise and hc <= 24 + X1_Origin + X1_Rise) or  (hc >= 30 + X1_Origin + X1_Rise	and hc <= 36 + X1_Origin + X1_Rise) 	or  (hc >= 42 + X1_Origin + X1_Rise and hc <= 54 + X1_Origin + X1_Rise))	and (vc >= 80 + Y1_Origin + Y1_Rise and vc <= 90 + Y1_Origin + Y1_Rise)) or
			(((hc >= 18 + X1_Origin + X1_Rise and hc <= 24 + X1_Origin + X1_Rise) or  (hc >= 42 + X1_Origin + X1_Rise	and hc <= 48 + X1_Origin + X1_Rise)) and	(vc >= 90 + Y1_Origin + Y1_Rise and vc <= 100 + Y1_Origin + Y1_Rise))	or
			 ((hc >= 30 + X1_Origin + X1_Rise and hc <= 36 + X1_Origin + X1_Rise) and (vc >= 100 + Y1_Origin + Y1_Rise and vc <= 110 + Y1_Origin + Y1_Rise)))
			and videoON = '1' and juego25 = '0' and juego9 = '1' and Turn ='1' and Winner3 = 0) then
			red <= "1111";
			blue <= "1111";
			green <= "1111";
		
		-- CAT movement animation 3x3		
		elsif((((hc >= 33 + X1_Origin + X1_Rise and hc <= 39 + X1_Origin + X1_Rise) and (vc >= 10 + Y1_Origin + Y1_Rise and vc <= 20 + Y1_Origin + Y1_Rise)) or
			(((hc >= 15 + X1_Origin + X1_Rise and hc <= 21 + X1_Origin + X1_Rise) or  (hc >= 33 + X1_Origin + X1_Rise and hc <= 39 + X1_Origin + X1_Rise) 	or  (hc >= 51 + X1_Origin + X1_Rise and hc <= 57 + X1_Origin + X1_Rise)) and (vc >= 20 + Y1_Origin + Y1_Rise and vc < 30 + Y1_Origin + Y1_Rise))  	or
			(((hc >= 21 + X1_Origin + X1_Rise and hc <  33 + X1_Origin + X1_Rise) or  (hc >  39 + X1_Origin + X1_Rise and hc <= 51 + X1_Origin + X1_Rise))	and (vc >= 30 + Y1_Origin + Y1_Rise and vc <= 40 + Y1_Origin + Y1_Rise)) or 
			(((hc >  3  + X1_Origin + X1_Rise and hc <  9  + X1_Origin + X1_Rise) or  (hc >  15 + X1_Origin + X1_Rise and hc <  57 + X1_Origin + X1_Rise) 	or  (hc >  63 + X1_Origin + X1_Rise and hc <  69 + X1_Origin + X1_Rise)) and (vc >  40 + Y1_Origin + Y1_Rise and vc < 50 + Y1_Origin + Y1_Rise)) 	or
			(((hc >  3  + X1_Origin + X1_Rise and hc <  21 + X1_Origin + X1_Rise) or  (hc >  27 + X1_Origin + X1_Rise and hc <  45 + X1_Origin + X1_Rise) 	or  (hc >  51 + X1_Origin + X1_Rise and hc <  69 + X1_Origin + X1_Rise)) and (vc >= 50 + Y1_Origin + Y1_Rise and vc <= 60 + Y1_Origin + Y1_Rise))  or
			 ((hc >= 15 + X1_Origin + X1_Rise and hc <= 57 + X1_Origin + X1_Rise) and (vc >  60 + Y1_Origin + Y1_Rise and vc <  70 + Y1_Origin + Y1_Rise))or
			(((hc >  9  + X1_Origin + X1_Rise and hc <  15 + X1_Origin + X1_Rise) or  (hc >= 21 + X1_Origin + X1_Rise and hc <  27 + X1_Origin + X1_Rise)	or	(hc >= 33 + X1_Origin + X1_Rise and hc <  39 + X1_Origin + X1_Rise)	 or (hc >= 45 + X1_Origin + X1_Rise and hc < 51 + X1_Origin + X1_Rise)	or	(hc > 57 + X1_Origin + X1_Rise and hc < 63 + X1_Origin + X1_Rise))	and (vc >= 70 + Y1_Origin + Y1_Rise and vc <= 80 + Y1_Origin + Y1_Rise)) or
			(((hc >  9  + X1_Origin + X1_Rise and hc <  15 + X1_Origin + X1_Rise) or  (hc >  57 + X1_Origin + X1_Rise and hc <  63 + X1_Origin + X1_Rise))  and (vc >  80 + Y1_Origin + Y1_Rise and vc <  90 + Y1_Origin + Y1_Rise)) or
			(((hc >= 15 + X1_Origin + X1_Rise and hc <= 21 + X1_Origin + X1_Rise) or  (hc >= 51 + X1_Origin + X1_Rise and hc <= 57 + X1_Origin + X1_Rise)) 	and (vc >= 90 + Y1_Origin + Y1_Rise and vc < 100 + Y1_Origin + Y1_Rise)))
			and videoON = '1' and juego25 = '0' and juego9 = '1' and Turn ='0' and Winner3 = 0) then
			red <= "1111";
			blue <= "1111";
			green <= "1111";
			
		-- Printed mouse graphic 3x3(1,1)
		elsif ((((hc >= 30 + X1_Mouse1 and hc <= 36 + X1_Mouse1) and (vc >= 10 + Y1_Mouse1	and vc <= 20 + Y1_Mouse1))	or
			(((hc >= 12 + X1_Mouse1 and hc <= 18 + X1_Mouse1) or  (hc >= 30	+ X1_Mouse1	and hc <= 36 + X1_Mouse1)	or  (hc >= 48 + X1_Mouse1 and hc <= 54 + X1_Mouse1))	and (vc >= 20 + Y1_Mouse1 and vc <= 30 + Y1_Mouse1)) or
			(((hc >= 18 + X1_Mouse1 and hc <= 24 + X1_Mouse1) or  (hc >= 42 + X1_Mouse1	and hc <= 48 + X1_Mouse1)) and	(vc >= 30 + Y1_Mouse1 and vc <= 40 + Y1_Mouse1))	or 
			 ((hc >= 12 + X1_Mouse1 and hc <= 54 + X1_Mouse1) and (vc >= 40 + Y1_Mouse1	and vc <  50 + Y1_Mouse1))	or
			(((hc >  6	+ X1_Mouse1 and hc <  18 + X1_Mouse1) or  (hc > 24  + X1_Mouse1	and hc <  42 + X1_Mouse1) 	or  (hc >  48 + X1_Mouse1 and hc <  60 + X1_Mouse1))	and (vc >= 50 + Y1_Mouse1 and vc <= 60 + Y1_Mouse1)) or
			 ((hc >= 12 + X1_Mouse1 and hc <= 54 + X1_Mouse1) and (vc > 60  + Y1_Mouse1	and vc <= 70 + Y1_Mouse1))	or
			(((hc >= 24 + X1_Mouse1 and hc <  30 + X1_Mouse1) or  (hc > 36  + X1_Mouse1	and hc <= 42 + X1_Mouse1)) and	(vc >= 70 + Y1_Mouse1 and vc <= 80 + Y1_Mouse1))	or
			(((hc >= 12 + X1_Mouse1 and hc <= 24 + X1_Mouse1) or  (hc >= 30 + X1_Mouse1	and hc <= 36 + X1_Mouse1) 	or  (hc >= 42 + X1_Mouse1 and hc <= 54 + X1_Mouse1))	and (vc >= 80 + Y1_Mouse1 and vc <= 90 + Y1_Mouse1)) or
			(((hc >= 18 + X1_Mouse1 and hc <= 24 + X1_Mouse1) or  (hc >= 42 + X1_Mouse1	and hc <= 48 + X1_Mouse1)) and	(vc >= 90 + Y1_Mouse1 and vc <= 100 + Y1_Mouse1))	or
			 ((hc >= 30 + X1_Mouse1 and hc <= 36 + X1_Mouse1) and (vc >= 100 + Y1_Mouse1 and vc <= 110 + Y1_Mouse1)))
			and videoON = '1' and juego25 = '0' and juego9 = '1' and P1_11 = 1 and Winner3 = 0) then
			red <= "1111";
			blue <= "0000";
			green <= "1111";
			
		-- Printed mouse graphic 3x3(1,2)
		elsif ((((hc >= 30 + X1_Mouse1 and hc <= 36 + X1_Mouse1) and (vc >= 10 + Y1_Mouse2	and vc <= 20 + Y1_Mouse2))	or
			(((hc >= 12 + X1_Mouse1 and hc <= 18 + X1_Mouse1) or  (hc >= 30	+ X1_Mouse1	and hc <= 36 + X1_Mouse1)	or  (hc >= 48 + X1_Mouse1 and hc <= 54 + X1_Mouse1))	and (vc >= 20 + Y1_Mouse2 and vc <= 30 + Y1_Mouse2)) or
			(((hc >= 18 + X1_Mouse1 and hc <= 24 + X1_Mouse1) or  (hc >= 42 + X1_Mouse1	and hc <= 48 + X1_Mouse1)) and	(vc >= 30 + Y1_Mouse2 and vc <= 40 + Y1_Mouse2))	or 
			 ((hc >= 12 + X1_Mouse1 and hc <= 54 + X1_Mouse1) and (vc >= 40 + Y1_Mouse2	and vc <  50 + Y1_Mouse2))	or
			(((hc >  6	+ X1_Mouse1 and hc <  18 + X1_Mouse1) or  (hc > 24  + X1_Mouse1	and hc <  42 + X1_Mouse1) 	or  (hc >  48 + X1_Mouse1 and hc <  60 + X1_Mouse1))	and (vc >= 50 + Y1_Mouse2 and vc <= 60 + Y1_Mouse2)) or
			 ((hc >= 12 + X1_Mouse1 and hc <= 54 + X1_Mouse1) and (vc > 60  + Y1_Mouse2	and vc <= 70 + Y1_Mouse2))	or
			(((hc >= 24 + X1_Mouse1 and hc <  30 + X1_Mouse1) or  (hc > 36  + X1_Mouse1	and hc <= 42 + X1_Mouse1)) and	(vc >= 70 + Y1_Mouse2 and vc <= 80 + Y1_Mouse2))	or
			(((hc >= 12 + X1_Mouse1 and hc <= 24 + X1_Mouse1) or  (hc >= 30 + X1_Mouse1	and hc <= 36 + X1_Mouse1) 	or  (hc >= 42 + X1_Mouse1 and hc <= 54 + X1_Mouse1))	and (vc >= 80 + Y1_Mouse2 and vc <= 90 + Y1_Mouse2)) or
			(((hc >= 18 + X1_Mouse1 and hc <= 24 + X1_Mouse1) or  (hc >= 42 + X1_Mouse1	and hc <= 48 + X1_Mouse1)) and	(vc >= 90 + Y1_Mouse2 and vc <= 100 + Y1_Mouse2))	or
			 ((hc >= 30 + X1_Mouse1 and hc <= 36 + X1_Mouse1) and (vc >= 100 + Y1_Mouse2 and vc <= 110 + Y1_Mouse2)))
			and videoON = '1' and juego25 = '0' and juego9 = '1' and P1_12 = 1 and Winner3 = 0) then
			red <= "1111";
			blue <= "0000";
			green <= "1111";
			
		-- Printed mouse graphic 3x3(1,3)
		elsif ((((hc >= 30 + X1_Mouse1 and hc <= 36 + X1_Mouse1) and (vc >= 10 + Y1_Mouse3	and vc <= 20 + Y1_Mouse3))	or
			(((hc >= 12 + X1_Mouse1 and hc <= 18 + X1_Mouse1) or  (hc >= 30	+ X1_Mouse1	and hc <= 36 + X1_Mouse1)	or  (hc >= 48 + X1_Mouse1 and hc <= 54 + X1_Mouse1))	and (vc >= 20 + Y1_Mouse3 and vc <= 30 + Y1_Mouse3)) or
			(((hc >= 18 + X1_Mouse1 and hc <= 24 + X1_Mouse1) or  (hc >= 42 + X1_Mouse1	and hc <= 48 + X1_Mouse1)) and	(vc >= 30 + Y1_Mouse3 and vc <= 40 + Y1_Mouse3))	or 
			 ((hc >= 12 + X1_Mouse1 and hc <= 54 + X1_Mouse1) and (vc >= 40 + Y1_Mouse3	and vc <  50 + Y1_Mouse3))	or
			(((hc >  6	+ X1_Mouse1 and hc <  18 + X1_Mouse1) or  (hc > 24  + X1_Mouse1	and hc <  42 + X1_Mouse1) 	or  (hc >  48 + X1_Mouse1 and hc <  60 + X1_Mouse1))	and (vc >= 50 + Y1_Mouse3 and vc <= 60 + Y1_Mouse3)) or
			 ((hc >= 12 + X1_Mouse1 and hc <= 54 + X1_Mouse1) and (vc > 60  + Y1_Mouse3	and vc <= 70 + Y1_Mouse3))	or
			(((hc >= 24 + X1_Mouse1 and hc <  30 + X1_Mouse1) or  (hc > 36  + X1_Mouse1	and hc <= 42 + X1_Mouse1)) and	(vc >= 70 + Y1_Mouse3 and vc <= 80 + Y1_Mouse3))	or
			(((hc >= 12 + X1_Mouse1 and hc <= 24 + X1_Mouse1) or  (hc >= 30 + X1_Mouse1	and hc <= 36 + X1_Mouse1) 	or  (hc >= 42 + X1_Mouse1 and hc <= 54 + X1_Mouse1))	and (vc >= 80 + Y1_Mouse3 and vc <= 90 + Y1_Mouse3)) or
			(((hc >= 18 + X1_Mouse1 and hc <= 24 + X1_Mouse1) or  (hc >= 42 + X1_Mouse1	and hc <= 48 + X1_Mouse1)) and	(vc >= 90 + Y1_Mouse3 and vc <= 100 + Y1_Mouse3))	or
			 ((hc >= 30 + X1_Mouse1 and hc <= 36 + X1_Mouse1) and (vc >= 100 + Y1_Mouse3 and vc <= 110 + Y1_Mouse3)))
			and videoON = '1' and juego25 = '0' and juego9 = '1' and P1_13 = 1 and Winner3 = 0) then
			red <= "1111";
			blue <= "0000";
			green <= "1111";
			
		-- Printed mouse graphic 3x3(2,1)
		elsif ((((hc >= 30 + X1_Mouse2 and hc <= 36 + X1_Mouse2) and (vc >= 10 + Y1_Mouse1	and vc <= 20 + Y1_Mouse1))	or
			(((hc >= 12 + X1_Mouse2 and hc <= 18 + X1_Mouse2) or  (hc >= 30	+ X1_Mouse2	and hc <= 36 + X1_Mouse2)	or  (hc >= 48 + X1_Mouse2 and hc <= 54 + X1_Mouse2))	and (vc >= 20 + Y1_Mouse1 and vc <= 30 + Y1_Mouse1)) or
			(((hc >= 18 + X1_Mouse2 and hc <= 24 + X1_Mouse2) or  (hc >= 42 + X1_Mouse2	and hc <= 48 + X1_Mouse2)) and	(vc >= 30 + Y1_Mouse1 and vc <= 40 + Y1_Mouse1))	or 
			 ((hc >= 12 + X1_Mouse2 and hc <= 54 + X1_Mouse2) and (vc >= 40 + Y1_Mouse1	and vc <  50 + Y1_Mouse1))	or
			(((hc >  6	+ X1_Mouse2 and hc <  18 + X1_Mouse2) or  (hc > 24  + X1_Mouse2	and hc <  42 + X1_Mouse2) 	or  (hc >  48 + X1_Mouse2 and hc <  60 + X1_Mouse2))	and (vc >= 50 + Y1_Mouse1 and vc <= 60 + Y1_Mouse1)) or
			 ((hc >= 12 + X1_Mouse2 and hc <= 54 + X1_Mouse2) and (vc > 60  + Y1_Mouse1	and vc <= 70 + Y1_Mouse1))	or
			(((hc >= 24 + X1_Mouse2 and hc <  30 + X1_Mouse2) or  (hc > 36  + X1_Mouse2	and hc <= 42 + X1_Mouse2)) and	(vc >= 70 + Y1_Mouse1 and vc <= 80 + Y1_Mouse1))	or
			(((hc >= 12 + X1_Mouse2 and hc <= 24 + X1_Mouse2) or  (hc >= 30 + X1_Mouse2	and hc <= 36 + X1_Mouse2) 	or  (hc >= 42 + X1_Mouse2 and hc <= 54 + X1_Mouse2))	and (vc >= 80 + Y1_Mouse1 and vc <= 90 + Y1_Mouse1)) or
			(((hc >= 18 + X1_Mouse2 and hc <= 24 + X1_Mouse2) or  (hc >= 42 + X1_Mouse2	and hc <= 48 + X1_Mouse2)) and	(vc >= 90 + Y1_Mouse1 and vc <= 100 + Y1_Mouse1))	or
			 ((hc >= 30 + X1_Mouse2 and hc <= 36 + X1_Mouse2) and (vc >= 100 + Y1_Mouse1 and vc <= 110 + Y1_Mouse1)))
			and videoON = '1' and juego25 = '0' and juego9 = '1' and P1_21 = 1 and Winner3 = 0) then
			red <= "1111";
			blue <= "0000";
			green <= "1111";
			
		-- Printed mouse graphic 3x3(2,2)
		elsif ((((hc >= 30 + X1_Mouse2 and hc <= 36 + X1_Mouse2) and (vc >= 10 + Y1_Mouse2	and vc <= 20 + Y1_Mouse2))	or
			(((hc >= 12 + X1_Mouse2 and hc <= 18 + X1_Mouse2) or  (hc >= 30	+ X1_Mouse2	and hc <= 36 + X1_Mouse2)	or  (hc >= 48 + X1_Mouse2 and hc <= 54 + X1_Mouse2))	and (vc >= 20 + Y1_Mouse2 and vc <= 30 + Y1_Mouse2)) or
			(((hc >= 18 + X1_Mouse2 and hc <= 24 + X1_Mouse2) or  (hc >= 42 + X1_Mouse2	and hc <= 48 + X1_Mouse2)) and	(vc >= 30 + Y1_Mouse2 and vc <= 40 + Y1_Mouse2))	or 
			 ((hc >= 12 + X1_Mouse2 and hc <= 54 + X1_Mouse2) and (vc >= 40 + Y1_Mouse2	and vc <  50 + Y1_Mouse2))	or
			(((hc >  6	+ X1_Mouse2 and hc <  18 + X1_Mouse2) or  (hc > 24  + X1_Mouse2	and hc <  42 + X1_Mouse2) 	or  (hc >  48 + X1_Mouse2 and hc <  60 + X1_Mouse2))	and (vc >= 50 + Y1_Mouse2 and vc <= 60 + Y1_Mouse2)) or
			 ((hc >= 12 + X1_Mouse2 and hc <= 54 + X1_Mouse2) and (vc > 60  + Y1_Mouse2	and vc <= 70 + Y1_Mouse2))	or
			(((hc >= 24 + X1_Mouse2 and hc <  30 + X1_Mouse2) or  (hc > 36  + X1_Mouse2	and hc <= 42 + X1_Mouse2)) and	(vc >= 70 + Y1_Mouse2 and vc <= 80 + Y1_Mouse2))	or
			(((hc >= 12 + X1_Mouse2 and hc <= 24 + X1_Mouse2) or  (hc >= 30 + X1_Mouse2	and hc <= 36 + X1_Mouse2) 	or  (hc >= 42 + X1_Mouse2 and hc <= 54 + X1_Mouse2))	and (vc >= 80 + Y1_Mouse2 and vc <= 90 + Y1_Mouse2)) or
			(((hc >= 18 + X1_Mouse2 and hc <= 24 + X1_Mouse2) or  (hc >= 42 + X1_Mouse2	and hc <= 48 + X1_Mouse2)) and	(vc >= 90 + Y1_Mouse2 and vc <= 100 + Y1_Mouse2))	or
			 ((hc >= 30 + X1_Mouse2 and hc <= 36 + X1_Mouse2) and (vc >= 100 + Y1_Mouse2 and vc <= 110 + Y1_Mouse2)))
			and videoON = '1' and juego25 = '0' and juego9 = '1' and P1_22 = 1 and Winner3 = 0) then
			red <= "1111";
			blue <= "0000";
			green <= "1111";
			
		-- Printed mouse graphic 3x3(2,3)
		elsif ((((hc >= 30 + X1_Mouse2 and hc <= 36 + X1_Mouse2) and (vc >= 10 + Y1_Mouse3	and vc <= 20 + Y1_Mouse3))	or
			(((hc >= 12 + X1_Mouse2 and hc <= 18 + X1_Mouse2) or  (hc >= 30	+ X1_Mouse2	and hc <= 36 + X1_Mouse2)	or  (hc >= 48 + X1_Mouse2 and hc <= 54 + X1_Mouse2))	and (vc >= 20 + Y1_Mouse3 and vc <= 30 + Y1_Mouse3)) or
			(((hc >= 18 + X1_Mouse2 and hc <= 24 + X1_Mouse2) or  (hc >= 42 + X1_Mouse2	and hc <= 48 + X1_Mouse2)) and	(vc >= 30 + Y1_Mouse3 and vc <= 40 + Y1_Mouse3))	or 
			 ((hc >= 12 + X1_Mouse2 and hc <= 54 + X1_Mouse2) and (vc >= 40 + Y1_Mouse3	and vc <  50 + Y1_Mouse3))	or
			(((hc >  6	+ X1_Mouse2 and hc <  18 + X1_Mouse2) or  (hc > 24  + X1_Mouse2	and hc <  42 + X1_Mouse2) 	or  (hc >  48 + X1_Mouse2 and hc <  60 + X1_Mouse2))	and (vc >= 50 + Y1_Mouse3 and vc <= 60 + Y1_Mouse3)) or
			 ((hc >= 12 + X1_Mouse2 and hc <= 54 + X1_Mouse2) and (vc > 60  + Y1_Mouse3	and vc <= 70 + Y1_Mouse3))	or
			(((hc >= 24 + X1_Mouse2 and hc <  30 + X1_Mouse2) or  (hc > 36  + X1_Mouse2	and hc <= 42 + X1_Mouse2)) and	(vc >= 70 + Y1_Mouse3 and vc <= 80 + Y1_Mouse3))	or
			(((hc >= 12 + X1_Mouse2 and hc <= 24 + X1_Mouse2) or  (hc >= 30 + X1_Mouse2	and hc <= 36 + X1_Mouse2) 	or  (hc >= 42 + X1_Mouse2 and hc <= 54 + X1_Mouse2))	and (vc >= 80 + Y1_Mouse3 and vc <= 90 + Y1_Mouse3)) or
			(((hc >= 18 + X1_Mouse2 and hc <= 24 + X1_Mouse2) or  (hc >= 42 + X1_Mouse2	and hc <= 48 + X1_Mouse2)) and	(vc >= 90 + Y1_Mouse3 and vc <= 100 + Y1_Mouse3))	or
			 ((hc >= 30 + X1_Mouse2 and hc <= 36 + X1_Mouse2) and (vc >= 100 + Y1_Mouse3 and vc <= 110 + Y1_Mouse3)))
			and videoON = '1' and juego25 = '0' and juego9 = '1' and P1_23 = 1 and Winner3 = 0) then
			red <= "1111";
			blue <= "0000";
			green <= "1111";
			
		-- Printed mouse graphic 3x3(3,1)
		elsif ((((hc >= 30 + X1_Mouse3 and hc <= 36 + X1_Mouse3) and (vc >= 10 + Y1_Mouse1	and vc <= 20 + Y1_Mouse1))	or
			(((hc >= 12 + X1_Mouse3 and hc <= 18 + X1_Mouse3) or  (hc >= 30	+ X1_Mouse3	and hc <= 36 + X1_Mouse3)	or  (hc >= 48 + X1_Mouse3 and hc <= 54 + X1_Mouse3))	and (vc >= 20 + Y1_Mouse1 and vc <= 30 + Y1_Mouse1)) or
			(((hc >= 18 + X1_Mouse3 and hc <= 24 + X1_Mouse3) or  (hc >= 42 + X1_Mouse3	and hc <= 48 + X1_Mouse3)) and	(vc >= 30 + Y1_Mouse1 and vc <= 40 + Y1_Mouse1))	or 
			 ((hc >= 12 + X1_Mouse3 and hc <= 54 + X1_Mouse3) and (vc >= 40 + Y1_Mouse1	and vc <  50 + Y1_Mouse1))	or
			(((hc >  6	+ X1_Mouse3 and hc <  18 + X1_Mouse3) or  (hc > 24  + X1_Mouse3	and hc <  42 + X1_Mouse3) 	or  (hc >  48 + X1_Mouse3 and hc <  60 + X1_Mouse3))	and (vc >= 50 + Y1_Mouse1 and vc <= 60 + Y1_Mouse1)) or
			 ((hc >= 12 + X1_Mouse3 and hc <= 54 + X1_Mouse3) and (vc > 60  + Y1_Mouse1	and vc <= 70 + Y1_Mouse1))	or
			(((hc >= 24 + X1_Mouse3 and hc <  30 + X1_Mouse3) or  (hc > 36  + X1_Mouse3	and hc <= 42 + X1_Mouse3)) and	(vc >= 70 + Y1_Mouse1 and vc <= 80 + Y1_Mouse1))	or
			(((hc >= 12 + X1_Mouse3 and hc <= 24 + X1_Mouse3) or  (hc >= 30 + X1_Mouse3	and hc <= 36 + X1_Mouse3) 	or  (hc >= 42 + X1_Mouse3 and hc <= 54 + X1_Mouse3))	and (vc >= 80 + Y1_Mouse1 and vc <= 90 + Y1_Mouse1)) or
			(((hc >= 18 + X1_Mouse3 and hc <= 24 + X1_Mouse3) or  (hc >= 42 + X1_Mouse3	and hc <= 48 + X1_Mouse3)) and	(vc >= 90 + Y1_Mouse1 and vc <= 100 + Y1_Mouse1))	or
			 ((hc >= 30 + X1_Mouse3 and hc <= 36 + X1_Mouse3) and (vc >= 100 + Y1_Mouse1 and vc <= 110 + Y1_Mouse1)))
			and videoON = '1' and juego25 = '0' and juego9 = '1' and P1_31 = 1 and Winner3 = 0) then
			red <= "1111";
			blue <= "0000";
			green <= "1111";
			
		-- Printed mouse graphic 3x3(3,2)
		elsif ((((hc >= 30 + X1_Mouse3 and hc <= 36 + X1_Mouse3) and (vc >= 10 + Y1_Mouse2	and vc <= 20 + Y1_Mouse2))	or
			(((hc >= 12 + X1_Mouse3 and hc <= 18 + X1_Mouse3) or  (hc >= 30	+ X1_Mouse3	and hc <= 36 + X1_Mouse3)	or  (hc >= 48 + X1_Mouse3 and hc <= 54 + X1_Mouse3))	and (vc >= 20 + Y1_Mouse2 and vc <= 30 + Y1_Mouse2)) or
			(((hc >= 18 + X1_Mouse3 and hc <= 24 + X1_Mouse3) or  (hc >= 42 + X1_Mouse3	and hc <= 48 + X1_Mouse3)) and	(vc >= 30 + Y1_Mouse2 and vc <= 40 + Y1_Mouse2))	or 
			 ((hc >= 12 + X1_Mouse3 and hc <= 54 + X1_Mouse3) and (vc >= 40 + Y1_Mouse2	and vc <  50 + Y1_Mouse2))	or
			(((hc >  6	+ X1_Mouse3 and hc <  18 + X1_Mouse3) or  (hc > 24  + X1_Mouse3	and hc <  42 + X1_Mouse3) 	or  (hc >  48 + X1_Mouse3 and hc <  60 + X1_Mouse3))	and (vc >= 50 + Y1_Mouse2 and vc <= 60 + Y1_Mouse2)) or
			 ((hc >= 12 + X1_Mouse3 and hc <= 54 + X1_Mouse3) and (vc > 60  + Y1_Mouse2	and vc <= 70 + Y1_Mouse2))	or
			(((hc >= 24 + X1_Mouse3 and hc <  30 + X1_Mouse3) or  (hc > 36  + X1_Mouse3	and hc <= 42 + X1_Mouse3)) and	(vc >= 70 + Y1_Mouse2 and vc <= 80 + Y1_Mouse2))	or
			(((hc >= 12 + X1_Mouse3 and hc <= 24 + X1_Mouse3) or  (hc >= 30 + X1_Mouse3	and hc <= 36 + X1_Mouse3) 	or  (hc >= 42 + X1_Mouse3 and hc <= 54 + X1_Mouse3))	and (vc >= 80 + Y1_Mouse2 and vc <= 90 + Y1_Mouse2)) or
			(((hc >= 18 + X1_Mouse3 and hc <= 24 + X1_Mouse3) or  (hc >= 42 + X1_Mouse3	and hc <= 48 + X1_Mouse3)) and	(vc >= 90 + Y1_Mouse2 and vc <= 100 + Y1_Mouse2))	or
			 ((hc >= 30 + X1_Mouse3 and hc <= 36 + X1_Mouse3) and (vc >= 100 + Y1_Mouse2 and vc <= 110 + Y1_Mouse2)))
			and videoON = '1' and juego25 = '0' and juego9 = '1' and P1_32 = 1 and Winner3 = 0) then
			red <= "1111";
			blue <= "0000";
			green <= "1111";
			
		-- Printed mouse graphic 3x3(3,3)
		elsif ((((hc >= 30 + X1_Mouse3 and hc <= 36 + X1_Mouse3) and (vc >= 10 + Y1_Mouse3	and vc <= 20 + Y1_Mouse3))	or
			(((hc >= 12 + X1_Mouse3 and hc <= 18 + X1_Mouse3) or  (hc >= 30	+ X1_Mouse3	and hc <= 36 + X1_Mouse3)	or  (hc >= 48 + X1_Mouse3 and hc <= 54 + X1_Mouse3))	and (vc >= 20 + Y1_Mouse3 and vc <= 30 + Y1_Mouse3)) or
			(((hc >= 18 + X1_Mouse3 and hc <= 24 + X1_Mouse3) or  (hc >= 42 + X1_Mouse3	and hc <= 48 + X1_Mouse3)) and	(vc >= 30 + Y1_Mouse3 and vc <= 40 + Y1_Mouse3))	or 
			 ((hc >= 12 + X1_Mouse3 and hc <= 54 + X1_Mouse3) and (vc >= 40 + Y1_Mouse3	and vc <  50 + Y1_Mouse3))	or
			(((hc >  6	+ X1_Mouse3 and hc <  18 + X1_Mouse3) or  (hc > 24  + X1_Mouse3	and hc <  42 + X1_Mouse3) 	or  (hc >  48 + X1_Mouse3 and hc <  60 + X1_Mouse3))	and (vc >= 50 + Y1_Mouse3 and vc <= 60 + Y1_Mouse3)) or
			 ((hc >= 12 + X1_Mouse3 and hc <= 54 + X1_Mouse3) and (vc > 60  + Y1_Mouse3	and vc <= 70 + Y1_Mouse3))	or
			(((hc >= 24 + X1_Mouse3 and hc <  30 + X1_Mouse3) or  (hc > 36  + X1_Mouse3	and hc <= 42 + X1_Mouse3)) and	(vc >= 70 + Y1_Mouse3 and vc <= 80 + Y1_Mouse3))	or
			(((hc >= 12 + X1_Mouse3 and hc <= 24 + X1_Mouse3) or  (hc >= 30 + X1_Mouse3	and hc <= 36 + X1_Mouse3) 	or  (hc >= 42 + X1_Mouse3 and hc <= 54 + X1_Mouse3))	and (vc >= 80 + Y1_Mouse3 and vc <= 90 + Y1_Mouse3)) or
			(((hc >= 18 + X1_Mouse3 and hc <= 24 + X1_Mouse3) or  (hc >= 42 + X1_Mouse3	and hc <= 48 + X1_Mouse3)) and	(vc >= 90 + Y1_Mouse3 and vc <= 100 + Y1_Mouse3))	or
			 ((hc >= 30 + X1_Mouse3 and hc <= 36 + X1_Mouse3) and (vc >= 100 + Y1_Mouse3 and vc <= 110 + Y1_Mouse3)))
			and videoON = '1' and juego25 = '0' and juego9 = '1' and P1_33 = 1 and Winner3 = 0) then
			red <= "1111";
			blue <= "0000";
			green <= "1111";
			
		-- Printed cat graphic 3x3(1,1)	
		elsif((((hc >= 33 + X1_Cat1 and hc <= 39 + X1_Cat1) and (vc >= 10 + Y1_Cat1 and vc <= 20 + Y1_Cat1)) or
			(((hc >= 15 + X1_Cat1 and hc <= 21 + X1_Cat1) or  (hc >= 33 + X1_Cat1 and hc <= 39 + X1_Cat1) 	or  (hc >= 51 + X1_Cat1 and hc <= 57 + X1_Cat1)) and (vc >= 20 + Y1_Cat1 and vc <  30 + Y1_Cat1))  	or
			(((hc >= 21 + X1_Cat1 and hc <  33 + X1_Cat1) or  (hc >  39 + X1_Cat1 and hc <= 51 + X1_Cat1))	and (vc >= 30 + Y1_Cat1 and vc <= 40 + Y1_Cat1)) or 
			(((hc >  3  + X1_Cat1 and hc <  9  + X1_Cat1) or  (hc >  15 + X1_Cat1 and hc <  57 + X1_Cat1) 	or  (hc >  63 + X1_Cat1 and hc <  69 + X1_Cat1)) and (vc >  40 + Y1_Cat1 and vc <  50 + Y1_Cat1)) 	or
			(((hc >  3  + X1_Cat1 and hc <  21 + X1_Cat1) or  (hc >  27 + X1_Cat1 and hc <  45 + X1_Cat1) 	or  (hc >  51 + X1_Cat1 and hc <  69 + X1_Cat1)) and (vc >= 50 + Y1_Cat1 and vc <= 60 + Y1_Cat1))	or
			 ((hc >= 15 + X1_Cat1 and hc <= 57 + X1_Cat1) and (vc >  60 + Y1_Cat1 and vc <  70 + Y1_Cat1))	or
			(((hc >  9  + X1_Cat1 and hc <  15 + X1_Cat1) or  (hc >= 21 + X1_Cat1 and hc <  27 + X1_Cat1)	or	(hc >= 33 + X1_Cat1 and hc <  39 + X1_Cat1)	 or	 (hc >= 45 + X1_Cat1 and hc <  51 + X1_Cat1)	or	(hc > 57 + X1_Cat1 and hc < 63 + X1_Cat1))	and (vc >= 70 + Y1_Cat1 and vc <= 80 + Y1_Cat1)) or
			(((hc >  9  + X1_Cat1 and hc <  15 + X1_Cat1) or  (hc >  57 + X1_Cat1 and hc <  63 + X1_Cat1))  and (vc >  80 + Y1_Cat1 and vc <  90 + Y1_Cat1)) or
			(((hc >= 15 + X1_Cat1 and hc <= 21 + X1_Cat1) or  (hc >= 51 + X1_Cat1 and hc <= 57 + X1_Cat1)) 	and (vc >= 90 + Y1_Cat1 and vc < 100 + Y1_Cat1)))
			and videoON = '1' and juego25 = '0' and juego9 = '1' and P2_11 = 1 and Winner3 = 0) then
			red <= "0000";
			blue <= "0100";
			green <= "1110"; 
			
		-- Printed cat graphic 3x3(1,2)	
		elsif((((hc >= 33 + X1_Cat1 and hc <= 39 + X1_Cat1) and (vc >= 10 + Y1_Cat2 and vc <= 20 + Y1_Cat2)) or
			(((hc >= 15 + X1_Cat1 and hc <= 21 + X1_Cat1) or  (hc >= 33 + X1_Cat1 and hc <= 39 + X1_Cat1) 	or  (hc >= 51 + X1_Cat1 and hc <= 57 + X1_Cat1)) and (vc >= 20 + Y1_Cat2 and vc <  30 + Y1_Cat2))  	or
			(((hc >= 21 + X1_Cat1 and hc <  33 + X1_Cat1) or  (hc >  39 + X1_Cat1 and hc <= 51 + X1_Cat1))	and (vc >= 30 + Y1_Cat2 and vc <= 40 + Y1_Cat2)) or 
			(((hc >  3  + X1_Cat1 and hc <  9  + X1_Cat1) or  (hc >  15 + X1_Cat1 and hc <  57 + X1_Cat1) 	or  (hc >  63 + X1_Cat1 and hc <  69 + X1_Cat1)) and (vc >  40 + Y1_Cat2 and vc <  50 + Y1_Cat2)) 	or
			(((hc >  3  + X1_Cat1 and hc <  21 + X1_Cat1) or  (hc >  27 + X1_Cat1 and hc <  45 + X1_Cat1) 	or  (hc >  51 + X1_Cat1 and hc <  69 + X1_Cat1)) and (vc >= 50 + Y1_Cat2 and vc <= 60 + Y1_Cat2))	or
			 ((hc >= 15 + X1_Cat1 and hc <= 57 + X1_Cat1) and (vc >  60 + Y1_Cat2 and vc <  70 + Y1_Cat2))	or
			(((hc >  9  + X1_Cat1 and hc <  15 + X1_Cat1) or  (hc >= 21 + X1_Cat1 and hc <  27 + X1_Cat1)	or	(hc >= 33 + X1_Cat1 and hc <  39 + X1_Cat1)	 or	 (hc >= 45 + X1_Cat1 and hc <  51 + X1_Cat1)	or	(hc > 57 + X1_Cat1 and hc < 63 + X1_Cat1))	and (vc >= 70 + Y1_Cat2 and vc <= 80 + Y1_Cat2)) or
			(((hc >  9  + X1_Cat1 and hc <  15 + X1_Cat1) or  (hc >  57 + X1_Cat1 and hc <  63 + X1_Cat1))  and (vc >  80 + Y1_Cat2 and vc <  90 + Y1_Cat2)) or
			(((hc >= 15 + X1_Cat1 and hc <= 21 + X1_Cat1) or  (hc >= 51 + X1_Cat1 and hc <= 57 + X1_Cat1)) 	and (vc >= 90 + Y1_Cat2 and vc < 100 + Y1_Cat2)))
			and videoON = '1' and juego25 = '0' and juego9 = '1' and P2_12 = 1 and Winner3 = 0) then
			red <= "0000";
			blue <= "0100";
			green <= "1110"; 
			
		-- Printed cat graphic 3x3(1,3)	
		elsif((((hc >= 33 + X1_Cat1 and hc <= 39 + X1_Cat1) and (vc >= 10 + Y1_Cat3 and vc <= 20 + Y1_Cat3)) or
			(((hc >= 15 + X1_Cat1 and hc <= 21 + X1_Cat1) or  (hc >= 33 + X1_Cat1 and hc <= 39 + X1_Cat1) 	or  (hc >= 51 + X1_Cat1 and hc <= 57 + X1_Cat1)) and (vc >= 20 + Y1_Cat3 and vc <  30 + Y1_Cat3))  	or
			(((hc >= 21 + X1_Cat1 and hc <  33 + X1_Cat1) or  (hc >  39 + X1_Cat1 and hc <= 51 + X1_Cat1))	and (vc >= 30 + Y1_Cat3 and vc <= 40 + Y1_Cat3)) or 
			(((hc >  3  + X1_Cat1 and hc <  9  + X1_Cat1) or  (hc >  15 + X1_Cat1 and hc <  57 + X1_Cat1) 	or  (hc >  63 + X1_Cat1 and hc <  69 + X1_Cat1)) and (vc >  40 + Y1_Cat3 and vc <  50 + Y1_Cat3)) 	or
			(((hc >  3  + X1_Cat1 and hc <  21 + X1_Cat1) or  (hc >  27 + X1_Cat1 and hc <  45 + X1_Cat1) 	or  (hc >  51 + X1_Cat1 and hc <  69 + X1_Cat1)) and (vc >= 50 + Y1_Cat3 and vc <= 60 + Y1_Cat3))	or
			 ((hc >= 15 + X1_Cat1 and hc <= 57 + X1_Cat1) and (vc >  60 + Y1_Cat3 and vc <  70 + Y1_Cat3))	or
			(((hc >  9  + X1_Cat1 and hc <  15 + X1_Cat1) or  (hc >= 21 + X1_Cat1 and hc <  27 + X1_Cat1)	or	(hc >= 33 + X1_Cat1 and hc <  39 + X1_Cat1)	 or	 (hc >= 45 + X1_Cat1 and hc <  51 + X1_Cat1)	or	(hc > 57 + X1_Cat1 and hc < 63 + X1_Cat1))	and (vc >= 70 + Y1_Cat3 and vc <= 80 + Y1_Cat3)) or
			(((hc >  9  + X1_Cat1 and hc <  15 + X1_Cat1) or  (hc >  57 + X1_Cat1 and hc <  63 + X1_Cat1))  and (vc >  80 + Y1_Cat3 and vc <  90 + Y1_Cat3)) or
			(((hc >= 15 + X1_Cat1 and hc <= 21 + X1_Cat1) or  (hc >= 51 + X1_Cat1 and hc <= 57 + X1_Cat1)) 	and (vc >= 90 + Y1_Cat3 and vc < 100 + Y1_Cat3)))
			and videoON = '1' and juego25 = '0' and juego9 = '1' and P2_13 = 1 and Winner3 = 0) then
			red <= "0000";
			blue <= "0100";
			green <= "1110"; 
			
		-- Printed cat graphic 3x3(2,1)	
		elsif((((hc >= 33 + X1_Cat2 and hc <= 39 + X1_Cat2) and (vc >= 10 + Y1_Cat1 and vc <= 20 + Y1_Cat1)) or
			(((hc >= 15 + X1_Cat2 and hc <= 21 + X1_Cat2) or  (hc >= 33 + X1_Cat2 and hc <= 39 + X1_Cat2) 	or  (hc >= 51 + X1_Cat2 and hc <= 57 + X1_Cat2)) and (vc >= 20 + Y1_Cat1 and vc <  30 + Y1_Cat1))  	or
			(((hc >= 21 + X1_Cat2 and hc <  33 + X1_Cat2) or  (hc >  39 + X1_Cat2 and hc <= 51 + X1_Cat2))	and (vc >= 30 + Y1_Cat1 and vc <= 40 + Y1_Cat1)) or 
			(((hc >  3  + X1_Cat2 and hc <  9  + X1_Cat2) or  (hc >  15 + X1_Cat2 and hc <  57 + X1_Cat2) 	or  (hc >  63 + X1_Cat2 and hc <  69 + X1_Cat2)) and (vc >  40 + Y1_Cat1 and vc <  50 + Y1_Cat1)) 	or
			(((hc >  3  + X1_Cat2 and hc <  21 + X1_Cat2) or  (hc >  27 + X1_Cat2 and hc <  45 + X1_Cat2) 	or  (hc >  51 + X1_Cat2 and hc <  69 + X1_Cat2)) and (vc >= 50 + Y1_Cat1 and vc <= 60 + Y1_Cat1))	or
			 ((hc >= 15 + X1_Cat2 and hc <= 57 + X1_Cat2) and (vc >  60 + Y1_Cat1 and vc <  70 + Y1_Cat1))	or
			(((hc >  9  + X1_Cat2 and hc <  15 + X1_Cat2) or  (hc >= 21 + X1_Cat2 and hc <  27 + X1_Cat2)	or	(hc >= 33 + X1_Cat2 and hc <  39 + X1_Cat2)	 or	 (hc >= 45 + X1_Cat2 and hc <  51 + X1_Cat2)	or	(hc > 57 + X1_Cat2 and hc < 63 + X1_Cat2))	and (vc >= 70 + Y1_Cat1 and vc <= 80 + Y1_Cat1)) or
			(((hc >  9  + X1_Cat2 and hc <  15 + X1_Cat2) or  (hc >  57 + X1_Cat2 and hc <  63 + X1_Cat2))  and (vc >  80 + Y1_Cat1 and vc <  90 + Y1_Cat1)) or
			(((hc >= 15 + X1_Cat2 and hc <= 21 + X1_Cat2) or  (hc >= 51 + X1_Cat2 and hc <= 57 + X1_Cat2)) 	and (vc >= 90 + Y1_Cat1 and vc < 100 + Y1_Cat1)))
			and videoON = '1' and juego25 = '0' and juego9 = '1' and P2_21 = 1 and Winner3 = 0) then
			red <= "0000";
			blue <= "0100";
			green <= "1110"; 
			
		-- Printed cat graphic 3x3(2,2)	
		elsif((((hc >= 33 + X1_Cat2 and hc <= 39 + X1_Cat2) and (vc >= 10 + Y1_Cat2 and vc <= 20 + Y1_Cat2)) or
			(((hc >= 15 + X1_Cat2 and hc <= 21 + X1_Cat2) or  (hc >= 33 + X1_Cat2 and hc <= 39 + X1_Cat2) 	or  (hc >= 51 + X1_Cat2 and hc <= 57 + X1_Cat2)) and (vc >= 20 + Y1_Cat2 and vc <  30 + Y1_Cat2))  	or
			(((hc >= 21 + X1_Cat2 and hc <  33 + X1_Cat2) or  (hc >  39 + X1_Cat2 and hc <= 51 + X1_Cat2))	and (vc >= 30 + Y1_Cat2 and vc <= 40 + Y1_Cat2)) or 
			(((hc >  3  + X1_Cat2 and hc <  9  + X1_Cat2) or  (hc >  15 + X1_Cat2 and hc <  57 + X1_Cat2) 	or  (hc >  63 + X1_Cat2 and hc <  69 + X1_Cat2)) and (vc >  40 + Y1_Cat2 and vc <  50 + Y1_Cat2)) 	or
			(((hc >  3  + X1_Cat2 and hc <  21 + X1_Cat2) or  (hc >  27 + X1_Cat2 and hc <  45 + X1_Cat2) 	or  (hc >  51 + X1_Cat2 and hc <  69 + X1_Cat2)) and (vc >= 50 + Y1_Cat2 and vc <= 60 + Y1_Cat2))	or
			 ((hc >= 15 + X1_Cat2 and hc <= 57 + X1_Cat2) and (vc >  60 + Y1_Cat2 and vc <  70 + Y1_Cat2))	or
			(((hc >  9  + X1_Cat2 and hc <  15 + X1_Cat2) or  (hc >= 21 + X1_Cat2 and hc <  27 + X1_Cat2)	or	(hc >= 33 + X1_Cat2 and hc <  39 + X1_Cat2)	 or	 (hc >= 45 + X1_Cat2 and hc <  51 + X1_Cat2)	or	(hc > 57 + X1_Cat2 and hc < 63 + X1_Cat2))	and (vc >= 70 + Y1_Cat2 and vc <= 80 + Y1_Cat2)) or
			(((hc >  9  + X1_Cat2 and hc <  15 + X1_Cat2) or  (hc >  57 + X1_Cat2 and hc <  63 + X1_Cat2))  and (vc >  80 + Y1_Cat2 and vc <  90 + Y1_Cat2)) or
			(((hc >= 15 + X1_Cat2 and hc <= 21 + X1_Cat2) or  (hc >= 51 + X1_Cat2 and hc <= 57 + X1_Cat2)) 	and (vc >= 90 + Y1_Cat2 and vc < 100 + Y1_Cat2)))
			and videoON = '1' and juego25 = '0' and juego9 = '1' and P2_22 = 1 and Winner3 = 0) then
			red <= "0000";
			blue <= "0100";
			green <= "1110"; 
			
		-- Printed cat graphic 3x3(2,3)	
		elsif((((hc >= 33 + X1_Cat2 and hc <= 39 + X1_Cat2) and (vc >= 10 + Y1_Cat3 and vc <= 20 + Y1_Cat3)) or
			(((hc >= 15 + X1_Cat2 and hc <= 21 + X1_Cat2) or  (hc >= 33 + X1_Cat2 and hc <= 39 + X1_Cat2) 	or  (hc >= 51 + X1_Cat2 and hc <= 57 + X1_Cat2)) and (vc >= 20 + Y1_Cat3 and vc <  30 + Y1_Cat3))  	or
			(((hc >= 21 + X1_Cat2 and hc <  33 + X1_Cat2) or  (hc >  39 + X1_Cat2 and hc <= 51 + X1_Cat2))	and (vc >= 30 + Y1_Cat3 and vc <= 40 + Y1_Cat3)) or 
			(((hc >  3  + X1_Cat2 and hc <  9  + X1_Cat2) or  (hc >  15 + X1_Cat2 and hc <  57 + X1_Cat2) 	or  (hc >  63 + X1_Cat2 and hc <  69 + X1_Cat2)) and (vc >  40 + Y1_Cat3 and vc <  50 + Y1_Cat3)) 	or
			(((hc >  3  + X1_Cat2 and hc <  21 + X1_Cat2) or  (hc >  27 + X1_Cat2 and hc <  45 + X1_Cat2) 	or  (hc >  51 + X1_Cat2 and hc <  69 + X1_Cat2)) and (vc >= 50 + Y1_Cat3 and vc <= 60 + Y1_Cat3))	or
			 ((hc >= 15 + X1_Cat2 and hc <= 57 + X1_Cat2) and (vc >  60 + Y1_Cat3 and vc <  70 + Y1_Cat3))	or
			(((hc >  9  + X1_Cat2 and hc <  15 + X1_Cat2) or  (hc >= 21 + X1_Cat2 and hc <  27 + X1_Cat2)	or	(hc >= 33 + X1_Cat2 and hc <  39 + X1_Cat2)	 or	 (hc >= 45 + X1_Cat2 and hc <  51 + X1_Cat2)	or	(hc > 57 + X1_Cat2 and hc < 63 + X1_Cat2))	and (vc >= 70 + Y1_Cat3 and vc <= 80 + Y1_Cat3)) or
			(((hc >  9  + X1_Cat2 and hc <  15 + X1_Cat2) or  (hc >  57 + X1_Cat2 and hc <  63 + X1_Cat2))  and (vc >  80 + Y1_Cat3 and vc <  90 + Y1_Cat3)) or
			(((hc >= 15 + X1_Cat2 and hc <= 21 + X1_Cat2) or  (hc >= 51 + X1_Cat2 and hc <= 57 + X1_Cat2)) 	and (vc >= 90 + Y1_Cat3 and vc < 100 + Y1_Cat3)))
			and videoON = '1' and juego25 = '0' and juego9 = '1' and P2_23 = 1 and Winner3 = 0) then
			red <= "0000";
			blue <= "0100";
			green <= "1110"; 
			
		-- Printed cat graphic 3x3(3,1)	
		elsif((((hc >= 33 + X1_Cat3 and hc <= 39 + X1_Cat3) and (vc >= 10 + Y1_Cat1 and vc <= 20 + Y1_Cat1)) or
			(((hc >= 15 + X1_Cat3 and hc <= 21 + X1_Cat3) or  (hc >= 33 + X1_Cat3 and hc <= 39 + X1_Cat3) 	or  (hc >= 51 + X1_Cat3 and hc <= 57 + X1_Cat3)) and (vc >= 20 + Y1_Cat1 and vc <  30 + Y1_Cat1))  	or
			(((hc >= 21 + X1_Cat3 and hc <  33 + X1_Cat3) or  (hc >  39 + X1_Cat3 and hc <= 51 + X1_Cat3))	and (vc >= 30 + Y1_Cat1 and vc <= 40 + Y1_Cat1)) or 
			(((hc >  3  + X1_Cat3 and hc <  9  + X1_Cat3) or  (hc >  15 + X1_Cat3 and hc <  57 + X1_Cat3) 	or  (hc >  63 + X1_Cat3 and hc <  69 + X1_Cat3)) and (vc >  40 + Y1_Cat1 and vc <  50 + Y1_Cat1)) 	or
			(((hc >  3  + X1_Cat3 and hc <  21 + X1_Cat3) or  (hc >  27 + X1_Cat3 and hc <  45 + X1_Cat3) 	or  (hc >  51 + X1_Cat3 and hc <  69 + X1_Cat3)) and (vc >= 50 + Y1_Cat1 and vc <= 60 + Y1_Cat1))	or
			 ((hc >= 15 + X1_Cat3 and hc <= 57 + X1_Cat3) and (vc >  60 + Y1_Cat1 and vc <  70 + Y1_Cat1))	or
			(((hc >  9  + X1_Cat3 and hc <  15 + X1_Cat3) or  (hc >= 21 + X1_Cat3 and hc <  27 + X1_Cat3)	or	(hc >= 33 + X1_Cat3 and hc <  39 + X1_Cat3)	 or	 (hc >= 45 + X1_Cat3 and hc <  51 + X1_Cat3)	or	(hc > 57 + X1_Cat3 and hc < 63 + X1_Cat3))	and (vc >= 70 + Y1_Cat1 and vc <= 80 + Y1_Cat1)) or
			(((hc >  9  + X1_Cat3 and hc <  15 + X1_Cat3) or  (hc >  57 + X1_Cat3 and hc <  63 + X1_Cat3))  and (vc >  80 + Y1_Cat1 and vc <  90 + Y1_Cat1)) or
			(((hc >= 15 + X1_Cat3 and hc <= 21 + X1_Cat3) or  (hc >= 51 + X1_Cat3 and hc <= 57 + X1_Cat3)) 	and (vc >= 90 + Y1_Cat1 and vc < 100 + Y1_Cat1)))
			and videoON = '1' and juego25 = '0' and juego9 = '1' and P2_31 = 1 and Winner3 = 0) then
			red <= "0000";
			blue <= "0100";
			green <= "1110"; 
			
		-- Printed cat graphic 3x3(3,2)	
		elsif((((hc >= 33 + X1_Cat3 and hc <= 39 + X1_Cat3) and (vc >= 10 + Y1_Cat2 and vc <= 20 + Y1_Cat2)) or
			(((hc >= 15 + X1_Cat3 and hc <= 21 + X1_Cat3) or  (hc >= 33 + X1_Cat3 and hc <= 39 + X1_Cat3) 	or  (hc >= 51 + X1_Cat3 and hc <= 57 + X1_Cat3)) and (vc >= 20 + Y1_Cat2 and vc <  30 + Y1_Cat2))  	or
			(((hc >= 21 + X1_Cat3 and hc <  33 + X1_Cat3) or  (hc >  39 + X1_Cat3 and hc <= 51 + X1_Cat3))	and (vc >= 30 + Y1_Cat2 and vc <= 40 + Y1_Cat2)) or 
			(((hc >  3  + X1_Cat3 and hc <  9  + X1_Cat3) or  (hc >  15 + X1_Cat3 and hc <  57 + X1_Cat3) 	or  (hc >  63 + X1_Cat3 and hc <  69 + X1_Cat3)) and (vc >  40 + Y1_Cat2 and vc <  50 + Y1_Cat2)) 	or
			(((hc >  3  + X1_Cat3 and hc <  21 + X1_Cat3) or  (hc >  27 + X1_Cat3 and hc <  45 + X1_Cat3) 	or  (hc >  51 + X1_Cat3 and hc <  69 + X1_Cat3)) and (vc >= 50 + Y1_Cat2 and vc <= 60 + Y1_Cat2))	or
			 ((hc >= 15 + X1_Cat3 and hc <= 57 + X1_Cat3) and (vc >  60 + Y1_Cat2 and vc <  70 + Y1_Cat2))	or
			(((hc >  9  + X1_Cat3 and hc <  15 + X1_Cat3) or  (hc >= 21 + X1_Cat3 and hc <  27 + X1_Cat3)	or	(hc >= 33 + X1_Cat3 and hc <  39 + X1_Cat3)	 or	 (hc >= 45 + X1_Cat3 and hc <  51 + X1_Cat3)	or	(hc > 57 + X1_Cat3 and hc < 63 + X1_Cat3))	and (vc >= 70 + Y1_Cat2 and vc <= 80 + Y1_Cat2)) or
			(((hc >  9  + X1_Cat3 and hc <  15 + X1_Cat3) or  (hc >  57 + X1_Cat3 and hc <  63 + X1_Cat3))  and (vc >  80 + Y1_Cat2 and vc <  90 + Y1_Cat2)) or
			(((hc >= 15 + X1_Cat3 and hc <= 21 + X1_Cat3) or  (hc >= 51 + X1_Cat3 and hc <= 57 + X1_Cat3)) 	and (vc >= 90 + Y1_Cat2 and vc < 100 + Y1_Cat2)))
			and videoON = '1' and juego25 = '0' and juego9 = '1' and P2_32 = 1 and Winner3 = 0) then
			red <= "0000";
			blue <= "0100";
			green <= "1110"; 
			
		-- Printed cat graphic 3x3(3,3)	
		elsif((((hc >= 33 + X1_Cat3 and hc <= 39 + X1_Cat3) and (vc >= 10 + Y1_Cat3 and vc <= 20 + Y1_Cat3)) or
			(((hc >= 15 + X1_Cat3 and hc <= 21 + X1_Cat3) or  (hc >= 33 + X1_Cat3 and hc <= 39 + X1_Cat3) 	or  (hc >= 51 + X1_Cat3 and hc <= 57 + X1_Cat3)) and (vc >= 20 + Y1_Cat3 and vc <  30 + Y1_Cat3))  	or
			(((hc >= 21 + X1_Cat3 and hc <  33 + X1_Cat3) or  (hc >  39 + X1_Cat3 and hc <= 51 + X1_Cat3))	and (vc >= 30 + Y1_Cat3 and vc <= 40 + Y1_Cat3)) or 
			(((hc >  3  + X1_Cat3 and hc <  9  + X1_Cat3) or  (hc >  15 + X1_Cat3 and hc <  57 + X1_Cat3) 	or  (hc >  63 + X1_Cat3 and hc <  69 + X1_Cat3)) and (vc >  40 + Y1_Cat3 and vc <  50 + Y1_Cat3)) 	or
			(((hc >  3  + X1_Cat3 and hc <  21 + X1_Cat3) or  (hc >  27 + X1_Cat3 and hc <  45 + X1_Cat3) 	or  (hc >  51 + X1_Cat3 and hc <  69 + X1_Cat3)) and (vc >= 50 + Y1_Cat3 and vc <= 60 + Y1_Cat3))	or
			 ((hc >= 15 + X1_Cat3 and hc <= 57 + X1_Cat3) and (vc >  60 + Y1_Cat3 and vc <  70 + Y1_Cat3))	or
			(((hc >  9  + X1_Cat3 and hc <  15 + X1_Cat3) or  (hc >= 21 + X1_Cat3 and hc <  27 + X1_Cat3)	or	(hc >= 33 + X1_Cat3 and hc <  39 + X1_Cat3)	 or	 (hc >= 45 + X1_Cat3 and hc <  51 + X1_Cat3)	or	(hc > 57 + X1_Cat3 and hc < 63 + X1_Cat3))	and (vc >= 70 + Y1_Cat3 and vc <= 80 + Y1_Cat3)) or
			(((hc >  9  + X1_Cat3 and hc <  15 + X1_Cat3) or  (hc >  57 + X1_Cat3 and hc <  63 + X1_Cat3))  and (vc >  80 + Y1_Cat3 and vc <  90 + Y1_Cat3)) or
			(((hc >= 15 + X1_Cat3 and hc <= 21 + X1_Cat3) or  (hc >= 51 + X1_Cat3 and hc <= 57 + X1_Cat3)) 	and (vc >= 90 + Y1_Cat3 and vc < 100 + Y1_Cat3)))
			and videoON = '1' and juego25 = '0' and juego9 = '1' and P2_33 = 1 and Winner3 = 0) then
			red <= "0000";
			blue <= "0100";
			green <= "1110"; 

		-- "Choose" Message 5x5
		elsif(((((hc >= 206 - 30 and hc <= 224 - 30) or (hc >= 236 - 30 and hc <= 242 - 30)) and (vc >= 110 and vc <= 120)) or
			(((hc >= 200 - 30 and hc <= 206 - 30) or  (hc >= 224 - 30 and hc <= 230 - 30)   or  (hc >= 236 - 30 and hc <= 242 - 30))	and (vc >= 120 and vc <= 130))  or
			(((hc >= 200 - 30 and hc <= 206 - 30) or  (hc >= 236 - 30 and hc <= 242 - 30)	or	(hc >= 248 - 30 and hc <= 254 - 30)	or	(hc >= 272 - 30 and hc <= 284 - 30)	or	(hc >= 302 - 30 and hc <= 314 - 30)	or	(hc >= 332 - 30 and hc <= 350 - 30)	or	(hc >= 362 - 30 and hc <= 374 - 30)) 	and (vc >= 130 and vc <= 140))  or 
			(((hc >= 200 - 30 and hc <= 206 - 30) or  (hc >= 236 - 30 and hc <= 248 - 30)	or	(hc >= 254 - 30 and hc <= 260 - 30)	or	(hc >= 266 - 30 and hc <= 272 - 30)	or	(hc >= 284 - 30 and hc <= 290 - 30)	or	(hc >= 296 - 30 and hc <= 302 - 30)	or	(hc >= 314 - 30 and hc <= 320 - 30)	or	(hc >= 326 - 30 and hc <= 332 - 30)	or	(hc >= 356 - 30 and hc <= 362 - 30)		or	(hc >= 374 - 30 and hc <= 380 - 30)) 	and (vc >= 140 and vc <= 150))  or 
			(((hc >= 200 - 30 and hc <= 206 - 30) or  (hc >= 236 - 30 and hc <= 242 - 30)	or	(hc >= 254 - 30 and hc <= 260 - 30)	or	(hc >= 266 - 30 and hc <= 272 - 30)	or	(hc >= 284 - 30 and hc <= 290 - 30)	or	(hc >= 296 - 30 and hc <= 302 - 30)	or	(hc >= 314 - 30 and hc <= 320 - 30)	or	(hc >= 332 - 30 and hc <= 344 - 30)	or	(hc >= 356 - 30 and hc <= 380 - 30)) 	and (vc >= 150 and vc <= 160))  or 
			(((hc >= 200 - 30 and hc <= 206 - 30) or  (hc >= 236 - 30 and hc <= 242 - 30)	or	(hc >= 254 - 30 and hc <= 260 - 30)	or	(hc >= 266 - 30 and hc <= 272 - 30)	or	(hc >= 284 - 30 and hc <= 290 - 30)	or	(hc >= 296 - 30 and hc <= 302 - 30)	or	(hc >= 314 - 30 and hc <= 320 - 30)	or	(hc >= 344 - 30 and hc <= 350 - 30)	or	(hc >= 356 - 30 and hc <= 362 - 30)) 	and (vc >= 160 and vc <= 170))  or 
			(((hc >= 200 - 30 and hc <= 206 - 30) or  (hc >= 224 - 30 and hc <= 230 - 30)	or	(hc >= 236 - 30 and hc <= 242 - 30)	or	(hc >= 254 - 30 and hc <= 260 - 30)	or	(hc >= 266 - 30 and hc <= 272 - 30)	or	(hc >= 284 - 30 and hc <= 290 - 30)	or	(hc >= 296 - 30 and hc <= 302 - 30)	or	(hc >= 314 - 30 and hc <= 320 - 30)	or	(hc >= 344 - 30 and hc <= 350 - 30)		or	(hc >= 356 - 30 and hc <= 362 - 30)	or	(hc >= 374 - 30 and hc <= 380 - 30)) 	and (vc >= 170 and vc <= 180))  or 
			(((hc >= 206 - 30 and hc <= 224 - 30) or  (hc >= 236 - 30 and hc <= 242 - 30)	or	(hc >= 254 - 30 and hc <= 260 - 30)	or	(hc >= 272 - 30 and hc <= 284 - 30)	or	(hc >= 302 - 30 and hc <= 314 - 30)	or	(hc >= 326 - 30 and hc <= 344 - 30)	or	(hc >= 362 - 30 and hc <= 380 - 30)) 	and (vc >= 180 and vc <= 190)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and Winner = 0) then
			red <= "1111";
			blue <= "1111";
			green <= "1111";
			
		-- "a space" Message 5x5
		elsif(((((hc >= 200 - 30 and hc <= 218 - 30) or (hc >= 248 - 30 and hc <= 266 - 30) or  (hc >= 272 - 30 and hc <= 278 - 30) or  (hc >= 284 - 30 and hc <= 290 - 30) or  (hc >= 302 - 30 and hc <= 320 - 30)	or 	(hc >= 338 - 30 and hc <= 350 - 30)	or	(hc >= 368 - 30 and hc <= 380 - 30))  and	(vc >= 220 and vc <= 230))  or
			(((hc >= 218 - 30 and hc <= 224 - 30) or  (hc >= 242 - 30 and hc <= 248 - 30)   or  (hc >= 272 - 30 and hc <= 284 - 30) or  (hc >= 290 - 30 and hc <= 296 - 30) or  (hc >= 320 - 30 and hc <= 326 - 30) or  (hc >= 332 - 30 and hc <= 338 - 30) or  (hc >= 350 - 30 and hc <= 356 - 30)   or	(hc >= 362 - 30 and hc <= 368 - 30) or  (hc >= 380 - 30 and hc <= 386 - 30))	and (vc >= 230 and vc <= 240))  or
			(((hc >= 206 - 30 and hc <= 224 - 30) or  (hc >= 248 - 30 and hc <= 260 - 30)	or	(hc >= 272 - 30 and hc <= 278 - 30)	or	(hc >= 290 - 30 and hc <= 296 - 30)	or	(hc >= 308 - 30 and hc <= 326 - 30)	or	(hc >= 332 - 30 and hc <= 338 - 30)	or	(hc >= 362 - 30 and hc <= 386 - 30))  and	(vc >= 240 and vc <= 250))  or 
			(((hc >= 200 - 30 and hc <= 206 - 30) or  (hc >= 218 - 30 and hc <= 224 - 30)	or	(hc >= 260 - 30 and hc <= 266 - 30)	or	(hc >= 272 - 30 and hc <= 278 - 30)	or	(hc >= 290 - 30 and hc <= 296 - 30)	or	(hc >= 302 - 30 and hc <= 308 - 30)	or	(hc >= 320 - 30 and hc <= 326 - 30)	  or	(hc >= 332 - 30 and hc <= 338 - 30)	or	(hc >= 362 - 30 and hc <= 368 - 30))	and (vc >= 250 and vc <= 260))  or 
			(((hc >= 200 - 30 and hc <= 206 - 30) or  (hc >= 218 - 30 and hc <= 224 - 30)	or	(hc >= 260 - 30 and hc <= 266 - 30)	or	(hc >= 272 - 30 and hc <= 278 - 30)	or	(hc >= 290 - 30 and hc <= 296 - 30)	or	(hc >= 302 - 30 and hc <= 308 - 30)	or	(hc >= 320 - 30 and hc <= 326 - 30)	  or	(hc >= 332 - 30 and hc <= 338 - 30)	or	(hc >= 350 - 30 and hc <= 356 - 30)		or	(hc >= 362 - 30 and hc <= 368 - 30)	or	(hc >= 380 - 30 and hc <= 386 - 30)) 	and (vc >= 260 and vc <= 270))  or 
			(((hc >= 206 - 30 and hc <= 224 - 30) or  (hc >= 242 - 30 and hc <= 260 - 30)	or	(hc >= 272 - 30 and hc <= 290 - 30)	or	(hc >= 308 - 30 and hc <= 326 - 30)	or	(hc >= 338 - 30 and hc <= 350 - 30)	or	(hc >= 368 - 30 and hc <= 386 - 30))and (vc >= 270 and vc <= 280))  or 
			 ((hc >= 272 - 30 and hc <= 278 - 30) and (vc >= 280 - 30 and vc <= 310)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and Winner = 0) then
			red <= "1111";
			blue <= "1111";
			green <= "1111";
			
		-- "Player" Message 5x5
		elsif(((((hc >= 200 - 30 and hc <= 224 - 30) or (hc >= 236 - 30 and hc <= 242 - 30)) and (vc >= 320 and vc <= 330)) or
			(((hc >= 200 - 30 and hc <= 206 - 30) or  (hc >= 224 - 30 and hc <= 230 - 30)   or  (hc >= 236 - 30 and hc <= 242 - 30))	and (vc >= 330 and vc <= 340))  or
			(((hc >= 200 - 30 and hc <= 224 - 30) or  (hc >= 236 - 30 and hc <= 242 - 30)	or	(hc >= 248 - 30 and hc <= 266 - 30)	or	(hc >= 278 - 30 and hc <= 284 - 30)	or	(hc >= 296 - 30 and hc <= 302 - 30)	or	(hc >= 314 - 30 and hc <= 326 - 30)	or	(hc >= 338 - 30 and hc <= 344 - 30)	or	(hc >= 350 - 30 and hc <= 356 - 30)) 	and (vc >= 340 and vc <= 350))  or 
			(((hc >= 200 - 30 and hc <= 206 - 30) or  (hc >= 236 - 30 and hc <= 242 - 30)	or	(hc >= 266 - 30 and hc <= 272 - 30)	or	(hc >= 278 - 30 and hc <= 284 - 30)	or	(hc >= 296 - 30 and hc <= 302 - 30)	or	(hc >= 308 - 30 and hc <= 314 - 30)	or	(hc >= 326 - 30 and hc <= 332 - 30)	or	(hc >= 338 - 30 and hc <= 350 - 30)) 	and (vc >= 350 and vc <= 360))  or 
			(((hc >= 200 - 30 and hc <= 206 - 30) or  (hc >= 236 - 30 and hc <= 242 - 30)	or	(hc >= 254 - 30 and hc <= 272 - 30)	or	(hc >= 278 - 30 and hc <= 284 - 30)	or	(hc >= 296 - 30 and hc <= 302 - 30)	or	(hc >= 308 - 30 and hc <= 332 - 30)	or	(hc >= 338 - 30 and hc <= 344 - 30)) 	and (vc >= 360 and vc <= 370))  or 
			(((hc >= 200 - 30 and hc <= 206 - 30) or  (hc >= 236 - 30 and hc <= 242 - 30)	or	(hc >= 248 - 30 and hc <= 254 - 30)	or	(hc >= 266 - 30 and hc <= 272 - 30)	or	(hc >= 278 - 30 and hc <= 284 - 30)	or	(hc >= 296 - 30 and hc <= 302 - 30)	or	(hc >= 308 - 30 and hc <= 314 - 30)	or	(hc >= 338 - 30 and hc <= 344 - 30)) 	and (vc >= 370 and vc <= 380))  or 
			(((hc >= 200 - 30 and hc <= 206 - 30) or  (hc >= 236 - 30 and hc <= 242 - 30)	or	(hc >= 248 - 30 and hc <= 254 - 30)	or	(hc >= 266 - 30 and hc <= 272 - 30)	or	(hc >= 278 - 30 and hc <= 284 - 30)	or	(hc >= 296 - 30 and hc <= 302 - 30)	or	(hc >= 308 - 30 and hc <= 314 - 30)	or	(hc >= 326 - 30 and hc <= 332 - 30)	or	(hc >= 338 - 30 and hc <= 344 - 30)) 	and (vc >= 380 and vc <= 390))  or 
			(((hc >= 200 - 30 and hc <= 206 - 30) or  (hc >= 236 - 30 and hc <= 242 - 30)	or	(hc >= 254 - 30 and hc <= 272 - 30)	or	(hc >= 284 - 30 and hc <= 302 - 30)	or	(hc >= 314 - 30 and hc <= 332 - 30)	or	(hc >= 338 - 30 and hc <= 344 - 30)) 	and (vc >= 390 and vc <= 400)) 	or
			 ((hc >= 296 - 30 and hc <= 302 - 30)	and (vc >= 400 and vc <= 420))	or
			 ((hc >= 278 - 30 and hc <= 296 - 30)	and (vc >= 420 and vc <= 430)))	
			and videoON = '1' and juego25 = '1' and juego9 = '0' and Winner = 0) then
			red <= "1111";
			blue <= "1111";
			green <= "1111"; 
		
		-- "No 2" Message 5x5	
		elsif((((hc >= 380 - 40 and hc <= 398 - 40) and (vc >= 320 and vc <= 330)) or
			(((hc >= 374 - 40 and hc <= 380 - 40) or  (hc >= 398 - 40 and hc <= 404 - 40))	and (vc >= 330 and vc <= 340))  	or
			 ((hc >= 398 - 40 and hc <= 404 - 40) and (vc >= 340 and vc <= 350))  or 
			 ((hc >= 392 - 40 and hc <= 398 - 40) and (vc >= 350 and vc <= 360)) 	or
			 ((hc >= 386 - 40 and hc <= 392 - 40) and (vc >= 360 and vc <= 370))  or
			 ((hc >= 380 - 40 and hc <= 386 - 40) and (vc >= 370 and vc <= 380)) 	or
			 ((hc >= 374 - 40 and hc <= 380 - 40) and (vc >= 380 and vc <= 390))	or
			 ((hc >= 374 - 40 and hc <= 404 - 40) and (vc >= 390 and vc <= 400)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and Turn ='0' and Winner = 0) then
			red <= "0000";
			blue <= "0100";
			green <= "1110";
			
		-- "No 1" Message 5x5	
		elsif((((hc >= 380 - 40 and hc <= 392 - 40) and (vc >= 320 and vc <= 330)) or
			(((hc >= 374 - 40 and hc <= 380 - 40) or  (hc >= 386 - 40 and hc <= 392 - 40))	and (vc >= 330 and vc <= 340))  	or
			 ((hc >= 386 - 40 and hc <= 392 - 40) and (vc >= 340 and vc <= 350))  or 
			 ((hc >= 386 - 40 and hc <= 392 - 40) and (vc >= 350 and vc <= 360)) 	or
			 ((hc >= 386 - 40 and hc <= 392 - 40) and (vc >= 360 and vc <= 370))  or
			 ((hc >= 386 - 40 and hc <= 392 - 40) and (vc >= 370 and vc <= 380)) 	or
			 ((hc >= 386 - 40 and hc <= 392 - 40) and (vc >= 380 and vc <= 390))	or
			 ((hc >= 374 - 40 and hc <= 404 - 40) and (vc >= 390 and vc <= 400)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and Turn ='1' and Winner = 0) then
			red <= "1111";
			blue <= "0000";
			green <= "1111"; 
			
		-- Mouse movement animation 5x5	
		elsif ((((hc >= 30 + X2_Origin + X2_Rise and hc <= 36 + X2_Origin + X2_Rise) and (vc >= 10 + Y2_Origin + Y2_Rise	and vc <= 20 + Y2_Origin + Y2_Rise))	or
			(((hc >= 12 + X2_Origin + X2_Rise and hc <= 18 + X2_Origin + X2_Rise) or  (hc >= 30	+ X2_Origin + X2_Rise	and hc <= 36 + X2_Origin + X2_Rise)	or  (hc >= 48 + X2_Origin + X2_Rise and hc <= 54 + X2_Origin + X2_Rise))	and (vc >= 20 + Y2_Origin + Y2_Rise and vc <= 30 + Y2_Origin + Y2_Rise)) or
			(((hc >= 18 + X2_Origin + X2_Rise and hc <= 24 + X2_Origin + X2_Rise) or  (hc >= 42 + X2_Origin + X2_Rise	and hc <= 48 + X2_Origin + X2_Rise)) and (vc >= 30 + Y2_Origin + Y2_Rise and vc <= 40 + Y2_Origin + Y2_Rise))	or 
			 ((hc >= 12 + X2_Origin + X2_Rise and hc <= 54 + X2_Origin + X2_Rise) and (vc >= 40 + Y2_Origin + Y2_Rise	and vc <  50 + Y2_Origin + Y2_Rise)) or
			(((hc >  6	+ X2_Origin + X2_Rise and hc <  18 + X2_Origin + X2_Rise) or  (hc > 24  + X2_Origin + X2_Rise	and hc <  42 + X2_Origin + X2_Rise)  or  (hc >  48 + X2_Origin + X2_Rise and hc <  60 + X2_Origin + X2_Rise))	and (vc >= 50 + Y2_Origin + Y2_Rise and vc <= 60 + Y2_Origin + Y2_Rise)) or
			 ((hc >= 12 + X2_Origin + X2_Rise and hc <= 54 + X2_Origin + X2_Rise) and (vc > 60  + Y2_Origin + Y2_Rise	and vc <= 70 + Y2_Origin + Y2_Rise)) or
			(((hc >= 24 + X2_Origin + X2_Rise and hc <  30 + X2_Origin + X2_Rise) or  (hc > 36  + X2_Origin + X2_Rise	and hc <= 42 + X2_Origin + X2_Rise)) and (vc >= 70 + Y2_Origin + Y2_Rise and vc <= 80 + Y2_Origin + Y2_Rise))	or
			(((hc >= 12 + X2_Origin + X2_Rise and hc <= 24 + X2_Origin + X2_Rise) or  (hc >= 30 + X2_Origin + X2_Rise	and hc <= 36 + X2_Origin + X2_Rise)  or  (hc >= 42 + X2_Origin + X2_Rise and hc <= 54 + X2_Origin + X2_Rise))	and (vc >= 80 + Y2_Origin + Y2_Rise and vc <= 90 + Y2_Origin + Y2_Rise)) or
			(((hc >= 18 + X2_Origin + X2_Rise and hc <= 24 + X2_Origin + X2_Rise) or  (hc >= 42 + X2_Origin + X2_Rise	and hc <= 48 + X2_Origin + X2_Rise)) and (vc >= 90 + Y2_Origin + Y2_Rise and vc <= 100 + Y2_Origin + Y2_Rise))	or
			 ((hc >= 30 + X2_Origin + X2_Rise and hc <= 36 + X2_Origin + X2_Rise) and (vc >= 100 + Y2_Origin + Y2_Rise and vc <= 110 + Y2_Origin + Y2_Rise)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and Turn5 ='1' and Winner = 0) then
			red <= "1111";
			blue <= "1111";
			green <= "1111";
		
		-- CAT movement animation 5x5		
		elsif((((hc >= 33 + X2_Origin + X2_Rise and hc <= 39 + X2_Origin + X2_Rise) and (vc >= 10 + Y2_Origin + Y2_Rise and vc <= 20 + Y2_Origin + Y2_Rise)) or
			(((hc >= 15 + X2_Origin + X2_Rise and hc <= 21 + X2_Origin + X2_Rise) or  (hc >= 33 + X2_Origin + X2_Rise and hc <= 39 + X2_Origin + X2_Rise) 	or  (hc >= 51 + X2_Origin + X2_Rise and hc <= 57 + X2_Origin + X2_Rise)) and (vc >= 20 + Y2_Origin + Y2_Rise and vc < 30 + Y2_Origin + Y2_Rise))  	or
			(((hc >= 21 + X2_Origin + X2_Rise and hc <  33 + X2_Origin + X2_Rise) or  (hc >  39 + X2_Origin + X2_Rise and hc <= 51 + X2_Origin + X2_Rise))	and (vc >= 30 + Y2_Origin + Y2_Rise and vc <= 40 + Y2_Origin + Y2_Rise)) or 
			(((hc >  3  + X2_Origin + X2_Rise and hc <  9  + X2_Origin + X2_Rise) or  (hc >  15 + X2_Origin + X2_Rise and hc <  57 + X2_Origin + X2_Rise) 	or  (hc >  63 + X2_Origin + X2_Rise and hc <  69 + X2_Origin + X2_Rise)) and (vc >  40 + Y2_Origin + Y2_Rise and vc < 50 + Y2_Origin + Y2_Rise)) 	or
			(((hc >  3  + X2_Origin + X2_Rise and hc <  21 + X2_Origin + X2_Rise) or  (hc >  27 + X2_Origin + X2_Rise and hc <  45 + X2_Origin + X2_Rise) 	or  (hc >  51 + X2_Origin + X2_Rise and hc <  69 + X2_Origin + X2_Rise)) and (vc >= 50 + Y2_Origin + Y2_Rise and vc <= 60 + Y2_Origin + Y2_Rise))  or
			 ((hc >= 15 + X2_Origin + X2_Rise and hc <= 57 + X2_Origin + X2_Rise) and (vc >  60 + Y2_Origin + Y2_Rise and vc <  70 + Y2_Origin + Y2_Rise))	or
			(((hc >  9  + X2_Origin + X2_Rise and hc <  15 + X2_Origin + X2_Rise) or  (hc >= 21 + X2_Origin + X2_Rise and hc <  27 + X2_Origin + X2_Rise)	or	(hc >= 33 + X2_Origin + X2_Rise and hc <  39 + X2_Origin + X2_Rise)	 or (hc >= 45 + X2_Origin + X2_Rise and hc < 51 + X2_Origin + X2_Rise)	or	(hc > 57 + X2_Origin + X2_Rise and hc < 63 + X2_Origin + X2_Rise))	and (vc >= 70 + Y2_Origin + Y2_Rise and vc <= 80 + Y2_Origin + Y2_Rise)) or
			(((hc >  9  + X2_Origin + X2_Rise and hc <  15 + X2_Origin + X2_Rise) or  (hc >  57 + X2_Origin + X2_Rise and hc <  63 + X2_Origin + X2_Rise))  and (vc >  80 + Y2_Origin + Y2_Rise and vc <  90 + Y2_Origin + Y2_Rise)) or
			(((hc >= 15 + X2_Origin + X2_Rise and hc <= 21 + X2_Origin + X2_Rise) or  (hc >= 51 + X2_Origin + X2_Rise and hc <= 57 + X2_Origin + X2_Rise)) 	and (vc >= 90 + Y2_Origin + Y2_Rise and vc < 100 + Y2_Origin + Y2_Rise)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and Turn5 ='0' and Winner = 0) then
			red <= "1111";
			blue <= "1111";
			green <= "1111";
			
		-- Printed mouse graphic 5x5 (1,1)
		elsif ((((hc >= 30 + X2_Mouse1 and hc <= 36 + X2_Mouse1) and (vc >= 10 + Y2_Mouse1	and vc <= 20 + Y2_Mouse1))	or
			(((hc >= 12 + X2_Mouse1 and hc <= 18 + X2_Mouse1) or  (hc >= 30	+ X2_Mouse1	and hc <= 36 + X2_Mouse1)	or  (hc >= 48 + X2_Mouse1 and hc <= 54 + X2_Mouse1))	and (vc >= 20 + Y2_Mouse1 and vc <= 30 + Y2_Mouse1)) or
			(((hc >= 18 + X2_Mouse1 and hc <= 24 + X2_Mouse1) or  (hc >= 42 + X2_Mouse1	and hc <= 48 + X2_Mouse1))	and (vc >= 30 + Y2_Mouse1 and vc <= 40 + Y2_Mouse1))	or 
			 ((hc >= 12 + X2_Mouse1 and hc <= 54 + X2_Mouse1) and (vc >= 40 + Y2_Mouse1	and vc <  50 + Y2_Mouse1))	or
			(((hc >  6	+ X2_Mouse1 and hc <  18 + X2_Mouse1) or  (hc > 24  + X2_Mouse1	and hc <  42 + X2_Mouse1) 	or  (hc >  48 + X2_Mouse1 and hc <  60 + X2_Mouse1))	and (vc >= 50 + Y2_Mouse1 and vc <= 60 + Y2_Mouse1)) or
			 ((hc >= 12 + X2_Mouse1 and hc <= 54 + X2_Mouse1) and (vc > 60  + Y2_Mouse1	and vc <= 70 + Y2_Mouse1))	or
			(((hc >= 24 + X2_Mouse1 and hc <  30 + X2_Mouse1) or  (hc > 36  + X2_Mouse1	and hc <= 42 + X2_Mouse1))	and (vc >= 70 + Y2_Mouse1 and vc <= 80 + Y2_Mouse1))	or
			(((hc >= 12 + X2_Mouse1 and hc <= 24 + X2_Mouse1) or  (hc >= 30 + X2_Mouse1	and hc <= 36 + X2_Mouse1)	or  (hc >= 42 + X2_Mouse1 and hc <= 54 + X2_Mouse1))	and (vc >= 80 + Y2_Mouse1 and vc <= 90 + Y2_Mouse1)) or
			(((hc >= 18 + X2_Mouse1 and hc <= 24 + X2_Mouse1) or  (hc >= 42 + X2_Mouse1	and hc <= 48 + X2_Mouse1))	and (vc >= 90 + Y2_Mouse1 and vc <= 100 + Y2_Mouse1))	or
			 ((hc >= 30 + X2_Mouse1 and hc <= 36 + X2_Mouse1) and (vc >= 100 + Y2_Mouse1 and vc <= 110 + Y2_Mouse1)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and M1_11 = 1 and Winner = 0) then
			red <= "1111";
			blue <= "0000";
			green <= "1111";
			
		-- Printed mouse graphic 5x5 (2,1)	
		elsif ((((hc >= 30 + X2_Mouse2 and hc <= 36 + X2_Mouse2) and (vc >= 10 + Y2_Mouse1	and vc <= 20 + Y2_Mouse1))	or
			(((hc >= 12 + X2_Mouse2 and hc <= 18 + X2_Mouse2) or  (hc >= 30	+ X2_Mouse2	and hc <= 36 + X2_Mouse2)	or  (hc >= 48 + X2_Mouse2 and hc <= 54 + X2_Mouse2))	and (vc >= 20 + Y2_Mouse1 and vc <= 30 + Y2_Mouse1)) or
			(((hc >= 18 + X2_Mouse2 and hc <= 24 + X2_Mouse2) or  (hc >= 42 + X2_Mouse2	and hc <= 48 + X2_Mouse2))	and (vc >= 30 + Y2_Mouse1 and vc <= 40 + Y2_Mouse1))	or 
			 ((hc >= 12 + X2_Mouse2 and hc <= 54 + X2_Mouse2) and (vc >= 40 + Y2_Mouse1	and vc <  50 + Y2_Mouse1))	or
			(((hc >  6	+ X2_Mouse2 and hc <  18 + X2_Mouse2) or  (hc > 24  + X2_Mouse2	and hc <  42 + X2_Mouse2) 	or  (hc >  48 + X2_Mouse2 and hc <  60 + X2_Mouse2))	and (vc >= 50 + Y2_Mouse1 and vc <= 60 + Y2_Mouse1)) or
			 ((hc >= 12 + X2_Mouse2 and hc <= 54 + X2_Mouse2) and (vc > 60  + Y2_Mouse1	and vc <= 70 + Y2_Mouse1))	or
			(((hc >= 24 + X2_Mouse2 and hc <  30 + X2_Mouse2) or  (hc > 36  + X2_Mouse2	and hc <= 42 + X2_Mouse2))	and (vc >= 70 + Y2_Mouse1 and vc <= 80 + Y2_Mouse1))	or
			(((hc >= 12 + X2_Mouse2 and hc <= 24 + X2_Mouse2) or  (hc >= 30 + X2_Mouse2	and hc <= 36 + X2_Mouse2)	or  (hc >= 42 + X2_Mouse2 and hc <= 54 + X2_Mouse2))	and (vc >= 80 + Y2_Mouse1 and vc <= 90 + Y2_Mouse1)) or
			(((hc >= 18 + X2_Mouse2 and hc <= 24 + X2_Mouse2) or  (hc >= 42 + X2_Mouse2	and hc <= 48 + X2_Mouse2))	and (vc >= 90 + Y2_Mouse1 and vc <= 100 + Y2_Mouse1))	or
			 ((hc >= 30 + X2_Mouse2 and hc <= 36 + X2_Mouse2) and (vc >= 100 + Y2_Mouse1 and vc <= 110 + Y2_Mouse1)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and M1_21 = 1 and Winner = 0) then
			red <= "1111";
			blue <= "0000";
			green <= "1111";
			
		-- Printed mouse graphic 5x5 (3,1)	
		elsif ((((hc >= 30 + X2_Mouse3 and hc <= 36 + X2_Mouse3) and (vc >= 10 + Y2_Mouse1	and vc <= 20 + Y2_Mouse1))	or
			(((hc >= 12 + X2_Mouse3 and hc <= 18 + X2_Mouse3) or  (hc >= 30	+ X2_Mouse3	and hc <= 36 + X2_Mouse3)	or  (hc >= 48 + X2_Mouse3 and hc <= 54 + X2_Mouse3))	and (vc >= 20 + Y2_Mouse1 and vc <= 30 + Y2_Mouse1)) or
			(((hc >= 18 + X2_Mouse3 and hc <= 24 + X2_Mouse3) or  (hc >= 42 + X2_Mouse3	and hc <= 48 + X2_Mouse3))	and (vc >= 30 + Y2_Mouse1 and vc <= 40 + Y2_Mouse1))	or 
			 ((hc >= 12 + X2_Mouse3 and hc <= 54 + X2_Mouse3) and (vc >= 40 + Y2_Mouse1	and vc <  50 + Y2_Mouse1))	or
			(((hc >  6	+ X2_Mouse3 and hc <  18 + X2_Mouse3) or  (hc > 24  + X2_Mouse3	and hc <  42 + X2_Mouse3) 	or  (hc >  48 + X2_Mouse3 and hc <  60 + X2_Mouse3))	and (vc >= 50 + Y2_Mouse1 and vc <= 60 + Y2_Mouse1)) or
			 ((hc >= 12 + X2_Mouse3 and hc <= 54 + X2_Mouse3) and (vc > 60  + Y2_Mouse1	and vc <= 70 + Y2_Mouse1))	or
			(((hc >= 24 + X2_Mouse3 and hc <  30 + X2_Mouse3) or  (hc > 36  + X2_Mouse3	and hc <= 42 + X2_Mouse3))	and (vc >= 70 + Y2_Mouse1 and vc <= 80 + Y2_Mouse1))	or
			(((hc >= 12 + X2_Mouse3 and hc <= 24 + X2_Mouse3) or  (hc >= 30 + X2_Mouse3	and hc <= 36 + X2_Mouse3)	or  (hc >= 42 + X2_Mouse3 and hc <= 54 + X2_Mouse3))	and (vc >= 80 + Y2_Mouse1 and vc <= 90 + Y2_Mouse1)) or
			(((hc >= 18 + X2_Mouse3 and hc <= 24 + X2_Mouse3) or  (hc >= 42 + X2_Mouse3	and hc <= 48 + X2_Mouse3))	and (vc >= 90 + Y2_Mouse1 and vc <= 100 + Y2_Mouse1))	or
			 ((hc >= 30 + X2_Mouse3 and hc <= 36 + X2_Mouse3) and (vc >= 100 + Y2_Mouse1 and vc <= 110 + Y2_Mouse1)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and M1_31 = 1 and Winner = 0) then
			red <= "1111";
			blue <= "0000";
			green <= "1111"; 
			
		-- Printed mouse graphic 5x5 (4,1)	
		elsif ((((hc >= 30 + X2_Mouse4 and hc <= 36 + X2_Mouse4) and (vc >= 10 + Y2_Mouse1	and vc <= 20 + Y2_Mouse1))	or
			(((hc >= 12 + X2_Mouse4 and hc <= 18 + X2_Mouse4) or  (hc >= 30	+ X2_Mouse4	and hc <= 36 + X2_Mouse4)	or  (hc >= 48 + X2_Mouse4 and hc <= 54 + X2_Mouse4))	and (vc >= 20 + Y2_Mouse1 and vc <= 30 + Y2_Mouse1)) or
			(((hc >= 18 + X2_Mouse4 and hc <= 24 + X2_Mouse4) or  (hc >= 42 + X2_Mouse4	and hc <= 48 + X2_Mouse4))	and (vc >= 30 + Y2_Mouse1 and vc <= 40 + Y2_Mouse1))	or 
			 ((hc >= 12 + X2_Mouse4 and hc <= 54 + X2_Mouse4) and (vc >= 40 + Y2_Mouse1	and vc <  50 + Y2_Mouse1))	or
			(((hc >  6	+ X2_Mouse4 and hc <  18 + X2_Mouse4) or  (hc > 24  + X2_Mouse4	and hc <  42 + X2_Mouse4) 	or  (hc >  48 + X2_Mouse4 and hc <  60 + X2_Mouse4))	and (vc >= 50 + Y2_Mouse1 and vc <= 60 + Y2_Mouse1)) or
			 ((hc >= 12 + X2_Mouse4 and hc <= 54 + X2_Mouse4) and (vc > 60  + Y2_Mouse1	and vc <= 70 + Y2_Mouse1))	or
			(((hc >= 24 + X2_Mouse4 and hc <  30 + X2_Mouse4) or  (hc > 36  + X2_Mouse4	and hc <= 42 + X2_Mouse4))	and (vc >= 70 + Y2_Mouse1 and vc <= 80 + Y2_Mouse1))	or
			(((hc >= 12 + X2_Mouse4 and hc <= 24 + X2_Mouse4) or  (hc >= 30 + X2_Mouse4	and hc <= 36 + X2_Mouse4)	or  (hc >= 42 + X2_Mouse4 and hc <= 54 + X2_Mouse4))	and (vc >= 80 + Y2_Mouse1 and vc <= 90 + Y2_Mouse1)) or
			(((hc >= 18 + X2_Mouse4 and hc <= 24 + X2_Mouse4) or  (hc >= 42 + X2_Mouse4	and hc <= 48 + X2_Mouse4))	and (vc >= 90 + Y2_Mouse1 and vc <= 100 + Y2_Mouse1))	or
			 ((hc >= 30 + X2_Mouse4 and hc <= 36 + X2_Mouse4) and (vc >= 100 + Y2_Mouse1 and vc <= 110 + Y2_Mouse1)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and M1_41 = 1 and Winner = 0) then
			red <= "1111";
			blue <= "0000";
			green <= "1111";
			
		-- Printed mouse graphic 5x5 (5,1)	
		elsif ((((hc >= 30 + X2_Mouse5 and hc <= 36 + X2_Mouse5) and (vc >= 10 + Y2_Mouse1	and vc <= 20 + Y2_Mouse1))	or
			(((hc >= 12 + X2_Mouse5 and hc <= 18 + X2_Mouse5) or  (hc >= 30	+ X2_Mouse5	and hc <= 36 + X2_Mouse5)	or  (hc >= 48 + X2_Mouse5 and hc <= 54 + X2_Mouse5))	and (vc >= 20 + Y2_Mouse1 and vc <= 30 + Y2_Mouse1)) or
			(((hc >= 18 + X2_Mouse5 and hc <= 24 + X2_Mouse5) or  (hc >= 42 + X2_Mouse5	and hc <= 48 + X2_Mouse5))	and (vc >= 30 + Y2_Mouse1 and vc <= 40 + Y2_Mouse1))	or 
			 ((hc >= 12 + X2_Mouse5 and hc <= 54 + X2_Mouse5) and (vc >= 40 + Y2_Mouse1	and vc <  50 + Y2_Mouse1))	or
			(((hc >  6	+ X2_Mouse5 and hc <  18 + X2_Mouse5) or  (hc > 24  + X2_Mouse5	and hc <  42 + X2_Mouse5) 	or  (hc >  48 + X2_Mouse5 and hc <  60 + X2_Mouse5))	and (vc >= 50 + Y2_Mouse1 and vc <= 60 + Y2_Mouse1)) or
			 ((hc >= 12 + X2_Mouse5 and hc <= 54 + X2_Mouse5) and (vc > 60  + Y2_Mouse1	and vc <= 70 + Y2_Mouse1))	or
			(((hc >= 24 + X2_Mouse5 and hc <  30 + X2_Mouse5) or  (hc > 36  + X2_Mouse5	and hc <= 42 + X2_Mouse5))	and (vc >= 70 + Y2_Mouse1 and vc <= 80 + Y2_Mouse1))	or
			(((hc >= 12 + X2_Mouse5 and hc <= 24 + X2_Mouse5) or  (hc >= 30 + X2_Mouse5	and hc <= 36 + X2_Mouse5)	or  (hc >= 42 + X2_Mouse5 and hc <= 54 + X2_Mouse5))	and (vc >= 80 + Y2_Mouse1 and vc <= 90 + Y2_Mouse1)) or
			(((hc >= 18 + X2_Mouse5 and hc <= 24 + X2_Mouse5) or  (hc >= 42 + X2_Mouse5	and hc <= 48 + X2_Mouse5))	and (vc >= 90 + Y2_Mouse1 and vc <= 100 + Y2_Mouse1))	or
			 ((hc >= 30 + X2_Mouse5 and hc <= 36 + X2_Mouse5) and (vc >= 100 + Y2_Mouse1 and vc <= 110 + Y2_Mouse1)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and M1_51 = 1 and Winner = 0) then
			red <= "1111";
			blue <= "0000";
			green <= "1111";
			
		-- Printed mouse graphic 5x5 (1,2)
		elsif ((((hc >= 30 + X2_Mouse1 and hc <= 36 + X2_Mouse1) and (vc >= 10 + Y2_Mouse2	and vc <= 20 + Y2_Mouse2))	or
			(((hc >= 12 + X2_Mouse1 and hc <= 18 + X2_Mouse1) or  (hc >= 30	+ X2_Mouse1	and hc <= 36 + X2_Mouse1)	or  (hc >= 48 + X2_Mouse1 and hc <= 54 + X2_Mouse1))	and (vc >= 20 + Y2_Mouse2 and vc <= 30 + Y2_Mouse2)) or
			(((hc >= 18 + X2_Mouse1 and hc <= 24 + X2_Mouse1) or  (hc >= 42 + X2_Mouse1	and hc <= 48 + X2_Mouse1))	and (vc >= 30 + Y2_Mouse2 and vc <= 40 + Y2_Mouse2))	or 
			 ((hc >= 12 + X2_Mouse1 and hc <= 54 + X2_Mouse1) and (vc >= 40 + Y2_Mouse2	and vc <  50 + Y2_Mouse2))	or
			(((hc >  6	+ X2_Mouse1 and hc <  18 + X2_Mouse1) or  (hc > 24  + X2_Mouse1	and hc <  42 + X2_Mouse1) 	or  (hc >  48 + X2_Mouse1 and hc <  60 + X2_Mouse1))	and (vc >= 50 + Y2_Mouse2 and vc <= 60 + Y2_Mouse2)) or
			 ((hc >= 12 + X2_Mouse1 and hc <= 54 + X2_Mouse1) and (vc > 60  + Y2_Mouse2	and vc <= 70 + Y2_Mouse2))	or
			(((hc >= 24 + X2_Mouse1 and hc <  30 + X2_Mouse1) or  (hc > 36  + X2_Mouse1	and hc <= 42 + X2_Mouse1))	and (vc >= 70 + Y2_Mouse2 and vc <= 80 + Y2_Mouse2))	or
			(((hc >= 12 + X2_Mouse1 and hc <= 24 + X2_Mouse1) or  (hc >= 30 + X2_Mouse1	and hc <= 36 + X2_Mouse1)	or  (hc >= 42 + X2_Mouse1 and hc <= 54 + X2_Mouse1))	and (vc >= 80 + Y2_Mouse2 and vc <= 90 + Y2_Mouse2)) or
			(((hc >= 18 + X2_Mouse1 and hc <= 24 + X2_Mouse1) or  (hc >= 42 + X2_Mouse1	and hc <= 48 + X2_Mouse1))	and (vc >= 90 + Y2_Mouse2 and vc <= 100 + Y2_Mouse2))	or
			 ((hc >= 30 + X2_Mouse1 and hc <= 36 + X2_Mouse1) and (vc >= 100 + Y2_Mouse2 and vc <= 110 + Y2_Mouse2)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and M1_12 = 1 and Winner = 0) then
			red <= "1111";
			blue <= "0000";
			green <= "1111";
			
		-- Printed mouse graphic 5x5 (2,2)	
		elsif ((((hc >= 30 + X2_Mouse2 and hc <= 36 + X2_Mouse2) and (vc >= 10 + Y2_Mouse2	and vc <= 20 + Y2_Mouse2))	or
			(((hc >= 12 + X2_Mouse2 and hc <= 18 + X2_Mouse2) or  (hc >= 30	+ X2_Mouse2	and hc <= 36 + X2_Mouse2)	or  (hc >= 48 + X2_Mouse2 and hc <= 54 + X2_Mouse2))	and (vc >= 20 + Y2_Mouse2 and vc <= 30 + Y2_Mouse2)) or
			(((hc >= 18 + X2_Mouse2 and hc <= 24 + X2_Mouse2) or  (hc >= 42 + X2_Mouse2	and hc <= 48 + X2_Mouse2))	and (vc >= 30 + Y2_Mouse2 and vc <= 40 + Y2_Mouse2))	or 
			 ((hc >= 12 + X2_Mouse2 and hc <= 54 + X2_Mouse2) and (vc >= 40 + Y2_Mouse2	and vc <  50 + Y2_Mouse2))	or
			(((hc >  6	+ X2_Mouse2 and hc <  18 + X2_Mouse2) or  (hc > 24  + X2_Mouse2	and hc <  42 + X2_Mouse2) 	or  (hc >  48 + X2_Mouse2 and hc <  60 + X2_Mouse2))	and (vc >= 50 + Y2_Mouse2 and vc <= 60 + Y2_Mouse2)) or
			 ((hc >= 12 + X2_Mouse2 and hc <= 54 + X2_Mouse2) and (vc > 60  + Y2_Mouse2	and vc <= 70 + Y2_Mouse2))	or
			(((hc >= 24 + X2_Mouse2 and hc <  30 + X2_Mouse2) or  (hc > 36  + X2_Mouse2	and hc <= 42 + X2_Mouse2))	and (vc >= 70 + Y2_Mouse2 and vc <= 80 + Y2_Mouse2))	or
			(((hc >= 12 + X2_Mouse2 and hc <= 24 + X2_Mouse2) or  (hc >= 30 + X2_Mouse2	and hc <= 36 + X2_Mouse2)	or  (hc >= 42 + X2_Mouse2 and hc <= 54 + X2_Mouse2))	and (vc >= 80 + Y2_Mouse2 and vc <= 90 + Y2_Mouse2)) or
			(((hc >= 18 + X2_Mouse2 and hc <= 24 + X2_Mouse2) or  (hc >= 42 + X2_Mouse2	and hc <= 48 + X2_Mouse2))	and (vc >= 90 + Y2_Mouse2 and vc <= 100 + Y2_Mouse2))	or
			 ((hc >= 30 + X2_Mouse2 and hc <= 36 + X2_Mouse2) and (vc >= 100 + Y2_Mouse2 and vc <= 110 + Y2_Mouse2)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and M1_22 = 1 and Winner = 0) then
			red <= "1111";
			blue <= "0000";
			green <= "1111";
			
		-- Printed mouse graphic 5x5 (3,2)	
		elsif ((((hc >= 30 + X2_Mouse3 and hc <= 36 + X2_Mouse3) and (vc >= 10 + Y2_Mouse2	and vc <= 20 + Y2_Mouse2))	or
			(((hc >= 12 + X2_Mouse3 and hc <= 18 + X2_Mouse3) or  (hc >= 30	+ X2_Mouse3	and hc <= 36 + X2_Mouse3)	or  (hc >= 48 + X2_Mouse3 and hc <= 54 + X2_Mouse3))	and (vc >= 20 + Y2_Mouse2 and vc <= 30 + Y2_Mouse2)) or
			(((hc >= 18 + X2_Mouse3 and hc <= 24 + X2_Mouse3) or  (hc >= 42 + X2_Mouse3	and hc <= 48 + X2_Mouse3))	and (vc >= 30 + Y2_Mouse2 and vc <= 40 + Y2_Mouse2))	or 
			 ((hc >= 12 + X2_Mouse3 and hc <= 54 + X2_Mouse3) and (vc >= 40 + Y2_Mouse2	and vc <  50 + Y2_Mouse2))	or
			(((hc >  6	+ X2_Mouse3 and hc <  18 + X2_Mouse3) or  (hc > 24  + X2_Mouse3	and hc <  42 + X2_Mouse3) 	or  (hc >  48 + X2_Mouse3 and hc <  60 + X2_Mouse3))	and (vc >= 50 + Y2_Mouse2 and vc <= 60 + Y2_Mouse2)) or
			 ((hc >= 12 + X2_Mouse3 and hc <= 54 + X2_Mouse3) and (vc > 60  + Y2_Mouse2	and vc <= 70 + Y2_Mouse2))	or
			(((hc >= 24 + X2_Mouse3 and hc <  30 + X2_Mouse3) or  (hc > 36  + X2_Mouse3	and hc <= 42 + X2_Mouse3))	and (vc >= 70 + Y2_Mouse2 and vc <= 80 + Y2_Mouse2))	or
			(((hc >= 12 + X2_Mouse3 and hc <= 24 + X2_Mouse3) or  (hc >= 30 + X2_Mouse3	and hc <= 36 + X2_Mouse3)	or  (hc >= 42 + X2_Mouse3 and hc <= 54 + X2_Mouse3))	and (vc >= 80 + Y2_Mouse2 and vc <= 90 + Y2_Mouse2)) or
			(((hc >= 18 + X2_Mouse3 and hc <= 24 + X2_Mouse3) or  (hc >= 42 + X2_Mouse3	and hc <= 48 + X2_Mouse3))	and (vc >= 90 + Y2_Mouse2 and vc <= 100 + Y2_Mouse2))	or
			 ((hc >= 30 + X2_Mouse3 and hc <= 36 + X2_Mouse3) and (vc >= 100 + Y2_Mouse2 and vc <= 110 + Y2_Mouse2)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and M1_32 = 1 and Winner = 0) then
			red <= "1111";
			blue <= "0000";
			green <= "1111"; 
			
		-- Printed mouse graphic 5x5 (4,2)	
		elsif ((((hc >= 30 + X2_Mouse4 and hc <= 36 + X2_Mouse4) and (vc >= 10 + Y2_Mouse2	and vc <= 20 + Y2_Mouse2))	or
			(((hc >= 12 + X2_Mouse4 and hc <= 18 + X2_Mouse4) or  (hc >= 30	+ X2_Mouse4	and hc <= 36 + X2_Mouse4)	or  (hc >= 48 + X2_Mouse4 and hc <= 54 + X2_Mouse4))	and (vc >= 20 + Y2_Mouse2 and vc <= 30 + Y2_Mouse2)) or
			(((hc >= 18 + X2_Mouse4 and hc <= 24 + X2_Mouse4) or  (hc >= 42 + X2_Mouse4	and hc <= 48 + X2_Mouse4))	and (vc >= 30 + Y2_Mouse2 and vc <= 40 + Y2_Mouse2))	or 
			 ((hc >= 12 + X2_Mouse4 and hc <= 54 + X2_Mouse4) and (vc >= 40 + Y2_Mouse2	and vc <  50 + Y2_Mouse2))	or
			(((hc >  6	+ X2_Mouse4 and hc <  18 + X2_Mouse4) or  (hc > 24  + X2_Mouse4	and hc <  42 + X2_Mouse4) 	or  (hc >  48 + X2_Mouse4 and hc <  60 + X2_Mouse4))	and (vc >= 50 + Y2_Mouse2 and vc <= 60 + Y2_Mouse2)) or
			 ((hc >= 12 + X2_Mouse4 and hc <= 54 + X2_Mouse4) and (vc > 60  + Y2_Mouse2	and vc <= 70 + Y2_Mouse2))	or
			(((hc >= 24 + X2_Mouse4 and hc <  30 + X2_Mouse4) or  (hc > 36  + X2_Mouse4	and hc <= 42 + X2_Mouse4))	and (vc >= 70 + Y2_Mouse2 and vc <= 80 + Y2_Mouse2))	or
			(((hc >= 12 + X2_Mouse4 and hc <= 24 + X2_Mouse4) or  (hc >= 30 + X2_Mouse4	and hc <= 36 + X2_Mouse4)	or  (hc >= 42 + X2_Mouse4 and hc <= 54 + X2_Mouse4))	and (vc >= 80 + Y2_Mouse2 and vc <= 90 + Y2_Mouse2)) or
			(((hc >= 18 + X2_Mouse4 and hc <= 24 + X2_Mouse4) or  (hc >= 42 + X2_Mouse4	and hc <= 48 + X2_Mouse4))	and (vc >= 90 + Y2_Mouse2 and vc <= 100 + Y2_Mouse2))	or
			 ((hc >= 30 + X2_Mouse4 and hc <= 36 + X2_Mouse4) and (vc >= 100 + Y2_Mouse2 and vc <= 110 + Y2_Mouse2)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and M1_42 = 1 and Winner = 0) then
			red <= "1111";
			blue <= "0000";
			green <= "1111";
			
		-- Printed mouse graphic 5x5 (5,2)	
		elsif ((((hc >= 30 + X2_Mouse5 and hc <= 36 + X2_Mouse5) and (vc >= 10 + Y2_Mouse2	and vc <= 20 + Y2_Mouse2))	or
			(((hc >= 12 + X2_Mouse5 and hc <= 18 + X2_Mouse5) or  (hc >= 30	+ X2_Mouse5	and hc <= 36 + X2_Mouse5)	or  (hc >= 48 + X2_Mouse5 and hc <= 54 + X2_Mouse5))	and (vc >= 20 + Y2_Mouse2 and vc <= 30 + Y2_Mouse2)) or
			(((hc >= 18 + X2_Mouse5 and hc <= 24 + X2_Mouse5) or  (hc >= 42 + X2_Mouse5	and hc <= 48 + X2_Mouse5))	and (vc >= 30 + Y2_Mouse2 and vc <= 40 + Y2_Mouse2))	or 
			 ((hc >= 12 + X2_Mouse5 and hc <= 54 + X2_Mouse5) and (vc >= 40 + Y2_Mouse2	and vc <  50 + Y2_Mouse2))	or
			(((hc >  6	+ X2_Mouse5 and hc <  18 + X2_Mouse5) or  (hc > 24  + X2_Mouse5	and hc <  42 + X2_Mouse5) 	or  (hc >  48 + X2_Mouse5 and hc <  60 + X2_Mouse5))	and (vc >= 50 + Y2_Mouse2 and vc <= 60 + Y2_Mouse2)) or
			 ((hc >= 12 + X2_Mouse5 and hc <= 54 + X2_Mouse5) and (vc > 60  + Y2_Mouse2	and vc <= 70 + Y2_Mouse2))	or
			(((hc >= 24 + X2_Mouse5 and hc <  30 + X2_Mouse5) or  (hc > 36  + X2_Mouse5	and hc <= 42 + X2_Mouse5))	and (vc >= 70 + Y2_Mouse2 and vc <= 80 + Y2_Mouse2))	or
			(((hc >= 12 + X2_Mouse5 and hc <= 24 + X2_Mouse5) or  (hc >= 30 + X2_Mouse5	and hc <= 36 + X2_Mouse5)	or  (hc >= 42 + X2_Mouse5 and hc <= 54 + X2_Mouse5))	and (vc >= 80 + Y2_Mouse2 and vc <= 90 + Y2_Mouse2)) or
			(((hc >= 18 + X2_Mouse5 and hc <= 24 + X2_Mouse5) or  (hc >= 42 + X2_Mouse5	and hc <= 48 + X2_Mouse5))	and (vc >= 90 + Y2_Mouse2 and vc <= 100 + Y2_Mouse2))	or
			 ((hc >= 30 + X2_Mouse5 and hc <= 36 + X2_Mouse5) and (vc >= 100 + Y2_Mouse2 and vc <= 110 + Y2_Mouse2)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and M1_52 = 1 and Winner = 0) then
			red <= "1111";
			blue <= "0000";
			green <= "1111";
			
		-- Printed mouse graphic 5x5 (1,3)
		elsif ((((hc >= 30 + X2_Mouse1 and hc <= 36 + X2_Mouse1) and (vc >= 10 + Y2_Mouse3	and vc <= 20 + Y2_Mouse3))	or
			(((hc >= 12 + X2_Mouse1 and hc <= 18 + X2_Mouse1) or  (hc >= 30	+ X2_Mouse1	and hc <= 36 + X2_Mouse1)	or  (hc >= 48 + X2_Mouse1 and hc <= 54 + X2_Mouse1))	and (vc >= 20 + Y2_Mouse3 and vc <= 30 + Y2_Mouse3)) or
			(((hc >= 18 + X2_Mouse1 and hc <= 24 + X2_Mouse1) or  (hc >= 42 + X2_Mouse1	and hc <= 48 + X2_Mouse1))	and (vc >= 30 + Y2_Mouse3 and vc <= 40 + Y2_Mouse3))	or 
			 ((hc >= 12 + X2_Mouse1 and hc <= 54 + X2_Mouse1) and (vc >= 40 + Y2_Mouse3	and vc <  50 + Y2_Mouse3))	or
			(((hc >  6	+ X2_Mouse1 and hc <  18 + X2_Mouse1) or  (hc > 24  + X2_Mouse1	and hc <  42 + X2_Mouse1) 	or  (hc >  48 + X2_Mouse1 and hc <  60 + X2_Mouse1))	and (vc >= 50 + Y2_Mouse3 and vc <= 60 + Y2_Mouse3)) or
			 ((hc >= 12 + X2_Mouse1 and hc <= 54 + X2_Mouse1) and (vc > 60  + Y2_Mouse3	and vc <= 70 + Y2_Mouse3))	or
			(((hc >= 24 + X2_Mouse1 and hc <  30 + X2_Mouse1) or  (hc > 36  + X2_Mouse1	and hc <= 42 + X2_Mouse1))	and (vc >= 70 + Y2_Mouse3 and vc <= 80 + Y2_Mouse3))	or
			(((hc >= 12 + X2_Mouse1 and hc <= 24 + X2_Mouse1) or  (hc >= 30 + X2_Mouse1	and hc <= 36 + X2_Mouse1)	or  (hc >= 42 + X2_Mouse1 and hc <= 54 + X2_Mouse1))	and (vc >= 80 + Y2_Mouse3 and vc <= 90 + Y2_Mouse3)) or
			(((hc >= 18 + X2_Mouse1 and hc <= 24 + X2_Mouse1) or  (hc >= 42 + X2_Mouse1	and hc <= 48 + X2_Mouse1))	and (vc >= 90 + Y2_Mouse3 and vc <= 100 + Y2_Mouse3))	or
			 ((hc >= 30 + X2_Mouse1 and hc <= 36 + X2_Mouse1) and (vc >= 100 + Y2_Mouse3 and vc <= 110 + Y2_Mouse3)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and M1_13 = 1 and Winner = 0) then
			red <= "1111";
			blue <= "0000";
			green <= "1111";
			
		-- Printed mouse graphic 5x5 (2,3)	
		elsif ((((hc >= 30 + X2_Mouse2 and hc <= 36 + X2_Mouse2) and (vc >= 10 + Y2_Mouse3	and vc <= 20 + Y2_Mouse3))	or
			(((hc >= 12 + X2_Mouse2 and hc <= 18 + X2_Mouse2) or  (hc >= 30	+ X2_Mouse2	and hc <= 36 + X2_Mouse2)	or  (hc >= 48 + X2_Mouse2 and hc <= 54 + X2_Mouse2))	and (vc >= 20 + Y2_Mouse3 and vc <= 30 + Y2_Mouse3)) or
			(((hc >= 18 + X2_Mouse2 and hc <= 24 + X2_Mouse2) or  (hc >= 42 + X2_Mouse2	and hc <= 48 + X2_Mouse2))	and (vc >= 30 + Y2_Mouse3 and vc <= 40 + Y2_Mouse3))	or 
			 ((hc >= 12 + X2_Mouse2 and hc <= 54 + X2_Mouse2) and (vc >= 40 + Y2_Mouse3	and vc <  50 + Y2_Mouse3))	or
			(((hc >  6	+ X2_Mouse2 and hc <  18 + X2_Mouse2) or  (hc > 24  + X2_Mouse2	and hc <  42 + X2_Mouse2) 	or  (hc >  48 + X2_Mouse2 and hc <  60 + X2_Mouse2))	and (vc >= 50 + Y2_Mouse3 and vc <= 60 + Y2_Mouse3)) or
			 ((hc >= 12 + X2_Mouse2 and hc <= 54 + X2_Mouse2) and (vc > 60  + Y2_Mouse3	and vc <= 70 + Y2_Mouse3))	or
			(((hc >= 24 + X2_Mouse2 and hc <  30 + X2_Mouse2) or  (hc > 36  + X2_Mouse2	and hc <= 42 + X2_Mouse2))	and (vc >= 70 + Y2_Mouse3 and vc <= 80 + Y2_Mouse3))	or
			(((hc >= 12 + X2_Mouse2 and hc <= 24 + X2_Mouse2) or  (hc >= 30 + X2_Mouse2	and hc <= 36 + X2_Mouse2)	or  (hc >= 42 + X2_Mouse2 and hc <= 54 + X2_Mouse2))	and (vc >= 80 + Y2_Mouse3 and vc <= 90 + Y2_Mouse3)) or
			(((hc >= 18 + X2_Mouse2 and hc <= 24 + X2_Mouse2) or  (hc >= 42 + X2_Mouse2	and hc <= 48 + X2_Mouse2))	and (vc >= 90 + Y2_Mouse3 and vc <= 100 + Y2_Mouse3))	or
			 ((hc >= 30 + X2_Mouse2 and hc <= 36 + X2_Mouse2) and (vc >= 100 + Y2_Mouse3 and vc <= 110 + Y2_Mouse3)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and M1_23 = 1 and Winner = 0) then
			red <= "1111";
			blue <= "0000";
			green <= "1111";
			
		-- Printed mouse graphic 5x5 (3,3)	
		elsif ((((hc >= 30 + X2_Mouse3 and hc <= 36 + X2_Mouse3) and (vc >= 10 + Y2_Mouse3	and vc <= 20 + Y2_Mouse3))	or
			(((hc >= 12 + X2_Mouse3 and hc <= 18 + X2_Mouse3) or  (hc >= 30	+ X2_Mouse3	and hc <= 36 + X2_Mouse3)	or  (hc >= 48 + X2_Mouse3 and hc <= 54 + X2_Mouse3))	and (vc >= 20 + Y2_Mouse3 and vc <= 30 + Y2_Mouse3)) or
			(((hc >= 18 + X2_Mouse3 and hc <= 24 + X2_Mouse3) or  (hc >= 42 + X2_Mouse3	and hc <= 48 + X2_Mouse3))	and (vc >= 30 + Y2_Mouse3 and vc <= 40 + Y2_Mouse3))	or 
			 ((hc >= 12 + X2_Mouse3 and hc <= 54 + X2_Mouse3) and (vc >= 40 + Y2_Mouse3	and vc <  50 + Y2_Mouse3))	or
			(((hc >  6	+ X2_Mouse3 and hc <  18 + X2_Mouse3) or  (hc > 24  + X2_Mouse3	and hc <  42 + X2_Mouse3) 	or  (hc >  48 + X2_Mouse3 and hc <  60 + X2_Mouse3))	and (vc >= 50 + Y2_Mouse3 and vc <= 60 + Y2_Mouse3)) or
			 ((hc >= 12 + X2_Mouse3 and hc <= 54 + X2_Mouse3) and (vc > 60  + Y2_Mouse3	and vc <= 70 + Y2_Mouse3))	or
			(((hc >= 24 + X2_Mouse3 and hc <  30 + X2_Mouse3) or  (hc > 36  + X2_Mouse3	and hc <= 42 + X2_Mouse3))	and (vc >= 70 + Y2_Mouse3 and vc <= 80 + Y2_Mouse3))	or
			(((hc >= 12 + X2_Mouse3 and hc <= 24 + X2_Mouse3) or  (hc >= 30 + X2_Mouse3	and hc <= 36 + X2_Mouse3)	or  (hc >= 42 + X2_Mouse3 and hc <= 54 + X2_Mouse3))	and (vc >= 80 + Y2_Mouse3 and vc <= 90 + Y2_Mouse3)) or
			(((hc >= 18 + X2_Mouse3 and hc <= 24 + X2_Mouse3) or  (hc >= 42 + X2_Mouse3	and hc <= 48 + X2_Mouse3))	and (vc >= 90 + Y2_Mouse3 and vc <= 100 + Y2_Mouse3))	or
			 ((hc >= 30 + X2_Mouse3 and hc <= 36 + X2_Mouse3) and (vc >= 100 + Y2_Mouse3 and vc <= 110 + Y2_Mouse3)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and M1_33 = 1 and Winner = 0) then
			red <= "1111";
			blue <= "0000";
			green <= "1111"; 
			
		-- Printed mouse graphic 5x5 (4,3)	
		elsif ((((hc >= 30 + X2_Mouse4 and hc <= 36 + X2_Mouse4) and (vc >= 10 + Y2_Mouse3	and vc <= 20 + Y2_Mouse3))	or
			(((hc >= 12 + X2_Mouse4 and hc <= 18 + X2_Mouse4) or  (hc >= 30	+ X2_Mouse4	and hc <= 36 + X2_Mouse4)	or  (hc >= 48 + X2_Mouse4 and hc <= 54 + X2_Mouse4))	and (vc >= 20 + Y2_Mouse3 and vc <= 30 + Y2_Mouse3)) or
			(((hc >= 18 + X2_Mouse4 and hc <= 24 + X2_Mouse4) or  (hc >= 42 + X2_Mouse4	and hc <= 48 + X2_Mouse4))	and (vc >= 30 + Y2_Mouse3 and vc <= 40 + Y2_Mouse3))	or 
			 ((hc >= 12 + X2_Mouse4 and hc <= 54 + X2_Mouse4) and (vc >= 40 + Y2_Mouse3	and vc <  50 + Y2_Mouse3))	or
			(((hc >  6	+ X2_Mouse4 and hc <  18 + X2_Mouse4) or  (hc > 24  + X2_Mouse4	and hc <  42 + X2_Mouse4) 	or  (hc >  48 + X2_Mouse4 and hc <  60 + X2_Mouse4))	and (vc >= 50 + Y2_Mouse3 and vc <= 60 + Y2_Mouse3)) or
			 ((hc >= 12 + X2_Mouse4 and hc <= 54 + X2_Mouse4) and (vc > 60  + Y2_Mouse3	and vc <= 70 + Y2_Mouse3))	or
			(((hc >= 24 + X2_Mouse4 and hc <  30 + X2_Mouse4) or  (hc > 36  + X2_Mouse4	and hc <= 42 + X2_Mouse4))	and (vc >= 70 + Y2_Mouse3 and vc <= 80 + Y2_Mouse3))	or
			(((hc >= 12 + X2_Mouse4 and hc <= 24 + X2_Mouse4) or  (hc >= 30 + X2_Mouse4	and hc <= 36 + X2_Mouse4)	or  (hc >= 42 + X2_Mouse4 and hc <= 54 + X2_Mouse4))	and (vc >= 80 + Y2_Mouse3 and vc <= 90 + Y2_Mouse3)) or
			(((hc >= 18 + X2_Mouse4 and hc <= 24 + X2_Mouse4) or  (hc >= 42 + X2_Mouse4	and hc <= 48 + X2_Mouse4))	and (vc >= 90 + Y2_Mouse3 and vc <= 100 + Y2_Mouse3))	or
			 ((hc >= 30 + X2_Mouse4 and hc <= 36 + X2_Mouse4) and (vc >= 100 + Y2_Mouse3 and vc <= 110 + Y2_Mouse3)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and M1_43 = 1 and Winner = 0) then
			red <= "1111";
			blue <= "0000";
			green <= "1111";
			
		-- Printed mouse graphic 5x5 (5,3)	
		elsif ((((hc >= 30 + X2_Mouse5 and hc <= 36 + X2_Mouse5) and (vc >= 10 + Y2_Mouse3	and vc <= 20 + Y2_Mouse3))	or
			(((hc >= 12 + X2_Mouse5 and hc <= 18 + X2_Mouse5) or  (hc >= 30	+ X2_Mouse5	and hc <= 36 + X2_Mouse5)	or  (hc >= 48 + X2_Mouse5 and hc <= 54 + X2_Mouse5))	and (vc >= 20 + Y2_Mouse3 and vc <= 30 + Y2_Mouse3)) or
			(((hc >= 18 + X2_Mouse5 and hc <= 24 + X2_Mouse5) or  (hc >= 42 + X2_Mouse5	and hc <= 48 + X2_Mouse5))	and (vc >= 30 + Y2_Mouse3 and vc <= 40 + Y2_Mouse3))	or 
			 ((hc >= 12 + X2_Mouse5 and hc <= 54 + X2_Mouse5) and (vc >= 40 + Y2_Mouse3	and vc <  50 + Y2_Mouse3))	or
			(((hc >  6	+ X2_Mouse5 and hc <  18 + X2_Mouse5) or  (hc > 24  + X2_Mouse5	and hc <  42 + X2_Mouse5) 	or  (hc >  48 + X2_Mouse5 and hc <  60 + X2_Mouse5))	and (vc >= 50 + Y2_Mouse3 and vc <= 60 + Y2_Mouse3)) or
			 ((hc >= 12 + X2_Mouse5 and hc <= 54 + X2_Mouse5) and (vc > 60  + Y2_Mouse3	and vc <= 70 + Y2_Mouse3))	or
			(((hc >= 24 + X2_Mouse5 and hc <  30 + X2_Mouse5) or  (hc > 36  + X2_Mouse5	and hc <= 42 + X2_Mouse5))	and (vc >= 70 + Y2_Mouse3 and vc <= 80 + Y2_Mouse3))	or
			(((hc >= 12 + X2_Mouse5 and hc <= 24 + X2_Mouse5) or  (hc >= 30 + X2_Mouse5	and hc <= 36 + X2_Mouse5)	or  (hc >= 42 + X2_Mouse5 and hc <= 54 + X2_Mouse5))	and (vc >= 80 + Y2_Mouse3 and vc <= 90 + Y2_Mouse3)) or
			(((hc >= 18 + X2_Mouse5 and hc <= 24 + X2_Mouse5) or  (hc >= 42 + X2_Mouse5	and hc <= 48 + X2_Mouse5))	and (vc >= 90 + Y2_Mouse3 and vc <= 100 + Y2_Mouse3))	or
			 ((hc >= 30 + X2_Mouse5 and hc <= 36 + X2_Mouse5) and (vc >= 100 + Y2_Mouse3 and vc <= 110 + Y2_Mouse3)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and M1_53 = 1 and Winner = 0) then
			red <= "1111";
			blue <= "0000";
			green <= "1111";
			
		-- Printed mouse graphic 5x5 (1,4)
		elsif ((((hc >= 30 + X2_Mouse1 and hc <= 36 + X2_Mouse1) and (vc >= 10 + Y2_Mouse4	and vc <= 20 + Y2_Mouse4))	or
			(((hc >= 12 + X2_Mouse1 and hc <= 18 + X2_Mouse1) or  (hc >= 30	+ X2_Mouse1	and hc <= 36 + X2_Mouse1)	or  (hc >= 48 + X2_Mouse1 and hc <= 54 + X2_Mouse1))	and (vc >= 20 + Y2_Mouse4 and vc <= 30 + Y2_Mouse4)) or
			(((hc >= 18 + X2_Mouse1 and hc <= 24 + X2_Mouse1) or  (hc >= 42 + X2_Mouse1	and hc <= 48 + X2_Mouse1))	and (vc >= 30 + Y2_Mouse4 and vc <= 40 + Y2_Mouse4))	or 
			 ((hc >= 12 + X2_Mouse1 and hc <= 54 + X2_Mouse1) and (vc >= 40 + Y2_Mouse4	and vc <  50 + Y2_Mouse4))	or
			(((hc >  6	+ X2_Mouse1 and hc <  18 + X2_Mouse1) or  (hc > 24  + X2_Mouse1	and hc <  42 + X2_Mouse1) 	or  (hc >  48 + X2_Mouse1 and hc <  60 + X2_Mouse1))	and (vc >= 50 + Y2_Mouse4 and vc <= 60 + Y2_Mouse4)) or
			 ((hc >= 12 + X2_Mouse1 and hc <= 54 + X2_Mouse1) and (vc > 60  + Y2_Mouse4	and vc <= 70 + Y2_Mouse4))	or
			(((hc >= 24 + X2_Mouse1 and hc <  30 + X2_Mouse1) or  (hc > 36  + X2_Mouse1	and hc <= 42 + X2_Mouse1))	and (vc >= 70 + Y2_Mouse4 and vc <= 80 + Y2_Mouse4))	or
			(((hc >= 12 + X2_Mouse1 and hc <= 24 + X2_Mouse1) or  (hc >= 30 + X2_Mouse1	and hc <= 36 + X2_Mouse1)	or  (hc >= 42 + X2_Mouse1 and hc <= 54 + X2_Mouse1))	and (vc >= 80 + Y2_Mouse4 and vc <= 90 + Y2_Mouse4)) or
			(((hc >= 18 + X2_Mouse1 and hc <= 24 + X2_Mouse1) or  (hc >= 42 + X2_Mouse1	and hc <= 48 + X2_Mouse1))	and (vc >= 90 + Y2_Mouse4 and vc <= 100 + Y2_Mouse4))	or
			 ((hc >= 30 + X2_Mouse1 and hc <= 36 + X2_Mouse1) and (vc >= 100 + Y2_Mouse4 and vc <= 110 + Y2_Mouse4)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and M1_14 = 1 and Winner = 0) then
			red <= "1111";
			blue <= "0000";
			green <= "1111";
			
		-- Printed mouse graphic 5x5 (2,4)	
		elsif ((((hc >= 30 + X2_Mouse2 and hc <= 36 + X2_Mouse2) and (vc >= 10 + Y2_Mouse4	and vc <= 20 + Y2_Mouse4))	or
			(((hc >= 12 + X2_Mouse2 and hc <= 18 + X2_Mouse2) or  (hc >= 30	+ X2_Mouse2	and hc <= 36 + X2_Mouse2)	or  (hc >= 48 + X2_Mouse2 and hc <= 54 + X2_Mouse2))	and (vc >= 20 + Y2_Mouse4 and vc <= 30 + Y2_Mouse4)) or
			(((hc >= 18 + X2_Mouse2 and hc <= 24 + X2_Mouse2) or  (hc >= 42 + X2_Mouse2	and hc <= 48 + X2_Mouse2))	and (vc >= 30 + Y2_Mouse4 and vc <= 40 + Y2_Mouse4))	or 
			 ((hc >= 12 + X2_Mouse2 and hc <= 54 + X2_Mouse2) and (vc >= 40 + Y2_Mouse4	and vc <  50 + Y2_Mouse4))	or
			(((hc >  6	+ X2_Mouse2 and hc <  18 + X2_Mouse2) or  (hc > 24  + X2_Mouse2	and hc <  42 + X2_Mouse2) 	or  (hc >  48 + X2_Mouse2 and hc <  60 + X2_Mouse2))	and (vc >= 50 + Y2_Mouse4 and vc <= 60 + Y2_Mouse4)) or
			 ((hc >= 12 + X2_Mouse2 and hc <= 54 + X2_Mouse2) and (vc > 60  + Y2_Mouse4	and vc <= 70 + Y2_Mouse4))	or
			(((hc >= 24 + X2_Mouse2 and hc <  30 + X2_Mouse2) or  (hc > 36  + X2_Mouse2	and hc <= 42 + X2_Mouse2))	and (vc >= 70 + Y2_Mouse4 and vc <= 80 + Y2_Mouse4))	or
			(((hc >= 12 + X2_Mouse2 and hc <= 24 + X2_Mouse2) or  (hc >= 30 + X2_Mouse2	and hc <= 36 + X2_Mouse2)	or  (hc >= 42 + X2_Mouse2 and hc <= 54 + X2_Mouse2))	and (vc >= 80 + Y2_Mouse4 and vc <= 90 + Y2_Mouse4)) or
			(((hc >= 18 + X2_Mouse2 and hc <= 24 + X2_Mouse2) or  (hc >= 42 + X2_Mouse2	and hc <= 48 + X2_Mouse2))	and (vc >= 90 + Y2_Mouse4 and vc <= 100 + Y2_Mouse4))	or
			 ((hc >= 30 + X2_Mouse2 and hc <= 36 + X2_Mouse2) and (vc >= 100 + Y2_Mouse4 and vc <= 110 + Y2_Mouse4)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and M1_24 = 1 and Winner = 0) then
			red <= "1111";
			blue <= "0000";
			green <= "1111";
			
		-- Printed mouse graphic 5x5 (3,4)	
		elsif ((((hc >= 30 + X2_Mouse3 and hc <= 36 + X2_Mouse3) and (vc >= 10 + Y2_Mouse4	and vc <= 20 + Y2_Mouse4))	or
			(((hc >= 12 + X2_Mouse3 and hc <= 18 + X2_Mouse3) or  (hc >= 30	+ X2_Mouse3	and hc <= 36 + X2_Mouse3)	or  (hc >= 48 + X2_Mouse3 and hc <= 54 + X2_Mouse3))	and (vc >= 20 + Y2_Mouse4 and vc <= 30 + Y2_Mouse4)) or
			(((hc >= 18 + X2_Mouse3 and hc <= 24 + X2_Mouse3) or  (hc >= 42 + X2_Mouse3	and hc <= 48 + X2_Mouse3))	and (vc >= 30 + Y2_Mouse4 and vc <= 40 + Y2_Mouse4))	or 
			 ((hc >= 12 + X2_Mouse3 and hc <= 54 + X2_Mouse3) and (vc >= 40 + Y2_Mouse4	and vc <  50 + Y2_Mouse4))	or
			(((hc >  6	+ X2_Mouse3 and hc <  18 + X2_Mouse3) or  (hc > 24  + X2_Mouse3	and hc <  42 + X2_Mouse3) 	or  (hc >  48 + X2_Mouse3 and hc <  60 + X2_Mouse3))	and (vc >= 50 + Y2_Mouse4 and vc <= 60 + Y2_Mouse4)) or
			 ((hc >= 12 + X2_Mouse3 and hc <= 54 + X2_Mouse3) and (vc > 60  + Y2_Mouse4	and vc <= 70 + Y2_Mouse4))	or
			(((hc >= 24 + X2_Mouse3 and hc <  30 + X2_Mouse3) or  (hc > 36  + X2_Mouse3	and hc <= 42 + X2_Mouse3))	and (vc >= 70 + Y2_Mouse4 and vc <= 80 + Y2_Mouse4))	or
			(((hc >= 12 + X2_Mouse3 and hc <= 24 + X2_Mouse3) or  (hc >= 30 + X2_Mouse3	and hc <= 36 + X2_Mouse3)	or  (hc >= 42 + X2_Mouse3 and hc <= 54 + X2_Mouse3))	and (vc >= 80 + Y2_Mouse4 and vc <= 90 + Y2_Mouse4)) or
			(((hc >= 18 + X2_Mouse3 and hc <= 24 + X2_Mouse3) or  (hc >= 42 + X2_Mouse3	and hc <= 48 + X2_Mouse3))	and (vc >= 90 + Y2_Mouse4 and vc <= 100 + Y2_Mouse4))	or
			 ((hc >= 30 + X2_Mouse3 and hc <= 36 + X2_Mouse3) and (vc >= 100 + Y2_Mouse4 and vc <= 110 + Y2_Mouse4)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and M1_34 = 1 and Winner = 0) then
			red <= "1111";
			blue <= "0000";
			green <= "1111"; 
			
		-- Printed mouse graphic 5x5 (4,3)	
		elsif ((((hc >= 30 + X2_Mouse4 and hc <= 36 + X2_Mouse4) and (vc >= 10 + Y2_Mouse4	and vc <= 20 + Y2_Mouse4))	or
			(((hc >= 12 + X2_Mouse4 and hc <= 18 + X2_Mouse4) or  (hc >= 30	+ X2_Mouse4	and hc <= 36 + X2_Mouse4)	or  (hc >= 48 + X2_Mouse4 and hc <= 54 + X2_Mouse4))	and (vc >= 20 + Y2_Mouse4 and vc <= 30 + Y2_Mouse4)) or
			(((hc >= 18 + X2_Mouse4 and hc <= 24 + X2_Mouse4) or  (hc >= 42 + X2_Mouse4	and hc <= 48 + X2_Mouse4))	and (vc >= 30 + Y2_Mouse4 and vc <= 40 + Y2_Mouse4))	or 
			 ((hc >= 12 + X2_Mouse4 and hc <= 54 + X2_Mouse4) and (vc >= 40 + Y2_Mouse4	and vc <  50 + Y2_Mouse4))	or
			(((hc >  6	+ X2_Mouse4 and hc <  18 + X2_Mouse4) or  (hc > 24  + X2_Mouse4	and hc <  42 + X2_Mouse4) 	or  (hc >  48 + X2_Mouse4 and hc <  60 + X2_Mouse4))	and (vc >= 50 + Y2_Mouse4 and vc <= 60 + Y2_Mouse4)) or
			 ((hc >= 12 + X2_Mouse4 and hc <= 54 + X2_Mouse4) and (vc > 60  + Y2_Mouse4	and vc <= 70 + Y2_Mouse4))	or
			(((hc >= 24 + X2_Mouse4 and hc <  30 + X2_Mouse4) or  (hc > 36  + X2_Mouse4	and hc <= 42 + X2_Mouse4))	and (vc >= 70 + Y2_Mouse4 and vc <= 80 + Y2_Mouse4))	or
			(((hc >= 12 + X2_Mouse4 and hc <= 24 + X2_Mouse4) or  (hc >= 30 + X2_Mouse4	and hc <= 36 + X2_Mouse4)	or  (hc >= 42 + X2_Mouse4 and hc <= 54 + X2_Mouse4))	and (vc >= 80 + Y2_Mouse4 and vc <= 90 + Y2_Mouse4)) or
			(((hc >= 18 + X2_Mouse4 and hc <= 24 + X2_Mouse4) or  (hc >= 42 + X2_Mouse4	and hc <= 48 + X2_Mouse4))	and (vc >= 90 + Y2_Mouse4 and vc <= 100 + Y2_Mouse4))	or
			 ((hc >= 30 + X2_Mouse4 and hc <= 36 + X2_Mouse4) and (vc >= 100 + Y2_Mouse4 and vc <= 110 + Y2_Mouse4)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and M1_44 = 1 and Winner = 0) then
			red <= "1111";
			blue <= "0000";
			green <= "1111";
			
		-- Printed mouse graphic 5x5 (5,4)	
		elsif ((((hc >= 30 + X2_Mouse5 and hc <= 36 + X2_Mouse5) and (vc >= 10 + Y2_Mouse4	and vc <= 20 + Y2_Mouse4))	or
			(((hc >= 12 + X2_Mouse5 and hc <= 18 + X2_Mouse5) or  (hc >= 30	+ X2_Mouse5	and hc <= 36 + X2_Mouse5)	or  (hc >= 48 + X2_Mouse5 and hc <= 54 + X2_Mouse5))	and (vc >= 20 + Y2_Mouse4 and vc <= 30 + Y2_Mouse4)) or
			(((hc >= 18 + X2_Mouse5 and hc <= 24 + X2_Mouse5) or  (hc >= 42 + X2_Mouse5	and hc <= 48 + X2_Mouse5))	and (vc >= 30 + Y2_Mouse4 and vc <= 40 + Y2_Mouse4))	or 
			 ((hc >= 12 + X2_Mouse5 and hc <= 54 + X2_Mouse5) and (vc >= 40 + Y2_Mouse4	and vc <  50 + Y2_Mouse4))	or
			(((hc >  6	+ X2_Mouse5 and hc <  18 + X2_Mouse5) or  (hc > 24  + X2_Mouse5	and hc <  42 + X2_Mouse5) 	or  (hc >  48 + X2_Mouse5 and hc <  60 + X2_Mouse5))	and (vc >= 50 + Y2_Mouse4 and vc <= 60 + Y2_Mouse4)) or
			 ((hc >= 12 + X2_Mouse5 and hc <= 54 + X2_Mouse5) and (vc > 60  + Y2_Mouse4	and vc <= 70 + Y2_Mouse4))	or
			(((hc >= 24 + X2_Mouse5 and hc <  30 + X2_Mouse5) or  (hc > 36  + X2_Mouse5	and hc <= 42 + X2_Mouse5))	and (vc >= 70 + Y2_Mouse4 and vc <= 80 + Y2_Mouse4))	or
			(((hc >= 12 + X2_Mouse5 and hc <= 24 + X2_Mouse5) or  (hc >= 30 + X2_Mouse5	and hc <= 36 + X2_Mouse5)	or  (hc >= 42 + X2_Mouse5 and hc <= 54 + X2_Mouse5))	and (vc >= 80 + Y2_Mouse4 and vc <= 90 + Y2_Mouse4)) or
			(((hc >= 18 + X2_Mouse5 and hc <= 24 + X2_Mouse5) or  (hc >= 42 + X2_Mouse5	and hc <= 48 + X2_Mouse5))	and (vc >= 90 + Y2_Mouse4 and vc <= 100 + Y2_Mouse4))	or
			 ((hc >= 30 + X2_Mouse5 and hc <= 36 + X2_Mouse5) and (vc >= 100 + Y2_Mouse4 and vc <= 110 + Y2_Mouse4)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and M1_54 = 1 and Winner = 0) then
			red <= "1111";
			blue <= "0000";
			green <= "1111";
			
		-- Printed mouse graphic 5x5 (1,5)
		elsif ((((hc >= 30 + X2_Mouse1 and hc <= 36 + X2_Mouse1) and (vc >= 10 + Y2_Mouse5	and vc <= 20 + Y2_Mouse5))	or
			(((hc >= 12 + X2_Mouse1 and hc <= 18 + X2_Mouse1) or  (hc >= 30	+ X2_Mouse1	and hc <= 36 + X2_Mouse1)	or  (hc >= 48 + X2_Mouse1 and hc <= 54 + X2_Mouse1))	and (vc >= 20 + Y2_Mouse5 and vc <= 30 + Y2_Mouse5)) or
			(((hc >= 18 + X2_Mouse1 and hc <= 24 + X2_Mouse1) or  (hc >= 42 + X2_Mouse1	and hc <= 48 + X2_Mouse1))	and (vc >= 30 + Y2_Mouse5 and vc <= 40 + Y2_Mouse5))	or 
			 ((hc >= 12 + X2_Mouse1 and hc <= 54 + X2_Mouse1) and (vc >= 40 + Y2_Mouse5	and vc <  50 + Y2_Mouse5))	or
			(((hc >  6	+ X2_Mouse1 and hc <  18 + X2_Mouse1) or  (hc > 24  + X2_Mouse1	and hc <  42 + X2_Mouse1) 	or  (hc >  48 + X2_Mouse1 and hc <  60 + X2_Mouse1))	and (vc >= 50 + Y2_Mouse5 and vc <= 60 + Y2_Mouse5)) or
			 ((hc >= 12 + X2_Mouse1 and hc <= 54 + X2_Mouse1) and (vc > 60  + Y2_Mouse5	and vc <= 70 + Y2_Mouse5))	or
			(((hc >= 24 + X2_Mouse1 and hc <  30 + X2_Mouse1) or  (hc > 36  + X2_Mouse1	and hc <= 42 + X2_Mouse1))	and (vc >= 70 + Y2_Mouse5 and vc <= 80 + Y2_Mouse5))	or
			(((hc >= 12 + X2_Mouse1 and hc <= 24 + X2_Mouse1) or  (hc >= 30 + X2_Mouse1	and hc <= 36 + X2_Mouse1)	or  (hc >= 42 + X2_Mouse1 and hc <= 54 + X2_Mouse1))	and (vc >= 80 + Y2_Mouse5 and vc <= 90 + Y2_Mouse5)) or
			(((hc >= 18 + X2_Mouse1 and hc <= 24 + X2_Mouse1) or  (hc >= 42 + X2_Mouse1	and hc <= 48 + X2_Mouse1))	and (vc >= 90 + Y2_Mouse5 and vc <= 100 + Y2_Mouse5))	or
			 ((hc >= 30 + X2_Mouse1 and hc <= 36 + X2_Mouse1) and (vc >= 100 + Y2_Mouse5 and vc <= 110 + Y2_Mouse5)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and M1_15 = 1 and Winner = 0) then
			red <= "1111";
			blue <= "0000";
			green <= "1111";
			
		-- Printed mouse graphic 5x5 (2,5)	
		elsif ((((hc >= 30 + X2_Mouse2 and hc <= 36 + X2_Mouse2) and (vc >= 10 + Y2_Mouse5	and vc <= 20 + Y2_Mouse5))	or
			(((hc >= 12 + X2_Mouse2 and hc <= 18 + X2_Mouse2) or  (hc >= 30	+ X2_Mouse2	and hc <= 36 + X2_Mouse2)	or  (hc >= 48 + X2_Mouse2 and hc <= 54 + X2_Mouse2))	and (vc >= 20 + Y2_Mouse5 and vc <= 30 + Y2_Mouse5)) or
			(((hc >= 18 + X2_Mouse2 and hc <= 24 + X2_Mouse2) or  (hc >= 42 + X2_Mouse2	and hc <= 48 + X2_Mouse2))	and (vc >= 30 + Y2_Mouse5 and vc <= 40 + Y2_Mouse5))	or 
			 ((hc >= 12 + X2_Mouse2 and hc <= 54 + X2_Mouse2) and (vc >= 40 + Y2_Mouse5	and vc <  50 + Y2_Mouse5))	or
			(((hc >  6	+ X2_Mouse2 and hc <  18 + X2_Mouse2) or  (hc > 24  + X2_Mouse2	and hc <  42 + X2_Mouse2) 	or  (hc >  48 + X2_Mouse2 and hc <  60 + X2_Mouse2))	and (vc >= 50 + Y2_Mouse5 and vc <= 60 + Y2_Mouse5)) or
			 ((hc >= 12 + X2_Mouse2 and hc <= 54 + X2_Mouse2) and (vc > 60  + Y2_Mouse5	and vc <= 70 + Y2_Mouse5))	or
			(((hc >= 24 + X2_Mouse2 and hc <  30 + X2_Mouse2) or  (hc > 36  + X2_Mouse2	and hc <= 42 + X2_Mouse2))	and (vc >= 70 + Y2_Mouse5 and vc <= 80 + Y2_Mouse5))	or
			(((hc >= 12 + X2_Mouse2 and hc <= 24 + X2_Mouse2) or  (hc >= 30 + X2_Mouse2	and hc <= 36 + X2_Mouse2)	or  (hc >= 42 + X2_Mouse2 and hc <= 54 + X2_Mouse2))	and (vc >= 80 + Y2_Mouse5 and vc <= 90 + Y2_Mouse5)) or
			(((hc >= 18 + X2_Mouse2 and hc <= 24 + X2_Mouse2) or  (hc >= 42 + X2_Mouse2	and hc <= 48 + X2_Mouse2))	and (vc >= 90 + Y2_Mouse5 and vc <= 100 + Y2_Mouse5))	or
			 ((hc >= 30 + X2_Mouse2 and hc <= 36 + X2_Mouse2) and (vc >= 100 + Y2_Mouse5 and vc <= 110 + Y2_Mouse5)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and M1_25 = 1 and Winner = 0) then
			red <= "1111";
			blue <= "0000";
			green <= "1111";
			
		-- Printed mouse graphic 5x5 (3,5)	
		elsif ((((hc >= 30 + X2_Mouse3 and hc <= 36 + X2_Mouse3) and (vc >= 10 + Y2_Mouse5	and vc <= 20 + Y2_Mouse5))	or
			(((hc >= 12 + X2_Mouse3 and hc <= 18 + X2_Mouse3) or  (hc >= 30	+ X2_Mouse3	and hc <= 36 + X2_Mouse3)	or  (hc >= 48 + X2_Mouse3 and hc <= 54 + X2_Mouse3))	and (vc >= 20 + Y2_Mouse5 and vc <= 30 + Y2_Mouse5)) or
			(((hc >= 18 + X2_Mouse3 and hc <= 24 + X2_Mouse3) or  (hc >= 42 + X2_Mouse3	and hc <= 48 + X2_Mouse3))	and (vc >= 30 + Y2_Mouse5 and vc <= 40 + Y2_Mouse5))	or 
			 ((hc >= 12 + X2_Mouse3 and hc <= 54 + X2_Mouse3) and (vc >= 40 + Y2_Mouse5	and vc <  50 + Y2_Mouse5))	or
			(((hc >  6	+ X2_Mouse3 and hc <  18 + X2_Mouse3) or  (hc > 24  + X2_Mouse3	and hc <  42 + X2_Mouse3) 	or  (hc >  48 + X2_Mouse3 and hc <  60 + X2_Mouse3))	and (vc >= 50 + Y2_Mouse5 and vc <= 60 + Y2_Mouse5)) or
			 ((hc >= 12 + X2_Mouse3 and hc <= 54 + X2_Mouse3) and (vc > 60  + Y2_Mouse5	and vc <= 70 + Y2_Mouse5))	or
			(((hc >= 24 + X2_Mouse3 and hc <  30 + X2_Mouse3) or  (hc > 36  + X2_Mouse3	and hc <= 42 + X2_Mouse3))	and (vc >= 70 + Y2_Mouse5 and vc <= 80 + Y2_Mouse5))	or
			(((hc >= 12 + X2_Mouse3 and hc <= 24 + X2_Mouse3) or  (hc >= 30 + X2_Mouse3	and hc <= 36 + X2_Mouse3)	or  (hc >= 42 + X2_Mouse3 and hc <= 54 + X2_Mouse3))	and (vc >= 80 + Y2_Mouse5 and vc <= 90 + Y2_Mouse5)) or
			(((hc >= 18 + X2_Mouse3 and hc <= 24 + X2_Mouse3) or  (hc >= 42 + X2_Mouse3	and hc <= 48 + X2_Mouse3))	and (vc >= 90 + Y2_Mouse5 and vc <= 100 + Y2_Mouse5))	or
			 ((hc >= 30 + X2_Mouse3 and hc <= 36 + X2_Mouse3) and (vc >= 100 + Y2_Mouse5 and vc <= 110 + Y2_Mouse5)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and M1_35 = 1 and Winner = 0) then
			red <= "1111";
			blue <= "0000";
			green <= "1111"; 
			
		-- Printed mouse graphic 5x5 (4,5)	
		elsif ((((hc >= 30 + X2_Mouse4 and hc <= 36 + X2_Mouse4) and (vc >= 10 + Y2_Mouse5	and vc <= 20 + Y2_Mouse5))	or
			(((hc >= 12 + X2_Mouse4 and hc <= 18 + X2_Mouse4) or  (hc >= 30	+ X2_Mouse4	and hc <= 36 + X2_Mouse4)	or  (hc >= 48 + X2_Mouse4 and hc <= 54 + X2_Mouse4))	and (vc >= 20 + Y2_Mouse5 and vc <= 30 + Y2_Mouse5)) or
			(((hc >= 18 + X2_Mouse4 and hc <= 24 + X2_Mouse4) or  (hc >= 42 + X2_Mouse4	and hc <= 48 + X2_Mouse4))	and (vc >= 30 + Y2_Mouse5 and vc <= 40 + Y2_Mouse5))	or 
			 ((hc >= 12 + X2_Mouse4 and hc <= 54 + X2_Mouse4) and (vc >= 40 + Y2_Mouse5	and vc <  50 + Y2_Mouse5))	or
			(((hc >  6	+ X2_Mouse4 and hc <  18 + X2_Mouse4) or  (hc > 24  + X2_Mouse4	and hc <  42 + X2_Mouse4) 	or  (hc >  48 + X2_Mouse4 and hc <  60 + X2_Mouse4))	and (vc >= 50 + Y2_Mouse5 and vc <= 60 + Y2_Mouse5)) or
			 ((hc >= 12 + X2_Mouse4 and hc <= 54 + X2_Mouse4) and (vc > 60  + Y2_Mouse5	and vc <= 70 + Y2_Mouse5))	or
			(((hc >= 24 + X2_Mouse4 and hc <  30 + X2_Mouse4) or  (hc > 36  + X2_Mouse4	and hc <= 42 + X2_Mouse4))	and (vc >= 70 + Y2_Mouse5 and vc <= 80 + Y2_Mouse5))	or
			(((hc >= 12 + X2_Mouse4 and hc <= 24 + X2_Mouse4) or  (hc >= 30 + X2_Mouse4	and hc <= 36 + X2_Mouse4)	or  (hc >= 42 + X2_Mouse4 and hc <= 54 + X2_Mouse4))	and (vc >= 80 + Y2_Mouse5 and vc <= 90 + Y2_Mouse5)) or
			(((hc >= 18 + X2_Mouse4 and hc <= 24 + X2_Mouse4) or  (hc >= 42 + X2_Mouse4	and hc <= 48 + X2_Mouse4))	and (vc >= 90 + Y2_Mouse5 and vc <= 100 + Y2_Mouse5))	or
			 ((hc >= 30 + X2_Mouse4 and hc <= 36 + X2_Mouse4) and (vc >= 100 + Y2_Mouse5 and vc <= 110 + Y2_Mouse5)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and M1_45 = 1 and Winner = 0) then
			red <= "1111";
			blue <= "0000";
			green <= "1111";
			
		-- Printed mouse graphic 5x5 (5,5)	
		elsif ((((hc >= 30 + X2_Mouse5 and hc <= 36 + X2_Mouse5) and (vc >= 10 + Y2_Mouse5	and vc <= 20 + Y2_Mouse5))	or
			(((hc >= 12 + X2_Mouse5 and hc <= 18 + X2_Mouse5) or  (hc >= 30	+ X2_Mouse5	and hc <= 36 + X2_Mouse5)	or  (hc >= 48 + X2_Mouse5 and hc <= 54 + X2_Mouse5))	and (vc >= 20 + Y2_Mouse5 and vc <= 30 + Y2_Mouse5)) or
			(((hc >= 18 + X2_Mouse5 and hc <= 24 + X2_Mouse5) or  (hc >= 42 + X2_Mouse5	and hc <= 48 + X2_Mouse5))	and (vc >= 30 + Y2_Mouse5 and vc <= 40 + Y2_Mouse5))	or 
			 ((hc >= 12 + X2_Mouse5 and hc <= 54 + X2_Mouse5) and (vc >= 40 + Y2_Mouse5	and vc <  50 + Y2_Mouse5))	or
			(((hc >  6	+ X2_Mouse5 and hc <  18 + X2_Mouse5) or  (hc > 24  + X2_Mouse5	and hc <  42 + X2_Mouse5) 	or  (hc >  48 + X2_Mouse5 and hc <  60 + X2_Mouse5))	and (vc >= 50 + Y2_Mouse5 and vc <= 60 + Y2_Mouse5)) or
			 ((hc >= 12 + X2_Mouse5 and hc <= 54 + X2_Mouse5) and (vc > 60  + Y2_Mouse5	and vc <= 70 + Y2_Mouse5))	or
			(((hc >= 24 + X2_Mouse5 and hc <  30 + X2_Mouse5) or  (hc > 36  + X2_Mouse5	and hc <= 42 + X2_Mouse5))	and (vc >= 70 + Y2_Mouse5 and vc <= 80 + Y2_Mouse5))	or
			(((hc >= 12 + X2_Mouse5 and hc <= 24 + X2_Mouse5) or  (hc >= 30 + X2_Mouse5	and hc <= 36 + X2_Mouse5)	or  (hc >= 42 + X2_Mouse5 and hc <= 54 + X2_Mouse5))	and (vc >= 80 + Y2_Mouse5 and vc <= 90 + Y2_Mouse5)) or
			(((hc >= 18 + X2_Mouse5 and hc <= 24 + X2_Mouse5) or  (hc >= 42 + X2_Mouse5	and hc <= 48 + X2_Mouse5))	and (vc >= 90 + Y2_Mouse5 and vc <= 100 + Y2_Mouse5))	or
			 ((hc >= 30 + X2_Mouse5 and hc <= 36 + X2_Mouse5) and (vc >= 100 + Y2_Mouse5 and vc <= 110 + Y2_Mouse5)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and M1_55 = 1 and Winner = 0) then
			red <= "1111";
			blue <= "0000";
			green <= "1111"; 
			
		-- Printed cat graphic 5x5(1,1)	
		elsif((((hc >= 33 + X2_Cat1 and hc <= 39 + X2_Cat1) and (vc >= 10 + Y2_Cat1 and vc <= 20 + Y2_Cat1)) or
			(((hc >= 15 + X2_Cat1 and hc <= 21 + X2_Cat1) or  (hc >= 33 + X2_Cat1 and hc <= 39 + X2_Cat1) 	or  (hc >= 51 + X2_Cat1 and hc <= 57 + X2_Cat1)) and (vc >= 20 + Y2_Cat1 and vc <  30 + Y2_Cat1))  	or
			(((hc >= 21 + X2_Cat1 and hc <  33 + X2_Cat1) or  (hc >  39 + X2_Cat1 and hc <= 51 + X2_Cat1))	and (vc >= 30 + Y2_Cat1 and vc <= 40 + Y2_Cat1)) or 
			(((hc >  3  + X2_Cat1 and hc <  9  + X2_Cat1) or  (hc >  15 + X2_Cat1 and hc <  57 + X2_Cat1) 	or  (hc >  63 + X2_Cat1 and hc <  69 + X2_Cat1)) and (vc >  40 + Y2_Cat1 and vc <  50 + Y2_Cat1)) 	or
			(((hc >  3  + X2_Cat1 and hc <  21 + X2_Cat1) or  (hc >  27 + X2_Cat1 and hc <  45 + X2_Cat1) 	or  (hc >  51 + X2_Cat1 and hc <  69 + X2_Cat1)) and (vc >= 50 + Y2_Cat1 and vc <= 60 + Y2_Cat1))	or
			 ((hc >= 15 + X2_Cat1 and hc <= 57 + X2_Cat1) and (vc >  60 + Y2_Cat1 and vc <  70 + Y2_Cat1))	or
			(((hc >  9  + X2_Cat1 and hc <  15 + X2_Cat1) or  (hc >= 21 + X2_Cat1 and hc <  27 + X2_Cat1)	or	(hc >= 33 + X2_Cat1 and hc <  39 + X2_Cat1)	 or	 (hc >= 45 + X2_Cat1 and hc <  51 + X2_Cat1)	or	(hc > 57 + X2_Cat1 and hc < 63 + X2_Cat1))	and (vc >= 70 + Y2_Cat1 and vc <= 80 + Y2_Cat1)) or
			(((hc >  9  + X2_Cat1 and hc <  15 + X2_Cat1) or  (hc >  57 + X2_Cat1 and hc <  63 + X2_Cat1))  and (vc >  80 + Y2_Cat1 and vc <  90 + Y2_Cat1)) or
			(((hc >= 15 + X2_Cat1 and hc <= 21 + X2_Cat1) or  (hc >= 51 + X2_Cat1 and hc <= 57 + X2_Cat1)) 	and (vc >= 90 + Y2_Cat1 and vc < 100 + Y2_Cat1)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and M2_11 = 1 and Winner = 0) then
			red <= "0000";
			blue <= "0100";
			green <= "1110";
			
		-- Printed cat graphic 5x5(2,1)	
		elsif((((hc >= 33 + X2_Cat2 and hc <= 39 + X2_Cat2) and (vc >= 10 + Y2_Cat1 and vc <= 20 + Y2_Cat1)) or
			(((hc >= 15 + X2_Cat2 and hc <= 21 + X2_Cat2) or  (hc >= 33 + X2_Cat2 and hc <= 39 + X2_Cat2) 	or  (hc >= 51 + X2_Cat2 and hc <= 57 + X2_Cat2)) and (vc >= 20 + Y2_Cat1 and vc <  30 + Y2_Cat1))  	or
			(((hc >= 21 + X2_Cat2 and hc <  33 + X2_Cat2) or  (hc >  39 + X2_Cat2 and hc <= 51 + X2_Cat2))	and (vc >= 30 + Y2_Cat1 and vc <= 40 + Y2_Cat1)) or 
			(((hc >  3  + X2_Cat2 and hc <  9  + X2_Cat2) or  (hc >  15 + X2_Cat2 and hc <  57 + X2_Cat2) 	or  (hc >  63 + X2_Cat2 and hc <  69 + X2_Cat2)) and (vc >  40 + Y2_Cat1 and vc <  50 + Y2_Cat1)) 	or
			(((hc >  3  + X2_Cat2 and hc <  21 + X2_Cat2) or  (hc >  27 + X2_Cat2 and hc <  45 + X2_Cat2) 	or  (hc >  51 + X2_Cat2 and hc <  69 + X2_Cat2)) and (vc >= 50 + Y2_Cat1 and vc <= 60 + Y2_Cat1))	or
			 ((hc >= 15 + X2_Cat2 and hc <= 57 + X2_Cat2) and (vc >  60 + Y2_Cat1 and vc <  70 + Y2_Cat1))	or
			(((hc >  9  + X2_Cat2 and hc <  15 + X2_Cat2) or  (hc >= 21 + X2_Cat2 and hc <  27 + X2_Cat2)	or	(hc >= 33 + X2_Cat2 and hc <  39 + X2_Cat2)	 or	 (hc >= 45 + X2_Cat2 and hc <  51 + X2_Cat2)	or	(hc > 57 + X2_Cat2 and hc < 63 + X2_Cat2))	and (vc >= 70 + Y2_Cat1 and vc <= 80 + Y2_Cat1)) or
			(((hc >  9  + X2_Cat2 and hc <  15 + X2_Cat2) or  (hc >  57 + X2_Cat2 and hc <  63 + X2_Cat2))  and (vc >  80 + Y2_Cat1 and vc <  90 + Y2_Cat1)) or
			(((hc >= 15 + X2_Cat2 and hc <= 21 + X2_Cat2) or  (hc >= 51 + X2_Cat2 and hc <= 57 + X2_Cat2)) 	and (vc >= 90 + Y2_Cat1 and vc < 100 + Y2_Cat1)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and M2_21 = 1 and Winner = 0) then
			red <= "0000";
			blue <= "0100";
			green <= "1110";
			
		-- Printed cat graphic 5x5(3,1)	
		elsif((((hc >= 33 + X2_Cat3 and hc <= 39 + X2_Cat3) and (vc >= 10 + Y2_Cat1 and vc <= 20 + Y2_Cat1)) or
			(((hc >= 15 + X2_Cat3 and hc <= 21 + X2_Cat3) or  (hc >= 33 + X2_Cat3 and hc <= 39 + X2_Cat3) 	or  (hc >= 51 + X2_Cat3 and hc <= 57 + X2_Cat3)) and (vc >= 20 + Y2_Cat1 and vc <  30 + Y2_Cat1))  	or
			(((hc >= 21 + X2_Cat3 and hc <  33 + X2_Cat3) or  (hc >  39 + X2_Cat3 and hc <= 51 + X2_Cat3))	and (vc >= 30 + Y2_Cat1 and vc <= 40 + Y2_Cat1)) or 
			(((hc >  3  + X2_Cat3 and hc <  9  + X2_Cat3) or  (hc >  15 + X2_Cat3 and hc <  57 + X2_Cat3) 	or  (hc >  63 + X2_Cat3 and hc <  69 + X2_Cat3)) and (vc >  40 + Y2_Cat1 and vc <  50 + Y2_Cat1)) 	or
			(((hc >  3  + X2_Cat3 and hc <  21 + X2_Cat3) or  (hc >  27 + X2_Cat3 and hc <  45 + X2_Cat3) 	or  (hc >  51 + X2_Cat3 and hc <  69 + X2_Cat3)) and (vc >= 50 + Y2_Cat1 and vc <= 60 + Y2_Cat1))	or
			 ((hc >= 15 + X2_Cat3 and hc <= 57 + X2_Cat3) and (vc >  60 + Y2_Cat1 and vc <  70 + Y2_Cat1))	or
			(((hc >  9  + X2_Cat3 and hc <  15 + X2_Cat3) or  (hc >= 21 + X2_Cat3 and hc <  27 + X2_Cat3)	or	(hc >= 33 + X2_Cat3 and hc <  39 + X2_Cat3)	 or	 (hc >= 45 + X2_Cat3 and hc <  51 + X2_Cat3)	or	(hc > 57 + X2_Cat3 and hc < 63 + X2_Cat3))	and (vc >= 70 + Y2_Cat1 and vc <= 80 + Y2_Cat1)) or
			(((hc >  9  + X2_Cat3 and hc <  15 + X2_Cat3) or  (hc >  57 + X2_Cat3 and hc <  63 + X2_Cat3))  and (vc >  80 + Y2_Cat1 and vc <  90 + Y2_Cat1)) or
			(((hc >= 15 + X2_Cat3 and hc <= 21 + X2_Cat3) or  (hc >= 51 + X2_Cat3 and hc <= 57 + X2_Cat3)) 	and (vc >= 90 + Y2_Cat1 and vc < 100 + Y2_Cat1)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and M2_31 = 1 and Winner = 0) then
			red <= "0000";
			blue <= "0100";
			green <= "1110";
			
		-- Printed cat graphic 5x5(4,1)	
		elsif((((hc >= 33 + X2_Cat4 and hc <= 39 + X2_Cat4) and (vc >= 10 + Y2_Cat1 and vc <= 20 + Y2_Cat1)) or
			(((hc >= 15 + X2_Cat4 and hc <= 21 + X2_Cat4) or  (hc >= 33 + X2_Cat4 and hc <= 39 + X2_Cat4) 	or  (hc >= 51 + X2_Cat4 and hc <= 57 + X2_Cat4)) and (vc >= 20 + Y2_Cat1 and vc <  30 + Y2_Cat1))  	or
			(((hc >= 21 + X2_Cat4 and hc <  33 + X2_Cat4) or  (hc >  39 + X2_Cat4 and hc <= 51 + X2_Cat4))	and (vc >= 30 + Y2_Cat1 and vc <= 40 + Y2_Cat1)) or 
			(((hc >  3  + X2_Cat4 and hc <  9  + X2_Cat4) or  (hc >  15 + X2_Cat4 and hc <  57 + X2_Cat4) 	or  (hc >  63 + X2_Cat4 and hc <  69 + X2_Cat4)) and (vc >  40 + Y2_Cat1 and vc <  50 + Y2_Cat1)) 	or
			(((hc >  3  + X2_Cat4 and hc <  21 + X2_Cat4) or  (hc >  27 + X2_Cat4 and hc <  45 + X2_Cat4) 	or  (hc >  51 + X2_Cat4 and hc <  69 + X2_Cat4)) and (vc >= 50 + Y2_Cat1 and vc <= 60 + Y2_Cat1))	or
			 ((hc >= 15 + X2_Cat4 and hc <= 57 + X2_Cat4) and (vc >  60 + Y2_Cat1 and vc <  70 + Y2_Cat1))	or
			(((hc >  9  + X2_Cat4 and hc <  15 + X2_Cat4) or  (hc >= 21 + X2_Cat4 and hc <  27 + X2_Cat4)	or	(hc >= 33 + X2_Cat4 and hc <  39 + X2_Cat4)	 or	 (hc >= 45 + X2_Cat4 and hc <  51 + X2_Cat4)	or	(hc > 57 + X2_Cat4 and hc < 63 + X2_Cat4))	and (vc >= 70 + Y2_Cat1 and vc <= 80 + Y2_Cat1)) or
			(((hc >  9  + X2_Cat4 and hc <  15 + X2_Cat4) or  (hc >  57 + X2_Cat4 and hc <  63 + X2_Cat4))  and (vc >  80 + Y2_Cat1 and vc <  90 + Y2_Cat1)) or
			(((hc >= 15 + X2_Cat4 and hc <= 21 + X2_Cat4) or  (hc >= 51 + X2_Cat4 and hc <= 57 + X2_Cat4)) 	and (vc >= 90 + Y2_Cat1 and vc < 100 + Y2_Cat1)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and M2_41 = 1 and Winner = 0) then
			red <= "0000";
			blue <= "0100";
			green <= "1110";
			
		-- Printed cat graphic 5x5(5,1)	
		elsif((((hc >= 33 + X2_Cat5 and hc <= 39 + X2_Cat5) and (vc >= 10 + Y2_Cat1 and vc <= 20 + Y2_Cat1)) or
			(((hc >= 15 + X2_Cat5 and hc <= 21 + X2_Cat5) or  (hc >= 33 + X2_Cat5 and hc <= 39 + X2_Cat5) 	or  (hc >= 51 + X2_Cat5 and hc <= 57 + X2_Cat5)) and (vc >= 20 + Y2_Cat1 and vc <  30 + Y2_Cat1))  	or
			(((hc >= 21 + X2_Cat5 and hc <  33 + X2_Cat5) or  (hc >  39 + X2_Cat5 and hc <= 51 + X2_Cat5))	and (vc >= 30 + Y2_Cat1 and vc <= 40 + Y2_Cat1)) or 
			(((hc >  3  + X2_Cat5 and hc <  9  + X2_Cat5) or  (hc >  15 + X2_Cat5 and hc <  57 + X2_Cat5) 	or  (hc >  63 + X2_Cat5 and hc <  69 + X2_Cat5)) and (vc >  40 + Y2_Cat1 and vc <  50 + Y2_Cat1)) 	or
			(((hc >  3  + X2_Cat5 and hc <  21 + X2_Cat5) or  (hc >  27 + X2_Cat5 and hc <  45 + X2_Cat5) 	or  (hc >  51 + X2_Cat5 and hc <  69 + X2_Cat5)) and (vc >= 50 + Y2_Cat1 and vc <= 60 + Y2_Cat1))	or
			 ((hc >= 15 + X2_Cat5 and hc <= 57 + X2_Cat5) and (vc >  60 + Y2_Cat1 and vc <  70 + Y2_Cat1))	or
			(((hc >  9  + X2_Cat5 and hc <  15 + X2_Cat5) or  (hc >= 21 + X2_Cat5 and hc <  27 + X2_Cat5)	or	(hc >= 33 + X2_Cat5 and hc <  39 + X2_Cat5)	 or	 (hc >= 45 + X2_Cat5 and hc <  51 + X2_Cat5)	or	(hc > 57 + X2_Cat5 and hc < 63 + X2_Cat5))	and (vc >= 70 + Y2_Cat1 and vc <= 80 + Y2_Cat1)) or
			(((hc >  9  + X2_Cat5 and hc <  15 + X2_Cat5) or  (hc >  57 + X2_Cat5 and hc <  63 + X2_Cat5))  and (vc >  80 + Y2_Cat1 and vc <  90 + Y2_Cat1)) or
			(((hc >= 15 + X2_Cat5 and hc <= 21 + X2_Cat5) or  (hc >= 51 + X2_Cat5 and hc <= 57 + X2_Cat5)) 	and (vc >= 90 + Y2_Cat1 and vc < 100 + Y2_Cat1)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and M2_51 = 1 and Winner = 0) then
			red <= "0000";
			blue <= "0100";
			green <= "1110";
			
		-- Printed cat graphic 5x5(1,2)	
		elsif((((hc >= 33 + X2_Cat1 and hc <= 39 + X2_Cat1) and (vc >= 10 + Y2_Cat2 and vc <= 20 + Y2_Cat2)) or
			(((hc >= 15 + X2_Cat1 and hc <= 21 + X2_Cat1) or  (hc >= 33 + X2_Cat1 and hc <= 39 + X2_Cat1) 	or  (hc >= 51 + X2_Cat1 and hc <= 57 + X2_Cat1)) and (vc >= 20 + Y2_Cat2 and vc <  30 + Y2_Cat2))  	or
			(((hc >= 21 + X2_Cat1 and hc <  33 + X2_Cat1) or  (hc >  39 + X2_Cat1 and hc <= 51 + X2_Cat1))	and (vc >= 30 + Y2_Cat2 and vc <= 40 + Y2_Cat2)) or 
			(((hc >  3  + X2_Cat1 and hc <  9  + X2_Cat1) or  (hc >  15 + X2_Cat1 and hc <  57 + X2_Cat1) 	or  (hc >  63 + X2_Cat1 and hc <  69 + X2_Cat1)) and (vc >  40 + Y2_Cat2 and vc <  50 + Y2_Cat2)) 	or
			(((hc >  3  + X2_Cat1 and hc <  21 + X2_Cat1) or  (hc >  27 + X2_Cat1 and hc <  45 + X2_Cat1) 	or  (hc >  51 + X2_Cat1 and hc <  69 + X2_Cat1)) and (vc >= 50 + Y2_Cat2 and vc <= 60 + Y2_Cat2))	or
			 ((hc >= 15 + X2_Cat1 and hc <= 57 + X2_Cat1) and (vc >  60 + Y2_Cat2 and vc <  70 + Y2_Cat2))	or
			(((hc >  9  + X2_Cat1 and hc <  15 + X2_Cat1) or  (hc >= 21 + X2_Cat1 and hc <  27 + X2_Cat1)	or	(hc >= 33 + X2_Cat1 and hc <  39 + X2_Cat1)	 or	 (hc >= 45 + X2_Cat1 and hc <  51 + X2_Cat1)	or	(hc > 57 + X2_Cat1 and hc < 63 + X2_Cat1))	and (vc >= 70 + Y2_Cat2 and vc <= 80 + Y2_Cat2)) or
			(((hc >  9  + X2_Cat1 and hc <  15 + X2_Cat1) or  (hc >  57 + X2_Cat1 and hc <  63 + X2_Cat1))  and (vc >  80 + Y2_Cat2 and vc <  90 + Y2_Cat2)) or
			(((hc >= 15 + X2_Cat1 and hc <= 21 + X2_Cat1) or  (hc >= 51 + X2_Cat1 and hc <= 57 + X2_Cat1)) 	and (vc >= 90 + Y2_Cat2 and vc < 100 + Y2_Cat2)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and M2_12 = 1 and Winner = 0) then
			red <= "0000";
			blue <= "0100";
			green <= "1110";
			
		-- Printed cat graphic 5x5(2,2)	
		elsif((((hc >= 33 + X2_Cat2 and hc <= 39 + X2_Cat2) and (vc >= 10 + Y2_Cat2 and vc <= 20 + Y2_Cat2)) or
			(((hc >= 15 + X2_Cat2 and hc <= 21 + X2_Cat2) or  (hc >= 33 + X2_Cat2 and hc <= 39 + X2_Cat2) 	or  (hc >= 51 + X2_Cat2 and hc <= 57 + X2_Cat2)) and (vc >= 20 + Y2_Cat2 and vc <  30 + Y2_Cat2))  	or
			(((hc >= 21 + X2_Cat2 and hc <  33 + X2_Cat2) or  (hc >  39 + X2_Cat2 and hc <= 51 + X2_Cat2))	and (vc >= 30 + Y2_Cat2 and vc <= 40 + Y2_Cat2)) or 
			(((hc >  3  + X2_Cat2 and hc <  9  + X2_Cat2) or  (hc >  15 + X2_Cat2 and hc <  57 + X2_Cat2) 	or  (hc >  63 + X2_Cat2 and hc <  69 + X2_Cat2)) and (vc >  40 + Y2_Cat2 and vc <  50 + Y2_Cat2)) 	or
			(((hc >  3  + X2_Cat2 and hc <  21 + X2_Cat2) or  (hc >  27 + X2_Cat2 and hc <  45 + X2_Cat2) 	or  (hc >  51 + X2_Cat2 and hc <  69 + X2_Cat2)) and (vc >= 50 + Y2_Cat2 and vc <= 60 + Y2_Cat2))	or
			 ((hc >= 15 + X2_Cat2 and hc <= 57 + X2_Cat2) and (vc >  60 + Y2_Cat2 and vc <  70 + Y2_Cat2))	or
			(((hc >  9  + X2_Cat2 and hc <  15 + X2_Cat2) or  (hc >= 21 + X2_Cat2 and hc <  27 + X2_Cat2)	or	(hc >= 33 + X2_Cat2 and hc <  39 + X2_Cat2)	 or	 (hc >= 45 + X2_Cat2 and hc <  51 + X2_Cat2)	or	(hc > 57 + X2_Cat2 and hc < 63 + X2_Cat2))	and (vc >= 70 + Y2_Cat2 and vc <= 80 + Y2_Cat2)) or
			(((hc >  9  + X2_Cat2 and hc <  15 + X2_Cat2) or  (hc >  57 + X2_Cat2 and hc <  63 + X2_Cat2))  and (vc >  80 + Y2_Cat2 and vc <  90 + Y2_Cat2)) or
			(((hc >= 15 + X2_Cat2 and hc <= 21 + X2_Cat2) or  (hc >= 51 + X2_Cat2 and hc <= 57 + X2_Cat2)) 	and (vc >= 90 + Y2_Cat2 and vc < 100 + Y2_Cat2)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and M2_22 = 1 and Winner = 0) then
			red <= "0000";
			blue <= "0100";
			green <= "1110";
			
		-- Printed cat graphic 5x5(3,2)	
		elsif((((hc >= 33 + X2_Cat3 and hc <= 39 + X2_Cat3) and (vc >= 10 + Y2_Cat2 and vc <= 20 + Y2_Cat2)) or
			(((hc >= 15 + X2_Cat3 and hc <= 21 + X2_Cat3) or  (hc >= 33 + X2_Cat3 and hc <= 39 + X2_Cat3) 	or  (hc >= 51 + X2_Cat3 and hc <= 57 + X2_Cat3)) and (vc >= 20 + Y2_Cat2 and vc <  30 + Y2_Cat2))  	or
			(((hc >= 21 + X2_Cat3 and hc <  33 + X2_Cat3) or  (hc >  39 + X2_Cat3 and hc <= 51 + X2_Cat3))	and (vc >= 30 + Y2_Cat2 and vc <= 40 + Y2_Cat2)) or 
			(((hc >  3  + X2_Cat3 and hc <  9  + X2_Cat3) or  (hc >  15 + X2_Cat3 and hc <  57 + X2_Cat3) 	or  (hc >  63 + X2_Cat3 and hc <  69 + X2_Cat3)) and (vc >  40 + Y2_Cat2 and vc <  50 + Y2_Cat2)) 	or
			(((hc >  3  + X2_Cat3 and hc <  21 + X2_Cat3) or  (hc >  27 + X2_Cat3 and hc <  45 + X2_Cat3) 	or  (hc >  51 + X2_Cat3 and hc <  69 + X2_Cat3)) and (vc >= 50 + Y2_Cat2 and vc <= 60 + Y2_Cat2))	or
			 ((hc >= 15 + X2_Cat3 and hc <= 57 + X2_Cat3) and (vc >  60 + Y2_Cat2 and vc <  70 + Y2_Cat2))	or
			(((hc >  9  + X2_Cat3 and hc <  15 + X2_Cat3) or  (hc >= 21 + X2_Cat3 and hc <  27 + X2_Cat3)	or	(hc >= 33 + X2_Cat3 and hc <  39 + X2_Cat3)	 or	 (hc >= 45 + X2_Cat3 and hc <  51 + X2_Cat3)	or	(hc > 57 + X2_Cat3 and hc < 63 + X2_Cat3))	and (vc >= 70 + Y2_Cat2 and vc <= 80 + Y2_Cat2)) or
			(((hc >  9  + X2_Cat3 and hc <  15 + X2_Cat3) or  (hc >  57 + X2_Cat3 and hc <  63 + X2_Cat3))  and (vc >  80 + Y2_Cat2 and vc <  90 + Y2_Cat2)) or
			(((hc >= 15 + X2_Cat3 and hc <= 21 + X2_Cat3) or  (hc >= 51 + X2_Cat3 and hc <= 57 + X2_Cat3)) 	and (vc >= 90 + Y2_Cat2 and vc < 100 + Y2_Cat2)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and M2_32 = 1 and Winner = 0) then
			red <= "0000";
			blue <= "0100";
			green <= "1110";
			
		-- Printed cat graphic 5x5(4,2)	
		elsif((((hc >= 33 + X2_Cat4 and hc <= 39 + X2_Cat4) and (vc >= 10 + Y2_Cat2 and vc <= 20 + Y2_Cat2)) or
			(((hc >= 15 + X2_Cat4 and hc <= 21 + X2_Cat4) or  (hc >= 33 + X2_Cat4 and hc <= 39 + X2_Cat4) 	or  (hc >= 51 + X2_Cat4 and hc <= 57 + X2_Cat4)) and (vc >= 20 + Y2_Cat2 and vc <  30 + Y2_Cat2))  	or
			(((hc >= 21 + X2_Cat4 and hc <  33 + X2_Cat4) or  (hc >  39 + X2_Cat4 and hc <= 51 + X2_Cat4))	and (vc >= 30 + Y2_Cat2 and vc <= 40 + Y2_Cat2)) or 
			(((hc >  3  + X2_Cat4 and hc <  9  + X2_Cat4) or  (hc >  15 + X2_Cat4 and hc <  57 + X2_Cat4) 	or  (hc >  63 + X2_Cat4 and hc <  69 + X2_Cat4)) and (vc >  40 + Y2_Cat2 and vc <  50 + Y2_Cat2)) 	or
			(((hc >  3  + X2_Cat4 and hc <  21 + X2_Cat4) or  (hc >  27 + X2_Cat4 and hc <  45 + X2_Cat4) 	or  (hc >  51 + X2_Cat4 and hc <  69 + X2_Cat4)) and (vc >= 50 + Y2_Cat2 and vc <= 60 + Y2_Cat2))	or
			 ((hc >= 15 + X2_Cat4 and hc <= 57 + X2_Cat4) and (vc >  60 + Y2_Cat2 and vc <  70 + Y2_Cat2))	or
			(((hc >  9  + X2_Cat4 and hc <  15 + X2_Cat4) or  (hc >= 21 + X2_Cat4 and hc <  27 + X2_Cat4)	or	(hc >= 33 + X2_Cat4 and hc <  39 + X2_Cat4)	 or	 (hc >= 45 + X2_Cat4 and hc <  51 + X2_Cat4)	or	(hc > 57 + X2_Cat4 and hc < 63 + X2_Cat4))	and (vc >= 70 + Y2_Cat2 and vc <= 80 + Y2_Cat2)) or
			(((hc >  9  + X2_Cat4 and hc <  15 + X2_Cat4) or  (hc >  57 + X2_Cat4 and hc <  63 + X2_Cat4))  and (vc >  80 + Y2_Cat2 and vc <  90 + Y2_Cat2)) or
			(((hc >= 15 + X2_Cat4 and hc <= 21 + X2_Cat4) or  (hc >= 51 + X2_Cat4 and hc <= 57 + X2_Cat4)) 	and (vc >= 90 + Y2_Cat2 and vc < 100 + Y2_Cat2)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and M2_42 = 1 and Winner = 0) then
			red <= "0000";
			blue <= "0100";
			green <= "1110";
			
		-- Printed cat graphic 5x5(5,2)	
		elsif((((hc >= 33 + X2_Cat5 and hc <= 39 + X2_Cat5) and (vc >= 10 + Y2_Cat2 and vc <= 20 + Y2_Cat2)) or
			(((hc >= 15 + X2_Cat5 and hc <= 21 + X2_Cat5) or  (hc >= 33 + X2_Cat5 and hc <= 39 + X2_Cat5) 	or  (hc >= 51 + X2_Cat5 and hc <= 57 + X2_Cat5)) and (vc >= 20 + Y2_Cat2 and vc <  30 + Y2_Cat2))  	or
			(((hc >= 21 + X2_Cat5 and hc <  33 + X2_Cat5) or  (hc >  39 + X2_Cat5 and hc <= 51 + X2_Cat5))	and (vc >= 30 + Y2_Cat2 and vc <= 40 + Y2_Cat2)) or 
			(((hc >  3  + X2_Cat5 and hc <  9  + X2_Cat5) or  (hc >  15 + X2_Cat5 and hc <  57 + X2_Cat5) 	or  (hc >  63 + X2_Cat5 and hc <  69 + X2_Cat5)) and (vc >  40 + Y2_Cat2 and vc <  50 + Y2_Cat2)) 	or
			(((hc >  3  + X2_Cat5 and hc <  21 + X2_Cat5) or  (hc >  27 + X2_Cat5 and hc <  45 + X2_Cat5) 	or  (hc >  51 + X2_Cat5 and hc <  69 + X2_Cat5)) and (vc >= 50 + Y2_Cat2 and vc <= 60 + Y2_Cat2))	or
			 ((hc >= 15 + X2_Cat5 and hc <= 57 + X2_Cat5) and (vc >  60 + Y2_Cat2 and vc <  70 + Y2_Cat2))	or
			(((hc >  9  + X2_Cat5 and hc <  15 + X2_Cat5) or  (hc >= 21 + X2_Cat5 and hc <  27 + X2_Cat5)	or	(hc >= 33 + X2_Cat5 and hc <  39 + X2_Cat5)	 or	 (hc >= 45 + X2_Cat5 and hc <  51 + X2_Cat5)	or	(hc > 57 + X2_Cat5 and hc < 63 + X2_Cat5))	and (vc >= 70 + Y2_Cat2 and vc <= 80 + Y2_Cat2)) or
			(((hc >  9  + X2_Cat5 and hc <  15 + X2_Cat5) or  (hc >  57 + X2_Cat5 and hc <  63 + X2_Cat5))  and (vc >  80 + Y2_Cat2 and vc <  90 + Y2_Cat2)) or
			(((hc >= 15 + X2_Cat5 and hc <= 21 + X2_Cat5) or  (hc >= 51 + X2_Cat5 and hc <= 57 + X2_Cat5)) 	and (vc >= 90 + Y2_Cat2 and vc < 100 + Y2_Cat2)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and M2_52 = 1 and Winner = 0) then
			red <= "0000";
			blue <= "0100";
			green <= "1110"; 
			
		-- Printed cat graphic 5x5(1,3)	
		elsif((((hc >= 33 + X2_Cat1 and hc <= 39 + X2_Cat1) and (vc >= 10 + Y2_Cat3 and vc <= 20 + Y2_Cat3)) or
			(((hc >= 15 + X2_Cat1 and hc <= 21 + X2_Cat1) or  (hc >= 33 + X2_Cat1 and hc <= 39 + X2_Cat1) 	or  (hc >= 51 + X2_Cat1 and hc <= 57 + X2_Cat1)) and (vc >= 20 + Y2_Cat3 and vc <  30 + Y2_Cat3))  	or
			(((hc >= 21 + X2_Cat1 and hc <  33 + X2_Cat1) or  (hc >  39 + X2_Cat1 and hc <= 51 + X2_Cat1))	and (vc >= 30 + Y2_Cat3 and vc <= 40 + Y2_Cat3)) or 
			(((hc >  3  + X2_Cat1 and hc <  9  + X2_Cat1) or  (hc >  15 + X2_Cat1 and hc <  57 + X2_Cat1) 	or  (hc >  63 + X2_Cat1 and hc <  69 + X2_Cat1)) and (vc >  40 + Y2_Cat3 and vc <  50 + Y2_Cat3)) 	or
			(((hc >  3  + X2_Cat1 and hc <  21 + X2_Cat1) or  (hc >  27 + X2_Cat1 and hc <  45 + X2_Cat1) 	or  (hc >  51 + X2_Cat1 and hc <  69 + X2_Cat1)) and (vc >= 50 + Y2_Cat3 and vc <= 60 + Y2_Cat3))	or
			 ((hc >= 15 + X2_Cat1 and hc <= 57 + X2_Cat1) and (vc >  60 + Y2_Cat3 and vc <  70 + Y2_Cat3))	or
			(((hc >  9  + X2_Cat1 and hc <  15 + X2_Cat1) or  (hc >= 21 + X2_Cat1 and hc <  27 + X2_Cat1)	or	(hc >= 33 + X2_Cat1 and hc <  39 + X2_Cat1)	 or	 (hc >= 45 + X2_Cat1 and hc <  51 + X2_Cat1)	or	(hc > 57 + X2_Cat1 and hc < 63 + X2_Cat1))	and (vc >= 70 + Y2_Cat3 and vc <= 80 + Y2_Cat3)) or
			(((hc >  9  + X2_Cat1 and hc <  15 + X2_Cat1) or  (hc >  57 + X2_Cat1 and hc <  63 + X2_Cat1))  and (vc >  80 + Y2_Cat3 and vc <  90 + Y2_Cat3)) or
			(((hc >= 15 + X2_Cat1 and hc <= 21 + X2_Cat1) or  (hc >= 51 + X2_Cat1 and hc <= 57 + X2_Cat1)) 	and (vc >= 90 + Y2_Cat3 and vc < 100 + Y2_Cat3)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and M2_13 = 1 and Winner = 0) then
			red <= "0000";
			blue <= "0100";
			green <= "1110";
			
		-- Printed cat graphic 5x5(2,3)	
		elsif((((hc >= 33 + X2_Cat2 and hc <= 39 + X2_Cat2) and (vc >= 10 + Y2_Cat3 and vc <= 20 + Y2_Cat3)) or
			(((hc >= 15 + X2_Cat2 and hc <= 21 + X2_Cat2) or  (hc >= 33 + X2_Cat2 and hc <= 39 + X2_Cat2) 	or  (hc >= 51 + X2_Cat2 and hc <= 57 + X2_Cat2)) and (vc >= 20 + Y2_Cat3 and vc <  30 + Y2_Cat3))  	or
			(((hc >= 21 + X2_Cat2 and hc <  33 + X2_Cat2) or  (hc >  39 + X2_Cat2 and hc <= 51 + X2_Cat2))	and (vc >= 30 + Y2_Cat3 and vc <= 40 + Y2_Cat3)) or 
			(((hc >  3  + X2_Cat2 and hc <  9  + X2_Cat2) or  (hc >  15 + X2_Cat2 and hc <  57 + X2_Cat2) 	or  (hc >  63 + X2_Cat2 and hc <  69 + X2_Cat2)) and (vc >  40 + Y2_Cat3 and vc <  50 + Y2_Cat3)) 	or
			(((hc >  3  + X2_Cat2 and hc <  21 + X2_Cat2) or  (hc >  27 + X2_Cat2 and hc <  45 + X2_Cat2) 	or  (hc >  51 + X2_Cat2 and hc <  69 + X2_Cat2)) and (vc >= 50 + Y2_Cat3 and vc <= 60 + Y2_Cat3))	or
			 ((hc >= 15 + X2_Cat2 and hc <= 57 + X2_Cat2) and (vc >  60 + Y2_Cat3 and vc <  70 + Y2_Cat3))	or
			(((hc >  9  + X2_Cat2 and hc <  15 + X2_Cat2) or  (hc >= 21 + X2_Cat2 and hc <  27 + X2_Cat2)	or	(hc >= 33 + X2_Cat2 and hc <  39 + X2_Cat2)	 or	 (hc >= 45 + X2_Cat2 and hc <  51 + X2_Cat2)	or	(hc > 57 + X2_Cat2 and hc < 63 + X2_Cat2))	and (vc >= 70 + Y2_Cat3 and vc <= 80 + Y2_Cat3)) or
			(((hc >  9  + X2_Cat2 and hc <  15 + X2_Cat2) or  (hc >  57 + X2_Cat2 and hc <  63 + X2_Cat2))  and (vc >  80 + Y2_Cat3 and vc <  90 + Y2_Cat3)) or
			(((hc >= 15 + X2_Cat2 and hc <= 21 + X2_Cat2) or  (hc >= 51 + X2_Cat2 and hc <= 57 + X2_Cat2)) 	and (vc >= 90 + Y2_Cat3 and vc < 100 + Y2_Cat3)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and M2_23 = 1 and Winner = 0) then
			red <= "0000";
			blue <= "0100";
			green <= "1110";
			
		-- Printed cat graphic 5x5(3,3)	
		elsif((((hc >= 33 + X2_Cat3 and hc <= 39 + X2_Cat3) and (vc >= 10 + Y2_Cat3 and vc <= 20 + Y2_Cat3)) or
			(((hc >= 15 + X2_Cat3 and hc <= 21 + X2_Cat3) or  (hc >= 33 + X2_Cat3 and hc <= 39 + X2_Cat3) 	or  (hc >= 51 + X2_Cat3 and hc <= 57 + X2_Cat3)) and (vc >= 20 + Y2_Cat3 and vc <  30 + Y2_Cat3))  	or
			(((hc >= 21 + X2_Cat3 and hc <  33 + X2_Cat3) or  (hc >  39 + X2_Cat3 and hc <= 51 + X2_Cat3))	and (vc >= 30 + Y2_Cat3 and vc <= 40 + Y2_Cat3)) or 
			(((hc >  3  + X2_Cat3 and hc <  9  + X2_Cat3) or  (hc >  15 + X2_Cat3 and hc <  57 + X2_Cat3) 	or  (hc >  63 + X2_Cat3 and hc <  69 + X2_Cat3)) and (vc >  40 + Y2_Cat3 and vc <  50 + Y2_Cat3)) 	or
			(((hc >  3  + X2_Cat3 and hc <  21 + X2_Cat3) or  (hc >  27 + X2_Cat3 and hc <  45 + X2_Cat3) 	or  (hc >  51 + X2_Cat3 and hc <  69 + X2_Cat3)) and (vc >= 50 + Y2_Cat3 and vc <= 60 + Y2_Cat3))	or
			 ((hc >= 15 + X2_Cat3 and hc <= 57 + X2_Cat3) and (vc >  60 + Y2_Cat3 and vc <  70 + Y2_Cat3))	or
			(((hc >  9  + X2_Cat3 and hc <  15 + X2_Cat3) or  (hc >= 21 + X2_Cat3 and hc <  27 + X2_Cat3)	or	(hc >= 33 + X2_Cat3 and hc <  39 + X2_Cat3)	 or	 (hc >= 45 + X2_Cat3 and hc <  51 + X2_Cat3)	or	(hc > 57 + X2_Cat3 and hc < 63 + X2_Cat3))	and (vc >= 70 + Y2_Cat3 and vc <= 80 + Y2_Cat3)) or
			(((hc >  9  + X2_Cat3 and hc <  15 + X2_Cat3) or  (hc >  57 + X2_Cat3 and hc <  63 + X2_Cat3))  and (vc >  80 + Y2_Cat3 and vc <  90 + Y2_Cat3)) or
			(((hc >= 15 + X2_Cat3 and hc <= 21 + X2_Cat3) or  (hc >= 51 + X2_Cat3 and hc <= 57 + X2_Cat3)) 	and (vc >= 90 + Y2_Cat3 and vc < 100 + Y2_Cat3)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and M2_33 = 1 and Winner = 0) then
			red <= "0000";
			blue <= "0100";
			green <= "1110";
			
		-- Printed cat graphic 5x5(4,3)	
		elsif((((hc >= 33 + X2_Cat4 and hc <= 39 + X2_Cat4) and (vc >= 10 + Y2_Cat3 and vc <= 20 + Y2_Cat3)) or
			(((hc >= 15 + X2_Cat4 and hc <= 21 + X2_Cat4) or  (hc >= 33 + X2_Cat4 and hc <= 39 + X2_Cat4) 	or  (hc >= 51 + X2_Cat4 and hc <= 57 + X2_Cat4)) and (vc >= 20 + Y2_Cat3 and vc <  30 + Y2_Cat3))  	or
			(((hc >= 21 + X2_Cat4 and hc <  33 + X2_Cat4) or  (hc >  39 + X2_Cat4 and hc <= 51 + X2_Cat4))	and (vc >= 30 + Y2_Cat3 and vc <= 40 + Y2_Cat3)) or 
			(((hc >  3  + X2_Cat4 and hc <  9  + X2_Cat4) or  (hc >  15 + X2_Cat4 and hc <  57 + X2_Cat4) 	or  (hc >  63 + X2_Cat4 and hc <  69 + X2_Cat4)) and (vc >  40 + Y2_Cat3 and vc <  50 + Y2_Cat3)) 	or
			(((hc >  3  + X2_Cat4 and hc <  21 + X2_Cat4) or  (hc >  27 + X2_Cat4 and hc <  45 + X2_Cat4) 	or  (hc >  51 + X2_Cat4 and hc <  69 + X2_Cat4)) and (vc >= 50 + Y2_Cat3 and vc <= 60 + Y2_Cat3))	or
			 ((hc >= 15 + X2_Cat4 and hc <= 57 + X2_Cat4) and (vc >  60 + Y2_Cat3 and vc <  70 + Y2_Cat3))	or
			(((hc >  9  + X2_Cat4 and hc <  15 + X2_Cat4) or  (hc >= 21 + X2_Cat4 and hc <  27 + X2_Cat4)	or	(hc >= 33 + X2_Cat4 and hc <  39 + X2_Cat4)	 or	 (hc >= 45 + X2_Cat4 and hc <  51 + X2_Cat4)	or	(hc > 57 + X2_Cat4 and hc < 63 + X2_Cat4))	and (vc >= 70 + Y2_Cat3 and vc <= 80 + Y2_Cat3)) or
			(((hc >  9  + X2_Cat4 and hc <  15 + X2_Cat4) or  (hc >  57 + X2_Cat4 and hc <  63 + X2_Cat4))  and (vc >  80 + Y2_Cat3 and vc <  90 + Y2_Cat3)) or
			(((hc >= 15 + X2_Cat4 and hc <= 21 + X2_Cat4) or  (hc >= 51 + X2_Cat4 and hc <= 57 + X2_Cat4)) 	and (vc >= 90 + Y2_Cat3 and vc < 100 + Y2_Cat3)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and M2_43 = 1 and Winner = 0) then
			red <= "0000";
			blue <= "0100";
			green <= "1110";
			
		-- Printed cat graphic 5x5(5,3)	
		elsif((((hc >= 33 + X2_Cat5 and hc <= 39 + X2_Cat5) and (vc >= 10 + Y2_Cat3 and vc <= 20 + Y2_Cat3)) or
			(((hc >= 15 + X2_Cat5 and hc <= 21 + X2_Cat5) or  (hc >= 33 + X2_Cat5 and hc <= 39 + X2_Cat5) 	or  (hc >= 51 + X2_Cat5 and hc <= 57 + X2_Cat5)) and (vc >= 20 + Y2_Cat3 and vc <  30 + Y2_Cat3))  	or
			(((hc >= 21 + X2_Cat5 and hc <  33 + X2_Cat5) or  (hc >  39 + X2_Cat5 and hc <= 51 + X2_Cat5))	and (vc >= 30 + Y2_Cat3 and vc <= 40 + Y2_Cat3)) or 
			(((hc >  3  + X2_Cat5 and hc <  9  + X2_Cat5) or  (hc >  15 + X2_Cat5 and hc <  57 + X2_Cat5) 	or  (hc >  63 + X2_Cat5 and hc <  69 + X2_Cat5)) and (vc >  40 + Y2_Cat3 and vc <  50 + Y2_Cat3)) 	or
			(((hc >  3  + X2_Cat5 and hc <  21 + X2_Cat5) or  (hc >  27 + X2_Cat5 and hc <  45 + X2_Cat5) 	or  (hc >  51 + X2_Cat5 and hc <  69 + X2_Cat5)) and (vc >= 50 + Y2_Cat3 and vc <= 60 + Y2_Cat3))	or
			 ((hc >= 15 + X2_Cat5 and hc <= 57 + X2_Cat5) and (vc >  60 + Y2_Cat3 and vc <  70 + Y2_Cat3))	or
			(((hc >  9  + X2_Cat5 and hc <  15 + X2_Cat5) or  (hc >= 21 + X2_Cat5 and hc <  27 + X2_Cat5)	or	(hc >= 33 + X2_Cat5 and hc <  39 + X2_Cat5)	 or	 (hc >= 45 + X2_Cat5 and hc <  51 + X2_Cat5)	or	(hc > 57 + X2_Cat5 and hc < 63 + X2_Cat5))	and (vc >= 70 + Y2_Cat3 and vc <= 80 + Y2_Cat3)) or
			(((hc >  9  + X2_Cat5 and hc <  15 + X2_Cat5) or  (hc >  57 + X2_Cat5 and hc <  63 + X2_Cat5))  and (vc >  80 + Y2_Cat3 and vc <  90 + Y2_Cat3)) or
			(((hc >= 15 + X2_Cat5 and hc <= 21 + X2_Cat5) or  (hc >= 51 + X2_Cat5 and hc <= 57 + X2_Cat5)) 	and (vc >= 90 + Y2_Cat3 and vc < 100 + Y2_Cat3)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and M2_53 = 1 and Winner = 0) then
			red <= "0000";
			blue <= "0100";
			green <= "1110";
			
		-- Printed cat graphic 5x5(1,4)	
		elsif((((hc >= 33 + X2_Cat1 and hc <= 39 + X2_Cat1) and (vc >= 10 + Y2_Cat4 and vc <= 20 + Y2_Cat4)) or
			(((hc >= 15 + X2_Cat1 and hc <= 21 + X2_Cat1) or  (hc >= 33 + X2_Cat1 and hc <= 39 + X2_Cat1) 	or  (hc >= 51 + X2_Cat1 and hc <= 57 + X2_Cat1)) and (vc >= 20 + Y2_Cat4 and vc <  30 + Y2_Cat4))  	or
			(((hc >= 21 + X2_Cat1 and hc <  33 + X2_Cat1) or  (hc >  39 + X2_Cat1 and hc <= 51 + X2_Cat1))	and (vc >= 30 + Y2_Cat4 and vc <= 40 + Y2_Cat4)) or 
			(((hc >  3  + X2_Cat1 and hc <  9  + X2_Cat1) or  (hc >  15 + X2_Cat1 and hc <  57 + X2_Cat1) 	or  (hc >  63 + X2_Cat1 and hc <  69 + X2_Cat1)) and (vc >  40 + Y2_Cat4 and vc <  50 + Y2_Cat4)) 	or
			(((hc >  3  + X2_Cat1 and hc <  21 + X2_Cat1) or  (hc >  27 + X2_Cat1 and hc <  45 + X2_Cat1) 	or  (hc >  51 + X2_Cat1 and hc <  69 + X2_Cat1)) and (vc >= 50 + Y2_Cat4 and vc <= 60 + Y2_Cat4))	or
			 ((hc >= 15 + X2_Cat1 and hc <= 57 + X2_Cat1) and (vc >  60 + Y2_Cat4 and vc <  70 + Y2_Cat4))	or
			(((hc >  9  + X2_Cat1 and hc <  15 + X2_Cat1) or  (hc >= 21 + X2_Cat1 and hc <  27 + X2_Cat1)	or	(hc >= 33 + X2_Cat1 and hc <  39 + X2_Cat1)	 or	 (hc >= 45 + X2_Cat1 and hc <  51 + X2_Cat1)	or	(hc > 57 + X2_Cat1 and hc < 63 + X2_Cat1))	and (vc >= 70 + Y2_Cat4 and vc <= 80 + Y2_Cat4)) or
			(((hc >  9  + X2_Cat1 and hc <  15 + X2_Cat1) or  (hc >  57 + X2_Cat1 and hc <  63 + X2_Cat1))  and (vc >  80 + Y2_Cat4 and vc <  90 + Y2_Cat4)) or
			(((hc >= 15 + X2_Cat1 and hc <= 21 + X2_Cat1) or  (hc >= 51 + X2_Cat1 and hc <= 57 + X2_Cat1)) 	and (vc >= 90 + Y2_Cat4 and vc < 100 + Y2_Cat4)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and M2_14 = 1 and Winner = 0) then
			red <= "0000";
			blue <= "0100";
			green <= "1110";
			
		-- Printed cat graphic 5x5(2,4)	
		elsif((((hc >= 33 + X2_Cat2 and hc <= 39 + X2_Cat2) and (vc >= 10 + Y2_Cat4 and vc <= 20 + Y2_Cat4)) or
			(((hc >= 15 + X2_Cat2 and hc <= 21 + X2_Cat2) or  (hc >= 33 + X2_Cat2 and hc <= 39 + X2_Cat2) 	or  (hc >= 51 + X2_Cat2 and hc <= 57 + X2_Cat2)) and (vc >= 20 + Y2_Cat4 and vc <  30 + Y2_Cat4))  	or
			(((hc >= 21 + X2_Cat2 and hc <  33 + X2_Cat2) or  (hc >  39 + X2_Cat2 and hc <= 51 + X2_Cat2))	and (vc >= 30 + Y2_Cat4 and vc <= 40 + Y2_Cat4)) or 
			(((hc >  3  + X2_Cat2 and hc <  9  + X2_Cat2) or  (hc >  15 + X2_Cat2 and hc <  57 + X2_Cat2) 	or  (hc >  63 + X2_Cat2 and hc <  69 + X2_Cat2)) and (vc >  40 + Y2_Cat4 and vc <  50 + Y2_Cat4)) 	or
			(((hc >  3  + X2_Cat2 and hc <  21 + X2_Cat2) or  (hc >  27 + X2_Cat2 and hc <  45 + X2_Cat2) 	or  (hc >  51 + X2_Cat2 and hc <  69 + X2_Cat2)) and (vc >= 50 + Y2_Cat4 and vc <= 60 + Y2_Cat4))	or
			 ((hc >= 15 + X2_Cat2 and hc <= 57 + X2_Cat2) and (vc >  60 + Y2_Cat4 and vc <  70 + Y2_Cat4))	or
			(((hc >  9  + X2_Cat2 and hc <  15 + X2_Cat2) or  (hc >= 21 + X2_Cat2 and hc <  27 + X2_Cat2)	or	(hc >= 33 + X2_Cat2 and hc <  39 + X2_Cat2)	 or	 (hc >= 45 + X2_Cat2 and hc <  51 + X2_Cat2)	or	(hc > 57 + X2_Cat2 and hc < 63 + X2_Cat2))	and (vc >= 70 + Y2_Cat4 and vc <= 80 + Y2_Cat4)) or
			(((hc >  9  + X2_Cat2 and hc <  15 + X2_Cat2) or  (hc >  57 + X2_Cat2 and hc <  63 + X2_Cat2))  and (vc >  80 + Y2_Cat4 and vc <  90 + Y2_Cat4)) or
			(((hc >= 15 + X2_Cat2 and hc <= 21 + X2_Cat2) or  (hc >= 51 + X2_Cat2 and hc <= 57 + X2_Cat2)) 	and (vc >= 90 + Y2_Cat4 and vc < 100 + Y2_Cat4)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and M2_24 = 1 and Winner = 0) then
			red <= "0000";
			blue <= "0100";
			green <= "1110";
			
		-- Printed cat graphic 5x5(3,4)	
		elsif((((hc >= 33 + X2_Cat3 and hc <= 39 + X2_Cat3) and (vc >= 10 + Y2_Cat4 and vc <= 20 + Y2_Cat4)) or
			(((hc >= 15 + X2_Cat3 and hc <= 21 + X2_Cat3) or  (hc >= 33 + X2_Cat3 and hc <= 39 + X2_Cat3) 	or  (hc >= 51 + X2_Cat3 and hc <= 57 + X2_Cat3)) and (vc >= 20 + Y2_Cat4 and vc <  30 + Y2_Cat4))  	or
			(((hc >= 21 + X2_Cat3 and hc <  33 + X2_Cat3) or  (hc >  39 + X2_Cat3 and hc <= 51 + X2_Cat3))	and (vc >= 30 + Y2_Cat4 and vc <= 40 + Y2_Cat4)) or 
			(((hc >  3  + X2_Cat3 and hc <  9  + X2_Cat3) or  (hc >  15 + X2_Cat3 and hc <  57 + X2_Cat3) 	or  (hc >  63 + X2_Cat3 and hc <  69 + X2_Cat3)) and (vc >  40 + Y2_Cat4 and vc <  50 + Y2_Cat4)) 	or
			(((hc >  3  + X2_Cat3 and hc <  21 + X2_Cat3) or  (hc >  27 + X2_Cat3 and hc <  45 + X2_Cat3) 	or  (hc >  51 + X2_Cat3 and hc <  69 + X2_Cat3)) and (vc >= 50 + Y2_Cat4 and vc <= 60 + Y2_Cat4))	or
			 ((hc >= 15 + X2_Cat3 and hc <= 57 + X2_Cat3) and (vc >  60 + Y2_Cat4 and vc <  70 + Y2_Cat4))	or
			(((hc >  9  + X2_Cat3 and hc <  15 + X2_Cat3) or  (hc >= 21 + X2_Cat3 and hc <  27 + X2_Cat3)	or	(hc >= 33 + X2_Cat3 and hc <  39 + X2_Cat3)	 or	 (hc >= 45 + X2_Cat3 and hc <  51 + X2_Cat3)	or	(hc > 57 + X2_Cat3 and hc < 63 + X2_Cat3))	and (vc >= 70 + Y2_Cat4 and vc <= 80 + Y2_Cat4)) or
			(((hc >  9  + X2_Cat3 and hc <  15 + X2_Cat3) or  (hc >  57 + X2_Cat3 and hc <  63 + X2_Cat3))  and (vc >  80 + Y2_Cat4 and vc <  90 + Y2_Cat4)) or
			(((hc >= 15 + X2_Cat3 and hc <= 21 + X2_Cat3) or  (hc >= 51 + X2_Cat3 and hc <= 57 + X2_Cat3)) 	and (vc >= 90 + Y2_Cat4 and vc < 100 + Y2_Cat4)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and M2_34 = 1 and Winner = 0) then
			red <= "0000";
			blue <= "0100";
			green <= "1110";
			
		-- Printed cat graphic 5x5(4,4)	
		elsif((((hc >= 33 + X2_Cat4 and hc <= 39 + X2_Cat4) and (vc >= 10 + Y2_Cat4 and vc <= 20 + Y2_Cat4)) or
			(((hc >= 15 + X2_Cat4 and hc <= 21 + X2_Cat4) or  (hc >= 33 + X2_Cat4 and hc <= 39 + X2_Cat4) 	or  (hc >= 51 + X2_Cat4 and hc <= 57 + X2_Cat4)) and (vc >= 20 + Y2_Cat4 and vc <  30 + Y2_Cat4))  	or
			(((hc >= 21 + X2_Cat4 and hc <  33 + X2_Cat4) or  (hc >  39 + X2_Cat4 and hc <= 51 + X2_Cat4))	and (vc >= 30 + Y2_Cat4 and vc <= 40 + Y2_Cat4)) or 
			(((hc >  3  + X2_Cat4 and hc <  9  + X2_Cat4) or  (hc >  15 + X2_Cat4 and hc <  57 + X2_Cat4) 	or  (hc >  63 + X2_Cat4 and hc <  69 + X2_Cat4)) and (vc >  40 + Y2_Cat4 and vc <  50 + Y2_Cat4)) 	or
			(((hc >  3  + X2_Cat4 and hc <  21 + X2_Cat4) or  (hc >  27 + X2_Cat4 and hc <  45 + X2_Cat4) 	or  (hc >  51 + X2_Cat4 and hc <  69 + X2_Cat4)) and (vc >= 50 + Y2_Cat4 and vc <= 60 + Y2_Cat4))	or
			 ((hc >= 15 + X2_Cat4 and hc <= 57 + X2_Cat4) and (vc >  60 + Y2_Cat4 and vc <  70 + Y2_Cat4))	or
			(((hc >  9  + X2_Cat4 and hc <  15 + X2_Cat4) or  (hc >= 21 + X2_Cat4 and hc <  27 + X2_Cat4)	or	(hc >= 33 + X2_Cat4 and hc <  39 + X2_Cat4)	 or	 (hc >= 45 + X2_Cat4 and hc <  51 + X2_Cat4)	or	(hc > 57 + X2_Cat4 and hc < 63 + X2_Cat4))	and (vc >= 70 + Y2_Cat4 and vc <= 80 + Y2_Cat4)) or
			(((hc >  9  + X2_Cat4 and hc <  15 + X2_Cat4) or  (hc >  57 + X2_Cat4 and hc <  63 + X2_Cat4))  and (vc >  80 + Y2_Cat4 and vc <  90 + Y2_Cat4)) or
			(((hc >= 15 + X2_Cat4 and hc <= 21 + X2_Cat4) or  (hc >= 51 + X2_Cat4 and hc <= 57 + X2_Cat4)) 	and (vc >= 90 + Y2_Cat4 and vc < 100 + Y2_Cat4)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and M2_44 = 1 and Winner = 0) then
			red <= "0000";
			blue <= "0100";
			green <= "1110";
			
		-- Printed cat graphic 5x5(5,4)	
		elsif((((hc >= 33 + X2_Cat5 and hc <= 39 + X2_Cat5) and (vc >= 10 + Y2_Cat4 and vc <= 20 + Y2_Cat4)) or
			(((hc >= 15 + X2_Cat5 and hc <= 21 + X2_Cat5) or  (hc >= 33 + X2_Cat5 and hc <= 39 + X2_Cat5) 	or  (hc >= 51 + X2_Cat5 and hc <= 57 + X2_Cat5)) and (vc >= 20 + Y2_Cat4 and vc <  30 + Y2_Cat4))  	or
			(((hc >= 21 + X2_Cat5 and hc <  33 + X2_Cat5) or  (hc >  39 + X2_Cat5 and hc <= 51 + X2_Cat5))	and (vc >= 30 + Y2_Cat4 and vc <= 40 + Y2_Cat4)) or 
			(((hc >  3  + X2_Cat5 and hc <  9  + X2_Cat5) or  (hc >  15 + X2_Cat5 and hc <  57 + X2_Cat5) 	or  (hc >  63 + X2_Cat5 and hc <  69 + X2_Cat5)) and (vc >  40 + Y2_Cat4 and vc <  50 + Y2_Cat4)) 	or
			(((hc >  3  + X2_Cat5 and hc <  21 + X2_Cat5) or  (hc >  27 + X2_Cat5 and hc <  45 + X2_Cat5) 	or  (hc >  51 + X2_Cat5 and hc <  69 + X2_Cat5)) and (vc >= 50 + Y2_Cat4 and vc <= 60 + Y2_Cat4))	or
			 ((hc >= 15 + X2_Cat5 and hc <= 57 + X2_Cat5) and (vc >  60 + Y2_Cat4 and vc <  70 + Y2_Cat4))	or
			(((hc >  9  + X2_Cat5 and hc <  15 + X2_Cat5) or  (hc >= 21 + X2_Cat5 and hc <  27 + X2_Cat5)	or	(hc >= 33 + X2_Cat5 and hc <  39 + X2_Cat5)	 or	 (hc >= 45 + X2_Cat5 and hc <  51 + X2_Cat5)	or	(hc > 57 + X2_Cat5 and hc < 63 + X2_Cat5))	and (vc >= 70 + Y2_Cat4 and vc <= 80 + Y2_Cat4)) or
			(((hc >  9  + X2_Cat5 and hc <  15 + X2_Cat5) or  (hc >  57 + X2_Cat5 and hc <  63 + X2_Cat5))  and (vc >  80 + Y2_Cat4 and vc <  90 + Y2_Cat4)) or
			(((hc >= 15 + X2_Cat5 and hc <= 21 + X2_Cat5) or  (hc >= 51 + X2_Cat5 and hc <= 57 + X2_Cat5)) 	and (vc >= 90 + Y2_Cat4 and vc < 100 + Y2_Cat4)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and M2_54 = 1 and Winner = 0) then
			red <= "0000";
			blue <= "0100";
			green <= "1110";
			
		-- Printed cat graphic 5x5(1,5)	
		elsif((((hc >= 33 + X2_Cat1 and hc <= 39 + X2_Cat1) and (vc >= 10 + Y2_Cat5 and vc <= 20 + Y2_Cat5)) or
			(((hc >= 15 + X2_Cat1 and hc <= 21 + X2_Cat1) or  (hc >= 33 + X2_Cat1 and hc <= 39 + X2_Cat1) 	or  (hc >= 51 + X2_Cat1 and hc <= 57 + X2_Cat1)) and (vc >= 20 + Y2_Cat5 and vc <  30 + Y2_Cat5))  	or
			(((hc >= 21 + X2_Cat1 and hc <  33 + X2_Cat1) or  (hc >  39 + X2_Cat1 and hc <= 51 + X2_Cat1))	and (vc >= 30 + Y2_Cat5 and vc <= 40 + Y2_Cat5)) or 
			(((hc >  3  + X2_Cat1 and hc <  9  + X2_Cat1) or  (hc >  15 + X2_Cat1 and hc <  57 + X2_Cat1) 	or  (hc >  63 + X2_Cat1 and hc <  69 + X2_Cat1)) and (vc >  40 + Y2_Cat5 and vc <  50 + Y2_Cat5)) 	or
			(((hc >  3  + X2_Cat1 and hc <  21 + X2_Cat1) or  (hc >  27 + X2_Cat1 and hc <  45 + X2_Cat1) 	or  (hc >  51 + X2_Cat1 and hc <  69 + X2_Cat1)) and (vc >= 50 + Y2_Cat5 and vc <= 60 + Y2_Cat5))	or
			 ((hc >= 15 + X2_Cat1 and hc <= 57 + X2_Cat1) and (vc >  60 + Y2_Cat5 and vc <  70 + Y2_Cat5))	or
			(((hc >  9  + X2_Cat1 and hc <  15 + X2_Cat1) or  (hc >= 21 + X2_Cat1 and hc <  27 + X2_Cat1)	or	(hc >= 33 + X2_Cat1 and hc <  39 + X2_Cat1)	 or	 (hc >= 45 + X2_Cat1 and hc <  51 + X2_Cat1)	or	(hc > 57 + X2_Cat1 and hc < 63 + X2_Cat1))	and (vc >= 70 + Y2_Cat5 and vc <= 80 + Y2_Cat5)) or
			(((hc >  9  + X2_Cat1 and hc <  15 + X2_Cat1) or  (hc >  57 + X2_Cat1 and hc <  63 + X2_Cat1))  and (vc >  80 + Y2_Cat5 and vc <  90 + Y2_Cat5)) or
			(((hc >= 15 + X2_Cat1 and hc <= 21 + X2_Cat1) or  (hc >= 51 + X2_Cat1 and hc <= 57 + X2_Cat1)) 	and (vc >= 90 + Y2_Cat5 and vc < 100 + Y2_Cat5)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and M2_15 = 1 and Winner = 0) then
			red <= "0000";
			blue <= "0100";
			green <= "1110";
			
		-- Printed cat graphic 5x5(2,4)	
		elsif((((hc >= 33 + X2_Cat2 and hc <= 39 + X2_Cat2) and (vc >= 10 + Y2_Cat5 and vc <= 20 + Y2_Cat5)) or
			(((hc >= 15 + X2_Cat2 and hc <= 21 + X2_Cat2) or  (hc >= 33 + X2_Cat2 and hc <= 39 + X2_Cat2) 	or  (hc >= 51 + X2_Cat2 and hc <= 57 + X2_Cat2)) and (vc >= 20 + Y2_Cat5 and vc <  30 + Y2_Cat5))  	or
			(((hc >= 21 + X2_Cat2 and hc <  33 + X2_Cat2) or  (hc >  39 + X2_Cat2 and hc <= 51 + X2_Cat2))	and (vc >= 30 + Y2_Cat5 and vc <= 40 + Y2_Cat5)) or 
			(((hc >  3  + X2_Cat2 and hc <  9  + X2_Cat2) or  (hc >  15 + X2_Cat2 and hc <  57 + X2_Cat2) 	or  (hc >  63 + X2_Cat2 and hc <  69 + X2_Cat2)) and (vc >  40 + Y2_Cat5 and vc <  50 + Y2_Cat5)) 	or
			(((hc >  3  + X2_Cat2 and hc <  21 + X2_Cat2) or  (hc >  27 + X2_Cat2 and hc <  45 + X2_Cat2) 	or  (hc >  51 + X2_Cat2 and hc <  69 + X2_Cat2)) and (vc >= 50 + Y2_Cat5 and vc <= 60 + Y2_Cat5))	or
			 ((hc >= 15 + X2_Cat2 and hc <= 57 + X2_Cat2) and (vc >  60 + Y2_Cat5 and vc <  70 + Y2_Cat5))	or
			(((hc >  9  + X2_Cat2 and hc <  15 + X2_Cat2) or  (hc >= 21 + X2_Cat2 and hc <  27 + X2_Cat2)	or	(hc >= 33 + X2_Cat2 and hc <  39 + X2_Cat2)	 or	 (hc >= 45 + X2_Cat2 and hc <  51 + X2_Cat2)	or	(hc > 57 + X2_Cat2 and hc < 63 + X2_Cat2))	and (vc >= 70 + Y2_Cat5 and vc <= 80 + Y2_Cat5)) or
			(((hc >  9  + X2_Cat2 and hc <  15 + X2_Cat2) or  (hc >  57 + X2_Cat2 and hc <  63 + X2_Cat2))  and (vc >  80 + Y2_Cat5 and vc <  90 + Y2_Cat5)) or
			(((hc >= 15 + X2_Cat2 and hc <= 21 + X2_Cat2) or  (hc >= 51 + X2_Cat2 and hc <= 57 + X2_Cat2)) 	and (vc >= 90 + Y2_Cat5 and vc < 100 + Y2_Cat5)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and M2_25 = 1 and Winner = 0) then
			red <= "0000";
			blue <= "0100";
			green <= "1110";
			
		-- Printed cat graphic 5x5(3,5)	
		elsif((((hc >= 33 + X2_Cat3 and hc <= 39 + X2_Cat3) and (vc >= 10 + Y2_Cat5 and vc <= 20 + Y2_Cat5)) or
			(((hc >= 15 + X2_Cat3 and hc <= 21 + X2_Cat3) or  (hc >= 33 + X2_Cat3 and hc <= 39 + X2_Cat3) 	or  (hc >= 51 + X2_Cat3 and hc <= 57 + X2_Cat3)) and (vc >= 20 + Y2_Cat5 and vc <  30 + Y2_Cat5))  	or
			(((hc >= 21 + X2_Cat3 and hc <  33 + X2_Cat3) or  (hc >  39 + X2_Cat3 and hc <= 51 + X2_Cat3))	and (vc >= 30 + Y2_Cat5 and vc <= 40 + Y2_Cat5)) or 
			(((hc >  3  + X2_Cat3 and hc <  9  + X2_Cat3) or  (hc >  15 + X2_Cat3 and hc <  57 + X2_Cat3) 	or  (hc >  63 + X2_Cat3 and hc <  69 + X2_Cat3)) and (vc >  40 + Y2_Cat5 and vc <  50 + Y2_Cat5)) 	or
			(((hc >  3  + X2_Cat3 and hc <  21 + X2_Cat3) or  (hc >  27 + X2_Cat3 and hc <  45 + X2_Cat3) 	or  (hc >  51 + X2_Cat3 and hc <  69 + X2_Cat3)) and (vc >= 50 + Y2_Cat5 and vc <= 60 + Y2_Cat5))	or
			 ((hc >= 15 + X2_Cat3 and hc <= 57 + X2_Cat3) and (vc >  60 + Y2_Cat5 and vc <  70 + Y2_Cat5))	or
			(((hc >  9  + X2_Cat3 and hc <  15 + X2_Cat3) or  (hc >= 21 + X2_Cat3 and hc <  27 + X2_Cat3)	or	(hc >= 33 + X2_Cat3 and hc <  39 + X2_Cat3)	 or	 (hc >= 45 + X2_Cat3 and hc <  51 + X2_Cat3)	or	(hc > 57 + X2_Cat3 and hc < 63 + X2_Cat3))	and (vc >= 70 + Y2_Cat5 and vc <= 80 + Y2_Cat5)) or
			(((hc >  9  + X2_Cat3 and hc <  15 + X2_Cat3) or  (hc >  57 + X2_Cat3 and hc <  63 + X2_Cat3))  and (vc >  80 + Y2_Cat5 and vc <  90 + Y2_Cat5)) or
			(((hc >= 15 + X2_Cat3 and hc <= 21 + X2_Cat3) or  (hc >= 51 + X2_Cat3 and hc <= 57 + X2_Cat3)) 	and (vc >= 90 + Y2_Cat5 and vc < 100 + Y2_Cat5)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and M2_35 = 1 and Winner = 0) then
			red <= "0000";
			blue <= "0100";
			green <= "1110";
			
		-- Printed cat graphic 5x5(4,5)	
		elsif((((hc >= 33 + X2_Cat4 and hc <= 39 + X2_Cat4) and (vc >= 10 + Y2_Cat5 and vc <= 20 + Y2_Cat5)) or
			(((hc >= 15 + X2_Cat4 and hc <= 21 + X2_Cat4) or  (hc >= 33 + X2_Cat4 and hc <= 39 + X2_Cat4) 	or  (hc >= 51 + X2_Cat4 and hc <= 57 + X2_Cat4)) and (vc >= 20 + Y2_Cat5 and vc <  30 + Y2_Cat5))  	or
			(((hc >= 21 + X2_Cat4 and hc <  33 + X2_Cat4) or  (hc >  39 + X2_Cat4 and hc <= 51 + X2_Cat4))	and (vc >= 30 + Y2_Cat5 and vc <= 40 + Y2_Cat5)) or 
			(((hc >  3  + X2_Cat4 and hc <  9  + X2_Cat4) or  (hc >  15 + X2_Cat4 and hc <  57 + X2_Cat4) 	or  (hc >  63 + X2_Cat4 and hc <  69 + X2_Cat4)) and (vc >  40 + Y2_Cat5 and vc <  50 + Y2_Cat5)) 	or
			(((hc >  3  + X2_Cat4 and hc <  21 + X2_Cat4) or  (hc >  27 + X2_Cat4 and hc <  45 + X2_Cat4) 	or  (hc >  51 + X2_Cat4 and hc <  69 + X2_Cat4)) and (vc >= 50 + Y2_Cat5 and vc <= 60 + Y2_Cat5))	or
			 ((hc >= 15 + X2_Cat4 and hc <= 57 + X2_Cat4) and (vc >  60 + Y2_Cat5 and vc <  70 + Y2_Cat5))	or
			(((hc >  9  + X2_Cat4 and hc <  15 + X2_Cat4) or  (hc >= 21 + X2_Cat4 and hc <  27 + X2_Cat4)	or	(hc >= 33 + X2_Cat4 and hc <  39 + X2_Cat4)	 or	 (hc >= 45 + X2_Cat4 and hc <  51 + X2_Cat4)	or	(hc > 57 + X2_Cat4 and hc < 63 + X2_Cat4))	and (vc >= 70 + Y2_Cat5 and vc <= 80 + Y2_Cat5)) or
			(((hc >  9  + X2_Cat4 and hc <  15 + X2_Cat4) or  (hc >  57 + X2_Cat4 and hc <  63 + X2_Cat4))  and (vc >  80 + Y2_Cat5 and vc <  90 + Y2_Cat5)) or
			(((hc >= 15 + X2_Cat4 and hc <= 21 + X2_Cat4) or  (hc >= 51 + X2_Cat4 and hc <= 57 + X2_Cat4)) 	and (vc >= 90 + Y2_Cat5 and vc < 100 + Y2_Cat5)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and M2_45 = 1 and Winner = 0) then
			red <= "0000";
			blue <= "0100";
			green <= "1110";
			
		-- Printed cat graphic 5x5(5,5)	
		elsif((((hc >= 33 + X2_Cat5 and hc <= 39 + X2_Cat5) and (vc >= 10 + Y2_Cat5 and vc <= 20 + Y2_Cat5)) or
			(((hc >= 15 + X2_Cat5 and hc <= 21 + X2_Cat5) or  (hc >= 33 + X2_Cat5 and hc <= 39 + X2_Cat5) 	or  (hc >= 51 + X2_Cat5 and hc <= 57 + X2_Cat5)) and (vc >= 20 + Y2_Cat5 and vc <  30 + Y2_Cat5))  	or
			(((hc >= 21 + X2_Cat5 and hc <  33 + X2_Cat5) or  (hc >  39 + X2_Cat5 and hc <= 51 + X2_Cat5))	and (vc >= 30 + Y2_Cat5 and vc <= 40 + Y2_Cat5)) or 
			(((hc >  3  + X2_Cat5 and hc <  9  + X2_Cat5) or  (hc >  15 + X2_Cat5 and hc <  57 + X2_Cat5) 	or  (hc >  63 + X2_Cat5 and hc <  69 + X2_Cat5)) and (vc >  40 + Y2_Cat5 and vc <  50 + Y2_Cat5)) 	or
			(((hc >  3  + X2_Cat5 and hc <  21 + X2_Cat5) or  (hc >  27 + X2_Cat5 and hc <  45 + X2_Cat5) 	or  (hc >  51 + X2_Cat5 and hc <  69 + X2_Cat5)) and (vc >= 50 + Y2_Cat5 and vc <= 60 + Y2_Cat5))	or
			 ((hc >= 15 + X2_Cat5 and hc <= 57 + X2_Cat5) and (vc >  60 + Y2_Cat5 and vc <  70 + Y2_Cat5))	or
			(((hc >  9  + X2_Cat5 and hc <  15 + X2_Cat5) or  (hc >= 21 + X2_Cat5 and hc <  27 + X2_Cat5)	or	(hc >= 33 + X2_Cat5 and hc <  39 + X2_Cat5)	 or	 (hc >= 45 + X2_Cat5 and hc <  51 + X2_Cat5)	or	(hc > 57 + X2_Cat5 and hc < 63 + X2_Cat5))	and (vc >= 70 + Y2_Cat5 and vc <= 80 + Y2_Cat5)) or
			(((hc >  9  + X2_Cat5 and hc <  15 + X2_Cat5) or  (hc >  57 + X2_Cat5 and hc <  63 + X2_Cat5))  and (vc >  80 + Y2_Cat5 and vc <  90 + Y2_Cat5)) or
			(((hc >= 15 + X2_Cat5 and hc <= 21 + X2_Cat5) or  (hc >= 51 + X2_Cat5 and hc <= 57 + X2_Cat5)) 	and (vc >= 90 + Y2_Cat5 and vc < 100 + Y2_Cat5)))
			and videoON = '1' and juego25 = '1' and juego9 = '0' and M2_55 = 1 and Winner = 0) then
			red <= "0000";
			blue <= "0100";
			green <= "1110";
		
		-- Winner Player 1 5x5	
		elsif(((((hc >= X_Winner and hc <= 10 +  X_Winner) or (hc >= 40 +  X_Winner and hc <= 50 +  X_Winner)) and (vc >= Y_Winner and vc <= 20 + Y_Winner)) or
			(((hc >= X_Winner and hc <= 10 +  X_Winner) or  (hc >= 40 +  X_Winner and hc <= 50 +  X_Winner))	and (vc >= 20 + Y_Winner and vc <= 40 + Y_Winner))  or
			(((hc >= X_Winner and hc <= 10 +  X_Winner) or  (hc >= 40 +  X_Winner and hc <= 50 +  X_Winner)	or	(hc >= 60 +  X_Winner and hc <= 70 +  X_Winner)		or	(hc >= 80 +  X_Winner and hc <= 90 +  X_Winner)		or	(hc >= 100 +  X_Winner and hc <= 110 +  X_Winner)	or	(hc >= 130 +  X_Winner and hc <= 140 +  X_Winner)	or	(hc >= 150 +  X_Winner and hc <= 160 +  X_Winner)	or	(hc >= 190 +  X_Winner and hc <= 210 +  X_Winner)	or	(hc >= 230 +  X_Winner and hc <= 240 +  X_Winner)	or	(hc >= 250 +  X_Winner and hc <= 260 +  X_Winner)) 	and (vc >= 40 + Y_Winner and vc <= 60 + Y_Winner))  or 
			(((hc >= X_Winner and hc <= 10 +  X_Winner) or  (hc >= 40 +  X_Winner and hc <= 50 +  X_Winner)	or	(hc >= 80 +  X_Winner and hc <= 100 +  X_Winner)	or	(hc >= 110 +  X_Winner and hc <= 120 +  X_Winner)	or	(hc >= 130 +  X_Winner and hc <= 150 +  X_Winner)	or	(hc >= 160 +  X_Winner and hc <= 170 +  X_Winner)	or	(hc >= 180 +  X_Winner and hc <= 190 +  X_Winner)	or	(hc >= 210 +  X_Winner and hc <= 220 +  X_Winner)	or	(hc >= 230 +  X_Winner and hc <= 250 +  X_Winner)) 	and (vc >= 60 + Y_Winner and vc <= 80 + Y_Winner))  or 
			(((hc >= X_Winner and hc <= 10 +  X_Winner) or  (hc >= 40 +  X_Winner and hc <= 50 +  X_Winner)	or	(hc >= 60 +  X_Winner and hc <= 70 +  X_Winner)		or	(hc >= 80 +  X_Winner and hc <= 90 +  X_Winner)		or	(hc >= 110 +  X_Winner and hc <= 120 +  X_Winner)	or	(hc >= 130 +  X_Winner and hc <= 140 +  X_Winner)	or	(hc >= 160 +  X_Winner and hc <= 170 +  X_Winner)	or	(hc >= 180 +  X_Winner and hc <= 220 +  X_Winner)	or	(hc >= 230 +  X_Winner and hc <= 240 +  X_Winner)) 	and (vc >= 80 + Y_Winner and vc <= 100 + Y_Winner))  or 
			(((hc >= X_Winner and hc <= 10 +  X_Winner) or  (hc >= 20 +  X_Winner and hc <= 30 +  X_Winner)	or	(hc >= 40 +  X_Winner and hc <= 50 +  X_Winner)		or	(hc >= 60 +  X_Winner and hc <= 70 +  X_Winner)		or	(hc >= 80 +  X_Winner and hc <= 90 +  X_Winner)		or	(hc >= 110 +  X_Winner and hc <= 120 +  X_Winner)	or	(hc >= 130 +  X_Winner and hc <= 140 +  X_Winner)	or	(hc >= 160 +  X_Winner and hc <= 170 +  X_Winner)	or	(hc >= 180 +  X_Winner and hc <= 190 +  X_Winner)	or	(hc >= 230 +  X_Winner and hc <= 240 +  X_Winner)) 	and (vc >= 100 + Y_Winner and vc <= 120 + Y_Winner))  or 
			(((hc >= X_Winner and hc <= 20 +  X_Winner) or  (hc >= 30 +  X_Winner and hc <= 50 +  X_Winner)	or	(hc >= 60 +  X_Winner and hc <= 70 +  X_Winner)		or	(hc >= 80 +  X_Winner and hc <= 90 +  X_Winner)		or	(hc >= 110 +  X_Winner and hc <= 120 +  X_Winner)	or	(hc >= 130 +  X_Winner and hc <= 140 +  X_Winner)	or	(hc >= 160 +  X_Winner and hc <= 170 +  X_Winner)	or	(hc >= 180 +  X_Winner and hc <= 190 +  X_Winner)	or	(hc >= 210 +  X_Winner and hc <= 220 +  X_Winner)	or	(hc >= 230 +  X_Winner and hc <= 240 +  X_Winner)) 	and (vc >= 120 + Y_Winner and vc <= 140 + Y_Winner))  or 
			(((hc >= X_Winner and hc <= 10 +  X_Winner) or  (hc >= 40 +  X_Winner and hc <= 50 +  X_Winner)	or	(hc >= 60 +  X_Winner and hc <= 70 +  X_Winner)		or	(hc >= 80 +  X_Winner and hc <= 90 +  X_Winner)		or	(hc >= 110 +  X_Winner and hc <= 120 +  X_Winner)	or	(hc >= 130 +  X_Winner and hc <= 140 +  X_Winner)	or	(hc >= 160 +  X_Winner and hc <= 170 +  X_Winner)	or	(hc >= 190 +  X_Winner and hc <= 220 +  X_Winner)	or	(hc >= 230 +  X_Winner and hc <= 240 +  X_Winner)) 	and (vc >= 140 + Y_Winner and vc <= 160 + Y_Winner)))	
			and videoON = '1' and Winner > 0 and Winner <= 1 and juego9 = '0' and juego25 = '1') then
			red <= "1111";
			blue <= "0000";
			green <= "1111";
		-- Winner Player 2 5x5		
		elsif(((((hc >= X_Winner and hc <= 10 +  X_Winner) or (hc >= 40 +  X_Winner and hc <= 50 +  X_Winner)) and (vc >= Y_Winner and vc <= 20 + Y_Winner)) or
			(((hc >= X_Winner and hc <= 10 +  X_Winner) or  (hc >= 40 +  X_Winner and hc <= 50 +  X_Winner))	and (vc >= 20 + Y_Winner and vc <= 40 + Y_Winner))  or
			(((hc >= X_Winner and hc <= 10 +  X_Winner) or  (hc >= 40 +  X_Winner and hc <= 50 +  X_Winner)	or	(hc >= 60 +  X_Winner and hc <= 70 +  X_Winner)		or	(hc >= 80 +  X_Winner and hc <= 90 +  X_Winner)		or	(hc >= 100 +  X_Winner and hc <= 110 +  X_Winner)	or	(hc >= 130 +  X_Winner and hc <= 140 +  X_Winner)	or	(hc >= 150 +  X_Winner and hc <= 160 +  X_Winner)	or	(hc >= 190 +  X_Winner and hc <= 210 +  X_Winner)	or	(hc >= 230 +  X_Winner and hc <= 240 +  X_Winner)	or	(hc >= 250 +  X_Winner and hc <= 260 +  X_Winner)) 	and (vc >= 40 + Y_Winner and vc <= 60 + Y_Winner))  or 
			(((hc >= X_Winner and hc <= 10 +  X_Winner) or  (hc >= 40 +  X_Winner and hc <= 50 +  X_Winner)	or	(hc >= 80 +  X_Winner and hc <= 100 +  X_Winner)	or	(hc >= 110 +  X_Winner and hc <= 120 +  X_Winner)	or	(hc >= 130 +  X_Winner and hc <= 150 +  X_Winner)	or	(hc >= 160 +  X_Winner and hc <= 170 +  X_Winner)	or	(hc >= 180 +  X_Winner and hc <= 190 +  X_Winner)	or	(hc >= 210 +  X_Winner and hc <= 220 +  X_Winner)	or	(hc >= 230 +  X_Winner and hc <= 250 +  X_Winner)) 	and (vc >= 60 + Y_Winner and vc <= 80 + Y_Winner))  or 
			(((hc >= X_Winner and hc <= 10 +  X_Winner) or  (hc >= 40 +  X_Winner and hc <= 50 +  X_Winner)	or	(hc >= 60 +  X_Winner and hc <= 70 +  X_Winner)		or	(hc >= 80 +  X_Winner and hc <= 90 +  X_Winner)		or	(hc >= 110 +  X_Winner and hc <= 120 +  X_Winner)	or	(hc >= 130 +  X_Winner and hc <= 140 +  X_Winner)	or	(hc >= 160 +  X_Winner and hc <= 170 +  X_Winner)	or	(hc >= 180 +  X_Winner and hc <= 220 +  X_Winner)	or	(hc >= 230 +  X_Winner and hc <= 240 +  X_Winner)) 	and (vc >= 80 + Y_Winner and vc <= 100 + Y_Winner))  or 
			(((hc >= X_Winner and hc <= 10 +  X_Winner) or  (hc >= 20 +  X_Winner and hc <= 30 +  X_Winner)	or	(hc >= 40 +  X_Winner and hc <= 50 +  X_Winner)		or	(hc >= 60 +  X_Winner and hc <= 70 +  X_Winner)		or	(hc >= 80 +  X_Winner and hc <= 90 +  X_Winner)		or	(hc >= 110 +  X_Winner and hc <= 120 +  X_Winner)	or	(hc >= 130 +  X_Winner and hc <= 140 +  X_Winner)	or	(hc >= 160 +  X_Winner and hc <= 170 +  X_Winner)	or	(hc >= 180 +  X_Winner and hc <= 190 +  X_Winner)	or	(hc >= 230 +  X_Winner and hc <= 240 +  X_Winner)) 	and (vc >= 100 + Y_Winner and vc <= 120 + Y_Winner))  or 
			(((hc >= X_Winner and hc <= 20 +  X_Winner) or  (hc >= 30 +  X_Winner and hc <= 50 +  X_Winner)	or	(hc >= 60 +  X_Winner and hc <= 70 +  X_Winner)		or	(hc >= 80 +  X_Winner and hc <= 90 +  X_Winner)		or	(hc >= 110 +  X_Winner and hc <= 120 +  X_Winner)	or	(hc >= 130 +  X_Winner and hc <= 140 +  X_Winner)	or	(hc >= 160 +  X_Winner and hc <= 170 +  X_Winner)	or	(hc >= 180 +  X_Winner and hc <= 190 +  X_Winner)	or	(hc >= 210 +  X_Winner and hc <= 220 +  X_Winner)	or	(hc >= 230 +  X_Winner and hc <= 240 +  X_Winner)) 	and (vc >= 120 + Y_Winner and vc <= 140 + Y_Winner))  or 
			(((hc >= X_Winner and hc <= 10 +  X_Winner) or  (hc >= 40 +  X_Winner and hc <= 50 +  X_Winner)	or	(hc >= 60 +  X_Winner and hc <= 70 +  X_Winner)		or	(hc >= 80 +  X_Winner and hc <= 90 +  X_Winner)		or	(hc >= 110 +  X_Winner and hc <= 120 +  X_Winner)	or	(hc >= 130 +  X_Winner and hc <= 140 +  X_Winner)	or	(hc >= 160 +  X_Winner and hc <= 170 +  X_Winner)	or	(hc >= 190 +  X_Winner and hc <= 220 +  X_Winner)	or	(hc >= 230 +  X_Winner and hc <= 240 +  X_Winner)) 	and (vc >= 140 + Y_Winner and vc <= 160 + Y_Winner)))	
			and videoON = '1' and Winner > 1 and Winner <= 2 and juego9 = '0' and juego25 = '1') then
			red <= "0000";
			blue <= "0100";
			green <= "1110";
		
		-- Winner Player 1 3x3		
		elsif(((((hc >= X_Winner and hc <= 10 +  X_Winner) or (hc >= 40 +  X_Winner and hc <= 50 +  X_Winner)) and (vc >= Y_Winner and vc <= 20 + Y_Winner)) or
			(((hc >= X_Winner and hc <= 10 +  X_Winner) or  (hc >= 40 +  X_Winner and hc <= 50 +  X_Winner))	and (vc >= 20 + Y_Winner and vc <= 40 + Y_Winner))  or
			(((hc >= X_Winner and hc <= 10 +  X_Winner) or  (hc >= 40 +  X_Winner and hc <= 50 +  X_Winner)	or	(hc >= 60 +  X_Winner and hc <= 70 +  X_Winner)		or	(hc >= 80 +  X_Winner and hc <= 90 +  X_Winner)		or	(hc >= 100 +  X_Winner and hc <= 110 +  X_Winner)	or	(hc >= 130 +  X_Winner and hc <= 140 +  X_Winner)	or	(hc >= 150 +  X_Winner and hc <= 160 +  X_Winner)	or	(hc >= 190 +  X_Winner and hc <= 210 +  X_Winner)	or	(hc >= 230 +  X_Winner and hc <= 240 +  X_Winner)	or	(hc >= 250 +  X_Winner and hc <= 260 +  X_Winner)) 	and (vc >= 40 + Y_Winner and vc <= 60 + Y_Winner))  or 
			(((hc >= X_Winner and hc <= 10 +  X_Winner) or  (hc >= 40 +  X_Winner and hc <= 50 +  X_Winner)	or	(hc >= 80 +  X_Winner and hc <= 100 +  X_Winner)	or	(hc >= 110 +  X_Winner and hc <= 120 +  X_Winner)	or	(hc >= 130 +  X_Winner and hc <= 150 +  X_Winner)	or	(hc >= 160 +  X_Winner and hc <= 170 +  X_Winner)	or	(hc >= 180 +  X_Winner and hc <= 190 +  X_Winner)	or	(hc >= 210 +  X_Winner and hc <= 220 +  X_Winner)	or	(hc >= 230 +  X_Winner and hc <= 250 +  X_Winner)) 	and (vc >= 60 + Y_Winner and vc <= 80 + Y_Winner))  or 
			(((hc >= X_Winner and hc <= 10 +  X_Winner) or  (hc >= 40 +  X_Winner and hc <= 50 +  X_Winner)	or	(hc >= 60 +  X_Winner and hc <= 70 +  X_Winner)		or	(hc >= 80 +  X_Winner and hc <= 90 +  X_Winner)		or	(hc >= 110 +  X_Winner and hc <= 120 +  X_Winner)	or	(hc >= 130 +  X_Winner and hc <= 140 +  X_Winner)	or	(hc >= 160 +  X_Winner and hc <= 170 +  X_Winner)	or	(hc >= 180 +  X_Winner and hc <= 220 +  X_Winner)	or	(hc >= 230 +  X_Winner and hc <= 240 +  X_Winner)) 	and (vc >= 80 + Y_Winner and vc <= 100 + Y_Winner))  or 
			(((hc >= X_Winner and hc <= 10 +  X_Winner) or  (hc >= 20 +  X_Winner and hc <= 30 +  X_Winner)	or	(hc >= 40 +  X_Winner and hc <= 50 +  X_Winner)		or	(hc >= 60 +  X_Winner and hc <= 70 +  X_Winner)		or	(hc >= 80 +  X_Winner and hc <= 90 +  X_Winner)		or	(hc >= 110 +  X_Winner and hc <= 120 +  X_Winner)	or	(hc >= 130 +  X_Winner and hc <= 140 +  X_Winner)	or	(hc >= 160 +  X_Winner and hc <= 170 +  X_Winner)	or	(hc >= 180 +  X_Winner and hc <= 190 +  X_Winner)	or	(hc >= 230 +  X_Winner and hc <= 240 +  X_Winner)) 	and (vc >= 100 + Y_Winner and vc <= 120 + Y_Winner))  or 
			(((hc >= X_Winner and hc <= 20 +  X_Winner) or  (hc >= 30 +  X_Winner and hc <= 50 +  X_Winner)	or	(hc >= 60 +  X_Winner and hc <= 70 +  X_Winner)		or	(hc >= 80 +  X_Winner and hc <= 90 +  X_Winner)		or	(hc >= 110 +  X_Winner and hc <= 120 +  X_Winner)	or	(hc >= 130 +  X_Winner and hc <= 140 +  X_Winner)	or	(hc >= 160 +  X_Winner and hc <= 170 +  X_Winner)	or	(hc >= 180 +  X_Winner and hc <= 190 +  X_Winner)	or	(hc >= 210 +  X_Winner and hc <= 220 +  X_Winner)	or	(hc >= 230 +  X_Winner and hc <= 240 +  X_Winner)) 	and (vc >= 120 + Y_Winner and vc <= 140 + Y_Winner))  or 
			(((hc >= X_Winner and hc <= 10 +  X_Winner) or  (hc >= 40 +  X_Winner and hc <= 50 +  X_Winner)	or	(hc >= 60 +  X_Winner and hc <= 70 +  X_Winner)		or	(hc >= 80 +  X_Winner and hc <= 90 +  X_Winner)		or	(hc >= 110 +  X_Winner and hc <= 120 +  X_Winner)	or	(hc >= 130 +  X_Winner and hc <= 140 +  X_Winner)	or	(hc >= 160 +  X_Winner and hc <= 170 +  X_Winner)	or	(hc >= 190 +  X_Winner and hc <= 220 +  X_Winner)	or	(hc >= 230 +  X_Winner and hc <= 240 +  X_Winner)) 	and (vc >= 140 + Y_Winner and vc <= 160 + Y_Winner)))	
			and videoON = '1' and Winner3 > 0 and Winner3 <= 1 and juego9 = '1' and juego25 = '0') then
			red <= "1111";
			blue <= "0000";
			green <= "1111"; 
			
		-- Winner Player 2 3x3		
		elsif(((((hc >= X_Winner and hc <= 10 +  X_Winner) or (hc >= 40 +  X_Winner and hc <= 50 +  X_Winner)) and (vc >= Y_Winner and vc <= 20 + Y_Winner)) or
			(((hc >= X_Winner and hc <= 10 +  X_Winner) or  (hc >= 40 +  X_Winner and hc <= 50 +  X_Winner))	and (vc >= 20 + Y_Winner and vc <= 40 + Y_Winner))  or
			(((hc >= X_Winner and hc <= 10 +  X_Winner) or  (hc >= 40 +  X_Winner and hc <= 50 +  X_Winner)	or	(hc >= 60 +  X_Winner and hc <= 70 +  X_Winner)		or	(hc >= 80 +  X_Winner and hc <= 90 +  X_Winner)		or	(hc >= 100 +  X_Winner and hc <= 110 +  X_Winner)	or	(hc >= 130 +  X_Winner and hc <= 140 +  X_Winner)	or	(hc >= 150 +  X_Winner and hc <= 160 +  X_Winner)	or	(hc >= 190 +  X_Winner and hc <= 210 +  X_Winner)	or	(hc >= 230 +  X_Winner and hc <= 240 +  X_Winner)	or	(hc >= 250 +  X_Winner and hc <= 260 +  X_Winner)) 	and (vc >= 40 + Y_Winner and vc <= 60 + Y_Winner))  or 
			(((hc >= X_Winner and hc <= 10 +  X_Winner) or  (hc >= 40 +  X_Winner and hc <= 50 +  X_Winner)	or	(hc >= 80 +  X_Winner and hc <= 100 +  X_Winner)	or	(hc >= 110 +  X_Winner and hc <= 120 +  X_Winner)	or	(hc >= 130 +  X_Winner and hc <= 150 +  X_Winner)	or	(hc >= 160 +  X_Winner and hc <= 170 +  X_Winner)	or	(hc >= 180 +  X_Winner and hc <= 190 +  X_Winner)	or	(hc >= 210 +  X_Winner and hc <= 220 +  X_Winner)	or	(hc >= 230 +  X_Winner and hc <= 250 +  X_Winner)) 	and (vc >= 60 + Y_Winner and vc <= 80 + Y_Winner))  or 
			(((hc >= X_Winner and hc <= 10 +  X_Winner) or  (hc >= 40 +  X_Winner and hc <= 50 +  X_Winner)	or	(hc >= 60 +  X_Winner and hc <= 70 +  X_Winner)		or	(hc >= 80 +  X_Winner and hc <= 90 +  X_Winner)		or	(hc >= 110 +  X_Winner and hc <= 120 +  X_Winner)	or	(hc >= 130 +  X_Winner and hc <= 140 +  X_Winner)	or	(hc >= 160 +  X_Winner and hc <= 170 +  X_Winner)	or	(hc >= 180 +  X_Winner and hc <= 220 +  X_Winner)	or	(hc >= 230 +  X_Winner and hc <= 240 +  X_Winner)) 	and (vc >= 80 + Y_Winner and vc <= 100 + Y_Winner))  or 
			(((hc >= X_Winner and hc <= 10 +  X_Winner) or  (hc >= 20 +  X_Winner and hc <= 30 +  X_Winner)	or	(hc >= 40 +  X_Winner and hc <= 50 +  X_Winner)		or	(hc >= 60 +  X_Winner and hc <= 70 +  X_Winner)		or	(hc >= 80 +  X_Winner and hc <= 90 +  X_Winner)		or	(hc >= 110 +  X_Winner and hc <= 120 +  X_Winner)	or	(hc >= 130 +  X_Winner and hc <= 140 +  X_Winner)	or	(hc >= 160 +  X_Winner and hc <= 170 +  X_Winner)	or	(hc >= 180 +  X_Winner and hc <= 190 +  X_Winner)	or	(hc >= 230 +  X_Winner and hc <= 240 +  X_Winner)) 	and (vc >= 100 + Y_Winner and vc <= 120 + Y_Winner))  or 
			(((hc >= X_Winner and hc <= 20 +  X_Winner) or  (hc >= 30 +  X_Winner and hc <= 50 +  X_Winner)	or	(hc >= 60 +  X_Winner and hc <= 70 +  X_Winner)		or	(hc >= 80 +  X_Winner and hc <= 90 +  X_Winner)		or	(hc >= 110 +  X_Winner and hc <= 120 +  X_Winner)	or	(hc >= 130 +  X_Winner and hc <= 140 +  X_Winner)	or	(hc >= 160 +  X_Winner and hc <= 170 +  X_Winner)	or	(hc >= 180 +  X_Winner and hc <= 190 +  X_Winner)	or	(hc >= 210 +  X_Winner and hc <= 220 +  X_Winner)	or	(hc >= 230 +  X_Winner and hc <= 240 +  X_Winner)) 	and (vc >= 120 + Y_Winner and vc <= 140 + Y_Winner))  or 
			(((hc >= X_Winner and hc <= 10 +  X_Winner) or  (hc >= 40 +  X_Winner and hc <= 50 +  X_Winner)	or	(hc >= 60 +  X_Winner and hc <= 70 +  X_Winner)		or	(hc >= 80 +  X_Winner and hc <= 90 +  X_Winner)		or	(hc >= 110 +  X_Winner and hc <= 120 +  X_Winner)	or	(hc >= 130 +  X_Winner and hc <= 140 +  X_Winner)	or	(hc >= 160 +  X_Winner and hc <= 170 +  X_Winner)	or	(hc >= 190 +  X_Winner and hc <= 220 +  X_Winner)	or	(hc >= 230 +  X_Winner and hc <= 240 +  X_Winner)) 	and (vc >= 140 + Y_Winner and vc <= 160 + Y_Winner)))	
			and videoON = '1' and Winner3 > 1 and Winner3 <= 2 and juego9 = '1' and juego25 = '0') then
			red <= "0000";
			blue <= "0100";
			green <= "1110";
		
		elsif((hc > 290 and hc < 340 and vc > 110 and vc < 125 and videoON = '1' and juego25 = '0' and juego9 = '0')) then --horiz T line 
			red <= "1000";		-- Purple.
			blue <= "1110";
			green <= "0000";
		elsif((hc > 308 and hc < 322 and vc > 115 and vc < 200 and videoON = '1' and juego25 = '0' and juego9 = '0')) then --vert T line
			red <= "1000";		-- Purple.
			blue <= "1110";
			green <= "0000";
		elsif((hc > 340 and hc < 351 and vc > 160 and vc < 200 and videoON = '1' and juego25 = '0' and juego9 = '0')) then --vert i line 
			red <= "1111";
			blue <= "1111";
			green <= "1111";
		elsif((hc > 340 and hc < 351 and vc > 140 and vc < 155 and videoON = '1' and juego25 = '0' and juego9 = '0')) then --dot for i
			red <= "1111";
			blue <= "1111";
			green <= "1111";
		elsif((hc > 362 and hc < 373 and vc > 150 and vc < 200 and videoON = '1' and juego25 = '0' and juego9 = '0')) then --c
			red <= "1111";
			blue <= "1111";
			green <= "1111";
		elsif((hc > 372 and hc < 390 and vc > 145 and vc < 151 and videoON = '1' and juego25 = '0' and juego9 = '0')) then --c
			red <= "1111";
			blue <= "1111";
			green <= "1111";
		elsif((hc > 372 and hc < 390 and vc > 194 and vc < 200 and videoON = '1' and juego25 = '0' and juego9 = '0')) then --c
			red <= "1111";
			blue <= "1111";
			green <= "1111";
		--word tic finished
		elsif((hc > 408 and hc < 458 and vc > 110 and vc < 125 and videoON = '1' and juego25 = '0' and juego9 = '0')) then --horiz T line 
			red <= "0000";  -- Green
			blue <= "1000";	
			green <= "1100";
		elsif((hc > 426 and hc < 438 and vc > 115 and vc < 200 and videoON = '1' and juego25 = '0' and juego9 = '0')) then --vert T line
			red <= "0000";  -- Green
			blue <= "1000";
			green <= "1100";
		elsif((hc > 451 and hc < 460 and vc > 150 and vc < 200 and videoON = '1' and juego25 = '0' and juego9 = '0')) then --a
			red <= "1111";
			blue <= "1111";
			green <= "1111";
		elsif((hc > 459 and hc < 480 and vc > 145 and vc < 151 and videoON = '1' and juego25 = '0' and juego9 = '0')) then --a
			red <= "1111";
			blue <= "1111";
			green <= "1111";
		elsif((hc > 459 and hc < 480 and vc > 165 and vc < 175 and videoON = '1' and juego25 = '0' and juego9 = '0')) then --a
			red <= "1111";
			blue <= "1111";
			green <= "1111";
		elsif((hc > 479 and hc < 488 and vc > 150 and vc < 200 and videoON = '1' and juego25 = '0' and juego9 = '0')) then --a
			red <= "1111";
			blue <= "1111";
			green <= "1111";
		elsif((hc > 498 and hc < 507 and vc > 150 and vc < 200 and videoON = '1' and juego25 = '0' and juego9 = '0')) then --c
			red <= "1111";
			blue <= "1111";
			green <= "1111";
		elsif((hc > 506 and hc < 525 and vc > 145 and vc < 151 and videoON = '1' and juego25 = '0' and juego9 = '0')) then --c
			red <= "1111";
			blue <= "1111";
			green <= "1111";
		elsif((hc > 506 and hc < 525 and vc > 194 and vc < 200 and videoON = '1' and juego25 = '0' and juego9 = '0')) then --c
			red <= "1111";
			blue <= "1111";
			green <= "1111"; 
		--tac word finished
		elsif((hc > 542 and hc < 595 and vc > 110 and vc < 125 and videoON = '1' and juego25 = '0' and juego9 = '0')) then --horiz T line 
			red <= "1110"; 		-- Orange
			blue <= "0100";
			green <= "1010";
		elsif((hc > 563 and hc < 575 and vc > 115 and vc < 200 and videoON = '1' and juego25 = '0' and juego9 = '0')) then --vert T line
			red <= "1110"; 		-- Orange
			blue <= "0100";
			green <= "1010";
		elsif((hc > 585 and hc < 591 and vc > 150 and vc < 200 and videoON = '1' and juego25 = '0' and juego9 = '0')) then --o
			red <= "1111";
			blue <= "1111";
			green <= "1111";
		elsif((hc > 590 and hc < 612 and vc > 145 and vc < 151 and videoON = '1' and juego25 = '0' and juego9 = '0')) then --o
			red <= "1111";
			blue <= "1111";
			green <= "1111";
		elsif((hc > 590 and hc < 612 and vc > 194 and vc < 200 and videoON = '1' and juego25 = '0' and juego9 = '0')) then --o
			red <= "1111";
			blue <= "1111";
			green <= "1111";
		elsif((hc > 611 and hc < 617 and vc > 150 and vc < 200 and videoON = '1' and juego25 = '0' and juego9 = '0')) then --o
			red <= "1111";
			blue <= "1111";
			green <= "1111";
		elsif((hc > 625 and hc < 631 and vc > 145 and vc < 200 and videoON = '1' and juego25 = '0' and juego9 = '0')) then --e
			red <= "1111";
			blue <= "1111";
			green <= "1111";
		elsif((hc > 630 and hc < 648 and vc > 145 and vc < 151 and videoON = '1' and juego25 = '0' and juego9 = '0')) then --e
			red <= "1111";
			blue <= "1111";
			green <= "1111";
		elsif((hc > 630 and hc < 648 and vc > 165 and vc < 172 and videoON = '1' and juego25 = '0' and juego9 = '0')) then --e
			red <= "1111";
			blue <= "1111";
			green <= "1111";
		elsif((hc > 630 and hc < 648 and vc > 194 and vc < 200 and videoON = '1' and juego25 = '0' and juego9 = '0')) then --e
			red <= "1111";
			blue <= "1111";
			green <= "1111";
			--toe finished 
			
		else
			red <= "0000";
			green <= "0000";
			blue <= "0000";
		end if;
	end process;
		
	Animation3x3: process(swRight, swDown, X1_Rise, Y1_Rise, btnMove, btnSelect, juego9)
	begin
		if(swRight = '1' and juego9 ='1') then 
			if(X1_Rise < 225) then
				if(btnMove'EVENT and btnMove = '0') then
					X1_Rise <= X1_Rise + 75;
				else 
					X1_Rise <= X1_Rise;
				end if;		
			else 
				X1_Rise <= 0;
			end if;
		end if;
		
		if(swDown = '1' and juego9 ='1') then 
			if(Y1_Rise < 360) then
				if(btnMove'EVENT and btnMove = '0') then
					Y1_Rise <= Y1_Rise + 120;
				else 
					Y1_Rise <= Y1_Rise;
				end if;	
			else
				Y1_Rise <= 0;
			end if;
		end if;
	end process;
	
	Animation5x5: process(swRight, swDown, X2_Rise, Y2_Rise, btnMove, btnSelect, juego25)
	begin
		if(swRight = '1' and juego25 ='1') then 
			if(X2_Rise < 375) then
				if(btnMove'EVENT and btnMove = '0') then
					X2_Rise <= X2_Rise + 75;
				else 
					X2_Rise <= X2_Rise;
				end if;		
			else 
				X2_Rise <= 0;
			end if;
		end if;
		
		if(swDown = '1' and juego25 ='1') then 
			if(Y2_Rise < 575) then
				if(btnMove'EVENT and btnMove = '0') then
					Y2_Rise <= Y2_Rise + 115;
				else 
					Y2_Rise <= Y2_Rise;
				end if;
			else
				Y2_Rise <= 0;
			end if;
		end if;
	end process;
	
	Printed3x3: process(btnSelect, Turn, X1_Rise, Y1_Rise)
	begin
		if(btnSelect'EVENT and btnSelect = '0' and juego9 = '1')then
			-- Player 1
			if(X1_Rise = 0		and Y1_Rise = 0 	and Turn = '1' and P2_11 = 0 and P1_11 = 0) then
				P1_11 <= 1;
				Turn <= not Turn;
			elsif(X1_Rise = 0 	and Y1_Rise = 120	and Turn = '1' and P2_12 = 0 and P1_12 = 0) then
				P1_12 <= 1;
				Turn <= not Turn;
			elsif(X1_Rise = 0 	and Y1_Rise = 240	and Turn = '1' and P2_13 = 0 and P1_13 = 0) then
				P1_13 <= 1;
				Turn <= not Turn;
			elsif(X1_Rise = 75 	and Y1_Rise = 0		and Turn = '1' and P2_21 = 0 and P1_21 = 0) then
				P1_21 <= 1;
				Turn <= not Turn;
			elsif(X1_Rise = 75 	and Y1_Rise = 120	and Turn = '1' and P2_22 = 0 and P1_22 = 0) then
				P1_22 <= 1;
				Turn <= not Turn;
			elsif(X1_Rise = 75 	and Y1_Rise = 240	and Turn = '1' and P2_23 = 0 and P1_23 = 0) then
				P1_23 <= 1;
				Turn <= not Turn;
			elsif(X1_Rise = 150 and Y1_Rise = 0		and Turn = '1' and P2_31 = 0 and P1_31 = 0) then
				P1_31 <= 1;
				Turn <= not Turn;
			elsif(X1_Rise = 150 and Y1_Rise = 120 	and Turn = '1' and P2_32 = 0 and P1_32 = 0) then
				P1_32 <= 1;
				Turn <= not Turn;
			elsif(X1_Rise = 150 and Y1_Rise = 240 	and Turn = '1' and P2_33 = 0 and P1_33 = 0) then
				P1_33 <= 1;
				Turn <= not Turn;
				
			-- Player 2
			elsif(X1_Rise = 0	and Y1_Rise = 0		and Turn = '0' and P1_11 = 0 and P2_11 = 0) then
				P2_11 <= 1;
				Turn <= not Turn;
			elsif(X1_Rise = 0	and Y1_Rise = 120	and Turn = '0' and P1_12 = 0 and P2_12 = 0) then
				P2_12 <= 1;
				Turn <= not Turn;
			elsif(X1_Rise = 0	and Y1_Rise = 240	and Turn = '0' and P1_13 = 0 and P2_13 = 0) then
				P2_13 <= 1;
				Turn <= not Turn;
			elsif(X1_Rise = 75	and Y1_Rise = 0		and Turn = '0' and P1_21 = 0 and P2_21 = 0) then
				P2_21 <= 1;
				Turn <= not Turn;
			elsif(X1_Rise = 75	and Y1_Rise = 120 	and Turn = '0' and P1_22 = 0 and P2_22 = 0) then
				P2_22 <= 1;
				Turn <= not Turn;
			elsif(X1_Rise = 75	and Y1_Rise = 240 	and Turn = '0' and P1_23 = 0 and P2_23 = 0) then
				P2_23 <= 1;
				Turn <= not Turn;
			elsif(X1_Rise = 150 and Y1_Rise = 0 	and Turn = '0' and P1_31 = 0 and P2_31 = 0) then
				P2_31 <= 1;
				Turn <= not Turn;
			elsif(X1_Rise = 150 and Y1_Rise = 120 	and Turn = '0' and P1_32 = 0 and P2_32 = 0) then
				P2_32 <= 1;
				Turn <= not Turn;
			elsif(X1_Rise = 150 and Y1_Rise = 240 	and Turn = '0' and P1_33 = 0 and P2_33 = 0) then
				P2_33 <= 1;
				Turn <= not Turn;
			else
				-- Player 1 3x3
				P1_11 <= P1_11;
				P1_12 <= P1_12;
				P1_13 <= P1_13;
				P1_21 <= P1_21;
				P1_22 <= P1_22;
				P1_23 <= P1_23;
				P1_31 <= P1_31;
				P1_32 <= P1_32;
				P1_33 <= P1_33;
				-- Player 2 3x3
				P2_11 <= P2_11;
				P2_12 <= P2_12;
				P2_13 <= P2_13;
				P2_21 <= P2_21;
				P2_22 <= P2_22;
				P2_23 <= P2_23;
				P2_31 <= P2_31;
				P2_32 <= P2_32;
				P2_33 <= P2_33;
				
				-- Turn
				Turn <= Turn;
			end if;
		end if;
	end process;
	
	Printed5x5: process(btnSelect, Turn5, X2_Rise, Y2_Rise)
	begin
		if(btnSelect'EVENT and btnSelect = '0' and juego25 = '1')then
			-- Player 1
			if(X2_Rise = 0		and Y2_Rise = 0 	and Turn5 = '1' and M1_11 = 0 and M2_11 = 0) then
				M1_11 <= 1;
				Turn5 <= not Turn5;
			elsif(X2_Rise = 0	and Y2_Rise = 115 	and Turn5 = '1' and M1_12 = 0 and M2_12 = 0) then
				M1_12 <= 1;
				Turn5 <= not Turn5;
			elsif(X2_Rise = 0	and Y2_Rise = 230 	and Turn5 = '1' and M1_13 = 0 and M2_13 = 0) then
				M1_13 <= 1;
				Turn5 <= not Turn5;
			elsif(X2_Rise = 0	and Y2_Rise = 345 	and Turn5 = '1' and M1_14 = 0 and M2_14 = 0) then
				M1_14 <= 1;
				Turn5 <= not Turn5;
			elsif(X2_Rise = 0	and Y2_Rise = 460 	and Turn5 = '1' and M1_15 = 0 and M2_15 = 0) then
				M1_15 <= 1;
				Turn5 <= not Turn5;
			
			elsif(X2_Rise = 75	and Y2_Rise = 0 	and Turn5 = '1' and M1_21 = 0 and M2_21 = 0) then
				M1_21 <= 1;
				Turn5 <= not Turn5;
			elsif(X2_Rise = 75	and Y2_Rise = 115 	and Turn5 = '1' and M1_22 = 0 and M2_22 = 0) then
				M1_22 <= 1;
				Turn5 <= not Turn5;
			elsif(X2_Rise = 75	and Y2_Rise = 230 	and Turn5 = '1' and M1_23 = 0 and M2_23 = 0) then
				M1_23 <= 1;
				Turn5 <= not Turn5;
			elsif(X2_Rise = 75	and Y2_Rise = 345 	and Turn5 = '1' and M1_24 = 0 and M2_24 = 0) then
				M1_24 <= 1;
				Turn5 <= not Turn5;
			elsif(X2_Rise = 75	and Y2_Rise = 460 	and Turn5 = '1' and M1_25 = 0 and M2_25 = 0) then
				M1_25 <= 1;
				Turn5 <= not Turn5;
				
			elsif(X2_Rise = 150	and Y2_Rise = 0 	and Turn5 = '1' and M1_31 = 0 and M2_31 = 0) then
				M1_31 <= 1;
				Turn5 <= not Turn5;
			elsif(X2_Rise = 150	and Y2_Rise = 115 	and Turn5 = '1' and M1_32 = 0 and M2_32 = 0) then
				M1_32 <= 1;
				Turn5 <= not Turn5;
			elsif(X2_Rise = 150	and Y2_Rise = 230 	and Turn5 = '1' and M1_33 = 0 and M2_33 = 0) then
				M1_33 <= 1;
				Turn5 <= not Turn5;
			elsif(X2_Rise = 150	and Y2_Rise = 345 	and Turn5 = '1' and M1_34 = 0 and M2_34 = 0) then
				M1_34 <= 1;
				Turn5 <= not Turn5;
			elsif(X2_Rise = 150	and Y2_Rise = 460 	and Turn5 = '1' and M1_35 = 0 and M2_35 = 0) then
				M1_35 <= 1;
				Turn5 <= not Turn5;
				
			elsif(X2_Rise = 225	and Y2_Rise = 0 	and Turn5 = '1' and M1_41 = 0 and M2_41 = 0) then
				M1_41 <= 1;
				Turn5 <= not Turn5;
			elsif(X2_Rise = 225	and Y2_Rise = 115 	and Turn5 = '1' and M1_42 = 0 and M2_42 = 0) then
				M1_42 <= 1;
				Turn5 <= not Turn5;
			elsif(X2_Rise = 225	and Y2_Rise = 230 	and Turn5 = '1' and M1_43 = 0 and M2_43 = 0) then
				M1_43 <= 1;
				Turn5 <= not Turn5;
			elsif(X2_Rise = 225	and Y2_Rise = 345 	and Turn5 = '1' and M1_44 = 0 and M2_44 = 0) then
				M1_44 <= 1;
				Turn5 <= not Turn5;
			elsif(X2_Rise = 225	and Y2_Rise = 460 	and Turn5 = '1' and M1_45 = 0 and M2_45 = 0) then
				M1_45 <= 1;
				Turn5 <= not Turn5;
				
			elsif(X2_Rise = 300	and Y2_Rise = 0 	and Turn5 = '1' and M1_51 = 0 and M2_51 = 0) then
				M1_51 <= 1;
				Turn5 <= not Turn5;
			elsif(X2_Rise = 300	and Y2_Rise = 115 	and Turn5 = '1' and M1_52 = 0 and M2_52 = 0) then
				M1_52 <= 1;
				Turn5 <= not Turn5;
			elsif(X2_Rise = 300	and Y2_Rise = 230 	and Turn5 = '1' and M1_53 = 0 and M2_53 = 0) then
				M1_53 <= 1;
				Turn5 <= not Turn5;
			elsif(X2_Rise = 300	and Y2_Rise = 345 	and Turn5 = '1' and M1_54 = 0 and M2_54 = 0) then
				M1_54 <= 1;
				Turn5 <= not Turn5;
			elsif(X2_Rise = 300	and Y2_Rise = 460 	and Turn5 = '1' and M1_55 = 0 and M2_55 = 0) then
				M1_55 <= 1;
				Turn5 <= not Turn5;
			
			-- Player 2
			elsif(X2_Rise = 0	and Y2_Rise = 0 	and Turn5 = '0' and M1_11 = 0 and M2_11 = 0) then
				M2_11 <= 1;
				Turn5 <= not Turn5;
			elsif(X2_Rise = 0	and Y2_Rise = 115 	and Turn5 = '0' and M1_12 = 0 and M2_12 = 0) then
				M2_12 <= 1;
				Turn5 <= not Turn5;
			elsif(X2_Rise = 0	and Y2_Rise = 230 	and Turn5 = '0' and M1_13 = 0 and M2_13 = 0) then
				M2_13 <= 1;
				Turn5 <= not Turn5;
			elsif(X2_Rise = 0	and Y2_Rise = 345 	and Turn5 = '0' and M1_14 = 0 and M2_14 = 0) then
				M2_14 <= 1;
				Turn5 <= not Turn5;
			elsif(X2_Rise = 0	and Y2_Rise = 460 	and Turn5 = '0' and M1_15 = 0 and M2_15 = 0) then
				M2_15 <= 1;
				Turn5 <= not Turn5;
			
			elsif(X2_Rise = 75	and Y2_Rise = 0 	and Turn5 = '0' and M1_21 = 0 and M2_21 = 0) then
				M2_21 <= 1;
				Turn5 <= not Turn5;
			elsif(X2_Rise = 75	and Y2_Rise = 115 	and Turn5 = '0' and M1_22 = 0 and M2_22 = 0) then
				M2_22 <= 1;
				Turn5 <= not Turn5;
			elsif(X2_Rise = 75	and Y2_Rise = 230 	and Turn5 = '0' and M1_23 = 0 and M2_23 = 0) then
				M2_23 <= 1;
				Turn5 <= not Turn5;
			elsif(X2_Rise = 75	and Y2_Rise = 345 	and Turn5 = '0' and M1_24 = 0 and M2_24 = 0) then
				M2_24 <= 1;
				Turn5 <= not Turn5;
			elsif(X2_Rise = 75	and Y2_Rise = 460 	and Turn5 = '0' and M1_25 = 0 and M2_25 = 0) then
				M2_25 <= 1;
				Turn5 <= not Turn5;
				
			elsif(X2_Rise = 150	and Y2_Rise = 0 	and Turn5 = '0' and M1_31 = 0 and M2_31 = 0) then
				M2_31 <= 1;
				Turn5 <= not Turn5;
			elsif(X2_Rise = 150	and Y2_Rise = 115 	and Turn5 = '0' and M1_32 = 0 and M2_32 = 0) then
				M2_32 <= 1;
				Turn5 <= not Turn5;
			elsif(X2_Rise = 150	and Y2_Rise = 230 	and Turn5 = '0' and M1_33 = 0 and M2_33 = 0) then
				M2_33 <= 1;
				Turn5 <= not Turn5;
			elsif(X2_Rise = 150	and Y2_Rise = 345 	and Turn5 = '0' and M1_34 = 0 and M2_34 = 0) then
				M2_34 <= 1;
				Turn5 <= not Turn5;
			elsif(X2_Rise = 150	and Y2_Rise = 460 	and Turn5 = '0' and M1_35 = 0 and M2_35 = 0) then
				M2_35 <= 1;
				Turn5 <= not Turn5;
				
			elsif(X2_Rise = 225	and Y2_Rise = 0 	and Turn5 = '0' and M1_41 = 0 and M2_41 = 0) then
				M2_41 <= 1;
				Turn5 <= not Turn5;
			elsif(X2_Rise = 225	and Y2_Rise = 115 	and Turn5 = '0' and M1_42 = 0 and M2_42 = 0) then
				M2_42 <= 1;
				Turn5 <= not Turn5;
			elsif(X2_Rise = 225	and Y2_Rise = 230 	and Turn5 = '0' and M1_43 = 0 and M2_43 = 0) then
				M2_43 <= 1;
				Turn5 <= not Turn5;
			elsif(X2_Rise = 225	and Y2_Rise = 345 	and Turn5 = '0' and M1_44 = 0 and M2_44 = 0) then
				M2_44 <= 1;
				Turn5 <= not Turn5;
			elsif(X2_Rise = 225	and Y2_Rise = 460 	and Turn5 = '0' and M1_45 = 0 and M2_45 = 0) then
				M2_45 <= 1;
				Turn5 <= not Turn5;
				
			elsif(X2_Rise = 300	and Y2_Rise = 0 	and Turn5 = '0' and M1_51 = 0 and M2_51 = 0) then
				M2_51 <= 1;
				Turn5 <= not Turn5;
			elsif(X2_Rise = 300	and Y2_Rise = 115 	and Turn5 = '0' and M1_52 = 0 and M2_52 = 0) then
				M2_52 <= 1;
				Turn5 <= not Turn5;
			elsif(X2_Rise = 300	and Y2_Rise = 230 	and Turn5 = '0' and M1_53 = 0 and M2_53 = 0) then
				M2_53 <= 1;
				Turn5 <= not Turn5;
			elsif(X2_Rise = 300	and Y2_Rise = 345 	and Turn5 = '0' and M1_54 = 0 and M2_54 = 0) then
				M2_54 <= 1;
				Turn5 <= not Turn5;
			elsif(X2_Rise = 300	and Y2_Rise = 460 	and Turn5 = '0' and M1_55 = 0 and M2_55 = 0) then
				M2_55 <= 1;
				Turn5 <= not Turn5;
				
			else
				-- Player 1
				M1_11 <= M1_11;
				M1_12 <= M1_12;
				M1_13 <= M1_13;
				M1_14 <= M1_14;
				M1_15 <= M1_15;
				
				M1_21 <= M1_21;
				M1_22 <= M1_22;
				M1_23 <= M1_23;
				M1_24 <= M1_24;
				M1_25 <= M1_25;
				
				M1_31 <= M1_31;
				M1_32 <= M1_32;
				M1_33 <= M1_33;
				M1_34 <= M1_34;
				M1_35 <= M1_35;
				
				M1_41 <= M1_41;
				M1_42 <= M1_42;
				M1_43 <= M1_43;
				M1_44 <= M1_44;
				M1_45 <= M1_45;
				
				M1_51 <= M1_51;
				M1_52 <= M1_52;
				M1_53 <= M1_53;
				M1_54 <= M1_54;
				M1_55 <= M1_55;	
				
				-- Player 2
				M2_11 <= M2_11;
				M2_12 <= M2_12;
				M2_13 <= M2_13;
				M2_14 <= M2_14;
				M2_15 <= M2_15;
				
				M2_21 <= M2_21;
				M2_22 <= M2_22;
				M2_23 <= M2_23;
				M2_24 <= M2_24;
				M2_25 <= M2_25;
				
				M2_31 <= M2_31;
				M2_32 <= M2_32;
				M2_33 <= M2_33;
				M2_34 <= M2_34;
				M2_35 <= M2_35;
				
				M2_41 <= M2_41;
				M2_42 <= M2_42;
				M2_43 <= M2_43;
				M2_44 <= M2_44;
				M2_45 <= M2_45;
				
				M2_51 <= M2_51;
				M2_52 <= M2_52;
				M2_53 <= M2_53;
				M2_54 <= M2_54;
				M2_55 <= M2_55;
				
				-- Turn
				Turn5 <= Turn5;
			end if;
		end if;
	end process;
	
	Combination3x3: process(P1_11, P1_12, P1_13, P1_21, P1_22, P1_23, P1_31, P1_32, P1_33, P2_11, P2_12, P2_13, P2_21, P2_22, P2_23, P2_31, P2_32, P2_33)
	begin
		-- Player 1
		if(P1_11 = 1 and P1_12 = 1 and P1_13 = 1) then
			Winner3 <= 1;
		elsif(P1_21 = 1 and P1_22 = 1 and P1_23 = 1) then
			Winner3 <= 1;
		elsif(P1_31 = 1 and P1_32 = 1 and P1_33 = 1) then
			Winner3 <= 1;
		elsif(P1_11 = 1 and P1_21 = 1 and P1_31 = 1) then
			Winner3 <= 1;
		elsif(P1_12 = 1 and P1_22 = 1 and P1_32 = 1) then
			Winner3 <= 1;
		elsif(P1_13 = 1 and P1_23 = 1 and P1_33 = 1) then
			Winner3 <= 1;
		elsif(P1_11 = 1 and P1_22 = 1 and P1_33 = 1) then
			Winner3 <= 1;
		elsif(P1_13 = 1 and P1_22 = 1 and P1_31 = 1) then
			Winner3 <= 1;
			
		-- Player 2
		elsif(P2_11 = 1 and P2_12 = 1 and P2_13 = 1) then
			Winner3 <= 2;
		elsif(P2_21 = 1 and P2_22 = 1 and P2_23 = 1) then
			Winner3 <= 2;
		elsif(P2_31 = 1 and P2_32 = 1 and P2_33 = 1) then
			Winner3 <= 2;
		elsif(P2_11 = 1 and P2_21 = 1 and P2_31 = 1) then
			Winner3 <= 2;
		elsif(P2_12 = 1 and P2_22 = 1 and P2_32 = 1) then
			Winner3 <= 2;
		elsif(P2_13 = 1 and P2_23 = 1 and P2_33 = 1) then
			Winner3 <= 2;
		elsif(P2_11 = 1 and P2_22 = 1 and P2_33 = 1) then
			Winner3 <= 2;
		elsif(P2_13 = 1 and P2_22 = 1 and P2_31 = 1) then
			Winner3 <= 2;
		--Draw
		elsif((P1_11 = 1 or P2_11 = 1) and (P1_12 = 1 or P2_12 = 1) and (P1_13 = 1 or P2_13 = 1) and
			  (P1_21 = 1 or P2_21 = 1) and (P1_22 = 1 or P2_22 = 1) and (P1_23 = 1 or P2_23 = 1) and
			  (P1_31 = 1 or P2_31 = 1) and (P1_32 = 1 or P2_32 = 1) and (P1_33 = 1 or P2_33 = 1)) then
			Draw3 <= 1;
		else
			Winner3	<= 0;
			Draw3	<= 0;
		end if;
	end process;
	
	Combination5x5: process(M1_11, M1_12, M1_13, M1_14, M1_15, M1_21, M1_22, M1_23, M1_24, M1_25, M1_31, M1_32, M1_33, M1_34, M1_35, M1_41, M1_42, M1_43, M1_44, M1_45, M1_51, M1_52, M1_53, M1_54, M1_55,
	M2_11, M2_12, M2_13, M2_14, M2_15, M2_21, M2_22, M2_23, M2_24, M2_25, M2_31, M2_32, M2_33, M2_34, M2_35, M2_41, M2_42, M2_43, M2_44, M2_45, M2_51, M2_52, M2_53, M2_54, M2_55)
	begin
		-- Player 1
		-- HZ
		if(M1_11 = 1 and M1_12 = 1 and M1_13 = 1) then
			Winner <= 1;
		elsif(M1_12 = 1 and M1_13 = 1 and M1_14 = 1) then
			Winner <= 1;
		elsif(M1_13 = 1 and M1_14 = 1 and M1_15 = 1) then
			Winner <= 1;
		elsif(M1_21 = 1 and M1_22 = 1 and M1_23 = 1) then
			Winner <= 1;
		elsif(M1_22 = 1 and M1_23 = 1 and M1_24 = 1) then
			Winner <= 1;
		elsif(M1_23 = 1 and M1_24 = 1 and M1_25 = 1) then
			Winner <= 1;
		elsif(M1_31 = 1 and M1_32 = 1 and M1_33 = 1) then
			Winner <= 1;
		elsif(M1_32 = 1 and M1_33 = 1 and M1_34 = 1) then
			Winner <= 1;
		elsif(M1_33 = 1 and M1_34 = 1 and M1_35 = 1) then
			Winner <= 1;
		elsif(M1_41 = 1 and M1_42 = 1 and M1_43 = 1) then
			Winner <= 1;
		elsif(M1_42 = 1 and M1_43 = 1 and M1_44 = 1) then
			Winner <= 1;
		elsif(M1_43 = 1 and M1_44 = 1 and M1_45 = 1) then
			Winner <= 1;
		elsif(M1_51 = 1 and M1_52 = 1 and M1_53 = 1) then
			Winner <= 1;
		elsif(M1_52 = 1 and M1_53 = 1 and M1_54 = 1) then
			Winner <= 1;
		elsif(M1_53 = 1 and M1_54 = 1 and M1_55 = 1) then
			Winner <= 1;
			
		--VT
		elsif(M1_11 = 1 and M1_21 = 1 and M1_31 = 1) then
			Winner <= 1;
		elsif(M1_21 = 1 and M1_31 = 1 and M1_41 = 1) then
			Winner <= 1;
		elsif(M1_31 = 1 and M1_41 = 1 and M1_51 = 1) then
			Winner <= 1;
		elsif(M1_12 = 1 and M1_22 = 1 and M1_32 = 1) then
			Winner <= 1;
		elsif(M1_22 = 1 and M1_32 = 1 and M1_42 = 1) then
			Winner <= 1;
		elsif(M1_32 = 1 and M1_42 = 1 and M1_52 = 1) then
			Winner <= 1;
		elsif(M1_13 = 1 and M1_23 = 1 and M1_33 = 1) then
			Winner <= 1;
		elsif(M1_23 = 1 and M1_33 = 1 and M1_43 = 1) then
			Winner <= 1;
		elsif(M1_33 = 1 and M1_43 = 1 and M1_53 = 1) then
			Winner <= 1;
		elsif(M1_14 = 1 and M1_24 = 1 and M1_34 = 1) then
			Winner <= 1;
		elsif(M1_24 = 1 and M1_34 = 1 and M1_44 = 1) then
			Winner <= 1;
		elsif(M1_34 = 1 and M1_44 = 1 and M1_54 = 1) then
			Winner <= 1;
		elsif(M1_15 = 1 and M1_25 = 1 and M1_35 = 1) then
			Winner <= 1;
		elsif(M1_25 = 1 and M1_35 = 1 and M1_45 = 1) then
			Winner <= 1;
		elsif(M1_35 = 1 and M1_45 = 1 and M1_55 = 1) then
			Winner <= 1;
				
		-- Player 2
		-- HZ
		elsif(M2_11 = 1 and M2_12 = 1 and M2_13 = 1) then
			Winner <= 2;
		elsif(M2_12 = 1 and M2_13 = 1 and M2_14 = 1) then
			Winner <= 2;
		elsif(M2_13 = 1 and M2_14 = 1 and M2_15 = 1) then
			Winner <= 2;
		elsif(M2_21 = 1 and M2_22 = 1 and M2_23 = 1) then
			Winner <= 2;
		elsif(M2_22 = 1 and M2_23 = 1 and M2_24 = 1) then
			Winner <= 2;
		elsif(M2_23 = 1 and M2_24 = 1 and M2_25 = 1) then
			Winner <= 2;
		elsif(M2_31 = 1 and M2_32 = 1 and M2_33 = 1) then
			Winner <= 2;
		elsif(M2_32 = 1 and M2_33 = 1 and M2_34 = 1) then
			Winner <= 2;
		elsif(M2_33 = 1 and M2_34 = 1 and M2_35 = 1) then
			Winner <= 2;
		elsif(M2_41 = 1 and M2_42 = 1 and M2_43 = 1) then
			Winner <= 2;
		elsif(M2_42 = 1 and M2_43 = 1 and M2_44 = 1) then
			Winner <= 2;
		elsif(M2_43 = 1 and M2_44 = 1 and M2_45 = 1) then
			Winner <= 2;
		elsif(M2_51 = 1 and M2_52 = 1 and M2_53 = 1) then
			Winner <= 2;
		elsif(M2_52 = 1 and M2_53 = 1 and M2_54 = 1) then
			Winner <= 2;
		elsif(M2_53 = 1 and M2_54 = 1 and M2_55 = 1) then
			Winner <= 2;
			
		--VT
		elsif(M2_11 = 1 and M2_21 = 1 and M2_31 = 1) then
			Winner <= 2;
		elsif(M2_21 = 1 and M2_31 = 1 and M2_41 = 1) then
			Winner <= 2;
		elsif(M2_31 = 1 and M2_41 = 1 and M2_51 = 1) then
			Winner <= 2;
		elsif(M2_12 = 1 and M2_22 = 1 and M2_32 = 1) then
			Winner <= 2;	 
		elsif(M2_22 = 1 and M2_32 = 1 and M2_42 = 1) then
			Winner <= 2;
		elsif(M2_32 = 1 and M2_42 = 1 and M2_52 = 1) then
			Winner <= 2;
		elsif(M2_13 = 1 and M2_23 = 1 and M2_33 = 1) then
			Winner <= 2;
		elsif(M2_23 = 1 and M2_33 = 1 and M2_43 = 1) then
			Winner <= 2;
		elsif(M2_33 = 1 and M2_43 = 1 and M2_53 = 1) then
			Winner <= 2;
		elsif(M2_14 = 1 and M2_24 = 1 and M2_34 = 1) then
			Winner <= 2;
		elsif(M2_24 = 1 and M2_34 = 1 and M2_44 = 1) then
			Winner <= 2;
		elsif(M2_34 = 1 and M2_44 = 1 and M2_54 = 1) then
			Winner <= 2;
		elsif(M2_15 = 1 and M2_25 = 1 and M2_35 = 1) then
			Winner <= 2;
		elsif(M2_25 = 1 and M2_35 = 1 and M2_45 = 1) then
			Winner <= 2;
		elsif(M2_35 = 1 and M2_45 = 1 and M2_55 = 1) then
			Winner <= 2;
		--Draw
		elsif((P1_11 = 1 or P2_11 = 1) and (P1_12 = 1 or P2_12 = 1) and (P1_13 = 1 or P2_13 = 1) and
			  (P1_21 = 1 or P2_21 = 1) and (P1_22 = 1 or P2_22 = 1) and (P1_23 = 1 or P2_23 = 1) and
			  (P1_31 = 1 or P2_31 = 1) and (P1_32 = 1 or P2_32 = 1) and (P1_33 = 1 or P2_33 = 1)) then
			Draw <= 1;
		else
			Winner	<= 0;
			Draw	<= 0;
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

