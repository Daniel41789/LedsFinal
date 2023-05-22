.include "gpio.inc" @ Includes definitions from gpio.inc file

.thumb              @ Assembles using thumb mode
.cpu cortex-m3      @ Generates Cortex-M3 instructions
.syntax unified

.include "nvic.inc"

wait_ms:
        # Prologue
        push    {r7}                @ backs r7 up
        sub     sp, sp, #28         @ reserves a 32-byte function frame
        add     r7, sp, #0          @ updates r7
        str     r0, [r7]            @ backs ms up
        # Body function
        mov     r0, #255            @ ticks = 255, adjust to achieve 1 ms delay
        str     r0, [r7, #16]       @ store ticks
# for (i = 0; i < ms; i++)
        mov     r0, #0              @ i = 0;
        str     r0, [r7, #8]        @ store i
        b       F0                  @ branch to F3
# for (j = 0; j < tick; j++)
F1:     mov     r0, #0              @ j = 0;
        str     r0, [r7, #12]       @ store j
        b       F2                  @ branch to F5
F3:     ldr     r0, [r7, #12]       @ r0 <-- j
        add     r0, #1              @ j++
        str     r0, [r7, #12]       @ store j
F2:     ldr     r0, [r7, #12]       @ r0 <-- j
        ldr     r1, [r7, #16]       @ r1 <-- ticks
        cmp     r0, r1              @ compare j with ticks 
        blt     F3                  @ branch if j is less than ticks
        ldr     r0, [r7, #8]        @ r0 <-- i
        add     r0, #1              @ i++
        str     r0, [r7, #8]        @ store i
F0:     ldr     r0, [r7, #8]        @ r0 <-- i
        ldr     r1, [r7]            @ r1 <-- ms
        cmp     r0, r1              @ compare i with ms
        blt     F1                  @ branch if i is less than ms
        # Epilogue
        adds    r7, r7, #28
        mov	    sp, r7
        pop	    {r7}
        bx	    lr

read_button_input:
    # Prologue
    push {r7}                       @ backs r7 up 
    sub sp, sp, #4                  @ reserves a 8 bytes function frame
    add r7, sp, #0                  @ updates r7
    str r0, [r7]                    @ backs function argument up
    # Body Function                 
    ldr r1, =GPIOA_IDR              @ load address
    ldr r1, [r1]                    @ load value
    ldr r0, [r7]                    @ load value of function argument
    and r1, r1, r0                   
    cmp r1, r0                      @ compare r1 with r0
    beq L0                          @ branch if r1 is equal r0
    @ return 0
    mov r0, #0                      @ r0 <-- 0
L0: 
    # Epilogue
    adds r7, r7, #4                  
    mov sp, r7                      
    pop {r7}
    bx lr                           

is_button_pressed:
    push {r7, lr}                   @ backs r7 and lr up
    sub sp, sp, #16                 @ reserves a 24 bytes function frame
    add r7, sp, #0                  @ updates r7
    str r0, [r7, #4]                @ backs function argument up
    ldr r0, [r7, #4]                @ r0 <-- function argument 
    bl read_button_input            @ branch to read_button_input
    ldr r3, [r7, #4]                @ r3 <-- function argument
    cmp r0, r3                      @ compare r0 with r3
    beq L1                          @ branch to L1 if r0 equal r3
    mov r0, #0                      @ r0 <-- 0
    adds r7, r7, #16                 
    mov sp, r7                      
    pop {r7}
    pop {lr}
    bx lr
L1: 
    mov r3, #0                      @ r3 <--- 0
    str r3, [r7, #8]                @ store r3
    # for (int i=0; i<10; i++)
    mov r3, #0                      @ r3 <-- 0
    str r3, [r7, #12]               @ store r3
    b L2                            @ branch to L2
L5: 
    mov r0, #50                     @ r0 <-- 50
    bl wait_ms                      @ branch to wait_ms function
    ldr r0, [r7, #4]                @ r0 <-- function argument
    bl read_button_input            @ branch to read read_button_input function
    ldr r3, [r7, #4]                @ r3 <-- function argument 
    cmp r0, r3                      @ compare r0 with r3    
    beq L3                          @ branch to L3 if r0 equal r3
    mov r3, #0                      @ r3 <-- 0
    str r3, [r7, #8]                @ store 0
L3: 
    ldr r3, [r7, #8]                @ r3 <-- 0
    add r3, #1                      @ c++
    str r3, [r7, #8]                @ store c++
    ldr r3, [r7, #8]                @ r3 <-- c
    cmp r3, #4                      @ compare r3 with 4
    blt L4                          @ branch to L4 if r3 less than 4
    ldr r0, [r7, #4]                @ r0 <-- function argument
    adds r7, r7, #16                 
    mov sp, r7
    pop {r7}
    pop {lr}
    bx lr
L4: 
    ldr r3, [r7, #12]               @ r3 <-- j
    add r3, #1                      @ j++
    str r3, [r7, #12]               @ store j++
L2: 
    ldr r3, [r7, #12]               @ r3 <-- j
    cmp r3, #10                     @ compare r3 with 10 
    blt L5                          @ branch to L5 if r3 less than 10

    # Epilogue
    mov r0, #0                      @ return 0
    adds r7, r7, #16
    mov sp, r7
    pop {r7}
    pop {lr}
    bx lr


reset:
    # prologue
    push {r7, lr}                   @ backs r7 and lr up
    sub sp, sp, #8                  @ reserves a 16 bytes function frame
    add r7, sp, #0                  @ updates r7
    # body function
    ldr r0, = GPIOB_ODR
    mov r1, 0x0
    str r1, [r0]
    # epilogue
    adds r7, r7, #8
    mov sp, r7
    pop {r7}
    pop {lr}
    bx lr

incremento:
    @ prologue
    push {r7, lr}
    sub sp, sp, #8
    add r7, sp, #0
    str r0, [r7, #4]        @ store argument of function
    @ end of prologue

    @ body function
    ldr r0, [r7, #4]        @ load counter into r0
    adds r0, r0, #1         @ counter++
    str r0, [r7,#4]         @ store counter++
    ldr r0, [r7, #4]
    ldr r1, =0x100          @ load 256 in r1 -> 2 ^ 8 Leds = 256
    cmp r0, r1              @ compare r0 with r1
    ble L6
    bl reset
    str r0, [r7, #4]        @ store counter
L6:
    ldr r0, [r0, #4] 
    @ epilogue
    adds r7, r7, #8
    mov sp, r7
    pop {r7}
    pop {lr}
    bx lr

decremento:
    @ prologue
    push {r7, lr}
    sub sp, sp, #8
    add r7, sp, #0
    str r0, [r7, #4]
    
    @ body function
    ldr r0, [r7, #4]
    sub r0, r0, #1          @ r0 <- r0 - 1 
    str r0, [r7, #4]        @ store r0 in d
    ldr r0, [r7, #4]
    cmp r0, #0
    bge L7
    bl reset
    str r0, [r7, #4]
L7:
    ldr r0, [r7, #4]
    @ epilogue
    adds r7, r7, #8
    mov sp, r7
    pop {r7}
    pop {lr}
    bx lr

setup: 
    @ prologue 
    push {r7, lr}
    sub sp, sp, #8
    add r7, sp, #0

    @ enabling clock in port A, B and C
    ldr r0, =RCC_APB2ENR
    mov r1, 0x1C
    str r1, [r0]

    @ set pins PA0 & PA4 as digital input
    ldr r0, =GPIOA_CRL
    ldr r1, =0x44484448
    str r1, [r0]

    @ set pins PB8 - PB15 as digital output
    ldr r0, =GPIOB_CRH
    ldr r1, =0x33333333
    str r1, [r0]

    @ set led status initial value 
    ldr r1, =GPIOB_ODR
    mov r2, 0x0
    str r2, [r1]

    mov r1, 0x0
    str r1, [r7, #4]

loop:
    mov r0, #0x11                     @ and with 17 <-- 0001 0001 (PA0 and PA4)
    bl is_button_pressed            @ function call is_button_pressed
    cmp r0, #0x11                     @ compare function return with 0001 0001
    bne L8                          @ branch if r0 not equal 17
    bl reset                        @ function call reset
    str r0, [r7, #4]                @ 
L8:
    # verificación del 'push button' (PA0)
    mov r0, #0x01                      @ r0 <-- 1 <-- 0000 0001
    bl is_button_pressed            @ function call is_button_pressed
    cmp r0, #0x01                      @ compare function return with 1
    bne L9                          @ branch if r0 not equal 1
    ldr r0, [r7, #4]
    bl incremento                   @ function call incremento
    str r0, [r7, #4]
L9:
    # verificación del 'push button' (PA4)
    mov r0, #0x10                     @ r0 <-- 16 <-- 0001 0000 (PA4)
    bl is_button_pressed            @ function call is_button_pressed
    cmp r0, #0x10                     @ compare r0 with #16
    bne L10                         @ branch to L8 if r0 not equal 16
    ldr r0, [r7, #4]                @
    bl decremento                   @ function call decremento
    str r0, [r7, #4]                @

L10:
    ldr r2, =GPIOB_ODR              @ 
    ldr r0, [r7, #4]                @ r0 <- counter 
    mov r1, r0                      @ r1 <- counter
    lsl r1, r1, #8                  @ counter << 8
    str r1, [r2]                    @ store r1 in r2 
    b loop
