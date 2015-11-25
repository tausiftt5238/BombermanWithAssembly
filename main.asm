public rect_x1,rect_y1,rect_x2,rect_y2 	;for rect.asm
public s_x1,s_y1,s_x2,s_y2,b_tx,b_ty 	;for rect.asm,bomb.asm
public map							   	;for drawMap.asm,rect.asm,bomb.asm
public scan_code						;for keyint.asm
public key_flag							;for keyint.asm
public bombr							;for rect.asm
public timer_flag						;for timer.asm
public bmb 								;for rect.asm
public creep							;for rect.asm
public temp_x,temp_y					;for rect.asm
public bomb_life, bomb_x, bomb_y		;for bomb.asm
public fire								;for rect.asm
public fire_x, fire_y					;for rect.asm
public c_tx,c_ty,c_alive				;for creep.asm
public c_dir,c_index,c_count			;for creep.asm,bomb.asm
public rand								;for creep.asm
public life								;for creep.asm, bomb.asm

extern draw_rect:near				   	;from rect.asm
extern drawMap:near					   	;from drawMap.asm
extern keyboard_int:near			   	;from keyint.asm
extern setup_int:near				   	;from setint.asm
extern draw_bomber:near					;from rect.asm
extern draw_pixel:near					;from rect.asm
extern timer_tick:near					;from timer.asm
extern move_bomber:near					;from rect.asm
extern clear_tile:near					;from rect.asm
extern set_bomb:near					;from bomb.asm
extern clear_bomb:near					;from bomb.asm
extern draw_bmb:near					;from rect.asm
extern bomb_blast:near					;from bomb.asm
extern update_creep:near				;from creep.asm

include mac

.model small
.stack 100h
.data

;variables for interrupts

new_timer_vec dw ? , ?
old_timer_vec dw ? , ?
new_key_vec	dw ? , ?
old_key_vec dw ? , ?
scan_code	db 0
key_flag db 0
timer_flag db 0
temp_x dw 0
temp_y dw 0

;parameters for drawing rectangle
rect_x1 dw ?
rect_y1 dw ?
rect_x2 dw ?
rect_y2 dw ?

;parameters for bomberman
b_tx dw 0
b_ty dw 0
life dw 1

;parameters for creep
c_tx dw 7,18,16
c_ty dw 9,1,11
c_alive dw 1,1,1
c_index dw 0
c_dir dw 0
c_count dw 3

rand dw 1

;parameters for drawing sprite
s_x1 dw 0
s_y1 dw 0
s_x2 dw 0
s_y2 dw 0

;parameter for explosion
fire_x dw 0
fire_y dw 0

;variables for keyboard
up_arrow = 48h
down_arrow = 50h
left_arrow = 4Bh
right_arrow = 4Dh
spc_button = 39h
esc_key	= 1

;bomb variables
bomb_life db -1
bomb_x	dw -1
bomb_y 	dw -1



;map of the level
;map db 2 dup(1), 5 dup(0), 8 dup(1), 10 dup(0), 11 dup(1), 4 dup(0), 2 dup(1), 5 dup(0), 9 dup(1), 9 dup(0), 9 dup(1), 12 dup(0), 10 dup(1), 5 dup(0) 
map db 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
	db 8,0,0,4,0,4,4,0,0,8,4,0,0,0,4,0,0,0,0,8
	db 8,0,8,4,8,0,8,0,8,0,4,8,0,8,4,8,0,8,0,8
	db 8,4,4,4,0,4,0,4,0,0,8,0,0,0,4,4,4,0,0,8
	db 8,0,8,0,8,0,8,4,8,0,0,8,0,8,0,8,4,8,0,8
	db 8,4,4,4,4,4,0,0,0,8,0,0,4,4,0,0,4,0,0,8
	db 8,0,8,4,8,0,8,0,8,0,0,8,4,8,4,8,4,8,4,8
	db 8,0,0,4,0,0,0,4,4,4,8,0,4,0,0,0,0,0,0,8
	db 8,0,8,0,8,0,8,0,8,0,0,8,0,8,0,8,0,8,4,8
	db 8,4,4,4,4,4,0,0,0,8,0,4,0,0,4,4,4,0,0,8
	db 8,0,8,4,8,4,8,0,8,4,4,8,0,8,4,8,0,8,0,8
	db 8,0,0,0,0,0,0,0,0,4,8,0,0,0,4,0,0,0,0,8
	db 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8

;map db 20 dup(8)
;	db 8 , 18 dup (0) , 8
;	db 8 , 18 dup (0) , 8
;	db 8 , 18 dup (0) , 8
;	db 8 , 18 dup (0) , 8
;	db 8 , 18 dup (0) , 8
;	db 8 , 18 dup (0) , 8
;	db 8 , 18 dup (0) , 8
;	db 8 , 18 dup (0) , 8
;	db 8 , 18 dup (0) , 8
;	db 8 , 18 dup (0) , 8
;	db 8 , 18 dup (0) , 8
;	db 20 dup(8)

