extern scan_code : byte, key_flag:byte

public keyboard_int
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

keyboard_int proc
;keyboard interrupt routine
;save registers
	push DS
	push AX
;set up DS
	mov ax, seg scan_code
	mov ds,ax
;input scan code
	In al,60h	;read scan code
	push ax		;save it
	in al,61	;control port value
	mov ah,al	;save in ah
	or al,80h	;set bit for keyboard
	out 61h,al	;write back
	xchg ah,al	;get back control value
	out 61h,al	;reset control port
	pop ax		;recover scan code
	mov ah,al	;save scan code in ah
	test al,80h	;test for break code
	jne key_0	;yes, clear flags goto KEY_0
;make code
	mov scan_code,al	;save in variable
	mov key_flag,1		;set key flag
key_0:
	mov al,20h			;reset interrupt
	out 20h,al
;restore registers
	pop ax
	pop ds
	iret
keyboard_int endp

	end