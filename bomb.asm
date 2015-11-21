extern bomb_life:byte, bomb_x:word, bomb_y:word
extern b_tx:word ,b_ty:word
extern map:byte
extern clear_tile:near

public set_bomb
public clear_bomb


include mac

.model small
.code

set_bomb proc
	save_reg
	
	push b_tx
	pop bomb_x
	push b_ty
	pop bomb_y
	mov bomb_life,4
	
	mov ax,20d
	mul bomb_y
	
	mov bx,ax
	mov si,bomb_x
	
	mov map[bx][si],5
	
	load_reg
	ret
set_bomb endp

clear_bomb proc
	save_reg
	
	mov bx,bomb_x
	mov cx,bomb_y
	call clear_tile
	
	mov bx,bomb_y
	mov si,bomb_x
	mov ax,20d
	mul bx
	mov bx,ax
	mov map[bx][si],0
	
	load_reg
	ret
clear_bomb endp

end