extern c_tx:word,c_ty:word,c_alive:word,c_index:word
extern c_dir:word
extern clear_tile:near
extern temp_x:word,temp_y:word
extern map:byte
extern rand:word
extern draw_creep:near
public update_creep

include mac

.model small
.stack
.code

;Generates a random direction into c_dir
rng proc
	save_reg
	mov ax,rand
	mov bx,57
	mul bx
	add ax,113
	xor dx,dx
	mov bx,1001
	div bx
	mov rand,dx
	mov c_dir,3
	cmp rand,750
	jle rng_range_1
	mov c_dir,0
	jmp rng_range_3
rng_range_1:	
	cmp rand,500
	jle rng_range_2
	mov c_dir,1
	jmp rng_range_3
rng_range_2:
	cmp rand,250
	jle rng_range_3
	mov c_dir,2
rng_range_3:
	load_reg
	ret
rng endp

;c_dir: 0=up,1=right,2=down,3=left
update_creep proc
	save_reg
	xor cx,cx
	
creep_loop:
	mov c_index,cx
	call move_creep
	add cx,2
	cmp cx,6
	jne creep_loop
	
	load_reg
	ret
update_creep endp


move_creep proc
	save_reg
	
	mov di,c_index
	cmp c_alive[di],0
	je move_creep_done
	call rng
	
	cmp c_dir,1
	je creep_right
	cmp c_dir,2
	je creep_down
	cmp c_dir,3
	je creep_left
	
creep_up:
	mov bx,-20
	mov si,0
	jmp creep_dir_set
	
creep_right:
	mov bx,0
	mov si,1
	jmp creep_dir_set
	
creep_down:
	mov bx,20
	mov si,0
	jmp creep_dir_set
	
creep_left:
	mov bx,0
	mov si,-1
	jmp creep_dir_set
	
creep_dir_set:
	mov temp_x, si
	mov temp_y, bx
	mov ax,20d
	mul c_ty[di]
	add bx,ax
	add si,c_tx[di]
	cmp map[bx][si],0
	jne move_creep_done
	mov bx,c_tx[di]
	mov cx,c_ty[di]
	cmp temp_x,0
	jl move_creep_up
	jg move_creep_down
	cmp temp_y,0
	jl move_creep_left
	jg move_creep_right
	jmp move_creep_done
	
move_creep_up:
	dec c_tx[di]
	jmp render_creep

move_creep_right:
	inc c_ty[di]
	jmp render_creep

move_creep_down:
	inc c_tx[di]
	jmp render_creep

move_creep_left:
	dec c_ty[di]
	jmp render_creep

render_creep:
	call clear_tile
	
move_creep_done:
	call draw_creep
	
	load_reg
	ret
move_creep endp


end