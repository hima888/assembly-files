org 100h
.data
array db 2,3,5,6,7,8,33,4,16        

.code 
mov si ,00
mov bl ,array[si]
add si,1
findmax:
mov al,array[si]
add si,1
cmp bl ,al
jb changemax ;to find min you'll ja  
return:
cmp si,7
jnz findmax
jz endd



changemax:
mov bl ,al 
jmp return  

endd:
