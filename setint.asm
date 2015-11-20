public setup_int

include mac

.model small
.code

setup_int proc
;saves old vector and sets up new vector
;input: al = interrupt number
;di = address of buffer for old vector
;si = address of buffer containing new vector
;save old interrupt vector

	mov ah,35h	;function 35h, get vector
	int 21h		;es:bx = vector
	mov [di],bx	;save offset
	mov [di+2],es	;save segment
;setup new vector
	mov dx,[si]	;dx has offset
	push ds		;save ds
	mov ds,[si+2]	;ds has segment number
	mov ah,25h	;function 25h, set vector
	int 21h
	pop ds		;restore ds
	ret
setup_int endp

	end