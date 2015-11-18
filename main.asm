public rect_x1,rect_y1,rect_x2,rect_y2 	;for rect.asm
public map							   	;for drawMap.asm
public scan_code						;for int.asm
public key_flag							;for int.asm
extern draw_rect:near				   	;from rect.asm
extern drawMap:near					   	;from drawMap.asm
extern keyboard_int:near			   	;from int.asm
extern setup_int:near				   	;from int.asm

.model small
.stack 100h
.data

;parameters for drawing rectangle
rect_x1 dw ?
rect_y1 dw ?
rect_x2 dw ?
rect_y2 dw ?

;variables for keyboard
up_arrow = 48h
down_arrow = 50h
left_arrow = 4Bh
right_arrow = 4Dh
spc_button = 39h

scan_code	db 0
key_flag db 0

;map of the level
;map db 2 dup(1), 5 dup(0), 8 dup(1), 10 dup(0), 11 dup(1), 4 dup(0), 2 dup(1), 5 dup(0), 9 dup(1), 9 dup(0), 9 dup(1), 12 dup(0), 10 dup(1), 5 dup(0) 
map db 400 dup(?)

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

;set breakable and unbreakable boxes on the map
set_map proc
	mov cx,20d		;20 x 20 array, so needs to iterate 20 times
	mov bx,0		;upper border, for bx = 0 : 19
set_map_loop1:
	mov map[bx],2	;2 for unbreakable wall
	inc bx			;bx ++
	loop set_map_loop1
	
	mov cx,20d		;20 iteration
	mov bx,0		;left bound

set_map_loop2:
	mov map[bx],2	;2 for unbreakable wall
	add bx,20d		;for bx = 0 : 190 : 20
	loop set_map_loop2
	
	mov cx,20d		;20 iteration
	mov bx,0d		;right bound
	mov si,19d		;
	
set_map_loop3:
	mov map[bx][si],2
	add bx,20d		;for bx = 0 : 190 : 20
	loop set_map_loop3
	
	mov cx,20d		;20 iteration
	mov bx,380d		;lower bound
	mov si,0d
	
set_map_loop4:
	mov map[bx][si],2	
	inc si			; for si = 0 : 20
	loop set_map_loop4

	ret
set_map endp

main proc
	mov ax,@data
	mov ds,ax
	
	call setup_display
	call set_map
	
	mov bx,240
	mov si,5
	mov map[bx][si],1
	call drawmap

	mov ah,1h	;take an input from keyboard
	int 21h
	call reset_display
	
	mov ah,4ch
	int 21h
main endp
	end main