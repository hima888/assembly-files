org 100h
.data
array :db 1,3,4,5,3,87,45,23,11,22  

.code
mov cx,9
mov si,00
Bublesort:
cmp cx,si
jz next
mov al ,array[si]
mov bl ,array[si+1]
cmp al ,bl 
jb exchange  ;jb if you wanna to sort descending order 
add si ,1 
jmp Bublesort




exchange:
mov array[si],bl
mov array [si+1],al
add si,1
jmp Bublesort
               
next:
sub cx,1
mov si,00
cmp cx,0
jnz Bublesort