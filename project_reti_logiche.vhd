library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity project_reti_logiche is
 port (
 i_clk : in std_logic;
 i_rst : in std_logic;
 i_start : in std_logic;
 i_w : in std_logic;
 o_z0 : out std_logic_vector(7 downto 0);
 o_z1 : out std_logic_vector(7 downto 0);
 o_z2 : out std_logic_vector(7 downto 0);
 o_z3 : out std_logic_vector(7 downto 0);
 o_done : out std_logic;
 o_mem_addr : out std_logic_vector(15 downto 0);
 i_mem_data : in std_logic_vector(7 downto 0);
 o_mem_we : out std_logic := '0';
 o_mem_en : out std_logic := '0'
 );
 
end project_reti_logiche;



architecture project_reti_logiche_arch of project_reti_logiche is
    -- FSM: Macchina di Mealy
   type S is (S_START, S_2BIT, S_ACQUISIZ,S_DATA_REQUEST,S_DATA_WAIT,S_DEMUX, S_DISPLAY); -- enumeraz degli stati dove vado a finire
   signal curr_state : S;
    
   signal address : std_logic_vector(15 downto 0) := (others => '0');
   signal sel : std_logic_vector(1 downto 0) := (others => '0');
   signal w0 : std_logic_vector(7 downto 0) := (others => '0');
   signal w1 : std_logic_vector(7 downto 0) := (others => '0');
   signal w2 : std_logic_vector(7 downto 0) := (others => '0');
   signal w3 : std_logic_vector(7 downto 0) := (others => '0');
   begin
  
   lambda_delta: process(i_clk,i_rst,i_start)
begin
 
 -- Controlla se bisogna effettuare il RST
    if (i_rst = '1') then
                o_mem_en <= '0';
                o_done <= '0';
                o_z0 <= "00000000";
                o_z1 <= "00000000";
                o_z2 <= "00000000";
                o_z3 <= "00000000";
                w0 <= "00000000";
                w1 <= "00000000";
                w2 <= "00000000";
                w3 <= "00000000";
                address <= (others => '0');
                sel <= "00";
                o_mem_addr <= "0000000000000000";
                curr_state <= S_START; 
        
    elsif (rising_edge(i_clk) and i_clk = '1') then
        case curr_state is
        
-- Inizializza i segnali
            when S_START =>
                o_mem_en <= '0';
                o_mem_we <= '0';
                o_done <= '0';
                o_z0 <= "00000000";
                o_z1 <= "00000000";
                o_z2 <= "00000000";
                o_z3 <= "00000000";
                o_mem_addr <= "0000000000000000";
                address <= (others => '0');
                
-- Prende il primo bit ( di 2 bit) che servirà per selezionare il canale di uscita
                sel(1) <= i_w;
                
                if(i_start = '1') then
                    curr_state <= S_2BIT;
                else
                    curr_state <= S_START;
                end if;
                          
-- Prende il secondo bit (di 2 bit) che servirà per selezionare il canale di uscita
            when S_2BIT =>  
                o_done <= '0';
                sel(0) <= i_w;
                curr_state <= S_ACQUISIZ;
                
 -- Acquisizione dei bit che andranno a costituire l'indirizzo di memoria dal quale bisognerà leggere il dato da trasmettere in uscita           
            when S_ACQUISIZ =>                         
                o_done <= '0';
                if (i_start = '1') then
                    address(15) <= address(14);
                    address(14) <= address(13);
                    address(13) <= address(12);
                    address(12) <= address(11);
                    address(11) <= address(10);
                    address(10) <= address(9);
                    address(9) <= address(8);
                    address(8) <= address(7);
                    address(7) <= address(6);
                    address(6) <= address(5);
                    address(5) <= address(4);
                    address(4) <= address(3);
                    address(3) <= address(2);
                    address(2) <= address(1);
                    address(1) <= address(0);
                    address(0) <= i_w;
                    curr_state <= S_ACQUISIZ;
                else curr_state <= S_DATA_REQUEST;
              end if;
              
-- Richiesta di lettura dalla memoria                            
            WHEN S_DATA_REQUEST =>
                o_done <= '0';
                o_mem_en <= '1';
                o_mem_addr <= address; 
                
                if (sel = "00") 
                    then w0 <= (others => '0');
                     
                end if;
                
                if (sel = "01") 
                    then w1 <= (others => '0');
                     
                end if;
                
                if (sel = "10") 
                    then w2 <= (others => '0');
                     
                end if;
                
                if (sel = "11") 
                    then w3 <= (others => '0');
                     
                end if;
                curr_state <= S_DATA_WAIT;               
              
 -- Attesa per un ciclo di CLK affinchè il dato richiesto dalla memoria sia pronto                  
            when S_DATA_WAIT => o_done <= '0';
                curr_state <= S_DEMUX;
            
            when S_DEMUX => 
                if (sel = "00") 
                    then w0 <= i_mem_data;
                     
                end if;
                
                if (sel = "01") 
                    then w1 <= i_mem_data;
                     
                end if;
                
                if (sel = "10") 
                    then w2 <= i_mem_data;
                     
                end if;
                
                if (sel = "11") 
                    then w3 <= i_mem_data;
                     
                end if;
                curr_state <= S_DISPLAY;
                             
-- Display dell'OUTPUT                             
            when S_DISPLAY => 
            
                o_done <= '1';
                o_z0 <= w0;
                o_z1 <= w1;
                o_z2 <= w2;
                o_z3 <= w3;
                o_mem_en <= '0';
                address <= (others => '0');
                sel <= "00";
                o_mem_addr <= "0000000000000000";
                o_mem_we <= '0';
                curr_state <= S_START;
                               
                     
        end case;
    end if;
end process lambda_delta;


end project_reti_logiche_arch;