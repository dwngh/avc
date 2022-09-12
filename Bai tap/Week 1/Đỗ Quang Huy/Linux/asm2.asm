section .data
	msg1 DB "Nhap xau: "
section .bss
	str1 resb 32
section .text
	global _start
_start:
	mov eax, 1
	mov edi, 1
	mov esi, msg1
	mov edx, 10
	syscall

	mov eax, 0
	mov edi, 1,
	mov esi, str1
	mov edx, 32
	syscall

	mov eax, 1
	mov edi, 1
	mov esi, str1
	mov edx, 32
	syscall

	mov eax, 60
	mov edi, 0
	syscall