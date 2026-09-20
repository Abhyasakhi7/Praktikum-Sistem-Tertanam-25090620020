library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_leading_one_detector is
-- Testbench tidak memiliki port
end tb_leading_one_detector;

architecture behavior of tb_leading_one_detector is
    -- Deklarasi komponen (Unit Under Test)
    component leading_one_detector
        Generic (WIDTH : integer := 8);
        Port ( din  : in STD_LOGIC_VECTOR (WIDTH-1 downto 0);
               pos  : out STD_LOGIC_VECTOR (2 downto 0);
               valid : out STD_LOGIC );
    end component;

    -- Deklarasi sinyal internal
    signal din   : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal pos   : STD_LOGIC_VECTOR(2 downto 0);
    signal valid : STD_LOGIC;

begin
    -- Instansiasi UUT
    uut: leading_one_detector
        Generic Map (WIDTH => 8)
        Port Map (
            din   => din,
            pos   => pos,
            valid => valid
        );

    -- Proses stimulus
    stim_proc: process
    begin
        -- Pola 1: Semua nol
        din <= "00000000";
        wait for 10 ns;
        assert (valid = '0' and pos = "000") report "Error Pola 1: Harusnya valid='0', pos=0" severity error;

        -- Pola 2: Bit '1' tertinggi di indeks 7 (MSB)
        din <= "10000000";
        wait for 10 ns;
        assert (valid = '1' and pos = "111") report "Error Pola 2: Harusnya valid='1', pos=7" severity error;

        -- Pola 3: Bit '1' tertinggi di indeks 5
        din <= "00101000";
        wait for 10 ns;
        assert (valid = '1' and pos = "101") report "Error Pola 3: Harusnya valid='1', pos=5" severity error;

        -- Pola 4: Bit '1' tertinggi di indeks 1
        din <= "00000010";
        wait for 10 ns;
        assert (valid = '1' and pos = "001") report "Error Pola 4: Harusnya valid='1', pos=1" severity error;

        -- Pola 5: Bit '1' tertinggi di indeks 0 (LSB)
        din <= "00000001";
        wait for 10 ns;
        assert (valid = '1' and pos = "000") report "Error Pola 5: Harusnya valid='1', pos=0" severity error;

        -- Selesai
        report "Simulasi testbench leading-one detector selesai." severity note;
        wait;
    end process;

end behavior;

