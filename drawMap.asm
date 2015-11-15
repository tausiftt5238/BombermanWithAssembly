extern map:byte
extern draw_box:near, draw_bomber:near,draw_enemy:near
public drawMap

.model small
.stack
.code

drawMap proc
	push bx
	push si
	push cx
	push dx
	
	mov bx,0
	mov si,0
drawMap_loop:
	mov dl, map[bx][si]	;store current location's content
	
	cmp dl,1h			;does dl have 1?
	je drawMap_box		;yes, draw box
	
	jmp loop_back
drawMap_box:
	call draw_box		;draw box
	jmp loop_back		;loop back
drawMap_enemy:
	call draw_enemy		;draw enemy
	jmp loop_back		;loop back
drawMap_bomber:
	call draw_bomber	;draw bomber
	jmp loop_back		;loop back
loop_back:
	inc si				;increase si
	cmp si,10			;is si > 10
	jl drawMap_loop		;no, loop back
	add bx,si			;yes, bx += si
	mov si,0			;put 0 in si (start of row)
	cmp bx,100d			;is bx > 10 * 11
	jl drawMap_loop		;no, loop back
						;yes, end loop
	pop dx
	pop cx
	pop si
	pop bx
	ret
drawMap endp
	end