; Program 2: Ethan Emerson, Braxton Hardman, Christian Sapp

; call the main subroutine
JSR main
BRK


; create the main subroutine
main:

    LDA #00 ; inital loop value
    LDX #00 ; inital address value
    LDY #00 ; initial inner loop value

    ; main loop to change color
    loop:
        PHA ; push the A value to keep track of how many times we are looping
        JSR changeColor
        STA $0200,X
        STA $0300,X
        INX
        STA $0200,X
        STA $0300,X
        INX
        PLA
        ADC #01
        CLC
        CMP #128 ; 16 colors before restarting so 8 rows of that = 128 End of row every 32 memory addresses (so that was the math worked out) 
        BNE loop

    RTS


; color change subroutine just adds one to A
changeColor:
    ADC #$01
    CLC
    RTS