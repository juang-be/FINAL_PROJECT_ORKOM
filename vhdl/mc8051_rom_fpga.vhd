-------------------------------------------------------------------------------
-- mc8051_rom_fpga.vhd
-- ROM berisi program aritmatika untuk mc8051 IP Core
--
-- Operan: R0 = 5 (05h), R1 = 3 (03h)
--
-- Hasil di RAM:
--   RAM[30h] = 08h  <- ADD  (5+3=8,  1000b) -> LED4 ON
--   RAM[31h] = 02h  <- SUBB (5-3=2,  0010b) -> LED2 ON
--   RAM[32h] = 07h  <- ORL  (5 OR 3= 7, 0111b) -> LED3,2,1 ON
--   RAM[33h] = 01h  <- DIV quotient (5/3=1, 0001b) -> LED1 ON
--
-- Port P1 default menampilkan hasil ADD (08h)
-- KEY1-KEY4 untuk switch tampilan LED
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.mc8051_p.all;

entity mc8051_rom is
  port (
    clk       : in  std_logic;
    reset     : in  std_logic;
    rom_adr_i : in  std_logic_vector(15 downto 0);
    rom_data_o: out std_logic_vector(7 downto 0)
  );
end mc8051_rom;

architecture fpga of mc8051_rom is

  type rom_type is array (0 to 255) of std_logic_vector(7 downto 0);

  -- ================================================================
  -- Assembly (arithmetic.asm):
  --
  -- reset:  LJMP start        ; 02 00 26
  -- [interrupt vectors + NOP padding]
  --
  -- start (0026h):
  --   MOV SP, #70h            ; 75 81 70
  --   MOV R0, #05h            ; 78 05
  --   MOV R1, #03h            ; 79 03
  --
  --   ; ADD: A = R0 + R1 = 5 + 3 = 8
  --   MOV A, R0               ; E8
  --   ADD A, R1               ; 29
  --   MOV 30h, A              ; F5 30
  --
  --   ; SUBB: A = R0 - R1 = 5 - 3 = 2
  --   MOV A, R0               ; E8
  --   CLR C                   ; C3
  --   SUBB A, R1              ; 99
  --   MOV 31h, A              ; F5 31
  --
  --   ; ORL: A = R0 OR R1 = 0101 OR 0011 = 0111 = 7
  --   MOV A, R0               ; E8
  --   ORL A, R1               ; 4A  (ORL A,Rn = 48h+n, R1=49h... wait)
  --   MOV 32h, A              ; F5 32
  --
  --   ; DIV: A = R0 / R1 = 5 / 3 = 1 sisa 2
  --   MOV A, R0               ; E8
  --   MOV B, #03h             ; 75 F0 03
  --   DIV AB                  ; 84
  --   MOV 33h, A              ; F5 33
  --
  --   ; Output default ke P1 = hasil ADD
  --   MOV P1, 30h             ; 85 30 90
  --
  -- ende: SJMP ende           ; 80 FE
  -- ================================================================

  constant ROM_DATA : rom_type := (
    -- 0000: Reset vector LJMP start (start=0x0026)
    0  => x"02", 1  => x"00", 2  => x"26",
    -- 0003: i_ext0 LJMP 0x0100
    3  => x"02", 4  => x"01", 5  => x"00",
    6  => x"00", 7  => x"00", 8  => x"00", 9  => x"00", 10 => x"00",
    -- 000B: i_tim0 LJMP 0x0106
    11 => x"02", 12 => x"01", 13 => x"06",
    14 => x"00", 15 => x"00", 16 => x"00", 17 => x"00", 18 => x"00",
    -- 0013: i_ext1 LJMP 0x010C
    19 => x"02", 20 => x"01", 21 => x"0C",
    22 => x"00", 23 => x"00", 24 => x"00", 25 => x"00", 26 => x"00",
    -- 001B: i_tim1 LJMP 0x0112
    27 => x"02", 28 => x"01", 29 => x"12",
    30 => x"00", 31 => x"00", 32 => x"00", 33 => x"00", 34 => x"00",
    -- 0023: i_siu LJMP 0x0118
    35 => x"02", 36 => x"01", 37 => x"18",

    -- 0026: start
    -- MOV SP, #70h
    38 => x"75", 39 => x"81", 40 => x"70",
    -- MOV R0, #05h
    41 => x"78", 42 => x"05",
    -- MOV R1, #03h
    43 => x"79", 44 => x"03",

    -- ADD: A = R0 + R1 = 5+3 = 8
    45 => x"E8",        -- MOV A, R0
    46 => x"29",        -- ADD A, R1
    47 => x"F5", 48 => x"30",  -- MOV 30h, A

    -- SUBB: A = R0 - R1 = 5-3 = 2
    49 => x"E8",        -- MOV A, R0
    50 => x"C3",        -- CLR C
    51 => x"99",        -- SUBB A, R1
    52 => x"F5", 53 => x"31",  -- MOV 31h, A

    -- ORL: A = R0 OR R1 = 5 OR 3 = 7
    54 => x"E8",        -- MOV A, R0
    55 => x"49",        -- ORL A, R1  (ORL A,Rn = 48h+n, R1=49h)
    56 => x"F5", 57 => x"32",  -- MOV 32h, A

    -- DIV: A = R0 / R1 = 5/3 = 1 sisa 2
    58 => x"E8",        -- MOV A, R0
    59 => x"75", 60 => x"F0", 61 => x"03",  -- MOV B, #03h
    62 => x"84",        -- DIV AB
    63 => x"F5", 64 => x"33",  -- MOV 33h, A (quotient=1)

    -- Output default ke P1 = hasil ADD (08h)
    65 => x"85", 66 => x"30", 67 => x"90",  -- MOV P1, 30h

    -- ende: SJMP ende
    68 => x"80", 69 => x"FE",

    others => x"00"
  );

begin

  p_rom : process(clk)
  begin
    if rising_edge(clk) then
      if conv_integer(unsigned(rom_adr_i)) < 256 then
        rom_data_o <= ROM_DATA(conv_integer(unsigned(rom_adr_i)));
      else
        rom_data_o <= x"32"; -- RETI untuk interrupt handler
      end if;
    end if;
  end process;

end fpga;
