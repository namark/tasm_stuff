RD struc
	x0 dw ?
	y0 dw ?
	r dw ?
	d dw ?
	x dw ?
	y dw ?
	map_size db 0 ; the byte size of the map
	map_bit db 0 ; size of the last byte in bits
	map db 256 dup(0) ; the map itself... need to find a way to store it more efficiently, most RDs will need much less than 256 bytes
RD ends

INCM macro value,count
rept count
inc value
endm
endm

DECM macro value,count
rept count
dec value
endm
endm

INCSI macro count
rept count
inc si
endm
endm

DECSI macro count
rept count
dec si
endm
endm

shdr macro h, l, count
	rept count
	shr h,1
	rcr l,1
	endm
endm

shdl macro h, l, count
	rept count
	shl l,1
	rcl h,1
	endm
endm

set_2d_cord macro rowsize,i,j,value,segm  ; segm:(bx+rowsizse*i+j)=value
push si ax dx
mov ax,i
mov dx,rowsize
;inc dx
mul dx
mov si,ax
add si,j
mov al, value
mov byte ptr segm:[bx+si],al
pop dx ax si
endm

set_2d_cord_w macro rowsize,i,j,value,segm  ; segm:(bx+rowsizse*i+j)=value
push si ax dx
mov ax,i
mov dx,rowsize
;inc dx
mul dx
mov si,ax
add si,j
mov ax, value
mov word ptr segm:[bx+si],ax
pop dx ax si
endm

set_2d_cord_d macro rowsize,i,j,value,segm  ; segm:(ebx+rowsizse*i+j)=value
push esi eax edx
mov eax,i
mov edx,rowsize
;inc dx
mul edx
mov esi,eax
add esi,j
mov eax, value
mov dword ptr segm:[ebx+esi],eax
pop edx eax esi
endm

draw_line macro rowsize, x1, y1, x2, y2, value, segm ; x1, y1 must be a memory, or unused register
local skipx, skipy, swap, skip_swap, x, y, go_straightx, go_straighty, go_downy, gone_upy, go_downx, gone_upx, dec_x, inc_x, dec_y, inc_y
	
	push bp ax bx cx dx si di
	xor bx,bx
	xor dx,dx
	xor bp,bp
	mov si,x2
	sub si,x1
	jge skipx
	or dl,10b
	neg si
skipx:	
	mov di,y2
	sub di,y1
	jge skipy
	or dl,1
	neg di
skipy:
	
	cmp si,di
	jl swap
	mov cx,si
	x:
		xor bx,bx
		set_2d_cord rowsize,y1,x1,value,segm
		add bp,di
		mov bx,bp
		shl bx,1
		cmp bx,si
		jl go_straightx
			ror dl,1
			jc go_downy
				inc y1
				jmp gone_upy
			go_downy:
				dec y1
			gone_upy:
			rol dl,1
			sub bp,si
		go_straightx:
		ror dl,2
		jc dec_x
			inc x1
			jmp inc_x
		dec_x:
			dec x1
		inc_x:
		rol dl,2
	loop x
	jmp skip_swap
swap:
	mov cx,di
	y:
		xor bx,bx
		set_2d_cord rowsize,y1,x1,value,segm
		add bp,si
		mov bx,bp
		shl bx,1
		cmp bx,di
		jl go_straighty
			ror dl,2
			jc go_downx
				inc x1
				jmp gone_upx
			go_downx:
				dec x1
			gone_upx:
			rol dl,2
			sub bp,di
		go_straighty:
		ror dl,1
		jc dec_y
			inc y1
			jmp inc_y
		dec_y:
			dec y1
		inc_y:
		rol dl,1
	loop y
	
	
skip_swap:
	xor bx,bx
	set_2d_cord rowsize,y1,x1,value,segm

pop di si dx cx bx ax bp	
endm

