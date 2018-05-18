segment .text
global test1
test1:
	enter 0,0
	mov EAX,[EBP+8]
	add EAX,[EBP+12]
	sub EAX,[EBP+16]
	leave
	ret




