public rect_x1,rect_y1,rect_x2,rect_y2 ;for rect.asm
public map							   ;for drawMap.asm
extern draw_rect:near				   ;from rect.asm
extern drawMap:near					   ;from drawMap.asm
.model small
.stack 100h
.data
;parameters for drawing rectangle
rect_x1 dw ?
rect_y1 dw ?
rect_x2 dw ?
rect_y2 dw ?

;map of the level
map db 2 dup(1), 5 dup(0), 8 dup(1), 10 dup(0), 11 dup(1), 4 dup(0), 2 dup(1), 5 dup(0), 9 dup(1), 9 dup(0), 9 dup(1), 12 dup(0), 10 dup(1), 5 dup(0) 

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
	
	call drawmap
	;call drawmap
	mov ah,1h	;take an input from keyboard
	int 21h
	call reset_display
	
	mov ah,4ch
	int 21h
main endp
	end main