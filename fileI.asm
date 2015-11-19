.model small
.stack
.data
fname db 'text',0
error db '404$'
handle dw ?
buffer db 100 dup('$')

.code
main proc
	mov ax,@data
	mov ds,ax
	mov es,ax
	lea dx,fname
	mov al,0
	lea dx,fname
	call open
	jc open_error
	mov handle,ax
read_loop:
	lea dx,buffer
	mov bx,handle
	call read
	or ax,ax
	je exit
	mov cx,ax
	call display
	jmp read_loop
open_error:
	lea dx,error
	mov ah,9
	int 21h
exit:
	mov bx,handle
	call close
	
	mov ah,4ch
	int 21h
main endp

open proc

	mov ah,3dh
	mov al,0
	int 21h
	ret
open endp

read proc

	push cx
	mov ah,3fh
	mov cx,512
	int 21h
	pop cx
	ret
read endp

display proc
	push dx
	push ax
	lea dx,buffer
	mov ah,9h
	int 21h
	pop ax
	pop dx
	ret
display endp

close proc
	mov ah,3eh
	int 21h
	ret
close endp
end main