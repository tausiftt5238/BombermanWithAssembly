;time interrupt procedure
extern timer_flag:byte
public timer_tick

.model small
.code
;timer routine

timer_tick proc

;save registers

	push ds 	;save ds
	push ax
	
	mov ax,seg timer_flag	;get segment of flag
	mov ds,ax		;put in DS
	mov timer_flag,1	;set flag
;restore registers
	pop ax
	pop ds	;restore ds
	iret
timer_tick endp
	end