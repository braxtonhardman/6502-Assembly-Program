; this will be counter for 14 fibonacci numbers
LDY #$01
; using absolute addressing load value
LDA #$00
; store the value 0 at register 0300 
STA $0300
; Load value 0 into A register
LDA #$01 
; Store A in next location 
STA $0301 

; beginning of for loop
loop:

; clear the carry 
CLC 
; Load A from position + Y 
LDA $0300, Y
; Decrement Y to get previous value 
DEY 
; ADD value in a + previous position value 
ADC $0300, Y 
; Increment Y to 1 past the previous spot 
INY
INY 
; Store value of A into next register
STA $0300 ,Y 

; end of for loop
; compare y to 15 if zero then we finished
CPY #$0E
BNE loop