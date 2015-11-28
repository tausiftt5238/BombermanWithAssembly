public rect_x1,rect_y1,rect_x2,rect_y2 	;for rect.asm
public s_x1,s_y1,s_x2,s_y2,b_tx,b_ty 	;for rect.asm,bomb.asm
public map							   	;for drawMap.asm,rect.asm,bomb.asm
public scan_code						;for keyint.asm
public key_flag							;for keyint.asm
public bombr							;for rect.asm
public timer_flag						;for timer.asm
public bmb 								;for rect.asm
public creep							;for rect.asm
public temp_x,temp_y					;for rect.asm
public bomb_life, bomb_x, bomb_y		;for bomb.asm
public fire								;for rect.asm
public fire_x, fire_y					;for rect.asm
public c_tx,c_ty,c_alive				;for creep.asm
public c_dir,c_index,c_count			;for creep.asm,bomb.asm
public rand								;for creep.asm
public life								;for creep.asm, bomb.asm
public time_var							;for str.asm
public names,scores,l_index1,l_index2	;for lead.asm
public htp1,htp2,htp3,htp4,htp5
public htp6,htp7,htp8,htp9				;for str.asm
public no_of_input,fnameb						;for lead.asm

extern draw_rect:near				   	;from rect.asm
extern drawMap:near					   	;from drawMap.asm
extern keyboard_int:near			   	;from keyint.asm
extern setup_int:near				   	;from setint.asm
extern draw_bomber:near					;from rect.asm
extern draw_pixel:near					;from rect.asm
extern timer_tick:near					;from timer.asm
extern move_bomber:near					;from rect.asm
extern clear_tile:near					;from rect.asm
extern set_bomb:near					;from bomb.asm
extern clear_bomb:near					;from bomb.asm
extern draw_bmb:near					;from rect.asm
extern bomb_blast:near					;from bomb.asm
extern update_creep:near				;from creep.asm
extern set_cursor:near,print_string:near;from str.asm
extern load_lead:near,store_lead:near	;from lead.asm
extern bsort:near						;from lead.asm
extern print_htp:near					;from str.asm

include mac

.model small
.stack 100h
.data

;variables for interrupts

new_timer_vec dw ? , ?
old_timer_vec dw ? , ?
new_key_vec	dw ? , ?
old_key_vec dw ? , ?
scan_code	db 0
key_flag db 0
timer_flag db 0
temp_x dw 0
temp_y dw 0

;parameters for drawing rectangle
rect_x1 dw ?
rect_y1 dw ?
rect_x2 dw ?
rect_y2 dw ?

;parameters for bomberman
b_tx dw 0
b_ty dw 0
life dw 1

;parameters for creep
c_tx dw 7,18,16
c_ty dw 9,1,11
c_alive dw 1,1,1
c_index dw 0
c_dir dw 0
c_count dw 3

rand dw 1

;parameters for drawing sprite
s_x1 dw 0
s_y1 dw 0
s_x2 dw 0
s_y2 dw 0

;parameter for explosion
fire_x dw 0
fire_y dw 0

;variables for keyboard
up_arrow = 48h
down_arrow = 50h
left_arrow = 4Bh
right_arrow = 4Dh
spc_button = 39h
esc_key	= 1
enter_key = 1ch

;bomb variables
bomb_life db -1
bomb_x	dw -1
bomb_y 	dw -1



;map of the level
;map db 2 dup(1), 5 dup(0), 8 dup(1), 10 dup(0), 11 dup(1), 4 dup(0), 2 dup(1), 5 dup(0), 9 dup(1), 9 dup(0), 9 dup(1), 12 dup(0), 10 dup(1), 5 dup(0) 
map db 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
	db 8,0,0,4,0,4,4,0,0,8,4,0,0,0,4,0,0,0,0,8
	db 8,0,8,4,8,0,8,0,8,0,4,8,0,8,4,8,0,8,0,8
	db 8,4,4,4,0,4,0,4,0,0,8,0,0,0,4,4,4,0,0,8
	db 8,0,8,0,8,0,8,4,8,0,0,8,0,8,0,8,4,8,0,8
	db 8,4,4,4,4,4,0,0,0,8,0,0,4,4,0,0,4,0,0,8
	db 8,0,8,4,8,0,8,0,8,0,0,8,4,8,4,8,4,8,4,8
	db 8,0,0,4,0,0,0,4,4,4,8,0,4,0,0,0,0,0,0,8
	db 8,0,8,0,8,0,8,0,8,0,0,8,0,8,0,8,0,8,4,8
	db 8,4,4,4,4,4,0,0,0,8,0,4,0,0,4,4,4,0,0,8
	db 8,0,8,4,8,4,8,0,8,4,4,8,0,8,4,8,0,8,0,8
	db 8,0,0,0,0,0,0,0,0,4,8,0,0,0,4,0,0,0,0,8
	db 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8

