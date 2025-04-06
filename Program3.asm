; pong game

; member variables
define screenStart          $0200
define screenEnd            $05FF
define screenWidth          $28
define screenHeight         $28

define paddle_start $10
; init paddle 
; low byte 
lda #$00
sta paddle_start
;high byte 
lda #$03
sta $11

define paddle_end $20 
; init paddle 
; low byte 
lda #$00
sta paddle_end
;high byte 
lda #$03
sta $21

define lastKey              $0B

define ASCII_w $77 
define ASCII_s $73

    ; initialize start of game 
    jsr init 
    ; main game loop for input, update, and draw 
    jsr loop 

init: 

    ;init paddle starter
    jsr add_paddle_start
    jsr add_paddle_start
    jsr add_paddle_start
    jsr add_paddle_start
    rts

loop:
    ; check the input of the use 
    jsr input 
    ; update needed variables 
    jsr update 
    ; display the updated positions 
    jsr display 
    jmp loop 
    rts

; get if user is pressing w or s
input:
    ; control paddle with w and s 
    ; $ff contains the value input of keyboard 
    LDA $ff
    ; need to load the valeu of ASCII_w as an literal value 
    CMP #ASCII_w
    BEQ upKey
    ; need to load the valeu of ASCII_s as an literal value 
    CMP #ASCII_s 
    BEQ downKey 
    rts
upKey:
    ; right now up direction is 1
    LDA #$01 
    STA lastKey
    jsr subtract_paddle_start
    jsr sub_paddle_end
    
    ;reset keyboard input 
    lda #$00
    sta $ff
    rts

downKey: 
    ; down direction is the value 0 
    LDA #$00 
    STA lastKey
    jsr add_paddle_start
    jsr add_paddle_end
    ;reset keyboard input 
    lda #$00
    sta $ff 
    rts 

update:
    rts

score:
    rts

display:
    rts

gameover:

rts

rightwall: 
; Store address $0200 in $10 (low) and $11 (high)
LDA #$1f
STA $10        ; Low byte of $0200
LDA #$02
STA $11

loop:

; draw white line at position using indirect indexing
LDA #$01
STA ($10), Y

; add 32 to the position 
CLC
tya 
adc #$20
tay 
; max value possible when adding 32
CPY #$e0 
BEQ resety 
jmp loop 
resety: 
CLC
; increment high byte by 1  
LDA $11
ADC #$01 
STA $11 
; reset y pointer 
ldy #$00
; jump back to the loop
jmp loop

subtract_paddle_start: 
; draw pixel
lda #$00 
sta (paddle_start), y 

SEC                 ; Set carry for subtraction
LDA $10             ; Load low byte
SBC #$20            ; Subtract 32
STA $10             ; Store back to low byte

LDA $11             ; Load high byte
SBC #$00            ; Subtract borrow
STA $11             ; Store back to high byte
rts

add_paddle_start: 
; draw pixel
lda #$01 
sta (paddle_start), y 

CLC                 ; Clear carry before addition
LDA $10             ; Load low byte
ADC #$20            ; Add 32
STA $10             ; Store back to low byte

LDA $11             ; Load high byte
ADC #$00            ; Add carry (if low byte overflowed)
STA $11             ; Store back to high byte
rts

sub_paddle_end: 
; draw pixel
lda #$01
sta (paddle_end), y 

SEC                 ; Set carry for subtraction
LDA $20             ; Load low byte
SBC #$20            ; Subtract 32
STA $20            ; Store back to low byte

LDA $21             ; Load high byte
SBC #$00            ; Subtract borrow
STA $21             ; Store back to high byte
rts

add_paddle_end: 
; draw pixel
lda #$00
sta (paddle_end), y 

CLC                 ; Clear carry before addition
LDA $20             ; Load low byte
ADC #$20            ; Add 32
STA $20             ; Store back to low byte

LDA $21             ; Load high byte
ADC #$00            ; Add carry (if low byte overflowed)
STA $21             ; Store back to high byte
rts
