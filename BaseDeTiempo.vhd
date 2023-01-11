library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.STD_LOGIC_ARITH.all;


entity BaseDeTiempo is		
	generic(			
			K: integer:= 50000000;	--	pulsos para contar 1 segundo en 50MHz.
			N: integer:=27		--	13 bits
 	 	    );
	 port(
		 CLK : in STD_LOGIC;	--	Reloj de la FPGA.
		 RST : in STD_LOGIC;	--	Reset maestro
		 H   : in STD_LOGIC;	--	Senal de habilitaciï¿½n de la base de tiempo
		 BT  : out STD_LOGIC	--	Base de tiempo
	     );
end BaseDeTiempo;


architecture Behavioral of BaseDeTiempo is
signal Qp,Qn : STD_LOGIC_VECTOR(N-1 downto 0):=(others => '0');	--	Estado presente y siguiente del contador
signal BdT   : STD_LOGIC:='0';									--	Señal de base de tiempo interna
signal BdTconH: STD_LOGIC_VECTOR(1 downto 0):=(others => '0');	--	Se?al base tiempo concatenada con la se?al de habilitaci?n

begin				

	BT <= BdT;
	BdTconH <=  BdT & H;																						

	Mux: process(BdTconH, Qp) is
	begin			
		case BdTconH is
			when "01" => Qn <= Qp +1;
			when "11" => Qn <= (others=>'0');
			when others => Qn <= Qp;
		end case;
	end process Mux;			
	
	Comparador: process(Qp) is
	begin				   
		if Qp = K then
			BdT <= '1';
		else
			BdT <= '0';
		end if;
	end process Comparador;
	
	
	
	combinacional: process(CLK, RST) is		--	Registro
	begin		   
		if RST = '0' then
			Qp <= (others=>'0');
		elsif CLK'event and CLK = '1' then
			Qp <= Qn; 
		end if;
	end process combinacional;
	
end Behavioral;