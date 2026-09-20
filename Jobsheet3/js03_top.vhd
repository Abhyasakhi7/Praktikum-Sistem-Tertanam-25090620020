library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity js03_top is
    Port ( sw  : in  STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (4 downto 0) );
end js03_top;

architecture Behavioral of js03_top is
    -- Deklarasi komponen alu4 agar bisa digunakan
    component alu4
        Port ( a      : in STD_LOGIC_VECTOR (3 downto 0);
               b      : in STD_LOGIC_VECTOR (3 downto 0);
               opcode : in STD_LOGIC;
               result : out STD_LOGIC_VECTOR (3 downto 0);
               carry  : out STD_LOGIC );
    end component;

begin
    -- Instansiasi alu4 dan pemetaan pin
    U_ALU: alu4 port map (
        a      => sw(3 downto 0),
        b      => sw(7 downto 4),
        opcode => sw(15),
        result => led(3 downto 0),
        carry  => led(4)
    );

end Behavioral;

