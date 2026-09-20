library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_alu4_signed is
end tb_alu4_signed;

architecture behavior of tb_alu4_signed is
    -- Panggil komponen ALU versi signed yang sudah dibuat
    component alu4
        Port ( a      : in STD_LOGIC_VECTOR (3 downto 0);
               b      : in STD_LOGIC_VECTOR (3 downto 0);
               opcode : in STD_LOGIC;
               result : out STD_LOGIC_VECTOR (3 downto 0);
               carry  : out STD_LOGIC );
    end component;

    signal a      : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal b      : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal opcode : STD_LOGIC := '0';
    signal result : STD_LOGIC_VECTOR(3 downto 0);
    signal carry  : STD_LOGIC;

begin
    uut: alu4
        Port Map (
            a => a, b => b, opcode => opcode,
            result => result, carry => carry
        );

    stim_proc: process
    begin
        -- Skenario Normal: +3 ditambah +2 = +5
        opcode <= '0';
        a <= "0011"; -- +3
        b <= "0010"; -- +2
        wait for 20 ns;

        -- Skenario OVERFLOW: +7 ditambah +1
        -- Harusnya +8, tapi akan menghasilkan 1000 (-8 dalam signed 4-bit)
        opcode <= '0';
        a <= "0111"; -- +7
        b <= "0001"; -- +1
        wait for 20 ns;

        -- Skenario OVERFLOW: -8 dikurangi +1
        -- Harusnya -9, tapi akan menghasilkan 0111 (+7)
        opcode <= '1'; -- Mode kurang
        a <= "1000"; -- -8
        b <= "0001"; -- +1
        wait for 20 ns;

        wait;
    end process;

end behavior;

