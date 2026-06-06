-------------------------------------------------------------------------------
-- mc8051_ramx_fpga.vhd
-- External RAM (XRAM) untuk mc8051 di Quartus
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.mc8051_p.all;

entity mc8051_ramx is
  port (
    clk       : in  std_logic;
    reset     : in  std_logic;
    ram_data_i: in  std_logic_vector(7 downto 0);
    ram_data_o: out std_logic_vector(7 downto 0);
    ram_adr_i : in  std_logic_vector(15 downto 0);
    ram_wr_i  : in  std_logic
  );
end mc8051_ramx;

architecture fpga of mc8051_ramx is

  type ramx_type is array (0 to 255) of std_logic_vector(7 downto 0);
  signal s_ramx : ramx_type := (others => x"00");

begin

  p_ramx : process(clk)
  begin
    if rising_edge(clk) then
      if ram_wr_i = '1' then
        s_ramx(conv_integer(unsigned(ram_adr_i(7 downto 0)))) <= ram_data_i;
      end if;
      ram_data_o <= s_ramx(conv_integer(unsigned(ram_adr_i(7 downto 0))));
    end if;
  end process;

end fpga;