;map db 20 dup(8)
;	db 8 , 18 dup (0) , 8
;	db 8 , 18 dup (0) , 8
;	db 8 , 18 dup (0) , 8
;	db 8 , 18 dup (0) , 8
;	db 8 , 18 dup (0) , 8
;	db 8 , 18 dup (0) , 8
;	db 8 , 18 dup (0) , 8
;	db 8 , 18 dup (0) , 8
;	db 8 , 18 dup (0) , 8
;	db 8 , 18 dup (0) , 8
;	db 8 , 18 dup (0) , 8
;	db 20 dup(8)

bombr	db 0,0,0,0,0,4,4,4,4,4,0,0,0,0,0
		db 0,0,0,0,0,4,4,4,4,4,0,0,0,0,0
		db 0,0,0,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0,0,0
		db 0,0,0,0fh,0eh,0,0eh,0eh,0eh,0,0eh,0fh,0,0,0
		db 0,0,0,0fh,0eh,0,0eh,0eh,0eh,0,0eh,0fh,0,0,0
		db 0,0,0,0fh,0eh,0,0eh,0eh,0eh,0,0eh,0fh,0,0,0
		db 0,0,0,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0,0,0
		db 0,0,0fh,1,1,1,1,1,1,1,1,1,0fh,0,0
		db 0,0,0fh,1,1,1,1,1,1,1,1,1,0fh,0,0
		db 0,0,0fh,1,1,1,1,1,1,1,1,1,0fh,0,0
		db 0,0,0fh,0,0,0,0eh,0eh,0eh,0,0,0,0fh,0,0
		db 0,0,0,1,1,1,1,1,1,1,1,1,0,0,0
		db 0,0,0,1,1,1,1,1,1,1,1,1,0,0,0
		db 0,0,4,4,4,4,0,0,0,0,4,4,4,4,0
		db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		
bmb		db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		db 0,0,0,0,0,0,0,0,0fh,0fh,0,0,0,0,0
		db 0,0,0,0,0,0,0,0fh,0,0,0fh,0,0,0,0
		db 0,0,0,0,0,0,0,0fh,0,0,0,0fh,0,0,0
		db 0,0,0,0,0,5,5,5,5,5,0,0,0,0,0
		db 0,0,0,0,5,5,5,5,5,5,5,0,0,0,0
		db 0,0,0,5,5,5,5,5,5,5,5,5,0,0,0
		db 0,0,5,5,5,5,5,5,5,5,5,5,5,0,0
		db 0,0,5,5,5,5,5,5,5,5,5,5,5,0,0
		db 0,0,5,5,5,5,5,5,5,5,5,5,5,0,0
		db 0,0,5,5,5,5,5,5,5,5,5,5,5,0,0
		db 0,0,0,5,5,5,5,5,5,5,5,5,0,0,0
		db 0,0,0,0,5,5,5,5,5,5,5,0,0,0,0
		db 0,0,0,0,0,5,5,5,5,5,0,0,0,0,0
		db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		
creep	db 0,0,0,0,0eh,0eh,2,2,2,2,2,2,0,0,0
		db 0,0,0,0,0eh,0eh,2,2,2,2,2,2,0,0,0
		db 0,0,0,0,2,0,0,2,2,0,0,2,0,0,0
		db 0,0,0,0,2,2,2,2,2,2,0eh,0eh,0,0,0
		db 0,0,0,0,2,2,2,0,0,2,0eh,0eh,0,0,0
		db 0,0,0,0,2,2,0,2,2,0,2,2,0,0,0
		db 0,0,0,0,0,0,2,2,2,2,0,0,0,0,0
		db 0,0,0,2,2,2,2,0eh,0eh,2,2,2,2,0,0
		db 0,0eh,0eh,0eh,2,2,2,0eh,0eh,2,2,2,2,2,2
		db 0,0eh,0eh,0eh,2,0,2,0eh,0eh,2,0,2,2,2,2
		db 0,0,0,0,0,0,2,0eh,0eh,2,0,0,0,0,0
		db 0,0,0,0,0,0,2,2,2,2,0,0,0,0,0
		db 0,0,0,2,2,2,2,0,0,2,2,2,2,0,0
		db 0,0,0,2,0eh,0eh,2,0,0,2,0eh,0eh,2,0,0
		db 0,0,0,2,2,2,2,0,0,2,2,2,2,0,0
		