bombr	db 0,0,0,0,0,4,4,4,4,4,0,0,0,0,0
		db 0,0,0,0,0,4,4,4,4,4,0,0,0,0,0
		db 0,0,0,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0,0,0
		db 0,0,0,0fh,0eh,0,0eh,0eh,0eh,0,0eh,0fh,0,0,0
		db 0,0,0,0fh,0eh,0,0eh,0eh,0eh,0,0eh,0fh,0,0,0
		db 0,0,0,0fh,0eh,0,0eh,0eh,0eh,0,0eh,0fh,0,0,0
		db 0,0,0,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0,0,0
		db 0,0,0fh,1,1,1,1,1,1,1,1,1,0fh,0,0
		db 0,0,0fh,1,1,1,1,1,1,1,1,1,0fh,0,0
		db 0,0,0fh,1,1,1,1,1,1,1,1,1,0fh,0,0
		db 0,0,0fh,0,0,0,0eh,0eh,0eh,0,0,0,0fh,0,0
		db 0,0,0,1,1,1,1,1,1,1,1,1,0,0,0
		db 0,0,0,1,1,1,1,1,1,1,1,1,0,0,0
		db 0,0,4,4,4,4,0,0,0,0,4,4,4,4,0
		db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		
bmb		db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		db 0,0,0,0,0,5,5,5,5,5,0,0,0,0,0
		db 0,0,0,0,5,5,5,5,5,5,5,0,0,0,0
		db 0,0,0,5,5,5,5,5,5,5,5,5,0,0,0
		db 0,0,5,5,5,5,5,5,5,5,5,5,5,0,0
		db 0,0,5,5,5,5,5,5,5,5,5,5,5,0,0
		db 0,0,5,5,5,5,5,5,5,5,5,5,5,0,0
		db 0,0,5,5,5,5,5,5,5,5,5,5,5,0,0
		db 0,0,0,5,5,5,5,5,5,5,5,5,0,0,0
		db 0,0,0,0,5,5,5,5,5,5,5,0,0,0,0
		db 0,0,0,0,0,5,5,5,5,5,0,0,0,0,0
		db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		
creep	db 0,0,0,0,0eh,0eh,2,2,2,2,2,2,0,0,0
		db 0,0,0,0,0eh,0eh,2,2,2,2,2,2,0,0,0
		db 0,0,0,0,2,0,0,2,2,0,0,2,0,0,0
		db 0,0,0,0,2,2,2,2,2,2,0eh,0eh,0,0,0
		db 0,0,0,0,2,2,2,0,0,2,0eh,0eh,0,0,0
		db 0,0,0,0,2,2,0,2,2,0,2,2,0,0,0
		db 0,0,0,0,0,0,2,2,2,2,0,0,0,0,0
		db 0,0,0,2,2,2,2,0eh,0eh,2,2,2,2,0,0
		db 0,0eh,0eh,0eh,2,2,2,0eh,0eh,2,2,2,2,2,2
		db 0,0eh,0eh,0eh,2,0,2,0eh,0eh,2,0,2,2,2,2
		db 0,0,0,0,0,0,2,0eh,0eh,2,0,0,0,0,0
		db 0,0,0,0,0,0,2,2,2,2,0,0,0,0,0
		db 0,0,0,2,2,2,2,0,0,2,2,2,2,0,0
		db 0,0,0,2,0eh,0eh,2,0,0,2,0eh,0eh,2,0,0
		db 0,0,0,2,2,2,2,0,0,2,2,2,2,0,0
		
fire 	db 4,4,4,0eh,4,0eh,0eh,0eh,0eh,4,0eh,4,0eh,0eh,4
		db 4,0eh,4,4,0eh,4,4,0eh,4,4,4,0eh,0eh,4,0eh
		db 0eh,4,4,0eh,0eh,0eh,4,4,0eh,0eh,0eh,4,4,0eh,4
		db 4,4,4,0eh,0eh,4,0eh,0eh,0eh,0eh,0eh,4,0eh,4,0eh
		db 4,0eh,4,4,0eh,0eh,4,0eh,0eh,4,4,4,0eh,0eh,0eh
		db 4,4,4,4,4,4,4,4,4,4,0eh,0eh,4,4,0eh
		db 0eh,0eh,0eh,4,4,0eh,0eh,4,4,0eh,4,4,4,4,4
		db 0eh,4,4,0eh,4,4,4,4,0eh,0eh,0eh,0eh,4,4,4
		db 4,4,4,0eh,0eh,4,4,4,4,4,0eh,0eh,4,0eh,4
		db 0eh,4,0eh,4,4,0eh,4,4,0eh,0eh,4,4,4,4,4
		db 4,4,4,4,0eh,0eh,4,4,0eh,4,4,0eh,0eh,4,0eh
		db 0eh,4,0eh,0eh,4,4,4,4,4,4,4,4,4,0eh,0eh
		db 4,0eh,0eh,0eh,4,4,4,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh
		db 4,0eh,4,4,4,4,4,0eh,4,4,4,0eh,4,4,4
		db 0eh,0eh,4,4,4,0eh,0eh,0eh,0eh,4,4,0eh,4,0eh,4


