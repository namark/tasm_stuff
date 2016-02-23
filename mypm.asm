.386p

RM_data segment use16 

message db 'H',7,'i',7,' ',7,'f',7,'r',7,'o',7,'m',7,' ',7,'P',7,'M',7
ml = $-message

GDT		db 8 dup(0)
GDT_FCS		db 0FFh,0FFh,0,0,0,10011010b,11001111b,0
GDT_FDS 	db 0FFh,0FFh,0,0,0,10010010b,11001111b,0
GDT_CS16	db 0FFh,0FFh,0,0,0,10011010b,0,0
GDT_DS16	db 0FFh,0FFh,0,0,0,10010010b,0,0
GDT_l = $-GDT

GDTR 	dw GDT_l-1
	dd ?

SEL_FCS	 equ 00001000b
SEL_FDS	 equ 00010000b
SEL_CS16 equ 00011000b
SEL_DS16 equ 00100000b

RM_data ends

RM_code segment use16
assume cs:RM_code, ds:RM_data

start:
	xor ax,ax
	mov ax,RM_data
	mov ds,ax
	
	in al,92h
	or al,2
	out 92h,al

	xor eax,eax
	mov ax,PM_seg
	shl eax,4
	add eax, offset PM_entry
	mov dword ptr cs:PM_entry_off,eax

	xor eax,eax
	mov ax,cs
	shl eax,4
	mov word ptr GDT_CS16[2],ax
	shr eax,16
	mov GDT_CS16[4],al

	xor eax,eax
	mov ax,ds
	shl eax,4
	push eax
	mov word ptr GDT_DS16[2],ax
	shr eax,16
	mov GDT_DS16[4],al
	
	pop eax
	add eax, offset GDT
	mov dword ptr GDTR[2],eax

	lgdt fword ptr GDTR 
	
	cli

	in al,70h
	or al,80h
	out 70h,al

	mov eax,cr0
	or al,1
	mov cr0,eax

	db 66h
	db 0EAh
	PM_entry_off dd ?
	dw SEL_FCS

RM_return:

	mov eax,cr0
	and al,0FEh
	mov cr0,eax

	db 0EAh
	dw $+4
	dw RM_code

	in al,70h
	and al,7Fh
	out 70h,al

	sti

	xor ah,ah
	int 16h

	mov ah,4Ch
	int 21h

RM_code ends


PM_seg segment use32
assume cs:PM_seg

PM_entry:
	mov ax,SEL_DS16
	mov ds,ax
	mov ax,SEL_FDS
	mov es,ax

	lea esi,message
	mov edi,0B8000h
	add edi, 24*80*2
	mov ecx,ml
	cld
	rep movsb

	db 0EAh
	dd offset RM_return
	dw SEL_CS16
PM_seg ends

RM_stack segment stack use16
db 32 dup(?)
RM_stack ends

end start	
	