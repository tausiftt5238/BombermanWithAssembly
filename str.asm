extern time_var:byte
extern htp1:byte,htp2:byte,htp3:byte,htp4:byte,htp5:byte,htp6:byte,htp7:byte,htp8:byte,htp9:byte

public set_cursor
public print_string
public print_htp

include mac

.model small
.code

set_cursor proc
	save_reg
	;input dh = row
	;dl = column
	;bh = page number
	
	xor bh,bh
	mov ah,2
	int 10h
	
	load_reg
	ret
set_cursor endp

print_string proc
	save_reg
	;input si = offset of msg
	;bl = color
	mov al,[si]
print_string_loop:
	mov ah,9h
	mov cx,1
	
	int 10h
	add si,1
	inc dl
	call set_cursor
	mov al,[si]
	cmp al,'$'
	jne print_string_loop
	
	load_reg
	ret
print_string endp

print_htp proc
	mov dh,2
	mov dl,2
	mov bh,0
	call set_cursor
	
	lea si,htp1
	mov bl,5h
	call print_string
	
	mov dh,4
	mov dl,2
	mov bh,0
	call set_cursor
	
	lea si,htp2
	mov bl,5h
	call print_string
	
	mov dh,6
	mov dl,2
	mov bh,0
	call set_cursor
	
	lea si,htp3
	mov bl,5h
	call print_string
	
	mov dh,8
	mov dl,2
	mov bh,0
	call set_cursor
	
	lea si,htp4
	mov bl,5h
	call print_string
	
	mov dh,10
	mov dl,2
	mov bh,0
	call set_cursor
	
	lea si,htp5
	mov bl,5h
	call print_string
	
	mov dh,12
	mov dl,2
	mov bh,0
	call set_cursor
	
	lea si,htp6
	mov bl,5h
	call print_string
	
	mov dh,14
	mov dl,2
	mov bh,0
	call set_cursor
	
	lea si,htp7
	mov bl,5h
	call print_string
	
	mov dh,16
	mov dl,2
	mov bh,0
	call set_cursor
	
	lea si,htp8
	mov bl,5h
	call print_string
	
	mov dh,18
	mov dl,2
	mov bh,0
	call set_cursor
	
	lea si,htp9
	mov bl,5h
	call print_string
	
	ret
print_htp endp
end