.code

;setup display for graphics mode
setup_display proc
	push ax
	mov ax,12h 	;resolution 640x480, 16 color
	int 10h
	pop ax
	ret
setup_display endp

;setup display to go back to text mode
reset_display proc
	push ax
	mov ax,3h	;to go back to text mode
	int 10h
	pop ax
	ret
reset_display endp


main proc
	mov ax,@data
	mov ds,ax
	
	call setup_display
	
	;set up timer interrupt vector
	mov new_timer_vec, offset timer_tick	;offset
	mov new_timer_vec+2,cs					;segment
	mov al,1ch								;interrupt number
	lea di, old_timer_vec
	lea si, new_timer_vec
	call setup_int
	
	;set up keyboard interrupt vector
	mov new_key_vec, offset keyboard_int		;offset
	mov new_key_vec+2, cs						;segment
	mov al,9h									;interrupt number
	lea di, old_key_vec
	lea si, new_key_vec
	call setup_int
	
	mov b_tx,1
	mov b_ty,2
	call draw_bomber
	call drawMap
	
;keyboard press test starts here
	
test_key:
	cmp key_flag,1		;check key flag
	jne test_timer		;not set, go ceck timer flag
	mov bx,b_tx
	mov cx,b_ty
	call clear_tile		;if key is pressed, clear bomberman from current position
	cmp bomb_life,0
	jle test_key_skip
	call draw_bmb		;draw bomb if bomb_life > 0
test_key_skip:
	mov key_flag,0		;flag set, clear it and check scan code
	cmp scan_code,esc_key	;esc key?
	jne tk_up			;no, check arrow keys
	jmp done			;esc, terminate

;direction checking starts here
	
tk_up:
	cmp scan_code, up_arrow		;up arrow?
	jne tk_down					;no, check down arrow
	mov bx,-20
	mov si,0
	call move_bomber
	jmp test_timer				;go check timer
	
tk_down:
	cmp scan_code, down_arrow		;down arrow?
	jne tk_left					;no, check left arrow
	mov bx,20
	mov si,0
	call move_bomber
	jmp test_timer				;go check timer
	
tk_left:
	cmp scan_code, left_arrow		;left arrow?
	jne tk_right					;no, check right arrow
	mov bx,0
	mov si,-1
	call move_bomber
	jmp test_timer				;go check timer
	
tk_right:
	cmp scan_code, right_arrow		;right arrow?
	jne tk_space					;no , check space bar
	mov bx,0
	mov si,1
	call move_bomber
	jmp test_timer				;go check timer
	
tk_space:
	cmp scan_code, spc_button		;space button?
	jne test_timer					;no , check timer
	cmp bomb_life,0					;is a bomb active?
	jge tk_space_skip				;yes? skip
	call set_bomb
tk_space_skip:
	
test_timer:
	;it's name test_timer, but doesn't do that :v it was when we had actual test timer here :p
	push cx
	mov cx,5
delay:
	cmp timer_flag,1			;timer ticked?
	jne delay					;no, keep checking
	mov timer_flag,0
	;bomberman keeps getting rendered here
	call draw_bomber			
	
	loop delay					;delay it for 500ms
	pop cx
	
	;rendering other stuff (creep, bomb, explosion) starts here
	
	call update_creep
	cmp life,1					;check if life is less than 1, you might wanna move this check later on to accomodate the check for bombs as well
	jl done						;checked for <1 coz for some reason the check doesn't activate for <=0. duibar collide korar por kaj hoi.
	cmp bomb_life,0				;check if explosion is to happen
	je burst_bomb				;yes? explosion!!!
	jl delay_skip				; < 0 ? skip
	dec bomb_life				;decrease bomb_life
	call draw_bmb				;render bomb
	jmp delay_skip				;done rendering
burst_bomb:						;after explosion, dec bomb_life to -1
	call bomb_blast
	dec bomb_life				;decrease bomb_life (to make it -1)
	call clear_bomb				;bomb is done, clear it.
	call bomb_blast
	cmp c_count,0				;if all creeps dead, done
	je done
	cmp life,0
	jle done
delay_skip:
	
	jmp test_key
			
	;reset timer interrupt vector
done:
	lea di,new_timer_vec
	lea si, old_timer_vec
	mov al,1ch
	call setup_int
	
	;reset keyboard interrupt vector
	lea di, new_key_vec
	lea si,old_key_vec
	mov al,9h
	call setup_int
	
	call reset_display
	
	mov ah,4ch
	int 21h
main endp
	end main