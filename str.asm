extern time_var:byte

public set_cursor
public print_string

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

end