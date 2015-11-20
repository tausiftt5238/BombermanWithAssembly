extern scan_code : byte, key_flag:byte
public keyboard_int
.model small
.code
keyboard_int proc
;keyboard interrupt routine
;save registers
	push ds
	push ax
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