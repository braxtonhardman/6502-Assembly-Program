jsr main 
jsr helper 

main: 
; Draw a pattern
; $100 will keep track of the screen register
LDA #$C8
; $100 
STA $A0

loop: 
; Clear carry 
CLC 
; Increments register 100 by 4 
LDA #$04 
ADC $a0 
STA $a0
; Doesnt do anything really 
CPY $FF
BNE loop

; helper changes the color of the drawing 
jsr helper
rts 