org 100h
.DATA
M_enter: db "Please enter the number of elements in the array to be sorted or press 0 to terminate:$"
M_ArrayElement: db "Please enter elements of the array to be sorted:$"
M_StoredArray: db "The sorted array is:$"   
M_Eerror: db "Please enter suitable number in the range of [1 - 25]:$" 

array: dw 25 dup(0)  
buffer 3,?,2 dup('')
.CODE
start:
    mov ah,05h
    int 10h
    call messageEnter   ;message
    jmp main  
;****************************************************************
proc messageEnter
    lea dx,M_enter 
    mov ah,9h
    int 21h
    ret
;****************************************************************
proc messageArrayElements
    lea dx,M_ArrayElement
    mov ah,9h  
    int 21h 
    ret
;****************************************************************
proc messageStoredArray
    lea dx,M_StoredArray
    mov ah,9h
    int 21h
    ret
;****************************************************************
proc newLine
    mov ah,2h
    mov dl,013
    int 21h
    mov dl,010
    int 21h
    ret
;****************************************************************
proc messageError 
    lea dx,M_Eerror
    mov ah,9h
    int 21h
    ret
;****************************************************************
proc arrayElements  
    mov di,0 
    mov ah,2h
    push cx  
    L_array:
        mov bx,array[di]    ;mov the value to print ,(array[0],array[1].....) di=0 --> n
        add di,2
        call get_digits
        call print
        cmp cx,1
        jz break
        call comma 
        loop L_array
   break:
    pop cx
    ret
;*****************************************************************
proc comma   
    mov ah,2h               
    mov Dl,44                      
    int 21h               
    ret 
;*****************************************************************
proc inputArrayLength
    Lea dx,buffer
	mov ah ,0ah
	int 21h
	mov dh,buffer[2]
	mov dl,buffer[3]
	sub dh,48
	sub dl,48
	mov ax,10
	mul dh
	mov dh,0
	add ax,dx
	mov cx,ax
	ret 
;*****************************************************************
proc testInput
    cmp cx,25
    ja L_error
    cmp cx,0
    jb L_error
    jz endd 
    ret    
;*****************************************************************
proc get_digits      ;number of digits of an integer in (SI) + every digit gonna stored in stack
     pop bp          ;save return address
     mov si,0        ;number of digits=0 
     mov ax,bx       ;move the number from bx to ax--->(accumulator) to divide it by 10
     mov bx,10       ;bx=10 to divide the number by 10
     digit:          ;label for looping
        mov dx,00    ;because dx store the reminder we have to make dx=00 every loop 
        div bx       ;divide DX,AX/10
        INC SI       ;number of digits ++
        push dx      ;store the reminder in stack
        cmp ax,00h   ;quotient==0 ?
        jnz digit    ;while(quotient != 0) loop    
     push bp         ;restore return address
     ret             ;return
;*****************************************************************
proc print          ;print an integers (SI)times
    pop bp          ;save return address
    mov ah,2h       ;intilaize printing
    prin:           ;label for looping
       pop dx       ;take the integer from stack
       add dl,48    ;correct its position
       int 21h      ;do it
       DEC si       ;SI--
       cmp si,0     ;SI==0 ?
       jnz prin     ;while (SI != 0) loop
    push bp         ;restore return address             
    ret             ;return
;*****************************************************************
proc inputArrayElements
    push cx ;save cx :D
    mov si,0
    mov bx,0
        ;while(cx !=0 )
        big:                      
            mov ah,01h  ;for taking input
            int 21h 
            cmp al,0Dh  ;if i/p == enter
            jz  ll2     ;then go to ll2 else ... put the value in bx after some calculation
                        ;example:
                        ;user entered first time 5 so bx will equall 5
                        ;the second i/p was 1 so the bx have to be 51
                        ;but to do that we have to 
                        ;bx=bx*10+i/bp
                        ;that is the calculation
            sub al,48   
            mov ah,00
            mov di,10
            xchg bx,ax 
            mul di
            add bx,ax   
            jmp big 
    ll2:
        call newLine
        mov array[si],bx    ;bx store the value that user entered
        add si,2    ;next element in the array[si]
        mov bx,0
        dec cx      ;taking elements depend on CX "dec cx untill cx==0"
        cmp cx,0
        jnz big
             
    jj:
    pop cx

    ret
;*****************************************************************************************************
proc bubbleSort
    ;initilze
    push cx
    mov si,00
    add cx,cx
    sub cx,2
    ;start bubble sort
    Sort:
        cmp cx,si
        jz next
        mov ax,array[si]  
        mov bx,array[si+2]  
        cmp ax,bx         
        ja exchange    ;we need to swap 
        add si,2  
        jmp Sort
    exchange:
        mov array[si+2],ax
        mov array[si],bx
        add si,2
        jmp Sort 
    ;start next iteration
    next: 
        mov si,0
        sub cx,2
        cmp cx,0
        jnz Sort
    pop cx
    ret
;*****************************************************************************************************
L_error:
    call messageError    
main: 
    call inputArrayLength  ;take input from user-2 digits --> the size of array 1-25,0 terminate
    call newLine
    call testInput         ;test that input is it in range 1-25
    call messageArrayElements   ;message
    call inputArrayElements     ;take the array elements from the user (array[0],array[1]....)
    cmp cx,1
    jz  haha
    call bubbleSort             ;sort
    haha:
    call messageStoredArray     ;message
    call newLine
    call arrayElements          ;print the array
    call newLine
    call messageEnter
    jmp main
endd:                   