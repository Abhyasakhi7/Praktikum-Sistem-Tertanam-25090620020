library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu4 is
    Port ( a      : in STD_LOGIC_VECTOR (3 downto 0);
           b      : in STD_LOGIC_VECTOR (3 downto 0);
           opcode : in STD_LOGIC; -- '0'=tambah, '1'=kurang
           result : out STD_LOGIC_VECTOR (3 downto 0);
           carry  : out STD_LOGIC );
end alu4;

architecture Behavioral of alu4 is
    -- 1. Mengubah tipe data menjadi signed
    signal a_s, b_s : signed (3 downto 0);
    signal sum_ext  : signed (4 downto 0);
begin
    -- 2. Mengubah konversi input menjadi signed
    a_s <= signed(a);
    b_s <= signed(b);

    process(a_s, b_s, opcode)
    begin
        if opcode = '0' then
            -- 3. Logika penambahan (sign extension) dengan menduplikasi bit paling kiri
            sum_ext <= (a_s(3) & a_s) + (b_s(3) & b_s);
        else
            -- 3. Logika pengurangan (sign extension)
            sum_ext <= (a_s(3) & a_s) - (b_s(3) & b_s);
        end if;
    end process;

    result <= STD_LOGIC_VECTOR(sum_ext(3 downto 0));
    carry  <= sum_ext(4);
end Behavioral;

