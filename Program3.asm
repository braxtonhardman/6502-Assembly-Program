; pong game

; member variables
define screenStart          $0200
define screenEnd            $05FF
define screenWidth          $28
define screenHeight         $28

define gameState            $00
define difficulty           $02

define paddle_x_max $02
define paddle_y_max $32

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
ldx #$00

loop:
lda #$01 
STA screenStart, X
INX
CPX #paddle_x_max 
BNE loop

loop: 
lda $ff 
jmp loop