fire 	db 4,4,4,0eh,4,0eh,0eh,0eh,0eh,4,0eh,4,0eh,0eh,4
		db 4,0eh,4,4,0eh,4,4,0eh,4,4,4,0eh,0eh,4,0eh
		db 0eh,4,4,0eh,0eh,0eh,4,4,0eh,0eh,0eh,4,4,0eh,4
		db 4,4,4,0eh,0eh,4,0eh,0eh,0eh,0eh,0eh,4,0eh,4,0eh
		db 4,0eh,4,4,0eh,0eh,4,0eh,0eh,4,4,4,0eh,0eh,0eh
		db 4,4,4,4,4,4,4,4,4,4,0eh,0eh,4,4,0eh
		db 0eh,0eh,0eh,4,4,0eh,0eh,4,4,0eh,4,4,4,4,4
		db 0eh,4,4,0eh,4,4,4,4,0eh,0eh,0eh,0eh,4,4,4
		db 4,4,4,0eh,0eh,4,4,4,4,4,0eh,0eh,4,0eh,4
		db 0eh,4,0eh,4,4,0eh,4,4,0eh,0eh,4,4,4,4,4
		db 4,4,4,4,0eh,0eh,4,4,0eh,4,4,0eh,0eh,4,0eh
		db 0eh,4,0eh,0eh,4,4,4,4,4,4,4,4,4,0eh,0eh
		db 4,0eh,0eh,0eh,4,4,4,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh
		db 4,0eh,4,4,4,4,4,0eh,4,4,4,0eh,4,4,4
		db 0eh,0eh,4,4,4,0eh,0eh,0eh,0eh,4,4,0eh,4,0eh,4

htp1 	db '                       HOW   TO   PLAY$'
htp2	db '1) Kill the creeps within the limited time to win.$'
htp3	db '2) Move Bomberman with the arrow keys.$'
htp4	db '3) Set a bomb with the space bar. Bombs will explode after a certain amount of     time.$'
htp5	db '4) Clear a path for yourself by destroying the red boxes with your bombs.$'
htp6	db '                         Warnings$'
htp7	db '1) Bombs are lethal to most creatures and should be used with caution.$'
htp8	db '2) Creeps are so strong that they touch Bomberman and he dies.$'
htp9	db '3) Gray boxes are the strongest in this universe and cannot be destroyed by       anything. Avoid picking a fight with gray boxes.$'

;messages to be printed

time_var db 'time: $'
bomberman_str db 'BOMBERMAN$$'
new_game_str	db 'new game$'
leaderboard_str	db 'leaderboard$'
instruction_str	db 'instructions$'
bomberman_dead_str 	db 'BOMBERMAN IS DEAD$'
bomberman_win_str 	db 'VICTORY ACHEIVED$'
enter_name_str 		db 'Enter your name:$'
exit_str db 'exit$'
credit_str db 'Made By: Sayontan & Tausif$'
result db 10 dup ('$')

;time variables
time dw 400

;leaderboard variables
names db 20 dup('$')
scores db 20 dup('$')
no_of_input db 0
fnameb db 'leader',0
l_index1 db 0
l_index2 db 0

;selection of main menu
selection db 0

.code

;setup display for graphics mode
setup_display proc
	push ax
	mov ax,12h 	;resolution 640x480, 16 color
	int 10h
	pop ax
	ret
setup_display endp

;setup display to go back to text mode
reset_display proc
	push ax
	mov ax,3h	;to go back to text mode
	int 10h
	pop ax
	ret
reset_display endp

;main menu
menu proc
	save_reg
	;clear screen
	
	call reset_display
	
	;show title of the game
	mov dh,5
	mov dl,30
	mov bh,0
	call set_cursor
	
	lea si,bomberman_str
	mov bl,5h
	call print_string
	
	;show new game
	mov dh,10
	mov dl,30
	mov bh,0
	call set_cursor
	
	lea si,new_game_str
	mov bl,5h
	call print_string
	
	;show leader board
	mov dh,12
	mov dl,30
	mov bh,0
	call set_cursor
	
	lea si,leaderboard_str
	mov bl,5h
	call print_string
	
	;show instruction 
	mov dh,14
	mov dl,30
	mov bh,0
	call set_cursor
	
	lea si,instruction_str
	mov bl,5h
	call print_string
	
	;show exit
	mov dh,16
	mov dl,30
	mov bh,0
	call set_cursor
	
	lea si,exit_str
	mov bl,5h
	call print_string
	
	;credits
	mov dh,24
	mov dl,24
	mov bh,0
	call set_cursor
	
	lea si,credit_str
	mov bl,5h
	call print_string
	
	
	load_reg
	ret
