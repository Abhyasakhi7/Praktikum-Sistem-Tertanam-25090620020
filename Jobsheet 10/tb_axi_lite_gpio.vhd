library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_axi_lite_gpio is
end tb_axi_lite_gpio;

architecture sim of tb_axi_lite_gpio is
  signal clk, resetn : std_logic := '0';
  signal awaddr, araddr : std_logic_vector(3 downto 0) := (others => '0');
  signal awvalid, awready, wvalid, wready : std_logic := '0';
  signal bvalid, bready, arvalid, arready, rvalid, rready : std_logic := '0';
  signal wdata, rdata : std_logic_vector(31 downto 0) := (others => '0');
  signal bresp, rresp : std_logic_vector(1 downto 0);
  signal gpio_out, gpio_in : std_logic_vector(15 downto 0) := (others => '0');
begin
  clk <= not clk after 5 ns;

  uut : entity work.axi_lite_gpio_v1_0
    port map (
      S_AXI_ACLK => clk, S_AXI_ARESETN => resetn,
      S_AXI_AWADDR => awaddr, S_AXI_AWVALID => awvalid, S_AXI_AWREADY => awready,
      S_AXI_WDATA => wdata, S_AXI_WVALID => wvalid, S_AXI_WREADY => wready,
      S_AXI_BRESP => bresp, S_AXI_BVALID => bvalid, S_AXI_BREADY => bready,
      S_AXI_ARADDR => araddr, S_AXI_ARVALID => arvalid, S_AXI_ARREADY => arready,
      S_AXI_RDATA => rdata, S_AXI_RRESP => rresp, S_AXI_RVALID => rvalid,
      S_AXI_RREADY => rready,
      gpio_out => gpio_out, gpio_in => gpio_in );

  stim : process
    variable rd : std_logic_vector(31 downto 0);

    procedure axi_write(addr : in std_logic_vector(3 downto 0);
                        data : in std_logic_vector(31 downto 0)) is
    begin
      wait until rising_edge(clk);
      awaddr <= addr; awvalid <= '1';
      wdata  <= data; wvalid  <= '1';
      bready <= '1';
      loop
        wait until rising_edge(clk);
        exit when awready = '1' and wready = '1';
      end loop;
      awvalid <= '0'; wvalid <= '0';
      wait until rising_edge(clk);
      bready <= '0';
    end procedure;

    procedure axi_read(addr : in std_logic_vector(3 downto 0);
                       data : out std_logic_vector(31 downto 0)) is
    begin
      wait until rising_edge(clk);
      araddr <= addr; arvalid <= '1'; rready <= '1';
      loop
        wait until rising_edge(clk);
        exit when arready = '1';
      end loop;
      data := rdata;
      arvalid <= '0';
      wait until rising_edge(clk);
      rready <= '0';
    end procedure;
  begin
    resetn <= '0';
    wait for 100 ns;
    resetn <= '1';
    wait for 50 ns;

    -- Tes 1: tulis reg0, cek LED
    axi_write("0000", x"0000A5A5");
    wait for 20 ns;
    assert gpio_out = x"A5A5" report "GAGAL: gpio_out salah" severity error;

    -- Tes 2: baca balik reg0
    axi_read("0000", rd);
    assert rd = x"0000A5A5" report "GAGAL: baca reg0 salah" severity error;

    -- Tes 3: baca switch lewat reg1
    gpio_in <= x"00F3";
    wait for 50 ns;
    axi_read("0100", rd);
    assert rd = x"000000F3" report "GAGAL: baca reg1 (switch) salah" severity error;

    -- Tes 4: tulis ke reg1 tidak boleh mengubah isinya (read-only)
    axi_write("0100", x"FFFFFFFF");
    axi_read("0100", rd);
    assert rd = x"000000F3" report "GAGAL: reg1 tidak read-only" severity error;

    report "Simulasi selesai" severity note;
    wait;
  end process;
end sim;