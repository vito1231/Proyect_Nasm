%include "io.mac"
	
.DATA
name_prompt    db  "Enter string: ",0
out_msg        db  "bin  ",0
hexa		   db  " hex  ",0
chari		   db  "  of char: ",0
espaciosp	   db  " sp ",0
newline	 	   db  " nwln ",0
file_name      db  "archivo.txt",0
nom_HEX		   db  "Hex",0
nom_BIN		   db  "BIN",0
nom_UTF	 	   db  "UTF-8",0
spacio		   db  " ",0
pregUtf		   db  "UTF-8-> 3",0
pregHEX		   db  "HEX-> 2",0
pregBIN		   db  "BIN-> 1",0
MENUS		   db  "MENU",0
pregUsu		   db  "Cual desea desplegar:",0
salirp		   db  "SALIR -> 4",0
error		   db  "ESE NO ES UN NUMERO VALIDO!",0


.UDATA
in_name        resb  31
letra 		   resb  31
binario 	   resb  300

octal		   resb  50
utf			   resb  50
hexadec		   resb  300
fd_out		   resb 1
fd_in	       resb 1
info		   resb  100


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
   mov edx, 50
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
     je      result           ; conversion done
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
nuevalinea1:
	 PutStr  newline
	 inc  ecx
	inc	 esi
	 jmp 	 imprUtf
	 
espacio1:
	 PutStr  espaciosp
	 inc  ecx
	inc	 esi
	 jmp 	 imprUtf
nuevalinea2:
	 PutStr  newline
	 inc  ecx
	inc	 esi
	 jmp 	 desplUTF
	 
espacio2:
	 PutStr  espaciosp
	 inc  ecx
	inc	 esi
	 jmp 	 desplUTF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
result:
	 mov	ebx,binario
	 mov	edx,hexadec
	 mov	ecx,info
	 xor	esi,esi
	 PutStr	nom_BIN
	 
	 mov ah, 09h
	 PutCh ah
	 PutCh ah
	 PutCh ah
	 PutCh ah
	 PutCh ah
	 
	 PutStr	nom_HEX
	 PutCh ah
	 PutCh ah
	 PutStr nom_UTF
	 
	 nwln
	 xor  esi,esi
	 jmp ciclo1
limpiacicl:
	nwln
	xor  esi,esi
ciclo1:
	mov	  al,[ebx]
	cmp	  al,0
	je 	  limpiarcx
	cmp	  esi,32
	je	  limpiarcx
	PutCh al
	inc	  esi
	inc	  ebx
	jmp	  ciclo1
     ;jmp	termina

limpiarcx:
	xor esi,esi
	mov ah, 09h
	 PutCh ah
	 
	 xor ax,ax
hexaimp:
	mov	  al,[edx]
	cmp	  al,0
	je	  limpi_UTF
	cmp	  esi,8
	je	  limpi_UTF
	PutCh al
	inc   esi
	inc	  edx
	jmp	  hexaimp

limpi_UTF:
	xor esi,esi
	mov ah, 09h
	PutCh ah
	xor ax,ax
	
imprUtf:
	mov	 al,[ecx]
	cmp	 al,0
	je	 menu
	cmp	 esi,4
	je	 limpiacicl
	cmp	 AL,20H
	je		 espacio1
	cmp 	 AL,0AH
	je	 	 nuevalinea1
	PutCh al
	inc  ecx
	inc	 esi
	jmp	 imprUtf

limBIN:
xor	esi,esi
xor	AX,AX
PutStr	nom_BIN
nwln
desplBIN:
	mov	  al,[ebx]
	cmp	  al,0
	je 	  menu
	cmp	  esi,32
	je	  nuevalineaB
	PutCh al
	inc	  esi
	inc	  ebx
	jmp	  desplBIN
nuevalineaB:
	xor	  esi,esi
	nwln
	jmp	  desplBIN
	
limHEX:
xor	esi,esi
xor	AX,AX
PutStr	nom_HEX
nwln

desplHEX:
	mov	  al,[edx]
	cmp	  al,0
	je	  menu
	cmp	  esi,8
	je	  nuevalineaH
	PutCh al
	inc   esi
	inc	  edx
	jmp	  desplHEX
	
nuevalineaH:
	xor	  esi,esi
	nwln
	jmp	  desplHEX
	
limUTF:
	xor	esi,esi
	xor	AX,AX
	PutStr	nom_UTF
	nwln
desplUTF:	
	mov	 al,[ecx]
	cmp	 al,0
	je	 menu
	cmp	 esi,4
	je	 nuevalineaU
	cmp	 AL,20H
	je	 espacio2
	cmp  AL,0AH
	je	 nuevalinea2
	PutCh al
	inc  ecx
	inc	 esi
	jmp	 desplUTF
nuevalineaU:
	xor	  esi,esi
	nwln
	jmp	  desplUTF
menu:
	mov	ebx,binario
	mov	edx,hexadec
	mov	ecx,info	
	nwln
	nwln
	PutStr	MENUS
	nwln
	PutStr	pregBIN
	nwln
	PutStr	pregHEX
	nwln
	PutStr	pregUtf
	nwln
	PutStr	salirp
	nwln
	PutStr	pregUsu
	GetCh	AH
	nwln
	cmp	    ah,31h
	je		limBIN
	cmp	    ah,32h
	je		limHEX
	cmp	    ah,33h
	je		limUTF
	cmp		ah,34h
	je		termina
	nwln
	nwln
	nwln
	nwln
	PutStr  error
	nwln
	nwln
	nwln
	nwln
	jmp		menu
	
	

termina:
     .EXIT
