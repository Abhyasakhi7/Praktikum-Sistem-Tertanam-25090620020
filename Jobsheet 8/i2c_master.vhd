library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity i2c_master is
    Port ( clk : in  STD_LOGIC;  -- Clock utama 100 MHz
           rst : in  STD_LOGIC;  -- Tombol reset
           scl : out STD_LOGIC;  -- Serial Clock I2C (100 kHz)
           sda : inout STD_LOGIC -- Serial Data I2C (dua arah)
         );
end i2c_master;

architecture Behavioral of i2c_master is
    -- Kerangka FSM konseptual
    type i2c_state is (S_IDLE, S_START, S_ADDR, S_ADDR_ACK, S_DATA, S_DATA_ACK, S_STOP);
    signal state : i2c_state := S_IDLE;
    
    -- Pembagi clock 100 MHz ke 100 kHz
    -- Target periode = 10us. Toggle terjadi setiap 5us (500 siklus clock)
    signal clk_div : integer range 0 to 499 := 0;
    signal i2c_clk : std_logic := '0';
begin

    -- Proses pembagi clock (Clock Divider)
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                clk_div <= 0;
                i2c_clk <= '0';
            elsif clk_div = 499 then
                clk_div <= 0;
                i2c_clk <= not i2c_clk;
            else
                clk_div <= clk_div + 1;
            end if;
        end if;
    end process;

    scl <= i2c_clk;
    
    -- Proses transisi State FSM
    process(i2c_clk, rst)
    begin
        if rst = '1' then
            state <= S_IDLE;
        elsif rising_edge(i2c_clk) then
            case state is
                when S_IDLE => state <= S_START;
                when S_START => state <= S_ADDR;
                when S_ADDR => state <= S_ADDR_ACK;
                when S_ADDR_ACK => state <= S_DATA;
                when S_DATA => state <= S_DATA_ACK;
                when S_DATA_ACK => state <= S_STOP;
                when S_STOP => state <= S_IDLE;
            end case;
        end if;
    end process;

    -- Kendali pin dua arah (open-drain / tri-state logic)
    -- 'Z' (High Impedance) saat fase menunggu respons ACK dari slave
    sda <= 'Z' when (state = S_ADDR_ACK or state = S_DATA_ACK) else '1';

end Behavioral;