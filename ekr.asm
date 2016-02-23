.386
IF 1
include macrolib.asm
ENDIF

data segment USE16
i dd 0
j dd 0
x1 dw ?
y1 dw ?
x2 dw ?
y2 dw ?

A RD <100,100,50,0,100,150>

radius dw 1

ms db ?
mstep equ 5

col equ 0B0B0B0B0h
sec_h equ 0Fh
sec_l equ 4240h
data ends

stek segment stack USE16
dw 512 dup(?)
stek ends

cod segment USE16
assume cs:cod,ds:data,ss:stek

main proc far
	push ds
	xor ax,ax
	push ax
	mov ax,data
	mov ds,ax
	
	mov	ax,0013h ; 320x200 256 colors	
	int	10h		
	
	
	;most VGA-boards has "Super VGA" resolutions
	;AX = 4F02h 
	;BX = mode 
	;INT 10h
    ;   video mode 

	; 100h  graph 640x400   256 colors 
	; 101h  graph 640x480   256 colors 
	; 102h  graph 800x600   16  colors 
	; 103h  graph 800x600   256 colors 
	; 104h  graph 1024x768  16  colors 
	; 105h  graph 1024x768  256 colors 
	; 106h  graph 1280x1024 16  colors 
	; 107h  graph 1280x1024 256 colors 
	; 108h  text 80x60 
	; 109h  text 132x25 
	; 10Ah  text 132x43 
	; 10Bh  text 132x50 
	; 10Ch  text 132x60  

        ; 10Dh : 320x200 32k-colour (1:5:5:5)
        ; 10Eh : 320x200 64k-colour (5:6:5)
        ; 10Fh : 320x200 16.8M-colour (8:8:8)
        ; 110h : 640x480 32k-colour (1:5:5:5)
        ; 111h : 640x480 64k-colour (5:6:5)
        ; 112h : 640x480 16.8M-colour (8:8:8)
        ; 113h : 800x600 32k-colour (1:5:5:5)
        ; 114h : 800x600 64k-colour (5:6:5)
        ; 115h : 800x600 16.8M-colour (8:8:8)
        ; 116h : 1024x768 32k-colour (1:5:5:5)
        ; 117h : 1024x768 64k-colour (5:6:5)
        ; 118h : 1024x768 16.8M-colour (8:8:8)
        ; 119h : 1280x1024 32k-colour (1:5:5:5)
        ; 11Ah : 1280x1024 64k-colour (5:6:5)
        ; 11Bh : 1280x1024 16.8M-colour (8:8:8)


	
	;mov ax,4F02h
	;mov bx,105h
	;int 10h
	;xor bx,bx
	push 0A000h
	pop es
