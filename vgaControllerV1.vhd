library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.STD_LOGIC_ARITH.all; 

entity vgaControllerV1 is
	port( 
	clk : in std_logic;
	hs	: out std_logic;
	vs  : out std_logic;
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
	fondo: process(hc, vc, videoON)
	begin 
		--if((hc > 48 and hc < 465 and videoON = '1')) then
--			red <= "0000";
--			blue <= "1111";
--			green <= "0000";
		if((vc > 200 and vc <450 and hc > 200 and hc < 400 and videoON = '1')) then
			red <= "1111";
			blue <= "0000";
			green <= "0000";
			--end if;
		elsif((hc >=465 and hc < 800 and videoON = '1')) then
			red <= "0000";
			blue <= "0000";
			green <= "1111";
		else
			red <= "0000";
			green <= "0000";
			blue <= "0000";
		end if;
	end process;
	
	--segundocolor: process(hc, videoON)
--	begin
--		if((hc >=465 and hc < 800 and videoON = '1')) then
--			red <= "0000";
--			blue <= "0000";
--			green <= "1111";
--		else
--			red <= "0000";
--			green <= "0000";
--			blue <= "0000";
--		end if;
--	end process;
	
	process(hc, vc)
	begin 
		if(((hc < hfp) and (hc > hbp)) or ((vc < vfp) and (vc > vbp))) then
			videoON <= '1';
		else
			videoON <= '0';
		end if;
	end process;
end Behavioral;
														