draw_circle macro rowsize,x0,y0,r,value,segm
local no_dec, cikl, finish
	push ax dx di cx bp
	xor ax,ax
	mov dx,r
	;plot
			mov cx,dx
			add cx,y0
			set_2d_cord rowsize,cx,x0,value,segm
			
			mov cx,dx
			neg cx
			add cx,y0
			set_2d_cord rowsize,cx,x0,value,segm
			
			mov cx,dx
			neg cx
			add cx,x0
			set_2d_cord rowsize,y0,cx,value,segm
			
			mov cx,dx
			add cx,x0
			set_2d_cord rowsize,y0,cx,value,segm
	;
	mov di,r
	shl di,2
	neg di
	add di,5
	cikl:
		
		
		jl no_dec
			inc ax
			dec dx
			;plot
			mov cx,dx
			add cx,y0
			mov bp,ax
			add bp,x0
			set_2d_cord rowsize,cx,bp,value,segm
			
			mov cx,dx
			neg cx
			add cx,y0
			mov bp,ax
			neg bp
			add bp,x0
			set_2d_cord rowsize,cx,bp,value,segm
			
			mov cx,dx
			neg cx
			add cx,y0
			mov bp,ax
			add bp,x0
			set_2d_cord rowsize,cx,bp,value,segm
			
			mov cx,dx
			add cx,y0
			mov bp,ax
			neg bp
			add bp,x0
			set_2d_cord rowsize,cx,bp,value,segm
			
			mov cx,dx
			add cx,x0
			mov bp,ax
			add bp,y0
			set_2d_cord rowsize,bp,cx,value,segm
			
			mov cx,dx
			neg cx
			add cx,x0
			mov bp,ax
			neg bp
			add bp,y0
			set_2d_cord rowsize,bp,cx,value,segm
			
			mov cx,dx
			neg cx
			add cx,x0
			mov bp,ax
			add bp,y0
			set_2d_cord rowsize,bp,cx,value,segm
			
			mov cx,dx
			add cx,x0
			mov bp,ax
			neg bp
			add bp,y0
			set_2d_cord rowsize,bp,cx,value,segm
			;
			cmp dx,ax
			jle finish
			push dx ax
			shl dx,3
			shl ax,3
			add di,ax
			sub di,dx
			add di,4
			pop ax dx
			;p=p+8x+4-8y
			jmp cikl
		no_dec:
			inc ax
			
			;plot
			mov cx,dx
			add cx,y0
			mov bp,ax
			add bp,x0
			set_2d_cord rowsize,cx,bp,value,segm
			
			mov cx,dx
			neg cx
			add cx,y0
			mov bp,ax
			neg bp
			add bp,x0
			set_2d_cord rowsize,cx,bp,value,segm
			
			mov cx,dx
			neg cx
			add cx,y0
			mov bp,ax
			add bp,x0
			set_2d_cord rowsize,cx,bp,value,segm
			
			mov cx,dx
			add cx,y0
			mov bp,ax
			neg bp
			add bp,x0
			set_2d_cord rowsize,cx,bp,value,segm
			
			mov cx,dx
			add cx,x0
			mov bp,ax
			add bp,y0
			set_2d_cord rowsize,bp,cx,value,segm
			
			mov cx,dx
			neg cx
			add cx,x0
			mov bp,ax
			neg bp
			add bp,y0
			set_2d_cord rowsize,bp,cx,value,segm
			
			mov cx,dx
			neg cx
			add cx,x0
			mov bp,ax
			add bp,y0
			set_2d_cord rowsize,bp,cx,value,segm
			
			mov cx,dx
			add cx,x0
			mov bp,ax
			neg bp
			add bp,y0
			set_2d_cord rowsize,bp,cx,value,segm
			;
			push ax
			shl ax,3
			add di,ax
			add di,4
			pop ax
			;p=p+8x+4
	jmp cikl
finish:
	pop bp cx di dx ax
endm

