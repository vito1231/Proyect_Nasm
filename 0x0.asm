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
binario 	   resb  50
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
process_char:
	 xor	 DL,DL
     mov     DL,[EBX]       ; move the char. to AL
     cmp     DL,0           ; if it is the NULL character
     je      done           ; conversion done
     call 	 binario
     
nextj:
	 PutCh	 byte[EBX]
     inc	 EBX
     nwln
     jmp	 process_char
done:      
	  .EXIT	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

binarioe:
	push	EBX
	xor	 	CX,CX
    mov 	CX,8
rotate:
	shl	DL,1
	jc	print_1
	mov	ebx, 30H
	mov [binario+eax],ebx
	PutCh	'0'
	jmp	skip

print_1:
	mov	ebx, 31H
	mov [binario+eax],ebx
	PutCh	'1'

skip:
	inc	 	eax
	loop	rotate
	pop	 	EBX
	ret
	
