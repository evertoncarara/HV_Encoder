----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/22/2025 02:25:26 M
-- Design Name: 
-- Module Name: BitEncoder - Behavioral
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

entity BitEncoder is
    generic (
        DIMENSIONS  : integer := 10000;
        THRESHOLD   : integer := 0   
    );
    port ( 
        clk         : in std_logic;
        rst         : in std_logic;
        idx         : in std_logic_vector (15 downto 0);
        data        : in std_logic_vector (7 downto 0);
        x           : in std_logic_vector (5 downto 0);
        y           : in std_logic_vector (5 downto 0);
        data_av     : in std_logic;
        b           : out std_logic
    );
end BitEncoder;

architecture Behavioral of BitEncoder is

    signal hv_bit_f, hv_bit_x, hv_bit_y : std_logic;
    signal bind_fxy : std_logic;
    
    signal idx_f, idx_x, idx_y : SIGNED (15 downto 0);
    signal temp_idx_f, temp_idx_x, temp_idx_y : SIGNED (15 downto 0);
    
    signal count: UNSIGNED(9 downto 0);

begin

    -- Emulate roll acording to 'data'
    temp_idx_f <= SIGNED(idx) - SIGNED(data); 
    idx_f <= temp_idx_f when temp_idx_f >= 0 else temp_idx_f + TO_SIGNED(DIMENSIONS, temp_idx_f'length);

    BASE_HV_F: entity work.HVBits(arch1) port map(
        t   => STD_LOGIC_VECTOR(idx_f),
        o   => hv_bit_f
    );
    
    -- Emulate roll acording to 'x'
    temp_idx_x <= SIGNED(idx) - SIGNED(x); 
    idx_x <= temp_idx_x when temp_idx_x >= 0 else temp_idx_x + TO_SIGNED(DIMENSIONS, temp_idx_x'length);
    
    BASE_HV_X: entity work.HVBits(arch3) port map(
        t   => STD_LOGIC_VECTOR(idx_x),
        o   => hv_bit_x
    );
    
    -- Emulate roll acording to 'y'
    temp_idx_y <= SIGNED(idx) - SIGNED(y); 
    idx_y <= temp_idx_y when temp_idx_y >= 0 else temp_idx_y + TO_SIGNED(DIMENSIONS, temp_idx_y'length);
    
    BASE_HV_Y: entity work.HVBits(arch2) port map(
        t   => STD_LOGIC_VECTOR(idx_y),
        o   => hv_bit_y
    );
    
    bind_fxy <= hv_bit_f xor hv_bit_x xor hv_bit_y;    
    
    process(clk, rst)
    begin
        if rst = '1' then
            count <= (others=>'0');
            
        elsif rising_edge(clk) then
            if data_av = '1' then
                count <= count + unsigned'("" & bind_fxy);
            end if;          
        end if;
    end process;
    
    b <= '1' when count > THRESHOLD else '0';
    


end Behavioral;
