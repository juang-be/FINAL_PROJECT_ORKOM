# mc8051 Simple Arithmetic — DE0-Nano Setup Guide

## Gambaran Proyek
Program ini menjalankan operasi aritmatika dasar (ADD, SUBB, MUL, DIV, INC, DEC)
pada IP core mc8051 (Oregano Systems) yang diimplementasikan di FPGA DE0-Nano.
Hasil operasi ditampilkan melalui LED onboard.

---

## Struktur File

```
mc8051_arithmetic/
├── vhdl/
│   ├── mc8051_p.vhd              ← Package (konstanta & tipe)
│   ├── mc8051_rom_fpga.vhd       ← ROM berisi program aritmatika  ← BARU
│   ├── mc8051_ram_fpga.vhd       ← Internal RAM 8051              ← BARU
│   ├── mc8051_ramx_fpga.vhd      ← External RAM (XRAM)            ← BARU
│   ├── arithmetic_top.vhd        ← Top-level wrapper DE0-Nano     ← BARU
│   ├── [semua file vhdl/ lainnya dari IP core mc8051]
├── asm/
│   └── arithmetic.asm            ← Source assembly (referensi)
├── de0_nano_pins.tcl             ← Pin assignment script
└── README.md
```

---

## Langkah Setup di Quartus Prime Lite

### Step 1: Buat Project Baru
1. Buka Quartus Prime Lite
2. **File → New Project Wizard**
3. Isi:
   - Directory: pilih folder `mc8051_arithmetic/`
   - Project name: `arithmetic_mc8051`
   - Top-level entity: `arithmetic_top`
4. Klik **Next**

### Step 2: Pilih Device
1. Di halaman "Family, Device & Board Settings":
   - Family: **Cyclone IV E**
   - Device: **EP4CE22F17C6**
   (atau search "EP4CE22F17C6" di kotak filter)
2. Klik **Next** → **Finish**

### Step 3: Tambahkan Semua File VHDL
1. **Project → Add/Remove Files in Project**
2. Klik tombol **...** (browse), arahkan ke folder `vhdl/`
3. Tambahkan file-file berikut **sesuai urutan ini** (urutan penting!):

   ```
   mc8051_p.vhd
   control_mem_.vhd
   control_mem_rtl.vhd
   control_mem_rtl_cfg.vhd
   control_fsm_.vhd
   control_fsm_rtl.vhd
   control_fsm_rtl_cfg.vhd
   mc8051_control_.vhd
   mc8051_control_struc.vhd
   mc8051_control_struc_cfg.vhd
   alucore_.vhd
   alucore_rtl.vhd
   alucore_rtl_cfg.vhd
   alumux_.vhd
   alumux_rtl.vhd
   alumux_rtl_cfg.vhd
   addsub_cy_.vhd
   addsub_cy_rtl.vhd
   addsub_cy_rtl_cfg.vhd
   addsub_ovcy_.vhd
   addsub_ovcy_rtl.vhd
   addsub_ovcy_rtl_cfg.vhd
   addsub_core_.vhd
   addsub_core_struc.vhd
   addsub_core_struc_cfg.vhd
   comb_divider_.vhd
   comb_divider_rtl.vhd
   comb_divider_rtl_cfg.vhd
   comb_mltplr_.vhd
   comb_mltplr_rtl.vhd
   comb_mltplr_rtl_cfg.vhd
   dcml_adjust_.vhd
   dcml_adjust_rtl.vhd
   dcml_adjust_rtl_cfg.vhd
   mc8051_alu_.vhd
   mc8051_alu_struc.vhd
   mc8051_alu_struc_cfg.vhd
   mc8051_siu_.vhd
   mc8051_siu_rtl.vhd
   mc8051_siu_rtl_cfg.vhd
   mc8051_tmrctr_.vhd
   mc8051_tmrctr_rtl.vhd
   mc8051_tmrctr_rtl_cfg.vhd
   mc8051_core_.vhd
   mc8051_core_struc.vhd
   mc8051_core_struc_cfg.vhd
   mc8051_rom_.vhd
   mc8051_ram_.vhd
   mc8051_ramx_.vhd
   mc8051_rom_fpga.vhd       <- implementasi ROM
   mc8051_ram_fpga.vhd       <- implementasi RAM
   mc8051_ramx_fpga.vhd      <- implementasi RAMX
   mc8051_top_.vhd
   mc8051_top_struc.vhd
   mc8051_top_struc_cfg.vhd
   arithmetic_top.vhd        <- TOP LEVEL (paling terakhir)
   ```

