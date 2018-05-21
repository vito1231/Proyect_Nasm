
%include "io.mac"
.DATA
cont db 1
file_name db 'archivo.txt',0
bin       db  "bin-->  ",0
hexa	  db  " hex-->  ",0
utf8	  db  " UTF-8-->  ",0
oct       db  " oct-->  ",0
caracespacio db  "sp",0
newline  db  "nwln",0
lineas  db  "---------------------",0
.UDATA
fd_out resb 1
fd_in  resb 1
info resb  2048
to_print resb 2048
in_name        resb  31
letra 		   resb  31
binario 	   resb  50

octal		   resb  50
utf			   resb  50
hexadec		   resb  50

;--------------- inicio de abrir y guardar archivo--------------------
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
   mov edx, 50
   int  0x80
   ; close the file
   mov eax, 6
   mov ebx, [fd_in]
   
   mov ebx, info  
   ;--------------------------------fin de la apertura de archivos
   xor	edx,edx			;contis de binario
   xor 	ebp,ebp			;vamos a usar este como el digito a ingresar
   xor 	esi,esi			;contis de hexa
   
   xor	ecx,ecx
   xor	eax,eax
   ;----------------limpia de registros
process_char:
	xor		AL,AL
     mov     AL,[EBX]       ; move the char. to AL
     cmp     AL,0           ; if it is the NULL character
     je      done           ; conversion done
     ;-----------------------empieza con el bin
     PutStr  bin
     xor	 CX,CX
     mov 	 CX,8
     
     

putbin:
	shl	AL,1
	jc	print_1
	PutCh	'0'
	jmp	skip

print_1:
	PutCh	'1'

skip:
	loop	putbin
	;--------------------termina con el bin
	xor	edx,edx			;contis de binario
	xor ebp,ebp			;vamos a usar este como el digito a ingresar
	xor esi,esi			;contis de hexa
   
	xor	ecx,ecx
	xor	eax,eax
	xor	 AH,AH
	xor	 AL,AL
	xor	CX,CX
	;---------------------inicio con el oct
	PutStr oct
	mov     CX,8
	 mov     esi,[EBX] 

     mov     AH,0      
	rcr esi,6
	mov AL,1
altobajoomedio:
	cmp CX,6
	jg  bajooct
	je imprimebajooct
	cmp CX,3
	jg mediooct
	je imprimemediooct
	jmp altooct
bajooct:
	rcr	esi,1
	jc	es1oct
	add AL,AL

	jmp loopoct
	 	
es1oct:
	add AH,AL	
	add AL,AL
	jmp loopoct
imprimebajooct:

     add     AH,'0'   
     jmp     Putoct
	
Putoct:
	mov  esi,[EBX]
	rcr esi,3
	
	PutCh AH
	mov AL,1
	mov AH,0
mediooct:
	rcr	esi,1
	jc	es1oct
	add AL,AL
	jmp loopoct
imprimemediooct:

     add     AH,'0'   
     jmp     Putoct2

Putoct2:
mov  esi,[EBX]
	
	PutCh AH
	mov AL,1
	mov AH,0
altooct:	
	shr	esi,1
	jc	es1oct
	add AL,AL
	jmp loopoct
loopoct:
	loop altobajoomedio
imprimeoctbajo:

     add     AH,'0'       ; otherwise, convert to 0 through 9

Putoct3:
	PutCh AH
	
	
	;-------------------inicia con el hexa
		PutStr  hexa

	;-------------------limpia de registros

limpia_hex:
	xor	edx,edx			;contis de binario
	xor ebp,ebp			;vamos a usar este como el digito a ingresar
	xor esi,esi			;contis de hexa
   
	xor	ecx,ecx
	xor	eax,eax
	xor	 AH,AH
	xor	 AL,AL
	xor	CX,CX

     ;-------------------------------------
Puthex:    
     mov     CX,8
	 mov     esi,[EBX] 
	 rcr   esi,4

     mov     AH,0        ; save input character in AH
     ;shr     esi,4
			; move upper 4 bits to lower half
			; loop count - 2 hex digits to print
	mov AL,1

altoobajo:
	cmp CX,4
	jg  altohex
	je imprimehex
	jmp bajohex
altohex:
	shr	esi,1
	jc	es1hex
	add AL,AL

	jmp loophex
	 	
es1hex:
	add AH,AL	
	add AL,AL
	jmp loophex
imprimehex:
	 cmp     AH,9         ; if greater than 9
     jg      A_to_F       ; convert to A through F digits
     add     AH,'0'   
     jmp     PutHex
A_to_F:
     add     AH,'A'-10    ; subtract 10 and add 'A'
                          ; to convert to A through F
PutHex:
	mov     esi,[EBX]
	PutCh AH
	mov AL,1
	mov AH,0
bajohex:
shr	esi,1
	jc	es1hexbajo
	add AL,AL
	jmp loophex
	 	
es1hexbajo:
	add AH,AL

	add AL,AL
	jmp loophex


loophex:
	loop altoobajo
imprimehexbajo:
	 cmp     AH,9         ; if greater than 9
     jg      A_to_Fbajo      ; convert to A through F digits
     add     AH,'0'       ; otherwise, convert to 0 through 9
     jmp     PutHexbajo
A_to_Fbajo:
     add     AH,'A'-10    ; subtract 10 and add 'A'
                          ; to convert to A through F
PutHexbajo:
	PutCh AH
	
;------------------------------------------- fin del hexa
;------------------------------------------- incio del utf-8

next:
	 PutStr  utf8
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
	 PutStr  caracespacio
	 jmp 	 nextj
done:     
	 PutStr lineas
	 nwln
     .EXIT
