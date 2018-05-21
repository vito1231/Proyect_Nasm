;Hex equivalent of characters              HEX1CHAR.ASM
;
;        Objective: To print the hex equivalent of
;                   ASCII character code.
;            Input: Requests a character from the user.
;           Output: Prints the ASCII code of the
;                   input character in hex.
%include "io.mac"
	
.DATA
char_prompt    db  "Please input a character: ",0
out_msg1      db  "The ASCII code of '",0
out_msg2       db  "' in hex is ",0
query_msg      db  "Do you want to quit (Y/N): ",0

.CODE
     .STARTUP
read_char:
     PutStr  char_prompt  ; request a char. input
     GetCh   AH          ; read input character
     PutStr  out_msg1
     PutCh   AH
     PutStr  out_msg2
	
print_Digit:
	 
	 
done:
     .EXIT
