section .data
	str1 DD "Hello, World!", 10
section .text
	global _start
_start:
	mov eax, 1
	mov edi, 1
	mov esi, str1
	mov edx, 15
	syscall

	mov eax, 80
	mov edi, 0
	syscall