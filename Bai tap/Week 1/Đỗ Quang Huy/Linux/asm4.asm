section .data
	msg1 DD "Nhap so thu nhat: "
	len1 equ $ - msg1
	msg2 DD "Nhap so thu hai: "
	len2 equ $ - msg2
	msg3 DD "Tong cua hai so la: "
	len3 equ $ - msg3
section .bss
	num1 resb 32
	num2 resb 32
	result resb 32
section .text
	global _start
_start:
	mov rax, 1
	mov rdi, 1
	mov rsi, msg1
	mov rdx, len1
	syscall

	mov rax, 0
	mov rdi, 1
	mov rsi, num1
	mov rdx, 32
	syscall

	mov rax, 1
	mov rdi, 1
	mov rsi, msg2
	mov rdx, len2
	syscall

	mov rax, 0
	mov rdi, 1
	mov rsi, num2
	mov rdx, 32
	syscall

	mov rax, 1
	mov rdi, 1
	mov rsi, msg3
	mov rdx, len3
	syscall

	mov rcx, num1
	mov rbx, 0
	call _atoi
	push rbx

	mov rcx, num2
	mov rbx, 0
	call _atoi
	push rbx

	pop rax
	pop rbx
	add rax, rbx
	push 0
	jmp _getResult
_atoi:
	;using the number store in rcx
	;store result in rbx
	xor rax, rax
	mov al, BYTE [rcx]
	cmp al, 10
	jne _atoi_iterate
	ret

_atoi_iterate:
	sub al, '0'
	imul rbx, 10
	add rbx, rax
	inc rcx
	jmp _atoi

_printResult:
	mov al, [rsp]
	cmp al, 0x0
	je _finish
	mov rax, 1
	mov rdi, 1
	mov rsi, rsp
	mov rdx, 1
	syscall
	pop rsi
	jmp _printResult
_getResult:
	mov rcx, 10
	mov rdx, 0
	div rcx
	add rdx, '0'
	push rdx
	cmp rax, 0
	je _printResult
	jmp _getResult
_finish:
	mov rax, 60
	mov rdi, 0
	syscall
