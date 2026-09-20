library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity js03_task2_top is
    Port ( sw  : in  STD_LOGIC_VECTOR (7 downto 0);
           led : out STD_LOGIC_VECTOR (3 downto 0) );
end js03_task2_top;

architecture Behavioral of js03_task2_top is
    component leading_one_detector
        Generic (WIDTH : integer := 8);
        Port ( din  : in STD_LOGIC_VECTOR (WIDTH-1 downto 0);
               pos  : out STD_LOGIC_VECTOR (2 downto 0);
               valid : out STD_LOGIC );
    end component;
begin
    U_PRIORITY: leading_one_detector
        Generic map (WIDTH => 8)
        port map (
            din   => sw(7 downto 0),
            pos   => led(3 downto 1), -- Menampilkan posisi pada LED 3, 2, 1
            valid => led(0)           -- Menampilkan flag valid pada LED 0
        );
end Behavioral;

