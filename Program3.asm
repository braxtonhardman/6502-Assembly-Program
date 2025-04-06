; pong game

; member variables
define screenStart          $0200
define screenEnd            $05FF
define screenWidth          $28
define screenHeight         $28

define gameState            $00
define difficulty           $02

define paddle_y_max $21

define ballX                $06
define ballY                $07
define ballDirX             $08
define ballDirY             $09
define ballSpeed            $0A

define lastKey              $0B

define ASCII_w $77 
define ASCII_s $73

    ; initialize start of game 
    jsr init 
    ; main game loop for input, update, and draw 
    jsr loop 

init: 
    ; load game state
    LDA #$01
    STA gameState

    ; set paddle position
    LDA #$01
    STA paddleX
    LDA #$0E
    STA paddleY
    LDA #$04
    STA paddleHeight

    ; set ball position
    LDA #$10
    STA ballX
    LDA #$10
    STA ballY
    LDA #$01
    STA ballDirX
    LDA #$01
    STA ballDirY
    LDA #$01
    STA ballSpeed

    ; loop is the game cycle 
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
    rts
downKey: 
    ; down direction is the value 0 
    LDA #$00 
    STA lastKey
    rts 

update:
    rts

score:
    rts

display:
    rts

gameover:

updatepaddle: 
ldy #$00

yloop: 
ldy #$00   

loop:
lda #$01 
sta screenStart , y 
tya
; Transfer Y to A
clc
adc #$20        ; Add 16
tay             ; Store result back into Y


CPY #paddle_y_max 
BNE loop

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