rot macro A,dir; type of A is RD, see structure above... dir specifice(?) the direction of rotation...    need to add some comments below... and a lot of optimization 
local exit, no_dec, cikl, finish, skip_init, map_bit_ok, map_not_built, dont_use_map, switch_table, case0, case1, case2, case3, case4, case5, case6, case7,  exit_switch, skip_dec0, cl_ok0, ch_ok0, skip_dec1, cl_ok1, ch_ok1, skip_dec2, cl_ok2, ch_ok2, skip_dec3, cl_ok3, ch_ok3, skip_dec4, cl_ok4, ch_ok4, skip_dec5, cl_ok5, ch_ok5, skip_dec6, cl_ok6, ch_ok6, skip_dec7, cl_ok7, ch_ok7, not_last0, is_last0, not_last2, is_last2, not_last4, is_last4, not_last6, is_last6 
	push ax bx dx di cx
	
	
	
	xor di,di
	add di,A.d
	jnz skip_init
	mov bh,A.map_size
	mov bl,A.map_bit
	mov di,A.r
	xor di,0
	jnz dont_use_map
	xor bx,0
	jz dont_use_map
	
		mov bx,A.x0 ; A.x0 now holds the case number
		shl bx,1 ; cases are 2B, i wonder if they would be 4 if i use32
		jmp cs:switch_table[bx]
		switch_table dw case0, case1, case2, case3, case4, case5, case6, case7
	
		case0:
			mov cx,A.y0 ; low byte of A.y0 now represents the bit coordinate and the high byte the byte coordinate in the map
			mov ah,1
			shl ah,cl
			xor bx,bx
			mov bl,ch
			mov al,A.map[bx]
			and al,ah
			jz skip_dec0
				;inc A.x
				;inc A.y
				;dec A.x
				dec A.y
			skip_dec0:
			;dec A.y
			;dec A.x
			;inc A.y
			inc A.x
			;dec cl
			inc cl
			cmp ch,A.map_size ; see if we're on the last byte, form here i think optimisation can be done... obviously... for me... i guess
			jne not_last0
			cmp cl,A.map_bit
			jmp is_last0
			not_last0:
			;jge cl_ok
			cmp cl,7
			is_last0:
			jle cl_ok0
				;cmp ch,0
				cmp ch,A.map_size
				jne ch_ok0
					;inc cl
					dec cl
					inc A.x0	
					jmp cl_ok0	
				ch_ok0:
				;dec ch
				inc ch
				;mov cl,7
				mov cl,0
			cl_ok0:
			mov A.y0,cx
			jmp exit_switch
		case1:
			mov cx,A.y0
			mov ah,1
			shl ah,cl
			xor bx,bx
			mov bl,ch
			mov al,A.map[bx]
			and al,ah
			jz skip_dec1
				inc A.x
				;inc A.y
				;dec A.x
				;dec A.y
			skip_dec1:
			dec A.y
			;dec A.x
			;inc A.y
			;inc A.x
			dec cl
			;inc cl
			jge cl_ok1
			;cmp cl,7
			;jle cl_ok
				
				cmp ch,0
				;cmp ch,A.map_size
				jne ch_ok1
					inc cl
					;dec cl
					inc A.x0	
					jmp cl_ok1	
				ch_ok1:
				dec ch
				;inc ch
				mov cl,7
				;mov cl,0
			cl_ok1:
			mov A.y0,cx
			jmp exit_switch
		case2:
			mov cx,A.y0
			mov ah,1
			shl ah,cl
			xor bx,bx
			mov bl,ch
			mov al,A.map[bx]
			and al,ah
			jz skip_dec2
				;inc A.x
				;inc A.y
				dec A.x
				;dec A.y
			skip_dec2:
			dec A.y
			;dec A.x
			;inc A.y
			;inc A.x
			;dec cl
			inc cl
			cmp ch,A.map_size
			jne not_last2
			cmp cl,A.map_bit
			jmp is_last2
			not_last2:
			;jge cl_ok
			cmp cl,7
			is_last2:
			jle cl_ok2
				
				;cmp ch,0
				cmp ch,A.map_size
				jne ch_ok2
					;inc cl
					dec cl
					inc A.x0	
					jmp cl_ok2
				ch_ok2:
				;dec ch
				inc ch
				;mov cl,7
				mov cl,0
			cl_ok2:
			mov A.y0,cx
			jmp exit_switch
		case3:
			mov cx,A.y0
			mov ah,1
			shl ah,cl
			xor bx,bx
			mov bl,ch
			mov al,A.map[bx]
			and al,ah
			jz skip_dec3
				;inc A.x
				;inc A.y
				;dec A.x
				dec A.y
			skip_dec3:
			;dec A.y
			dec A.x
			;inc A.y
			;inc A.x
			dec cl
			;inc cl
			jge cl_ok3
			;cmp cl,7
			;jle cl_ok
				
				cmp ch,0
				;cmp ch,A.map_size
				jne ch_ok3
					inc cl
					;dec cl
					inc A.x0	
					jmp cl_ok3	
				ch_ok3:
				dec ch
				;inc ch
				mov cl,7
				;mov cl,0
			cl_ok3:
			mov A.y0,cx
			jmp exit_switch
		case4:
			mov cx,A.y0
			mov ah,1
			shl ah,cl
			xor bx,bx
			mov bl,ch
			mov al,A.map[bx]
			and al,ah
			jz skip_dec4
				;inc A.x
				inc A.y
				;dec A.x
				;dec A.y
			skip_dec4:
			;dec A.y
			dec A.x
			;inc A.y
			;inc A.x
			;dec cl
			inc cl
			cmp ch,A.map_size
			jne not_last4
			cmp cl,A.map_bit
			jmp is_last4
			not_last4:
			;jge cl_ok
			cmp cl,7
			is_last4:
			jle cl_ok4
				
				;cmp ch,0
				cmp ch,A.map_size
				jne ch_ok4
					;inc cl
					dec cl
					inc A.x0	
					jmp cl_ok4	
				ch_ok4:
				;dec ch
				inc ch
				;mov cl,7
				mov cl,0
			cl_ok4:
			mov A.y0,cx
			jmp exit_switch
		case5:
			mov cx,A.y0
			mov ah,1
			shl ah,cl
			xor bx,bx
			mov bl,ch
			mov al,A.map[bx]
			and al,ah
			jz skip_dec5
				;inc A.x
				;inc A.y
				dec A.x
				;dec A.y
			skip_dec5:
			;dec A.y
			;dec A.x
			inc A.y
			;inc A.x
			dec cl
			;inc cl
			jge cl_ok5
			;cmp cl,7
			;jle cl_ok
				
				cmp ch,0
				;cmp ch,A.map_size
				jne ch_ok5
					inc cl
					;dec cl
					inc A.x0	
					jmp cl_ok5	
				ch_ok5:
				dec ch
				;inc ch
				mov cl,7
				;mov cl,0
			cl_ok5:
			mov A.y0,cx
			jmp exit_switch
		case6:
			mov cx,A.y0
			mov ah,1
			shl ah,cl
			xor bx,bx
			mov bl,ch
			mov al,A.map[bx]
			and al,ah
			jz skip_dec6
				inc A.x
				;inc A.y
				;dec A.x
				;dec A.y
			skip_dec6:
			;dec A.y
			;dec A.x
			inc A.y
			;inc A.x
			;dec cl
			inc cl
			cmp ch,A.map_size
			jne not_last6
			cmp cl,A.map_bit
			jmp is_last6
			not_last6:
			;jge cl_ok
			cmp cl,7
			is_last6:
			jle cl_ok6
				
				;cmp ch,0
				cmp ch,A.map_size
				jne ch_ok6
					;inc cl
					dec cl
					inc A.x0	
					jmp cl_ok6	
				ch_ok6:
				;dec ch
				inc ch
				;mov cl,7
				mov cl,0
			cl_ok6:
			mov A.y0,cx
			jmp exit_switch
		case7:
			mov cx,A.y0
			mov ah,1
			shl ah,cl
			xor bx,bx
			mov bl,ch
			mov al,A.map[bx]
			and al,ah
			jz skip_dec7
				;inc A.x
				inc A.y
				;dec A.x
				;dec A.y
			skip_dec7:
			;dec A.y
			;dec A.x
			;inc A.y
			inc A.x
			dec cl
			;inc cl
			jge cl_ok7
			;cmp cl,7
			;jle cl_ok
				
				cmp ch,0
				;cmp ch,A.map_size
				jne ch_ok7
					inc cl
					;dec cl;
					mov A.x0,0	
					jmp cl_ok7	
				ch_ok7:
				dec ch
				;inc ch
				mov cl,7
				;mov cl,0
			cl_ok7:
			mov A.y0,cx
			
		exit_switch:
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	jmp exit
	dont_use_map:
	
	shl di,2
	neg di
	add di,5
	skip_init:
		
		
		
		jl no_dec
			inc A.x
			dec A.y
			mov ax,A.x
			mov dx,A.y
			sub ax,A.x0
			sub dx,A.y0

			mov ch,1
			mov cl,A.map_bit
			shl ch,cl
			xor bx,bx
			mov bl,A.map_size
			or A.map[bx],ch
			
			;push dx ax
			shl dx,3
			shl ax,3
			add di,ax
			sub di,dx
			add di,4
			;pop ax dx
			;p=p+8x+4-8y
			jmp finish
		no_dec:
			inc A.x
			mov ax,A.x
			mov dx,A.y
			sub ax,A.x0
			sub dx,A.y0
			
			;push ax
			shl ax,3
			add di,ax
			add di,4
			;pop ax
			;p=p+8x+4
	;jmp cikl
