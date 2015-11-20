public rect_x1,rect_y1,rect_x2,rect_y2 	;for rect.asm
public s_x1,s_y1,s_x2,s_y2,b_tx,b_ty 	;for rect.asm
public map							   	;for drawMap.asm
public scan_code						;for keyint.asm
public key_flag							;for keyint.asm
public bombr							;for rect.asm
public timer_flag						;for timer.asm
public bmb 								;for rect.asm
public creep							;for rect.asm

extern draw_rect:near				   	;from rect.asm
extern drawMap:near					   	;from drawMap.asm
extern keyboard_int:near			   	;from keyint.asm
extern setup_int:near				   	;from setint.asm
extern draw_bomber:near					;from rect.asm
extern draw_pixel:near					;from rect.asm
extern timer_tick:near					;from timer.asm

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

;parameters for drawing rectangle
rect_x1 dw ?
rect_y1 dw ?
rect_x2 dw ?
rect_y2 dw ?

;parameters for bomberman
b_tx dw 0
b_ty dw 0

;parameters for creep
c_tx dw 0
c_ty dw 0

;parameters for drawing sprite
s_x1 dw 0
s_y1 dw 0
s_x2 dw 0
s_y2 dw 0

;variables for keyboard
up_arrow = 48h
down_arrow = 50h
left_arrow = 4Bh
right_arrow = 4Dh
spc_button = 39h



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
	
	mov b_tx,1
	mov b_ty,1
	call draw_bomber
	
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
	;call setup_int
	
	;call fileread_bombr
	
	
	
	
	call drawMap
	
	;mov ah,1h	;take an input from keyboard
	;int 21h
	call reset_display
	
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
	;call setup_int
	
	mov ah,4ch
	int 21h
main endp
	end main