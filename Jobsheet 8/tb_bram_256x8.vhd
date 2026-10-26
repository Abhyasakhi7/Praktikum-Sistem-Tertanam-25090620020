library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_bram_256x8 is
-- Testbench tidak memiliki port
end tb_bram_256x8;

architecture Behavioral of tb_bram_256x8 is
    signal clk  : STD_LOGIC := '0';
    signal we   : STD_LOGIC := '0';
    signal addr : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal din  : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal dout : STD_LOGIC_VECTOR(7 downto 0);

    constant clk_period : time := 10 ns; -- Clock 100 MHz Basys 3
begin
    -- Instansiasi Unit Under Test (UUT)
    uut: entity work.bram_256x8
        port map ( clk => clk, we => we, addr => addr, din => din, dout => dout );

    -- Pembangkit clock
    clk_process :process begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Proses pengujian (stimulus)
    stim_proc: process begin
        wait for 20 ns;
        
        -- Tulis data x"AA" ke alamat x"05"
        we <= '1';
        addr <= x"05";
        din <= x"AA";
        wait for clk_period;
        
        -- Tulis data x"BB" ke alamat x"06"
        addr <= x"06";
        din <= x"BB";
        wait for clk_period;
        
        -- Matikan mode Write, mulai mode pembacaan
        we <= '0';
        
        -- Baca alamat x"05"
        addr <= x"05";
        wait for clk_period * 2; -- Tunggu 1 siklus clock untuk registered output
        assert (dout = x"AA") report "Error: Data alamat x05 tidak sesuai!" severity error;
        
        -- Baca alamat x"06"
        addr <= x"06";
        wait for clk_period * 2;
        assert (dout = x"BB") report "Error: Data alamat x06 tidak sesuai!" severity error;
        
        wait;
    end process;
end Behavioral;