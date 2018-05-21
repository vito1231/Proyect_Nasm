%include "io.mac"
.DATA
file_name db "archivo.txt",0
out_msg	  db  "caca ",0
.UDATA
fd_out resb 1
fd_in  resb 1
info resb  26

.CODE
	.STARTUP
;open the file for reading
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
  ; print the info 
  
   mov ebx, info
   mov eax, info
recorrer:
   mov     AL,[EBX]       ; move the char. to AL
   cmp     AL,0           ; if it is the NULL character
   je      done           ; conversion done
   PutStr  out_msg
   inc 	   EBX
   jmp	   recorrer
done:
	nwln
	PutStr eax

  .EXIT