menu endp

;selection in menu

select_menu proc
	save_reg
	mov dh,10
	mov dl,29
	mov bh, 0
	
	
select_menu_loop:
	call set_cursor
	mov ah,00h
	int 16h
	;ah holds the scan-code
	cmp ah,up_arrow
	;10 is upper limit , 16 is lower limit
	je select_menu_up
	cmp ah,down_arrow
	je select_menu_down
	cmp ah,enter_key
	je select_menu_enter
	jmp select_menu_skip
select_menu_enter:
	mov selection,dh
	jmp select_menu_loop_done
select_menu_up:
	cmp dh,10
	je select_menu_up_skip
	sub dh,2
select_menu_up_skip:
	jmp select_menu_skip
select_menu_down:
	cmp dh,16
	je select_menu_down_skip
	add dh,2
select_menu_down_skip:
	
select_menu_skip:
	jmp select_menu_loop
select_menu_loop_done:
		
	load_reg
	ret
select_menu endp

show_leaderboard proc
	save_reg
	;show leaderboard
	mov dh,5
	mov dl,30
	mov bh,0
	call set_cursor
	
	lea si,leaderboard_str
	mov bl,1h
	call print_string
	
	call bsort
	
	mov di,0
	mov no_of_input,0
	mov dh,10
	
show_leaderboard_loop:	
	;show names
	
	mov dl,28
	mov bh,0
	call set_cursor
	
	lea si,names[di]
	mov bl,1h
	call print_string
	
	;show scores
	mov dl,40
	mov bh,0
	call set_cursor
	
	lea si,scores[di]
	mov bl,1h
	call print_string
	
	add dh,2
	add di,4
	inc no_of_input
	cmp no_of_input,3
	jl show_leaderboard_loop
	
	call store_lead
	
	load_reg
	ret
show_leaderboard endp

bomberman_dead proc
	save_reg
	mov dh, 10
	mov dl, 30
	mov bh, 0
	call set_cursor
	
	lea si,bomberman_dead_str
	mov bl, 4
	call print_string
	
	mov ah,1h
	int 21h
	
	load_reg
	ret
bomberman_dead endp

win_screen proc
	save_reg
	mov dh, 10
	mov dl, 30
	mov bh, 0
	call set_cursor
	
	lea si,bomberman_win_str
	mov bl, 2
	call print_string
	
	add time,100d
	printw time,result
	mov si,8
	mov di,0
	mov cx,3
	;check if current score is worth taking
score_comp:
	mov al,result[di]
	cmp al,scores[si]
	jl score_take_skip
	jg score_comp_done
	inc si
	inc di
	loop score_comp
score_comp_done:
	
	mov dh,15
	mov dl,30
	mov bh,0
	call set_cursor
	
	lea si,enter_name_str
	mov bl,3
	call print_string
	
	mov names[9],'$'
	mov names[10],'$'
	
	mov dh,17
	mov dl,34
	mov cx,3
	mov di,8
take_name_loop:
	inc dl
	call set_cursor
	mov ah,0
	int 16h
	mov names[di],al
	lea si,names[di]
	mov bl,3
	call print_string
	inc di
	loop take_name_loop
	
	mov si,8
	mov di,0
	mov cx,3
switch_score_loop:
	mov al,result[di]
	mov scores[si],al
	inc si
	inc di
	loop switch_score_loop
	
score_take_skip:
	mov ah,1h
	int 21h
	
	load_reg
	ret
win_screen endp

main proc
	mov ax,@data
	mov ds,ax

	call load_lead
main_main_menu:
	call menu
	call select_menu
	cmp selection,12
	je main_call_leaderboard
	cmp selection,14
	je main_call_instruction
	cmp selection,16
	je main_exit
	
	call setup_display
	
	;set up timer interrupt vector
	mov new_timer_vec, offset timer_tick	;offset
	mov new_timer_vec+2,cs					;segment
	mov al,1ch								;interrupt number
	lea di, old_timer_vec
	lea si, new_timer_vec
	call setup_int
	
	;set up keyboard interrupt vector
	mov new_key_vec, offset keyboard_int		;offset
	mov new_key_vec+2, cs						;segment
	mov al,9h									;interrupt number
	lea di, old_key_vec
	lea si, new_key_vec
	call setup_int
	
	mov dh,25	
	mov dl,20
	call set_cursor
	
	lea si,time_var
	mov bl,3h						;color
	call print_string
	printw time,result				;reduces possible redundancy
	
	mov b_tx,1
	mov b_ty,2
	call draw_bomber
	call drawMap
	
