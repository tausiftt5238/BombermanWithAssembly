extern rect_x1:word,rect_y1:word,rect_x2:word,rect_y2:word
extern b_x1:word,b_y1:word,b_x2:word,b_y2:word
extern bombr:byte
public draw_rect
public draw_box,draw_enemy,draw_bomber,draw_unbreak

include mac

.model small
.stack
.code
draw_rect proc
	save_reg
	
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
	lea bx,bombr
	
draw_bomber_loop:
	mov al,[bx]
	inc bx
	int 10h
	inc cx
	cmp cx,b_x2
	jl draw_bomber_loop
	mov cx,b_x1
	inc dx
	cmp dx,b_y2
	jl draw_bomber_loop
	
	load_reg
	ret
	ret
draw_bomber endp

draw_unbreak proc
	save_reg
	
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
	cmp bx,260
	jl draw_rect_skip
	mov al,2h
draw_rect_skip:
	call draw_rect
	
	load_reg
	ret
draw_unbreak endp
	end