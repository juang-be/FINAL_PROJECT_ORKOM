# ============================================================
# Pin Assignment
# Board: Chinese FPGA Dev Board (EP4CE6E22C8N)
# Sumber: TABEL_PIN_FPGA.pdf
# LED active LOW, KEY active LOW
# ============================================================

set_location_assignment PIN_23 -to FPGA_CLK
set_location_assignment PIN_25 -to RESET
set_location_assignment PIN_88 -to KEY1
set_location_assignment PIN_89 -to KEY2
set_location_assignment PIN_90 -to KEY3
set_location_assignment PIN_91 -to KEY4

# LED dibalik urutannya (LED1=pin84, LED4=pin87)
set_location_assignment PIN_84 -to LED1
set_location_assignment PIN_85 -to LED2
set_location_assignment PIN_86 -to LED3
set_location_assignment PIN_87 -to LED4

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to FPGA_CLK
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to RESET
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to KEY1
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to KEY2
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to KEY3
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to KEY4
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LED1
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LED2
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LED3
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LED4
