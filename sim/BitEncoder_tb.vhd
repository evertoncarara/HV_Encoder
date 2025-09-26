----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/24/2025 08:39:57 AM
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

entity BitEncoder_tb is
--  Port ( );
end BitEncoder_tb;

architecture Behavioral of BitEncoder_tb is

    signal clk : std_logic := '0';
    signal rst: std_logic;
    
    --type sample is array (natural range<>, natural range<>) of std_logic_vector(7 downto 0);
    --signal img: sample (0 to 1, 0 to 3):=( 
    --    (x"01", x"02", x"03", x"04"),
    --    (x"05", x"06", x"07", x"08")
    --);
    
    signal x, y: UNSIGNED(5 downto 0);
    
    signal data : std_logic_vector(7 downto 0);
    signal idx : UNSIGNED(15 downto 0);
    signal data_av : std_logic;
    
    type State is (S0, MEM_ADDR, S1, S2, S3);
    signal currentState : State;
    
    signal enc_rst: std_logic;
    
    signal address: UNSIGNED(9 downto 0);
    
    constant MAX_Y : integer := 2;
    constant MAX_X : integer := 4;
    constant SAMPLE_SIZE : integer := MAX_Y * MAX_X;
    
    
begin

    SAMPLE: entity work.Memory(BlockRAM)
        generic map (
            imageFileName   => "image.txt",         
            DATA_WIDTH      => 8,
            ADDR_WIDTH      => 10
        )
        port map (
            clock           => clk,
            wr              => '0',
            write_address   => (others=>'0'),
            read_address    => STD_LOGIC_VECTOR(address),
            data_i          => (others=>'0'),        
            data_o          => data
        );
    
    BIT_ENCODER: entity work.BitEncoder 
        port map (
            clk     => clk,
            rst     => enc_rst,
            idx     => STD_LOGIC_VECTOR(idx),
            data    => data,
            data_av => data_av,
            x       =>  STD_LOGIC_VECTOR(x),
            y       =>  STD_LOGIC_VECTOR(y)
        
        );
    
    clk <= not clk after 10 ns;
    rst <= '1', '0' after 15 ns;
   
    enc_rst <= '1' when currentState = S0 else '0';
    
    data_av <= '1' when currentState = S1 else '0';
        
    process(clk, rst)
    begin
        if rst = '1' then
            
            idx <= TO_UNSIGNED(0, idx'length);
            currentState <= S0;
        
        elsif rising_edge(clk) then
            case currentState is 
                when S0 =>
                    address <= (others=>'0');
                    x <= (others=>'0');
                    y <= (others=>'0');
                    currentState <= MEM_ADDR;
                    
                when MEM_ADDR =>
                    address <= address + 1;
                    currentState <= S1;
                    
                when S1 =>           
                    if address < SAMPLE_SIZE then
                        address <= address + 1;
                    else
                        currentState <= S2;
                    end if;
                    
                    if y < MAX_Y then
                        if x < MAX_X - 1 then
                            x <= x + 1;
                        else
                            x <= (others=>'0');
                            y <= y + 1;
                        end if; 
                    end if;
                    
                when S2 =>
                    if idx = 4 then
                        currentState <= S3;
                    else
                        idx <= idx + 1;
                        currentState <= S0;
                    end if;
                    
                when S3 =>
                    
                
            end case;
        end if;  
    end process;


end Behavioral;
