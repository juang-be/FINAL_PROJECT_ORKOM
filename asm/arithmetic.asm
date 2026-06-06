; ============================================================
; arithmetic.asm
; Program: Simple Arithmetic & Logic Operations
; Platform: mc8051 IP Core (Oregano Systems)
; Target  : FPGA Dev Board EP4CE6E22C8N via Quartus
;
; Operan:
;   R0 = 05h (5 desimal)
;   R1 = 03h (3 desimal)
;
; Hasil di RAM:
;   RAM[30h] = 08h  <- ADD (5+3=8,    1000b) -> LED4 ON
;   RAM[31h] = 02h  <- SUBB(5-3=2,    0010b) -> LED2 ON
;   RAM[32h] = 07h  <- ORL (5 OR 3=7, 0111b) -> LED3,2,1 ON
;   RAM[33h] = 01h  <- DIV (5/3=1,    0001b) -> LED1 ON
; ============================================================

reset:  LJMP    start

i_ext0: LJMP    j_ext0
        NOP
        NOP
        NOP
        NOP
        NOP
i_tim0: LJMP    j_tim0
        NOP
        NOP
        NOP
        NOP
        NOP
i_ext1: LJMP    j_ext1
        NOP
        NOP
        NOP
        NOP
        NOP
i_tim1: LJMP    j_tim1
        NOP
        NOP
        NOP
        NOP
        NOP
i_siu:  LJMP    j_siu

; start = 0026h
start:
        MOV     SP, #70h

        MOV     R0, #05h        ; R0 = 5
        MOV     R1, #03h        ; R1 = 3

        ; ADD: 5 + 3 = 8 (1000b)
        MOV     A, R0
        ADD     A, R1
        MOV     30h, A          ; RAM[30h] = 08h

        ; SUBB: 5 - 3 = 2 (0010b)
        MOV     A, R0
        CLR     C
        SUBB    A, R1
        MOV     31h, A          ; RAM[31h] = 02h

        ; ORL: 5 OR 3 = 0101 OR 0011 = 0111 = 7
        MOV     A, R0
        ORL     A, R1
        MOV     32h, A          ; RAM[32h] = 07h

        ; DIV: 5 / 3 = 1 sisa 2
        MOV     A, R0
        MOV     B, #03h
        DIV     AB
        MOV     33h, A          ; RAM[33h] = 01h (quotient)

        ; Output default ke P1 = hasil ADD
        MOV     P1, 30h         ; P1 = 08h

ende:   SJMP    ende

j_ext0: RETI
j_tim0: RETI
j_ext1: RETI
j_tim1: RETI
j_siu:  RETI

        END
