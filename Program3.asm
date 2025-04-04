; pong game

; member variables
define screenStart          $0200
define screenEnd            $05FF
define screenWidth          $28
define screenHeight         $28

define gameState            $00
define score                $01
define difficulty           $02

define paddleX              $03
define paddleY              $04
define paddleHeight         $05

define ballX                $06
define ballY                $07
define ballDirX             $08
define ballDirY             $09
define ballSpeed            $0A

define lastKey              $0B


;main program

    jsr main

main:
    ; load game state
    LDA #$01
    STA gameState

    ; clear score and set difficulty
    LDA #$00
    STA score
    LDA #$01
    STA difficulty

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



    rts

loop:
    rts

input:
    rts

update:
    rts

score:
    rts

display:
    rts

gameover:
