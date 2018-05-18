%include "io.mac"
	
.DATA
name_prompt    db  "Enter string: ",0
out_msg        db  "bin  ",0
hexa		   db  " hex  ",0
chari		   db  "  of char: ",0
espaciosp	   db  "sp",0
newline	 	   db  "nwln",0

.UDATA
in_name        resb  31
letra 		   resb  31
binario 	   resb  100
hexadec		   resb  100
octal		   resb  100
utf			   resb  100

.CODE
     .STARTUP
     PutStr  name_prompt    ; request character string
     GetStr  in_name,31     ; read input character string
	 
     xor 	 EDX,EDX
     mov     EBX,in_name    ; EBX = pointer to in_name
     xor	 EDX,EDX
     

process_char:
     mov     AL,[EBX]       ; move the char. to AL
     cmp     AL,0           ; if it is the NULL character
     je      done           ; conversion done
     PutStr  out_msg
     sub	 CX,CX
     mov 	 CX,8
     
     

rotate:
	shl	AL,1
	jc	print_1
		
	PutCh	'0'
	jmp	skip

print_1:
	PutCh	'1'

skip:
	loop	rotate
	PutStr  hexa
     
hex:     
	 mov     AL,[EBX] 
     mov     AH,AL        ; save input character in AH
     shr     AL,4         ; move upper 4 bits to lower half
     mov     CX,2         ; loop count - 2 hex digits to print
print_digit:
     cmp     AL,9         ; if greater than 9
     jg      A_to_F       ; convert to A through F digits
     add     AL,'0'       ; otherwise, convert to 0 through 9
     jmp     ski
A_to_F:
     add     AL,'A'-10    ; subtract 10 and add 'A'
                          ; to convert to A through F
ski:
	 
     PutCh   AL           ; write the first hex digit
     mov     AL,AH        ; restore input character in AL
     and     AL,0FH       ; mask off the upper half-byte
     
     loop    print_digit

next:
	 PutStr  chari
	 mov	 AL,[EBX]
	 cmp	 AL,20H
	 je		 espacio
	 cmp 	 AL,0AH
	 je	 	 nuevalinea
	 
	 
nextj:
	 PutCh	 byte[EBX]
     inc	 EBX
    
     nwln
     jmp	 process_char
    
     
         
nuevalinea:
	 PutStr  newline
	 jmp 	 nextj 
	 
espacio:
	 PutStr  espaciosp
	 jmp 	 nextj
done:     
	 PutStr newline
     nwln
     .EXIT
