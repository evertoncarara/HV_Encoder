----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/23/2025 02:39:17 PM
-- Design Name: 
-- Module Name: HVBits_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity HVBits_tb is
end HVBits_tb;

architecture Behavioral of HVBits_tb is

   signal clk : std_logic := '0';
   signal t: std_logic_vector(15 downto 0);    

begin

   
    UUT: entity work.HVBits(arch3)        
        port map(
            t       => t
        );
    
    clk <= not clk after 10 ns;
    
    process
    begin
        t <= (others=>'0');
        
        for i in 0 to 100 loop
            wait until rising_edge(clk);
            t <= STD_LOGIC_VECTOR(TO_UNSIGNED(i, t'length));
        end loop;        
    
        wait;
    end process;
    
end Behavioral;