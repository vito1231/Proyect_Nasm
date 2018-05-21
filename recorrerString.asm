%include "io.mac"
	
.DATA
name_prompt    db  "Enter string: ",0
out_msg        db  "bin  ",0
hexa		   db  " hex  ",0
chari		   db  "  of char: ",0
espaciosp	   db  "sp",0
newline	 	   db  "nwln",0
file_name      db  "archivo.txt",0



.UDATA
in_name        resb  31
letra 		   resb  31
binario 	   resb  100

octal		   resb  50
utf			   resb  50
hexadec		   resb  50
fd_out		   resb 1
fd_in	       resb 1
info		   resb  26


.CODE
     .STARTUP
     
   mov eax, 5
   mov ebx, file_name
   mov ecx, 0             ;for read only access
   mov edx, 0777        ;read, write and execute by all
   int  0x80
   mov  [fd_in], eax
   ;read from file
   mov eax, 3
   mov ebx, [fd_in]
   mov ecx, info
   mov edx, 26
   int  0x80
   ; close the file
   mov eax, 6
   mov ebx, [fd_in]
   
   mov ebx, info  
   xor	edx,edx			;contis de binario
   xor 	ebp,ebp			;vamos a usar este como el digito a ingresar
   xor 	esi,esi			;contis de hexa
   xor 	esi,esi
   xor	ecx,ecx
   xor	eax,eax
process_char:
	xor		AL,AL
     mov     AL,[EBX]       ; move the char. to AL
     cmp     AL,0           ; if it is the NULL character
     je      done           ; conversion done
     PutStr  out_msg
     xor	 CX,CX
     mov 	 CX,8
     
     

rotate:
	shl	AL,1
	jc	print_1
	mov	dx, 30H
	mov [binario+ebp],dx
	PutCh	'0'
	jmp	skip

print_1:
	mov	edx, 31H
	mov [binario+ebp],edx
	PutCh	'1'

skip:
	inc	 	ebp
	loop	rotate
	PutStr  hexa
     
hex:    
	 xor	 AH,AH
	 xor	 AL,AL
	 xor	CX,CX
	 
	 ;mov 	 [hexadec],esi
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
	 
	 mov 	[hexadec+esi],AL
     PutCh   AL           ; write the first hex digit
     inc	 esi
     ;inc	 ESP
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
	 PutStr binario
     nwln
     PutStr hexadec
     .EXIT