4. Pastikan **Top-level entity** diset ke `arithmetic_top`

### Step 4: Import Pin Assignment
1. Buka **Tcl Scripts**: **Tools → Tcl Scripts**
2. Browse ke file `de0_nano_pins.tcl`
3. Klik **Run**

   Atau bisa manual:
   1. **Assignments → Pin Planner**
   2. Set pin sesuai tabel di bawah

### Step 5: Compile
1. Klik **Processing → Start Compilation** (Ctrl+L)
2. Tunggu hingga selesai (~5-10 menit pertama kali)
3. Pastikan **tidak ada error** (warning boleh ada)

### Step 6: Upload ke DE0-Nano
1. Hubungkan DE0-Nano ke PC via USB (USB-Blaster)
2. **Tools → Programmer**
3. Klik **Hardware Setup**, pilih **USB-Blaster**
4. Klik **Add File**, pilih file `.sof` di folder `output_files/`
5. Centang **Program/Configure**
6. Klik **Start**

---

## Hasil yang Diharapkan di LED

Setelah upload berhasil, LED DE0-Nano akan menampilkan:

```
LED:  7  6  5  4  3  2  1  0
      OFF OFF ON ON ON OFF OFF OFF
           ↑  ↑  ↑
```

Ini adalah nilai **38h = 00111000b**, yaitu hasil operasi ADD:
- 25h (37 desimal) + 13h (19 desimal) = **38h (56 desimal)**

Tekan **KEY[0]** untuk reset, LED akan mati sebentar lalu kembali menyala.

---

## Ringkasan Operasi Aritmatika

| Operasi | Instruksi | Operan A | Operan B | Hasil | Alamat RAM |
|---------|-----------|----------|----------|-------|-----------|
| Penjumlahan | ADD  | 25h (37) | 13h (19) | 38h (56)  | RAM[30h] |
| Pengurangan | SUBB | 25h (37) | 13h (19) | 12h (18)  | RAM[31h] |
| Perkalian (low)  | MUL | 25h (37) | 13h (19) | EFh | RAM[32h] |
| Perkalian (high) | MUL | 25h (37) | 13h (19) | 02h | RAM[33h] |
| Pembagian (quotient)  | DIV | 25h (37) | 13h (19) | 01h | RAM[34h] |
| Pembagian (remainder) | DIV | 25h (37) | 13h (19) | 12h | RAM[35h] |
| Increment | INC | 38h (56) | — | 39h (57) | RAM[36h] |
| Decrement | DEC | 12h (18) | — | 11h (17) | RAM[37h] |

---

## Pin Assignment Manual (jika Tcl tidak berhasil)

| Signal     | Pin  | Keterangan         |
|------------|------|--------------------|
| CLOCK_50   | R8   | 50 MHz oscillator  |
| KEY[0]     | J15  | Push button reset  |
| KEY[1]     | E1   | Push button (unused)|
| LED[0]     | A15  | LED paling kanan   |
| LED[1]     | A13  |                    |
| LED[2]     | B13  |                    |
| LED[3]     | A11  |                    |
| LED[4]     | D1   |                    |
| LED[5]     | F3   |                    |
| LED[6]     | B1   |                    |
| LED[7]     | L3   | LED paling kiri    |
