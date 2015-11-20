extern rect_x1:word,rect_y1:word,rect_x2:word,rect_y2:word
extern s_x1:word,s_y1:word,s_x2:word,s_y2:word,b_tx:word,b_ty:word
extern temp_x:word,temp_y:word
extern bombr:byte
extern map:byte
public draw_rect,clear_tile
public draw_box,draw_enemy,draw_bomber,draw_unbreak,draw_pixel
public move_bomber

include mac

.model small
.stack
.code

;Draws one pixel as a 2x2 pixel square on-screen
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
	
;Before calling this make sure to load the array to be drawn to si
;Also have s_x1 and s_x2 point to the upper corner, basically tileX*15 and tileY*15
draw_sprite proc		
	save_reg
	
	mov ah,0ch
	
	mov cx,s_x1
	mov dx,s_y1
	
draw_sprite_loop:
	mov al,[si]
	inc si
	call draw_pixel
	inc cx
	cmp cx,s_x2
	jl draw_sprite_loop
	mov cx,s_x1
	inc dx
	cmp dx,s_y2
	jl draw_sprite_loop
	
	load_reg
	ret
draw_sprite endp

;Draws single colored box
;color needs to be loaded to al before calling
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

;sets the perimeter for single colored boxes to be drawn
;WARNING: does not save registers
set_box_perimeter proc 
	mov ax,15d
	mul si
	mov rect_x1,ax
	mov rect_x2,ax
	add rect_x2,15d
	
	mov ax,bx
	mov cl,20
	div cl				;quotient is in al
	mov ah,0
	mov cx,15d
	mul cx
	mov rect_y1,ax
	mov rect_y2,ax
	add rect_y2,15d
	ret
set_box_perimeter endp

;takes the tileX in bx and tileY in cx and turns it into
;sprite coordinates to be put in s_x1 and s_y1
;WARNING: does not save registers
set_sprite_perimeter proc
	mov ax,15d
	mul bx
	mov s_x1,ax
	
	mov ax,15d
	mul cx
	mov s_y1,ax
	
	mov cx,s_x1
	add cx,15d
	mov s_x2,cx
	
	mov cx,s_y1
	add cx,15d
	mov s_y2,cx
	ret
set_sprite_perimeter endp
	
;Draws breakable red boxes
draw_box proc
	save_reg
	
	call set_box_perimeter
	
	mov al,4h
	call draw_rect
	
	load_reg
	ret
draw_box endp

draw_enemy proc
	
	ret
draw_enemy endp

;Draws Bomberman
;b_tx and b_ty must have his tile coordinates
draw_bomber proc
	save_reg
	
	
	mov bx,b_tx
	mov cx,b_ty
	
	call set_sprite_perimeter
	
	lea si,bombr
	
	call draw_sprite
	
	load_reg
	ret
draw_bomber endp


;Draws gray unbreakable boxes
draw_unbreak proc
	save_reg
	
	call set_box_perimeter
	mov al,8h
	call draw_rect
	
	load_reg
	ret
draw_unbreak endp

move_bomber proc
	;input : si and bx, bx defines row while si defines column
	save_reg
	
	mov temp_x, si		;store si
	mov temp_y, bx		;store bx
	mov ax,20d			;multiply b_ty for coordinate in MAP
	mul b_ty			; ax = b_ty * 20
	add bx,ax			; bx += ax
	add si,b_tx				
	cmp map[bx][si],0	; checking if there's 0 (moveable tile) in the map
	jne move_bomber_done	;if not, bomberman can't move
	cmp temp_x,0		
	jl move_bomber_up	; if temp_x is negative, go up
	jg move_bomber_down	;if temp_x is positive, go down
	cmp temp_y,0
	jl	move_bomber_left	;if temp_y is negative go left
	jg move_bomber_right	;if temp_y is positive go right
	jmp move_bomber_done
move_bomber_up:
	dec b_tx
	jmp move_bomber_done
move_bomber_down:
	inc b_tx
	jmp move_bomber_done
move_bomber_left:
	dec b_ty
	jmp move_bomber_done
move_bomber_right:
	inc b_ty
	jmp move_bomber_done	
move_bomber_done:	
	load_reg
	ret
move_bomber endp

;send tileX in bx and tileY in cx
clear_tile proc
	save_reg
	
	call set_sprite_perimeter
	mov ax,s_x1
	mov rect_x1,ax
	mov ax,s_x2
	mov rect_x2,ax
	mov ax,s_y1
	mov rect_y1,ax
	mov ax,s_y2
	mov rect_y2,ax
	
	mov al,0
	call draw_rect
	
	load_reg
	ret
clear_tile endp
	end