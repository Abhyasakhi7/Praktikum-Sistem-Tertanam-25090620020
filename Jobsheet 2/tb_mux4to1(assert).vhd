library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_mux4to1 is
end tb_mux4to1;

architecture sim of tb_mux4to1 is
    signal sel_tb : STD_LOGIC_VECTOR(1 downto 0);
    signal in0_tb, in1_tb, in2_tb, in3_tb : STD_LOGIC_VECTOR(3 downto 0);
    signal y_tb   : STD_LOGIC_VECTOR(3 downto 0);
begin
    DUT: entity work.mux4to1
        port map ( sel => sel_tb,
                   in0 => in0_tb, in1 => in1_tb,
                   in2 => in2_tb, in3 => in3_tb,
                   y   => y_tb );

    stim_proc: process
    begin
        in0_tb <= "0001";
        in1_tb <= "0010";
        in2_tb <= "0100";
        in3_tb <= "1000";

        sel_tb <= "00"; wait for 20 ns;
        assert (y_tb = in0_tb)
            report "GAGAL: sel=00 seharusnya y=in0" severity error;

        sel_tb <= "01"; wait for 20 ns;
        assert (y_tb = in1_tb)
            report "GAGAL: sel=01 seharusnya y=in1" severity error;

        sel_tb <= "10"; wait for 20 ns;
        assert (y_tb = in2_tb)
            report "GAGAL: sel=10 seharusnya y=in2" severity error;

        sel_tb <= "11"; wait for 20 ns;
        assert (y_tb = in3_tb)
            report "GAGAL: sel=11 seharusnya y=in3" severity error;

        report "SEMUA SKENARIO SELESAI" severity note;
        wait;
    end process;
end sim;