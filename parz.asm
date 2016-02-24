.386

data segment use16
entr db 10,13,'$'
tr db 'YAY!$'
fl db 'NOPE$'
inp db 6,7 dup(?)
num dw ?
count dw 1
mass dw 2, 1024 dup(?)
data ends

stek segment stack use16
db 256 dup(?)
stek ends

cod segment use16
assume cs:cod,ds:data,ss:stek

input proc 
push cx si dx bx
xor cx,cx
mov cl,inp[1]
mov si,2
mov bx,10
xor ax,ax
inp_c:
mul bx
mov dl,inp[si]
and dl,00001111b
add ax,dx
inc si
loop inp_c
pop bx dx si cx
ret
input endp

num_gen proc
push cx bx dx

mov ax,num
xor dx,dx
mov bx,2
div bx
dec ax
add ax,dx
mov cx,ax

mov ax,3
valid_c:
call valid_num
inc ax
inc ax
loop valid_c

mov ax,count
dec ax
mul bx
mov cx,num
mov bx,ax
xor ax,ax
xor cx,mass[bx]
sete al
pop dx bx cx
ret
num_gen endp

valid_num proc
push cx bx dx si ax
mov cx,count
xor si,si
check:
pop ax
push ax
xor dx,dx
mov bx,mass[si]
div bx
test dx,0ffffh
jz end_f
inc si
inc si
loop check
jmp end_t
end_f:
pop ax si dx bx cx
ret
end_t:
pop ax
mov mass[si],ax
inc count
pop si dx bx cx
ret
valid_num endp

main proc far
push ds
xor ax,ax
push ax
mov ax,data
mov ds,ax
mov ah,10
lea dx,inp
int 21h
mov ah,9
lea dx,entr
int 21h
call input
mov num,ax
call num_gen
test ax,1
jz f
mov ah,9
lea dx,tr
int 21h
jmp e
f:
mov ah,9
lea dx,fl
int 21h
e:
lea dx,entr
int 21h

ret
main endp
cod ends
end main
