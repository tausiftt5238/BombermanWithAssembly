extern bombr:byte
extern fnameb:byte
public fileRead_bombr
.model small
.stack 100h
.code

fileRead_bombr proc
	push cx
	push bx
	push dx
	
	lea dx,fnameb
	mov ah,3dh
	mov al,0
	int 21h
	
	lea dx,bombr
	mov bx,ax
	mov ah,3fh
	mov cx,512
	int 21h
	
	mov ah,3eh
	int 21h	
	
	pop dx
	pop bx
	pop cx
	ret
fileRead_bombr endp
end