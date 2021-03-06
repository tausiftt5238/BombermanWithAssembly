extern bomb_life:byte, bomb_x:word, bomb_y:word
extern b_tx:word ,b_ty:word
extern map:byte
extern clear_tile:near
extern draw_bmb:near
extern fire_x:word, fire_y:word
extern draw_explode:near
extern temp_x:word, temp_y:word
extern life:word
extern c_tx:word,c_ty:word,c_alive:word,c_index:word
extern c_count:word

public set_bomb
public clear_bomb
public bomb_blast


include mac

.model small
.code

set_bomb proc
	save_reg
	
	push b_tx
	pop bomb_x
	push b_ty
	pop bomb_y
	mov bomb_life,5
	
	mov ax,20d
	mul bomb_y
	
	mov bx,ax
	mov si,bomb_x
	
	mov map[bx][si],5
	
	call draw_bmb
	
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

clear_explosion proc
	save_reg
	
	mov bx,fire_x
	mov cx,fire_y
	call clear_tile
	
	mov bx,fire_y
	mov si,fire_x
	mov ax,20d
	mul bx
	mov bx,ax
	mov map[bx][si],0
	
	load_reg
	ret
clear_explosion endp

bomb_blast proc
	save_reg
	mov bx,bomb_y		;store bomb_y
	mov si, bomb_x		;store bomb_x
	mov ax,20d
	mul bx
	mov bx,ax			;bx has row of array
	
	mov temp_x,si		;temporarily storing column
	mov temp_y,bx		;temporarily storing row
	
	push bomb_x
	pop fire_x
	push bomb_y
	pop fire_y
	
	mov cx,3
bomb_blast_check_right:
	cmp map[bx][si],8
	je bmb_chk_right_done
	cmp bomb_life,0
	jl bomb_blast_right_clear
	call draw_explode
	call kill_creep
	mov ax,b_tx
	cmp ax,fire_x
	jne bomb_blast_ck_rgt_kill_skip
	mov ax,b_ty
	cmp ax,fire_y
	jne bomb_blast_ck_rgt_kill_skip
	dec life
bomb_blast_ck_rgt_kill_skip:
	jmp bomb_blast_right_clear_skip
bomb_blast_right_clear:
	call clear_explosion
bomb_blast_right_clear_skip:
	mov map[bx][si],0
	inc si
	inc fire_x
	loop bomb_blast_check_right
bmb_chk_right_done:	
	
	mov si,temp_x
	mov bx,temp_y
	
	push bomb_x
	pop fire_x
	push bomb_y
	pop fire_y
	
	mov cx,3
bomb_blast_check_left:
	cmp map[bx][si],8
	je bmb_chk_left_done
	cmp bomb_life,0
	jl bomb_blast_left_clear
	call draw_explode
	call kill_creep
	mov ax,b_tx
	cmp ax,fire_x
	jne bomb_blast_ck_lft_kill_skip
	mov ax,b_ty
	cmp ax,fire_y
	jne bomb_blast_ck_lft_kill_skip
	dec life
bomb_blast_ck_lft_kill_skip:
	jmp bomb_blast_left_clear_skip
bomb_blast_left_clear:
	call clear_explosion
bomb_blast_left_clear_skip:
	mov map[bx][si],0
	
	dec si
	dec fire_x
	loop bomb_blast_check_left
bmb_chk_left_done:

	mov si,temp_x
	mov bx,temp_y
	
	push bomb_x
	pop fire_x
	push bomb_y
	pop fire_y
	
	mov cx,3
bomb_blast_check_up:
	cmp map[bx][si],8
	je bmb_chk_up_done
	cmp bomb_life,0
	jl bomb_blast_up_clear
	call draw_explode
	call kill_creep
	mov ax,b_tx
	cmp ax,fire_x
	jne bomb_blast_ck_up_kill_skip
	mov ax,b_ty
	cmp ax,fire_y
	jne bomb_blast_ck_up_kill_skip
	dec life
bomb_blast_ck_up_kill_skip:
	jmp bomb_blast_up_clear_skip
bomb_blast_up_clear:
	call clear_explosion
bomb_blast_up_clear_skip:
	mov map[bx][si],0
	
	sub bx,20
	dec fire_y
	loop bomb_blast_check_up
bmb_chk_up_done:

	mov si,temp_x
	mov bx,temp_y
	
	push bomb_x
	pop fire_x
	push bomb_y
	pop fire_y
	
	mov cx,3
bomb_blast_check_down:
	cmp map[bx][si],8
	je bmb_chk_down_done
	cmp bomb_life,0
	jl bomb_blast_down_clear
	call draw_explode
	call kill_creep
	mov ax,b_tx
	cmp ax,fire_x
	jne bomb_blast_ck_dwn_kill_skip
	mov ax,b_ty
	cmp ax,fire_y
	jne bomb_blast_ck_dwn_kill_skip
	dec life
bomb_blast_ck_dwn_kill_skip:
	jmp bomb_blast_down_clear_skip
bomb_blast_down_clear:
	call clear_explosion
bomb_blast_down_clear_skip:
	mov map[bx][si],0
	
	add bx,20
	inc fire_y
	loop bomb_blast_check_down
bmb_chk_down_done:	
	
	load_reg
	ret
bomb_blast endp

kill_creep proc
	save_reg
	mov c_index,0
	
	mov cx,3
kill_creep_loop:
	mov si,c_index
	mov ax,fire_x
	cmp c_tx[si],ax
	jne kill_creep_loop_skip
	mov ax,fire_y
	cmp c_ty[si],ax
	jne kill_creep_loop_skip
	mov c_alive[si],0
	mov c_tx[si],0
	mov c_ty[si],0
	dec c_count
kill_creep_loop_skip:
	add c_index,2
	loop kill_creep_loop
	
	load_reg
	ret
kill_creep endp

end