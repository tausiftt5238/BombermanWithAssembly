include mac

.model small
.stack 100h
.data

;parameters for drawing rectangle
rect_x1 dw ?
rect_y1 dw ?
rect_x2 dw ?
rect_y2 dw ?

;parameters for bomberman 
b_x1 dw 0
b_y1 dw 0
b_x2 dw 0
b_y2 dw 0

;variables for keyboard
up_arrow = 48h
down_arrow = 50h
left_arrow = 4Bh
right_arrow = 4Dh
spc_button = 39h

;variables for interrupts
new_key_vec	dw ? , ?
old_key_vec dw ? , ?
scan_code	db 0
key_flag db 0

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
	
	;set up keyboard interrupt vector
	mov new_key_vec, offset keyboard_int		;offset
	mov new_key_vec+2, cs						;segment
	mov al,9h									;interrupt number
	lea di, old_key_vec
	lea si, new_key_vec
	call setup_int
	
	;call fileread_bombr
	
	;call drawMap
	
	mov b_x1,15
	mov b_y1,15
	mov b_x2,30
	mov b_y2,30
	call draw_bomber
	
	mov ah,1h	;take an input from keyboard
	int 21h
	call reset_display
	
	;reset keyboard interrupt vector
	lea di, new_key_vec
	lea si,old_key_vec
	mov al,9h
	call setup_int
	
	mov ah,4ch
	int 21h
main endp 
draw_rect proc
	save_reg
	
	mov ah,0ch
	mov cx,rect_x1
	mov dx,rect_y1
	
draw_rect_loop:
	call draw_pixel
	inc cx
	cmp cx,rect_x2
	jl draw_rect_loop
	mov cx,rect_x1
	inc dx
	cmp dx,rect_y2
	jl draw_rect_loop
	
	load_reg
	ret
draw_rect endp

draw_sprite proc
	save_reg
	
	lea bx,bombr
	mov ah,0ch
	mov cx,rect_x1
	mov dx,rect_y1
	
draw_sprite_loop:
	mov al,[bx]
	int 10h
	inc cx
	cmp cx,rect_x2
	inc bx
	jl draw_sprite_loop
	mov cx,rect_x1
	inc dx
	cmp dx,rect_y2
	jl draw_sprite_loop
	
	load_reg
	ret
draw_sprite endp

draw_box proc
	save_reg
	
	mov ax,15d
	mul si
	mov rect_x1,ax
	mov rect_x2,ax
	add rect_x2,15d
	
	mov ax,bx
	mov cl,20
	div cl		;quotient is in al
	mov ah,0
	mov cx,15d
	mul cx
	mov rect_y1,ax
	mov rect_y2,ax
	add rect_y2,15d
	
	mov al,4h
	call draw_rect
	
	load_reg
	ret
draw_box endp
draw_enemy proc
	
	ret
draw_enemy endp

draw_bomber proc
	save_reg
	
	mov ah,0ch
	mov cx,b_x1
	mov dx,b_y1
	lea si,bombr
	
draw_bomber_loop:
	mov al,[si]
	inc si
	call draw_pixel
	inc cx
	cmp cx,b_x2
	jl draw_bomber_loop
	mov cx,b_x1
	inc dx
	cmp dx,b_y2
	jl draw_bomber_loop
	
	load_reg
	ret
draw_bomber endp


draw_pixel proc
	push cx
	push dx
	
	shl cx,1
	shl dx,1
	int 10h		;top-left pixel
	
	inc cx
	int 10h		;top-right
	
	dec cx
	inc dx
	int 10h		;bottom-left
	
	inc cx
	int 10h		;bottom-right
	
	pop dx
	pop cx
	ret
draw_pixel endp
	

draw_unbreak proc
	save_reg
	
	mov ax,15d
	mul si
	mov rect_x1,ax
	mov rect_x2,ax
	add rect_x2,15d
	
	mov ax,bx
	mov cl,20
	div cl		;quotient is in al
	xor ah,ah
	mov cx,15d
	mul cx
	mov rect_y1,ax
	mov rect_y2,ax
	add rect_y2,15d
	
	mov al,8h
	cmp bx,260
	jl draw_rect_skip
	mov al,2h
draw_rect_skip:
	call draw_rect
	
	load_reg
	ret
draw_unbreak endp
setup_int proc
;saves old vector and sets up new vector
;input: al = interrupt number
;di = address of buffer for old vector
;si = address of buffer containing new vector
;save old interrupt vector

	mov ah,35h	;function 35h, get vector
	int 21h		;es:bx = vector
	mov [di],bx	;save offset
	mov [di+2],es	;save segment
;setup new vector
	mov dx,[si]	;dx has offset
	push ds		;save ds
	mov ds,[si+2]	;ds has segment number
	mov ah,25h	;function 25h, set vector
	int 21h
	pop ds		;restore ds
	ret
setup_int endp

keyboard_int proc
;keyboard interrupt routine
;save registers
	push DS
	push AX
;set up DS
	mov ax, seg scan_code
	mov ds,ax
;input scan code
	In al,60h	;read scan code
	push ax		;save it
	in al,61	;control port value
	mov ah,al	;save in ah
	or al,80h	;set bit for keyboard
	out 61h,al	;write back
	xchg ah,al	;get back control value
	out 61h,al	;reset control port
	pop ax		;recover scan code
	mov ah,al	;save scan code in ah
	test al,80h	;test for break code
	jne key_0	;yes, clear flags goto KEY_0
;make code
	mov scan_code,al	;save in variable
	mov key_flag,1		;set key flag
key_0:
	mov al,20h			;reset interrupt
	out 20h,al
;restore registers
	pop ax
	pop ds
	iret
keyboard_int endp


	end main