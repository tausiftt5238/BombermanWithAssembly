.model small
.stack 100h
.data
x1 dw ?
x2 dw ?
y1 dw ?
y2 dw ?

fnameb db 'bombr',0
	
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
	;call fileread_bombr
	
	mov x1,48
	mov y1,48
	mov x2,63
	mov y2,63
	call draw_rect
	
	mov ah,1h	;take an input from keyboard
	int 21h
	call reset_display
	
	mov ah,4ch
	int 21h
main endp

draw_rect proc
	push ax
	push cx
	push dx
	push bx
	
	mov ah,0ch
	mov cx,x1
	mov dx,y1
	lea bx,bombr
	
draw_rect_loop:
	mov al,[bx]
	inc bx
	int 10h
	inc cx
	cmp cx,x2
	jl draw_rect_loop
	mov cx,x1
	inc dx
	cmp dx,y2
	jl draw_rect_loop
	
	pop bx
	pop dx
	pop cx
	pop ax
	ret
draw_rect endp
	end main