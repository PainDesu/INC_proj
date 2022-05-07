-- uart_fsm.vhd: UART controller - finite state machine
-- Author(s): Alexandr Vrana
--
library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------
entity UART_FSM is
port(
   CLK   : in std_logic;
   RST   : in std_logic;
   DIN   : in std_logic;
   CNT   : in std_logic_vector(4 downto 0);
   CNT2  : in std_logic_vector(3 downto 0);
   RX_EN : out std_logic;
   DVLD  : out std_logic;
   CNT_EN: out std_logic
   );
end entity UART_FSM;

-------------------------------------------------
architecture behavioral of UART_FSM is
type STATE_TYPE is (WAIT_START, WAIT_READ, READ_DATA, WAIT_STOP, DATA_RECEVED);
signal state : STATE_TYPE := WAIT_START;
begin
   process (CLK) begin
      if rising_edge(CLK) then
         if RST = '1' then
               state <= WAIT_START;
         else
            case state is
               when WAIT_START => RX_EN <= '0';
                                  CNT_EN <= '0';
                                  DVLD <= '0';
                                 if DIN = '0' then 
                                    state <= WAIT_READ;
                                 end if;
               when WAIT_READ => RX_EN <= '0';
                                 CNT_EN <= '1';
                              if CNT ="10110" then                                     
                                    state <= READ_DATA;
                              end if;
               when READ_DATA =>   RX_EN <= '1';
                                   CNT_EN <= '1';
                              if CNT2 ="1000" then
                                       state <= WAIT_STOP;
                              end if;
               when WAIT_STOP => RX_EN <= '0';
                                 CNT_EN <= '1';
                              if CNT = "10000" then
                                 if DIN = '1' then
                                    state <= DATA_RECEVED;
                                 end if;
                              end if;
               when DATA_RECEVED => DVLD <= '1';
                                    state <= WAIT_START;
                                    
               when others => null;
            end case;
         end if;
      end if;
   end process;
end behavioral;
