library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_bram_1024x8 is
-- File testbench tidak memiliki port
end tb_bram_1024x8;

architecture Behavioral of tb_bram_1024x8 is
    signal clk  : STD_LOGIC := '0';
    signal we   : STD_LOGIC := '0';
    signal addr : STD_LOGIC_VECTOR(9 downto 0) := (others => '0'); -- 10-bit alamat
    signal din  : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal dout : STD_LOGIC_VECTOR(7 downto 0);

    constant clk_period : time := 10 ns; 
begin
    -- Instansiasi modul 1024x8
    uut: entity work.bram_1024x8
        port map ( clk => clk, we => we, addr => addr, din => din, dout => dout );

    -- Pembangkit clock 100 MHz
    clk_process :process begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus tulis dan baca
    stim_proc: process begin
        wait for 20 ns;
        
        -- Tulis data x"CC" ke alamat tertinggi 1023 (biner 10-bit: 1111111111)
        we <= '1';
        addr <= "1111111111";
        din <= x"CC";
        wait for clk_period;
        
        -- Tulis data x"DD" ke alamat 5 (biner 10-bit: 0000000101)
        addr <= "0000000101";
        din <= x"DD";
        wait for clk_period;
        
        -- Matikan Write Enable, pindah ke mode baca
        we <= '0';
        
        -- Baca dan verifikasi alamat 1023
        addr <= "1111111111";
        wait for clk_period * 2; -- Tunggu 1 siklus ekstra untuk registered output
        assert (dout = x"CC") report "Error: Data alamat 1023 tidak sesuai!" severity error;
        
        -- Baca dan verifikasi alamat 5
        addr <= "0000000101";
        wait for clk_period * 2;
        assert (dout = x"DD") report "Error: Data alamat 5 tidak sesuai!" severity error;
        
        wait;
    end process;
end Behavioral;