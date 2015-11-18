extern rect_x1:word,rect_y1:word,rect_x2:word,rect_y2:word
public draw_rect
public draw_box,draw_enemy,draw_bomber,draw_unbreak

.model small
.stack
.code
draw_rect proc
	push ax
	push cx
	push dx
	
	mov ah,0ch
	mov cx,rect_x1
	mov dx,rect_y1
	
draw_rect_loop:
	int 10h
	inc cx
	cmp cx,rect_x2
	jl draw_rect_loop
	mov cx,rect_x1
	inc dx
	cmp dx,rect_y2
	jl draw_rect_loop
	
	pop dx
	pop cx
	pop ax
	ret
draw_rect endp

draw_box proc
	push si
	push bx
	push ax
	push cx
	
	mov ax,24d
	mul si
	mov rect_x1,ax
	mov rect_x2,ax
	add rect_x2,24d
	
	mov ax,bx
	mov cl,20
	div cl		;quotient is in al
	mov ah,0
	mov cx,24d
	mul cx
	mov rect_y1,ax
	mov rect_y2,ax
	add rect_y2,24d
	
	mov al,4h
	call draw_rect
	
	pop cx
	pop ax
	pop bx
	pop si
	ret
draw_box endp
draw_enemy proc
	
	ret
draw_enemy endp
draw_bomber proc
	
	ret
draw_bomber endp

draw_unbreak proc
	push si
	push bx
	push ax
	push cx
	
	mov ax,24d
	mul si
	mov rect_x1,ax
	mov rect_x2,ax
	add rect_x2,24d
	
	mov ax,bx
	mov cl,20
	div cl		;quotient is in al
	mov ah,0
	mov cx,24d
	mul cx
	mov rect_y1,ax
	mov rect_y2,ax
	add rect_y2,24d
	
	mov al,8h
	call draw_rect
	
	pop cx
	pop ax
	pop bx
	pop si
	ret
draw_unbreak endp
	end