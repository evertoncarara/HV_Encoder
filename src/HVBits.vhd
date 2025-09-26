----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/22/2025 10:17:18 AM
-- Design Name: 
-- Module Name: HVBits - Behavioral
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


entity HVBits is
    port (         
        t       : in std_logic_vector(15 downto 0);
        o       : out std_logic
    );
end HVBits;

architecture arch1 of HVBits is

    signal rt: UNSIGNED(15 downto 0);  
    signal rotate: integer;
    
    signal a: UNSIGNED(3 downto 0);
    signal b: UNSIGNED(1 downto 0);
    

begin
    
    rotate <= TO_INTEGER(UNSIGNED(t(3 downto 0)));

    rt <= ROTATE_RIGHT(UNSIGNED(t), rotate);
  
    a(0) <= rt(7) xor rt(6);
    a(1) <= rt(5) xor rt(4);
    a(2) <= rt(3) xor rt(2);
    a(3) <= rt(1) xor rt(0);

    b(0) <= a(0) xor a(1);
    b(1) <= a(2) xor a(3);
    
    o <= b(0) xor b(1); -- c[1]
    
end arch1;


architecture arch2 of HVBits is

    signal rt: UNSIGNED(15 downto 0);  
    signal rotate: integer;
    
    signal a: UNSIGNED(1 downto 0);
    signal b: UNSIGNED(3 downto 0);
    
begin
    
    rotate <= TO_INTEGER(UNSIGNED(t(3 downto 0)));

    rt <= ROTATE_RIGHT(UNSIGNED(t), rotate);
   
    a(0) <= rt(7) xor rt(6);
    a(1) <= rt(5) xor rt(4);   
    
    o <= a(0) xor a(1); -- b[2]
    
end arch2;





architecture arch3 of HVBits is

    signal rt: UNSIGNED(15 downto 0);  
    signal rotate: integer;
    
    signal a: UNSIGNED(3 downto 0);
    signal b: UNSIGNED(1 downto 0);
    

begin
    
    rotate <= TO_INTEGER(UNSIGNED(t(3 downto 0)));

    rt <= ROTATE_RIGHT(UNSIGNED(t), rotate);
       
    a(0) <= rt(15) xor rt(14);
    a(1) <= rt(13) xor rt(12);
    a(2) <= rt(11) xor rt(10);
    a(3) <= rt(9) xor rt(8);
  
    b(0) <= a(0) xor a(1);
    b(1) <= a(2) xor a(3);
    
    o <= b(0) xor b(1); -- c[0]
   
end arch3;


