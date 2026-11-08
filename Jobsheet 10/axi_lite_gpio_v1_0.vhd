library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity axi_lite_gpio_v1_0 is
  Generic ( C_S_AXI_ADDR_WIDTH : integer := 4;
            C_S_AXI_DATA_WIDTH : integer := 32 );
  Port (
    S_AXI_ACLK    : in  STD_LOGIC;
    S_AXI_ARESETN : in  STD_LOGIC;
    S_AXI_AWADDR  : in  STD_LOGIC_VECTOR(C_S_AXI_ADDR_WIDTH-1 downto 0);
    S_AXI_AWVALID : in  STD_LOGIC;
    S_AXI_AWREADY : out STD_LOGIC;
    S_AXI_WDATA   : in  STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH-1 downto 0);
    S_AXI_WVALID  : in  STD_LOGIC;
    S_AXI_WREADY  : out STD_LOGIC;
    S_AXI_BRESP   : out STD_LOGIC_VECTOR(1 downto 0);
    S_AXI_BVALID  : out STD_LOGIC;
    S_AXI_BREADY  : in  STD_LOGIC;
    S_AXI_ARADDR  : in  STD_LOGIC_VECTOR(C_S_AXI_ADDR_WIDTH-1 downto 0);
    S_AXI_ARVALID : in  STD_LOGIC;
    S_AXI_ARREADY : out STD_LOGIC;
    S_AXI_RDATA   : out STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH-1 downto 0);
    S_AXI_RRESP   : out STD_LOGIC_VECTOR(1 downto 0);
    S_AXI_RVALID  : out STD_LOGIC;
    S_AXI_RREADY  : in  STD_LOGIC;
    gpio_out      : out STD_LOGIC_VECTOR(15 downto 0);  -- ke LED
    gpio_in       : in  STD_LOGIC_VECTOR(15 downto 0)   -- dari switch
  );
end axi_lite_gpio_v1_0;

architecture rtl of axi_lite_gpio_v1_0 is
  signal reg0, reg2, reg3 : std_logic_vector(31 downto 0) := (others => '0');
  signal sw_s1, sw_s2     : std_logic_vector(15 downto 0) := (others => '0');
  signal awready, wready, bvalid : std_logic := '0';
  signal arready, rvalid         : std_logic := '0';
  signal rdata : std_logic_vector(31 downto 0) := (others => '0');
begin
  S_AXI_AWREADY <= awready;
  S_AXI_WREADY  <= wready;
  S_AXI_BVALID  <= bvalid;
  S_AXI_BRESP   <= "00";
  S_AXI_ARREADY <= arready;
  S_AXI_RVALID  <= rvalid;
  S_AXI_RDATA   <= rdata;
  S_AXI_RRESP   <= "00";
  gpio_out      <= reg0(15 downto 0);

  -- sinkronisasi switch (2 flip-flop)
  process(S_AXI_ACLK)
  begin
    if rising_edge(S_AXI_ACLK) then
      sw_s1 <= gpio_in;
      sw_s2 <= sw_s1;
    end if;
  end process;

  -- FSM tulis
  process(S_AXI_ACLK)
    variable idx : integer range 0 to 3;
  begin
    if rising_edge(S_AXI_ACLK) then
      if S_AXI_ARESETN = '0' then
        awready <= '0'; wready <= '0'; bvalid <= '0';
        reg0 <= (others => '0'); reg2 <= (others => '0'); reg3 <= (others => '0');
      else
        awready <= '0';
        wready  <= '0';
        if S_AXI_AWVALID = '1' and S_AXI_WVALID = '1' and bvalid = '0' and awready = '0' then
          awready <= '1';
          wready  <= '1';
          bvalid  <= '1';
          idx := to_integer(unsigned(S_AXI_AWADDR(3 downto 2)));
          case idx is
            when 0 => reg0 <= S_AXI_WDATA;
            when 2 => reg2 <= S_AXI_WDATA;
            when 3 => reg3 <= S_AXI_WDATA;
            when others => null;          -- reg1 (switch) read-only
          end case;
        elsif bvalid = '1' and S_AXI_BREADY = '1' then
          bvalid <= '0';
        end if;
      end if;
    end if;
  end process;

  -- FSM baca
  process(S_AXI_ACLK)
    variable idx : integer range 0 to 3;
  begin
    if rising_edge(S_AXI_ACLK) then
      if S_AXI_ARESETN = '0' then
        arready <= '0'; rvalid <= '0'; rdata <= (others => '0');
      else
        arready <= '0';
        if S_AXI_ARVALID = '1' and rvalid = '0' and arready = '0' then
          arready <= '1';
          rvalid  <= '1';
          idx := to_integer(unsigned(S_AXI_ARADDR(3 downto 2)));
          case idx is
            when 0 => rdata <= reg0;
            when 1 => rdata <= x"0000" & sw_s2;
            when 2 => rdata <= reg2;
            when others => rdata <= reg3;
          end case;
        elsif rvalid = '1' and S_AXI_RREADY = '1' then
          rvalid <= '0';
        end if;
      end if;
    end if;
  end process;
end rtl;