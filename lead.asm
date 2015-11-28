extern names:byte,scores:byte,l_index1:byte,l_index2:byte
extern fnameb:byte,no_of_input:byte
public load_lead
public store_lead
public bsort

.model small
include mac
.code
load_lead proc
	save_reg
	
	;load file handler
	lea dx,fnameb
	mov ah,3dh
	mov al,0
	int 21h
	
	;store file hander in bx
	mov bx,ax
	mov no_of_input,0
	
	mov si,0
load_lead_loop:	
	lea dx,names[si]
	mov ah,3fh
	mov cx,4
	int 21h
	
	lea dx,scores[si]
	mov ah,3fh
	mov cx,4
	int 21h
	
	add si,4
	inc no_of_input
	
	cmp no_of_input,4
	jl load_lead_loop
	
	;close file
	mov ah,3eh
	int 21h	
	
	load_reg
	ret
load_lead endp 

store_lead proc
	save_reg
	;load file handler
	lea dx,fnameb
	mov ah,3dh
	mov al,1
	int 21h
	
	;store file hander in bx
	mov bx,ax
	mov no_of_input,0
	
	mov si,0
store_lead_loop:	
	lea dx,names[si]
	mov ah,40h
	mov cx,4
	int 21h
	
	lea dx,scores[si]
	mov ah,40h
	mov cx,4
	int 21h
	
	add si,4
	inc no_of_input
	
	cmp no_of_input,4
	jl store_lead_loop
	
	;close file
	mov ah,3eh
	int 21h	
	
	load_reg
	ret
store_lead endp

bsort proc
	save_reg
	
	mov bx,-1
bsort_outer:
	inc bx
	cmp bx,3
	je bsort_done
	xor dx,dx
bsort_inner:
	
	mov si,dx
	mov di,dx
	inc di
	mov cl,2
	shl si,cl
	shl di,cl
	
	mov cx,3 
bsort_comp:
    mov al,scores[di]
    cmp al,scores[si]
	jl bsort_skip
	inc si
	inc di
	loop bsort_comp
	
	mov si,dx
	mov di,dx
	inc di
	mov cl,2
	shl si,cl
	shl di,cl
	mov cx,3
bsort_nameswap:
	mov al,names[si]
	mov ah,names[di]
	mov names[si],ah
	mov names[di],al
	mov al,scores[si]
	mov ah,scores[di]
	mov scores[si],ah
	mov scores[di],al
	inc si
	inc di
	loop bsort_nameswap			;swapping names
	
	
bsort_skip:
	inc dx
	cmp dx,2
	jne bsort_inner
	
	jmp bsort_outer
	
bsort_done:
	load_reg
	ret
bsort endp
end