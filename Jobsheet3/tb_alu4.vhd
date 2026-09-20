library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_alu4 is
-- Testbench tidak memiliki port
end tb_alu4;

architecture behavior of tb_alu4 is
    -- Deklarasi komponen ALU
    component alu4
        Port ( a      : in STD_LOGIC_VECTOR (3 downto 0);
               b      : in STD_LOGIC_VECTOR (3 downto 0);
               opcode : in STD_LOGIC;
               result : out STD_LOGIC_VECTOR (3 downto 0);
               carry  : out STD_LOGIC );
    end component;

    -- Sinyal internal untuk simulasi
    signal a, b      : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal opcode    : STD_LOGIC := '0';
    signal result    : STD_LOGIC_VECTOR(3 downto 0);
    signal carry     : STD_LOGIC;

begin
    -- Instansiasi UUT (Unit Under Test)
    uut: alu4
        Port Map (
            a      => a,
            b      => b,
            opcode => opcode,
            result => result,
            carry  => carry
        );

    -- Proses pemberian stimulus (nilai input)
    stim_proc: process
    begin
        -- Kasus 1 (Sesuai Modul): Penjumlahan 7 + 1 = 8 (Carry 0)
        a <= "0111";
        b <= "0001";
        opcode <= '0'; -- '0' = Tambah
        wait for 10 ns;
        assert (result = "1000" and carry = '0') report "Error Kasus 1: Gagal pada 7+1" severity error;

        -- Kasus 2: Penjumlahan dengan Carry 15 + 1 = 16 (Result 0, Carry 1)
        a <= "1111";
        b <= "0001";
        opcode <= '0';
        wait for 10 ns;
        assert (result = "0000" and carry = '1') report "Error Kasus 2: Gagal pada 15+1" severity error;

        -- Kasus 3: Pengurangan 8 - 3 = 5
        a <= "1000";
        b <= "0011";
        opcode <= '1'; -- '1' = Kurang
        wait for 10 ns;
        assert (result = "0101" and carry = '0') report "Error Kasus 3: Gagal pada 8-3" severity error;

        -- Kasus 4: Pengurangan 5 - 5 = 0
        a <= "0101";
        b <= "0101";
        opcode <= '1';
        wait for 10 ns;
        assert (result = "0000" and carry = '0') report "Error Kasus 4: Gagal pada 5-5" severity error;

        -- Selesai
        report "Simulasi testbench ALU selesai." severity note;
        wait;
    end process;

end behavior;