restart:
	mov ms,45
	mov x1,0
	mov y1,0
	mov i,0
	mov j,0
	mov cx, 16000
	xor di,di
	xor eax,eax
	;mov bl,al
	xor bx,bx
	xor dx,dx
	
	cld
	n:	
		;stosd
		
		
		;inc bl
		set_2d_cord_d 200,0,j,col,es
		
		INCM j,4
		;inc dx
		;inc di
		
		
	loop n
	
	mov ah,86h ; function wait of int 15h
	mov cx,sec_h ;  high bite of delay in microseconds
	mov dx,sec_l; low byte of delay in microseconds
	int 15h
	
	set_2d_cord_d 320,100,160,4040404h,es
	mov x2,10
	mov y2, 5
	
	mov ah,86h
	int 15h
	
	draw_line 320,x1,y1,x2,y2,7h,es
	add x2,20
	add y2,30
	
	mov ah,86h
	int 15h
	
	draw_line 320,x1,y1,x2,y2,7h,es
	add x2,87
	add y2,23
	
	mov ah,86h
	int 15h
	
	draw_line 320,x1,y1,x2,y2,7h,es
	add x2,-17
	add y2,-12
	
	mov ah,86h
	int 15h
	
	draw_line 320,x1,y1,x2,y2,7h,es
	add x2,87
	add y2,23
	
	mov ah,86h
	int 15h
	
	draw_line 320,x1,y1,x2,y2,7h,es
	mov x2,160
	mov y2,98
	
	mov ah,86h
	int 15h
	
	draw_line 320,x1,y1,x2,y2,7h,es
	add y2,2
	
	
	mov al, 0B6h
	out 43h,al ; tell to the comp that we wont to set T for timer 2
	mov al,255
	out 42h,al ; give the low byte of T
	mov al,ms
	out 42h,al; give the high byte of T

	; set first two bits of 61h to tell to connect timer two to speaker
	in al,61h
	or al,11b
	out 61h,al 
	
	shdr cx,dx,2
	mov ah,86h
	int 15h
	
	sub ms,mstep
	mov al, 0B6h
	out 43h,al 
	mov al,255
	out 42h,al 
	mov al,ms
	out 42h,al

	
	mov ah,86h
	int 15h
	
	sub ms,mstep
	mov al, 0B6h
	out 43h,al 
	mov al,255
	out 42h,al 
	mov al,ms
	out 42h,al

	
	mov ah,86h
	int 15h
	
	sub ms,mstep
	mov al, 0B6h
	out 43h,al
	mov al,255
	out 42h,al
	mov al,ms
	out 42h,al

	
	mov ah,86h
	int 15h
	
	sub ms,mstep
	mov al, 0B6h
	out 43h,al 
	mov al,255
	out 42h,al 
	mov al,ms
	out 42h,al

	draw_line 320,x1,y1,x2,y2,7h,es
	add x1,4
	add x2,32
	add y2,21
	
	mov ah,86h
	int 15h
	
	sub ms,mstep
	mov al, 0B6h
	out 43h,al 
	mov al,255
	out 42h,al 
	mov al,ms
	out 42h,al
	
	mov ah,86h
	int 15h
	
	sub ms,mstep
	mov al, 0B6h
	out 43h,al 
	mov al,255
	out 42h,al 
	mov al,ms
	out 42h,al
	
	mov ah,86h
	int 15h
	
	sub ms,mstep
	mov al, 0B6h
	out 43h,al 
	mov al,255
	out 42h,al 
	mov al,ms
	out 42h,al
	
	mov ah,86h
	int 15h
	
	sub ms,mstep
	mov al, 0B6h
	out 43h,al 
	mov al,255
	out 42h,al 
	mov al,ms
	out 42h,al
	
	shdl cx,dx,2
	
	draw_line 320,x1,y1,x2,y2,7h,es
	add x2,100
	draw_line 320,x1,y1,x2,y2,7h,es
	mov y2,180
	mov x2,180
	draw_line 320,x1,y1,x2,y2,7h,es
	mov x1,100
	mov y1,100
	
	draw_line 320,x1,y1,x2,y2,7h,es
	mov x1,50
	mov y1,150
	draw_line 320,x1,y1,x2,y2,7h,es
	
	; clear first two bits of 61h to tell to disconnect timer two from speaker
	in al,61h
	and al,11111100b
	out 61h,al
	
	draw_circle 320,162,100,70,7h,es
	draw_circle 320,100,100,50,7h,es
	
	; mov x1,100
	; mov y1,100
	; draw_line 320,x1,y1,150,100,7h,es
	; mov x1,100
	; mov y1,100
	; draw_line 320,x1,y1,50,100,7h,es
	; mov x1,100
	; mov y1,100
	; draw_line 320,x1,y1,100,150,7h,es
	; mov x1,100
	; mov y1,100
	; draw_line 320,x1,y1,100,50,7h,es
	
	
; cikl_crc:
	; draw_circle 320,160,100,radius,7h,es
	; inc radius
	; cmp radius,100
	; jae not_jmp_to_cikl_crc
	; jmp cikl_crc
; not_jmp_to_cikl_crc:

	; mov radius,1
; cikl_crc1:
	; draw_circle 320,161,100,radius,7h,es
	; inc radius
	; cmp radius,100
	; jae not_jmp_to_cikl_crc1
	; jmp cikl_crc1
; not_jmp_to_cikl_crc1:

    mov bx,2fe0h
	mov ax,20h
	speaker_start
cikl_sound:
	speaker_setT
	wait_for 10
	cmp bx,0
	je dc
	add ax,20h
	jmp nodc
dc:
	sub ax,20h
nodc:	
	cmp ax,bx
	jne cikl_sound
	xor bx,0
	je vsyo
	mov bx,0
	jmp cikl_sound
vsyo:
	
	
	speaker_end
	

get_key:
	xor ah,ah
	int 16h
	mov ecx,2h ;???
	; function 0 of int 16h: pressed key -> al
	cmp al,'r'
	je restart
	cmp al,'w'
	je rotate
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
	wait_for 200
	speaker_end
	jmp get_key
check_x:	
	xor al,'x'
	jnz get_key
	
	mov ax,0003h ; standart text mode
	int 10h
	
ret

rotate:
mov x1,20
mov y1,20
call rotateproc
loop rotate
jmp get_key

main endp

rotateproc proc
set_2d_cord 320,A.y,A.x,0Bh,es
mov x1,100
mov y1,100
draw_line 320,x1,y1,A.x,A.y,0B0h,es
draw_circle 320,100,100,50,7h,es
set_2d_cord 320,A.y,A.x,4h,es
rot A; .x0,A.y0,A.r,A.d, A.x,A.y
mov x1,100
mov y1,100

draw_line 320,x1,y1,A.x,A.y,0Bh,es
set_2d_cord 320,A.y,A.x,4h,es
;inc A.y
;-------
;dec A.x
ret
rotateproc endp

cod ends
end main