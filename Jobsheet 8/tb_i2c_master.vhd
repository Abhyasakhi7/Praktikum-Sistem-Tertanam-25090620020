library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_i2c_master is
-- Kosong karena ini file testbench
end tb_i2c_master;

architecture Behavioral of tb_i2c_master is
    -- Sinyal internal simulasi
    signal clk : STD_LOGIC := '0';
    signal rst : STD_LOGIC := '0';
    signal scl : STD_LOGIC;
    signal sda : STD_LOGIC;

    -- Konstanta periode untuk 100 MHz
    constant clk_period : time := 10 ns; 
begin
    -- Instansiasi modul I2C Master
    uut: entity work.i2c_master
        port map (
            clk => clk,
            rst => rst,
            scl => scl,
            sda => sda
        );

    -- Membangkitkan Clock 100 MHz
    clk_process: process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Proses inisiasi sinyal simulasi
    stim_proc: process
    begin
        -- Kondisi awal, berikan logika reset
        rst <= '1';
        wait for 100 ns;
        
        -- Lepas reset agar FSM bekerja
        rst <= '0';
        
        -- Simulasi dibiarkan berjalan selama 200 mikrodetik 
        -- agar cukup waktu melihat sinyal SCL 100 kHz berkedip
        wait for 200 us; 
        
        wait;
    end process;
end Behavioral;