include 'emu8086.inc'             ;include library of some functions
    
     org 100h
.data 
;all messages
    promptmsg DB 'Please enter a number [1..25]$'
    greatermsg db 'You have entered a greater number$'
    lessmsg db 'You have entered a lesser number$'
    correctmsg db 'You have hit a right number$'
    error_message:     db "Please enter suitable number in the range of [1 - 25]:$"
    fibonaci_message:  db "   *generating fibonaci series*   $"


buffer db 3,0,2 dup(' ')
.code 
jmp main     ;go to main
;-------------------------------------
main:
    call mesg1       ;call function to print message
    jmp inputprocess      ;go to label  
  error:
    call errorrange         ;call function to print error
inputprocess:
    call input          ;call function to take the input
    call test_input     ;call dunction to check the input is valid or not
    
    cmp cx,0    ;num==0 ?
    jz endd     ;terminate "go to label endd that will terminate"
                 
    call fibonaci2      ;call function to print ---fibonaci series---
    call new_line       ;call function to cout<<'\n 
               
    push 0              ;store 0 in stack
    push 1              ;store 1 in stack 
    
    mov Dl,48           ;print 0
    int 21h             ;do it
    cmp cx,1            ;cx==1
    jz main             ;if cx==1 : jmp to main 
    
    call print_comma    ;call function to print comma
    mov Dl,49           ;print 1         
    int 21h         ;do it        
  cmp cx,3          ;cx<3 ?
  jb main           ;if cx < 3 : go to exit 
  
  sub cx,2      ;cx-=2
fibo:
    call print_comma    ;call function to print comma
    call gen_fibo       ;call function that will generate nex generation of fibonaci in stack
    call get_digits     ;get the number of digits of the number hade generated
    call print          ;print that number
    loop fibo           ;loop again until                           
    jmp main            ;run the program again
endd: 
;---------------------------------------
proc input                  ;take input from user

   ;making new line after first statement
   mov dx,10
   mov ah,02h
   int 21h
   mov dx,13
   mov ah,02h
   int 21h
   call SCAN_NUM  ; calling a function in that library it takes a number and put it in cx                   
    
    
    
    
    ret
;---------------------------------------
proc mesg1       ;prining please enter the number .... 
    call new_line   ;call function to take new line      
    ;print first statement
   lea dx, promptmsg
   mov  ah,09h    
   int  21h
    ret             ;return 
;---------------------------------------
proc errorrange             ;printing Please enter suitable number...               
    call new_line       ;call function to take new line
    lea dx,error_message;the address of the message we wanna print stored in dx
    mov ah,9h           ;for printing
    int 21h             ;do it
    ret        
;---------------------------------------
proc new_line       ;taking new line
    mov ah,2h       ;intialize prinig
    mov Dl,013      ;go to first position
    int 21h         ;do it 
    mov Dl,010      ;new line
    int 21h         ;do it
    ret             ;return 
;---------------------------------------
proc test_input      ;checking range
   ;check num<25
   mov bx, 25 ;bigger number of range
   cmp cx, bx  ;calling scan_num puts number in cx so that it's being compared
   JG  greater ;if input is bigger, go to greater
   
   ;check num>0
   mov bx, 0
   cmp cx, bx
   JLE  correct
    
    
   
correct:
   lea dx, correctmsg
   mov ah, 09h
   int 21h
   ret
greater:

   ja error
   ret  
  
    
;---------------------------------------
proc fibonaci2              ;print ---fibonaci series--- 
    call new_line           ;call function to cout<<'\n'
    lea dx,fibonaci_message ;the address of the message we wanna print stored in dx
    mov ah,9h               ;intialize prining
    int 21h                 ;do it
    ret           
;---------------------------------------
proc print_comma    ;for prinig ','
    mov ah,2h       ;intialize for prining 
    mov Dl,44       ;the comma in ascii table          
    int 21h         ;do it 
    ret 
;---------------------------------------
proc gen_fibo       ;generate fibonaci
    pop bp          ;save return address
    pop ax          ;take past element
    pop bx          ;take past past element 
    push ax         ;store past element               
    add bx,ax       ;the new number in fibonaci
    push bx         ;store it
    push bp         ;restore return address
    ret   
;--------------------------------------- 
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
     ret
;---------------------------------------
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
    ret          
     
         
   DEFINE_SCAN_NUM  ;defination to call scan_num that we used
 
   END