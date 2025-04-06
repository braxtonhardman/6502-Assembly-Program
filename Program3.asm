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
define ball_prev_pos $19 
LDA #01 ; ball direction variable that controls whether or not we are going left or right (1 = right and 0 = left)
STA ball_direction

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
    ; Save current ball position to ball_prev_pos
    LDA ball_pos
    STA ball_prev_pos
    LDA $15
    STA $1A

    ; Move ball left or right depending on direction
    LDA ball_direction
    CMP #$01
    BEQ move_right
    JMP move_left

; if ball is right we are going to increment the ball pointer 1 to the right 
move_right:
    CLC
    LDA ball_pos
    ADC #$01
    STA ball_pos
    LDA $15
    ADC #$00
    STA $15
    rts

; if the ball is left we are going to decrement the ball pinter 1 to the left 
move_left:
    SEC
    LDA ball_pos
    SBC #$01
    STA ball_pos
    LDA $15
    SBC #$00
    STA $15
    rts
 
; draw both the wall and the ball every frame
; paddle is immedietly drawn from the input 
display:
    jsr draw_wall
    jsr draw_ball
    rts

; check the collision of the ball 
check_ball:
    ; store the pos of the previous ball to erase in the draw subroutine 
    LDA ball_pos
    STA $00
    LDA $15
    STA $01

    ; check direction right = 1, left = 0 
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
    ; if collision is left jump over the check right 
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
    ; if collision is not left we automatically go to check_collision

; check if the register infront of the ball_pos is 1 
check_collision:
    ; location uses indrect adressing stored at low $00 and hight $01 
    LDY #$00
    LDA ($00), Y
    CMP #$01
    ;if no collision jump over switching the direction 
    BNE no_collision

    ; flip direction
    LDA ball_direction
    EOR #$01       ; toggle 0 <-> 1
    STA ball_direction
    ; regardless we run into rts 

no_collision:
    RTS

; draw the wall using start_wall pointer
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

; loop for 32 increment wall pointer
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
    LDY #$00

    ; Erase previous ball
    LDA #$00
    STA (ball_prev_pos), Y

    ; Draw new ball
    LDA #$01
    STA (ball_pos), Y

    ; Check for collision
    JSR check_ball
    RTS