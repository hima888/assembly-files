;***********************************************************************
;Listing Contents:
;  Global Data
;    None
;  Functions/Procedures/Methods
;    fibLoop 
;    msg1
;    fibTerm
;***********************************************************************
org 100h    
    
    lea DX, first ;putting value of first message in dx - lea get its adress          
    mov AH, 09h  ;printing          
    int 21h      ;interrupt                                         
                            
    mov DL, 20h             
    mov AH, 02h             
    int 21h                          
 
    mov BH, 1
	mov DH, 1 
    mov CX, 9
    
;***********************************************************************
;Process:
;  Step 01 - Offset DL
;  Step 02 - Display
;  Step 03 - Save DX current state
;  Step 04 - AL = DL 
;  Step 05 - AH = DH
;  Step 06 - AH = AL 
;  Step 07 - BH = AH
;  Step 08 - Returns DX
;  Step 09 - Loop 
;*********************************************************************** 
		
    fibLoop:
		or DL, 30h
		mov AH, 02h
		int 21h
		mov DL, DH
		mov DH, BH
		    
		push DX
	        mov AL, DL
	        mov AH, DH
	        add AH, AL
	        mov BH, AH 
	    pop DX
	loop fibLoop
		
	ret

;veriable of first message
first db "     FIBONACCI FIRST 5 TERMS      $" ;dolar sign becouse i used int21h/ah=9