;keyboard press test starts here
	
test_key:
	cmp time,0
	je	done
	cmp key_flag,1		;check key flag
	jne test_timer		;not set, go ceck timer flag
	mov bx,b_tx
	mov cx,b_ty
	call clear_tile		;if key is pressed, clear bomberman from current position
	cmp bomb_life,0
	jle test_key_skip
	call draw_bmb		;draw bomb if bomb_life > 0
test_key_skip:
	mov key_flag,0		;flag set, clear it and check scan code
	cmp scan_code,esc_key	;esc key?
	jne tk_up			;no, check arrow keys
	jmp done			;esc, terminate

;direction checking starts here
	
tk_up:
	cmp scan_code, up_arrow		;up arrow?
	jne tk_down					;no, check down arrow
	mov bx,-20
	mov si,0
	call move_bomber
	jmp test_timer				;go check timer
	
tk_down:
	cmp scan_code, down_arrow		;down arrow?
	jne tk_left					;no, check left arrow
	mov bx,20
	mov si,0
	call move_bomber
	jmp test_timer				;go check timer
	
tk_left:
	cmp scan_code, left_arrow		;left arrow?
	jne tk_right					;no, check right arrow
	mov bx,0
	mov si,-1
	call move_bomber
	jmp test_timer				;go check timer
	
tk_right:
	cmp scan_code, right_arrow		;right arrow?
	jne tk_space					;no , check space bar
	mov bx,0	
	mov si,1
	call move_bomber
	jmp test_timer				;go check timer
	
tk_space:
	cmp scan_code, spc_button		;space button?
	jne test_timer					;no , check timer
	cmp bomb_life,0					;is a bomb active?
	jge tk_space_skip				;yes? skip
	call set_bomb
tk_space_skip:
	
test_timer:
	;it's name test_timer, but doesn't do that :v it was when we had actual test timer here :p
	push cx
	mov cx,5
delay:
	cmp timer_flag,1			;timer ticked?
	jne delay					;no, keep checking
	mov timer_flag,0
	;bomberman keeps getting rendered here
	call draw_bomber			
	
	loop delay					;delay it for 500ms
	pop cx
	
	;rendering other stuff (creep, bomb, explosion) starts here
	
	call update_creep
	cmp life,1					;check if life is less than 1, you might wanna move this check later on to accomodate the check for bombs as well
	jl done						;checked for <1 coz for some reason the check doesn't activate for <=0. duibar collide korar por kaj hoi.
	cmp bomb_life,0				;check if explosion is to happen
	je burst_bomb				;yes? explosion!!!
	jl delay_skip				; < 0 ? skip
	dec bomb_life				;decrease bomb_life
	call draw_bmb				;render bomb
	jmp delay_skip				;done rendering
burst_bomb:						;after explosion, dec bomb_life to -1
	call bomb_blast
	dec bomb_life				;decrease bomb_life (to make it -1)
	call clear_bomb				;bomb is done, clear it.
	call bomb_blast
	cmp c_count,0				;if all creeps dead, done
	je done
	cmp life,0
	jle done
delay_skip:

	mov dh,25
	mov dl,27
	call set_cursor

	lea si,result
	mov bl,0
	call print_string			;remove previously written time by printing over with black
	
	dec time
	mov dh,25
	mov dl,27
	call set_cursor

	printw time,result
	lea si,result
	mov bl,0c3h
	call print_string			;print current time
	
	jmp test_key
	
	;reset timer interrupt vector
done:
	lea di,new_timer_vec
	lea si, old_timer_vec
	mov al,1ch
	call setup_int
	
	;reset keyboard interrupt vector
	lea di, new_key_vec
	lea si,old_key_vec
	mov al,9h
	call setup_int
	
	call reset_display
	
;this is where the game ends, show leaderboard here
;all sort of winning/losing screen goes after this
;as we are back to text mode with the interrupts in their previous form
	cmp life,0
	jle main_bomberman_dead
	
;add victory condition here
	jmp main_victory

main_call_leaderboard:
	call reset_display
	call show_leaderboard
	mov ah,1h
	int 21h
	jmp main_main_menu
	
main_call_instruction:
	call reset_display
	
	call print_htp
	
	mov ah,1h
	int 21h
	
	jmp main_main_menu
;call victory screen here.
main_victory:
	call win_screen
	jmp main_post_game
	
main_bomberman_dead:
	call bomberman_dead
main_post_game:
	call reset_display
	call show_leaderboard
	mov ah,1h
	int 21h
main_exit:
	call reset_display
	
	mov ah,4ch
	int 21h
main endp
	end main