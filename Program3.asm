; pong game

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

define start_wall $12
; lower byte
lda #$1e
sta start_wall
; high byte
lda #$02
sta $13

define ball_pos $14
lda #$0f
sta ball_pos 
lda #$03 
sta $15

define ball_velocity_x $16
define ball_velocity_y $17
define ball_direction $18
LDA #01 ; ball direction variable that controls whether or not we are going left or right (1 = right and 0 = left)
STA ball_direction

; load the ball velocity into the X-register
LDA #100
STA ball_velocity_x

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
    JSR update_ball
    rts

update_ball:
    ; Erase old ball
    LDY #$00
    LDA #$00
    STA (ball_pos), Y

    ; jump to the ballSpeed label to wast time (make the processor do busy work to mimic speed)
    LDA ball_velocity_x
    LDX #0
    JMP ballSpeed

    ; now make the processor do busy work
    ballSpeed:
        CMP X 
        INX
        BNE ballSpeed


    ; Move ball left or right depending on direction
    LDA ball_direction
    CMP #$01
    BEQ move_right
    JMP move_left

move_right: ; move the ball right
    CLC
    LDA ball_pos
    ADC #$01
    STA ball_pos
    LDA $15
    ADC #$00
    STA $15
    rts

move_left: ; move the ball left
    SEC
    LDA ball_pos
    SBC #$01
    STA ball_pos
    LDA $15
    SBC #$00
    STA $15
    rts
 

score:
    rts

display:
    jsr draw_wall
    jsr draw_ball
    rts

check_ball:
    ; copy ball position to temp ($00/$01)
    LDA ball_pos
    STA $00
    LDA $15
    STA $01

    ; check direction
    LDA ball_direction
    CMP #$01
    BEQ check_right
    ; else it's left
check_left:
    ; subtract 1 from pointer
    SEC
    LDA $00
    SBC #$01
    STA $00
    LDA $01
    SBC #$00
    STA $01
    JMP check_collision

check_right:
    ; add 1 to pointer
    CLC
    LDA $00
    ADC #$01
    STA $00
    LDA $01
    ADC #$00
    STA $01

check_collision:
    LDY #$00
    LDA ($00), Y
    CMP #$01
    BNE no_collision

    ; flip direction
    LDA ball_direction
    EOR #$01       ; toggle 0 <-> 1
    STA ball_direction

    ; now decrement the value from the ball speed
    LDA ball_velocity_x
    TAX
    DEX
    LDX ball_velocity_x

    ; make sure we arent negative
    LDA ball_velocity_x
    BMI negativeSpeed
    JMP no_collision
    negativeSpeed:
        LDA #00
        STA ball_velocity_x

no_collision:
    RTS


draw_wall:
ldx #$00
wall_loop:
lda #$01
sta (start_wall), y  

CLC                 ; Clear carry before addition
LDA $12             ; Load low byte
ADC #$20            ; Add 32
STA $12             ; Store back to low byte

LDA $13             ; Load high byte
ADC #$00            ; Add carry (if any)
STA $13             ; Store back to high byte
inx
cpx #$20 
bne wall_loop

; reset wall start 
; lower byte
lda #$1e
sta start_wall
; high byte
lda #$02
sta $13
rts

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

draw_ball: 
    ; Draw new ball
    LDY #$00
    LDA #$01
    STA (ball_pos), Y

    ; Check for collision
    JSR check_ball
    RTS