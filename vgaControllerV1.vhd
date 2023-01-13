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

constant hpixels : std_logic_vector(9 downto 0) := "1100100000";
constant vlines : std_logic_vector(9 downto 0)	 := "1000001001";

constant hbp : std_logic_vector(9 downto 0) := "0010010000";
constant hfp : std_logic_vector(9 downto 0) := "1100010000";
constant vbp : std_logic_vector(9 downto 0) := "0000011111";
constant vfp : std_logic_vector(9 downto 0) := "0111111111";

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
		
	process(clk25)
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
	
	process(hc, videoON)
	begin 
		if((hc > 569 and videoON = '1') or (hc > 356 and hc < 569 and videoON = '1')) then
			red <= "1111";
		elsif((hc > 143 and hc < 356 and videoON = '1') or (hc > 356 and hc < 569 and videoON = '1')) then
			green <= "1111";
		elsif((hc > 356) and (hc < 569) and (videoON = '1')) then
			blue <= "1111";
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
														

