extern map:byte
extern draw_box:near, draw_bomber:near,draw_enemy:near
extern draw_unbreak:near
public drawMap

include mac

.model small
.stack
.code

drawMap proc
	save_reg
	
	xor bx,bx
	xor si,si
drawMap_loop:
	mov dl, map[bx][si]	;store current location's content
	
	cmp dl,4d			;does dl have Red?
	je drawMap_box		;yes, draw box
	cmp dl,8d			;does dl have Gray?
	je drawMap_unbreak	;yes, draw unbreakable wall
	jmp loop_back
drawMap_box:
	call draw_box		;draw box
	jmp loop_back		;loop back
drawMap_unbreak:
	call draw_unbreak	;draw unbreakable wall
	jmp loop_back		;loop back
loop_back:
	inc si				;increase si
	cmp si,20			;is si > 20
	jl drawMap_loop		;no, loop back
	add bx,si			;yes, bx += si
	xor si,si			;put 0 in si (start of row)
	cmp bx,260d			;is bx > 20 * 13
	jl drawMap_loop		;no, loop back
						;yes, end loop
	load_reg
	ret
drawMap endp
	end