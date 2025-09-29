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
    
    constant FEATURE_WIDTH  : integer := 8;
    constant INDEX_WIDTH    : integer := 16; -- 16 olny for simulation. 14 is enough
    
    
    signal x, y: UNSIGNED(5 downto 0);
    
    
    
    signal data_av : std_logic;
    
    type State is (RESET, INIT_SAMPLE_MEM_ADDR, SAMPLE_MEM_ADDR, SUM, NEXT_INDEX, STALL);
    signal currentState : State;
    
    signal enc_rst: std_logic;
    
    
    -- Memories
    signal samples_addr: UNSIGNED(9 downto 0);
    signal feature : std_logic_vector(FEATURE_WIDTH - 1 downto 0);
    
    signal indexes_addr: UNSIGNED(10 downto 0);
    signal idx : std_logic_vector(INDEX_WIDTH - 1 downto 0); 
    
    
    constant MAX_Y          : integer := 2;
    constant MAX_X          : integer := 4;
    constant SAMPLE_SIZE    : integer := MAX_Y * MAX_X;
    constant TOTAL_INDEXES  : integer := 4;
    
    
begin

    SAMPLE: entity work.Memory(BlockRAM)
        generic map (
            imageFileName   => "image.txt",         
            DATA_WIDTH      => FEATURE_WIDTH,
            ADDR_WIDTH      => 10
        )
        port map (
            clock           => clk,
            wr              => '0',
            write_address   => (others=>'0'),
            read_address    => STD_LOGIC_VECTOR(samples_addr),
            data_i          => (others=>'0'),        
            data_o          => feature
        );
        
    INDEXES: entity work.Memory(BlockRAM)
        generic map (
            imageFileName   => "indexes.txt",         
            DATA_WIDTH      => INDEX_WIDTH,
            ADDR_WIDTH      => 11
        )
        port map (
            clock           => clk,
            wr              => '0',
            write_address   => (others=>'0'),
            read_address    => STD_LOGIC_VECTOR(indexes_addr),
            data_i          => (others=>'0'),        
            data_o          => idx
        );
    
    BIT_ENCODER: entity work.BitEncoder 
        port map (
            clk     => clk,
            rst     => enc_rst,
            idx     => idx,
            data    => feature,
            data_av => data_av,
            x       =>  STD_LOGIC_VECTOR(x),
            y       =>  STD_LOGIC_VECTOR(y)
        
        );
    
    clk <= not clk after 10 ns;
    rst <= '1', '0' after 15 ns;
   
    enc_rst <= '1' when currentState = INIT_SAMPLE_MEM_ADDR else '0';
    
    data_av <= '1' when currentState = SUM else '0';
        
    process(clk, rst)
    begin
        if rst = '1' then
            
            currentState <= RESET;
        
        elsif rising_edge(clk) then
            case currentState is 
                when RESET =>                    
                    indexes_addr <= (others=>'0');                    
                    currentState <= INIT_SAMPLE_MEM_ADDR;
                    
                when INIT_SAMPLE_MEM_ADDR =>
                    x <= (others=>'0');
                    y <= (others=>'0');
                    samples_addr <= (others=>'0');
                    currentState <= SAMPLE_MEM_ADDR;
                    
                when SAMPLE_MEM_ADDR =>
                    samples_addr <= samples_addr + 1;
                    currentState <= SUM;
                    
                when SUM =>           
                    if samples_addr < SAMPLE_SIZE then
                        samples_addr <= samples_addr + 1;
                    else
                        currentState <= NEXT_INDEX;
                    end if;
                    
                    if y < MAX_Y then
                        if x < MAX_X - 1 then
                            x <= x + 1;
                        else
                            x <= (others=>'0');
                            y <= y + 1;
                        end if; 
                    end if;
                    
                when NEXT_INDEX =>
                    if indexes_addr = TOTAL_INDEXES then
                        currentState <= STALL;
                    else
                        indexes_addr <= indexes_addr + 1;
                        currentState <= INIT_SAMPLE_MEM_ADDR;
                    end if;
                    
                when STALL =>
                    
                
            end case;
        end if;  
    end process;


end Behavioral;
