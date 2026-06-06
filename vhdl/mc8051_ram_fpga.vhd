-------------------------------------------------------------------------------
-- mc8051_ram_fpga.vhd
-- Internal RAM (256 bytes) untuk mc8051 di Quartus
-- Digunakan sebagai data memory 8051
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.mc8051_p.all;

entity mc8051_ram is
  port (
    clk       : in  std_logic;
    reset     : in  std_logic;
    ram_data_i: in  std_logic_vector(7 downto 0);
    ram_data_o: out std_logic_vector(7 downto 0);
    ram_adr_i : in  std_logic_vector(6 downto 0);
    ram_wr_i  : in  std_logic;
    ram_en_i  : in  std_logic
  );
end mc8051_ram;

architecture fpga of mc8051_ram is

  type ram_type is array (0 to 127) of std_logic_vector(7 downto 0);
  signal s_ram : ram_type := (others => x"00");

begin

  p_ram : process(clk)
  begin
    if rising_edge(clk) then
      if ram_en_i = '1' then
        if ram_wr_i = '1' then
          s_ram(conv_integer(unsigned(ram_adr_i))) <= ram_data_i;
        end if;
        ram_data_o <= s_ram(conv_integer(unsigned(ram_adr_i)));
      end if;
    end if;
  end process;

end fpga;
