IF 1
INCLUDE macrolib.asm
purge INCSI, DECSI, set_2d_cord, set_2d_cord_w, set_2d_cord_d, draw_line, draw_circle  
ENDIF 


stek segment stack
dw 32 dup(?)
stek ends

cod segment 
assume cs:cod, ss:stek

main proc far
push ds
xor ax,ax
push ax


get_key:
	xor ah,ah
	int 16h
	; function 0 of int 16h: pressed key -> al
	mov ah,10
	cmp al,'a'
	je make_noise
	add ah,10
	cmp al,'s'
	je make_noise
	add ah,10
	cmp al,'d'
	je make_noise
	add ah,10
	cmp al,'f'
	je make_noise
	add ah,10
	cmp al,'g'
	je make_noise
	add ah,10
	cmp al,'h'
	je make_noise
	add ah,10
	cmp al,'j'
	je make_noise
	add ah,10
	cmp al,'k'
	je make_noise
	add ah,10
	cmp al,'l'
	jne check_x
	
make_noise:
	speaker_setT 
	speaker_start
	;clc
	;wait_for 200
	;jc exit
	xor ah,ah
	int 1ah
	add dx,4
	adc cx,0
	mov di,dx
	mov bx,cx
bad_wait_loop:
	int 1ah
	xor dx,di
	jne bad_wait_loop
	xor cx,bx
	jne bad_wait_loop
	speaker_end
	jmp get_key
check_x:	
	xor al,'x'
	jz exit
	jmp get_key
exit:	
ret


ret
main endp
cod ends
end main
