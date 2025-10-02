----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/24/2025 08:39:57 A
-- Design Name: 
-- Module Name: BitEncoder_tb - Behavioral
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

entity Encoder_tb is
end Encoder_tb;

architecture Behavioral of Encoder_tb is

    signal clk  : std_logic := '0';
    signal rst  : std_logic;        
      
begin

    clk <= not clk after 10 ns;
    rst <= '1', '0' after 15 ns;
    
    UUT: entity work.Encoder(Behavioral)
        generic map (
            FEATURE_WIDTH   => 8,
            INDEX_WIDTH     => 16, -- 16 olny for simulation. 14 is enough
            TOTAL_INDEXES   => 4,
            MAX_X           => 28,
            MAX_Y           => 28
        )
        port map (
            clk     => clk,
            rst     => rst           
        );

end Behavioral;
