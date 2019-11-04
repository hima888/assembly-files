org 100h
.data
array: db 1,2,3,4,5,6,7
.code

mov si,00
mov ax,00
mov bx,7

;sum of the array 
sum:
    add ax,array[si]
    inc si
    cmp si,7
    jnz sum
    
;average = sum/(length) ---> (al)/bx   
div bx
