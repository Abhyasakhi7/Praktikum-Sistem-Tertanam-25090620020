library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu4 is
    Port ( a      : in STD_LOGIC_VECTOR (3 downto 0);
           b      : in STD_LOGIC_VECTOR (3 downto 0);
           opcode : in STD_LOGIC_VECTOR (1 downto 0);
           result : out STD_LOGIC_VECTOR (7 downto 0);
           carry  : out STD_LOGIC );
end alu4;

architecture Behavioral of alu4 is
    signal a_u, b_u : unsigned (3 downto 0);
    signal sum_ext  : unsigned (4 downto 0);
    signal mul_ext  : unsigned (7 downto 0);
begin
    a_u <= unsigned(a);
    b_u <= unsigned(b);

    process(a_u, b_u, opcode)
    begin
        -- Nilai default
        sum_ext <= (others => '0');
        mul_ext <= (others => '0');

        if opcode = "00" then
            sum_ext <= ('0' & a_u) + ('0' & b_u);
        elsif opcode = "01" then
            sum_ext <= ('0' & a_u) - ('0' & b_u);
        elsif opcode = "10" then
            mul_ext <= a_u * b_u;
        end if;
    end process;

    process(opcode, sum_ext, mul_ext)
    begin
        if opcode = "10" then
            result <= STD_LOGIC_VECTOR(mul_ext);
            carry  <= '0';
        else
            result <= "0000" & STD_LOGIC_VECTOR(sum_ext(3 downto 0));
            carry  <= sum_ext(4);
        end if;
    end process;
end Behavioral;