finish:
	

	mov ax, A.x
	mov dx, A.y
 	cmp dx,ax
	jg map_not_built
		mov di,0
		mov A.r,0
		mov A.x0,1
		mov ax,A.y0;???
		xor ax,ax;???
		mov al, A.map_bit
		mov ah, A.map_size
		mov A.y0,ax
		jmp map_bit_ok
	map_not_built:
		
	inc A.map_bit
	cmp A.map_bit, 7
	jbe map_bit_ok
	mov A.map_bit,0
	inc A.map_size
map_bit_ok:
	
	mov A.d,di
exit:
	pop cx di dx bx ax
endm

speaker_setT macro
	;give T in ax
	push ax ax
	mov al, 0B6h	
	out 43h,al ; tell to the comp that we wont to set T for timer 2
	pop ax
	out 42h,al ; give the low byte of T
	shr ax,8
	out 42h,al; give the high byte of T
	pop ax
endm

speaker_start macro
	push ax
	in al,61h
	or al,11b
	out 61h,al
	pop ax
endm 

speaker_end macro
	push ax
	in al,61h
	and al,11111100b
	out 61h,al
	pop ax
endm

wait_for macro milisec
	push ax  dx  cx
	mov ax,milisec
	mov dx,1000
	mul dx
	mov cx,dx  ;  high bite of delay in microseconds
	mov dx,ax  ; low byte of delay in microseconds
	mov ah,86h ; function wait of int 15h
	int 15h
	pop cx dx ax
endm 
