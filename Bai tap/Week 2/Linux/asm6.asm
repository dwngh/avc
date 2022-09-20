section .data
	msg1 DB "Nhap xau: "
section .bss
	str1 resb 32
section .text
	global _start
_start:
	mov rax, 1
	mov rdi, 1
	mov rsi, msg1
	mov rdx, 10
	syscall

	mov rax, 0
	mov rdi, 1
	mov rsi, str1
	mov rdx, 32
	syscall

	xor rax, rax
	mov rbx, str1
	jmp _append_to_stack

	mov rbx, str1
	jmp _get_from_stack

_append_to_stack:
	mov al, BYTE [rbx]
	cmp al, 0x0
	jne _append
	mov rbx, str1
	jmp _get_from_stack
_append:
	push rax
	inc rbx
	jmp _append_to_stack

_get_from_stack:
	pop rax
	cmp al, 0x10
	jne _store_value
	jmp _print

_store_value:
	mov [rbx], al
	inc rbx
	mov al, [rbx]
	cmp al, 0x0
	jne _get_from_stack
	jmp _print
_print:
	mov eax, 1
	mov edi, 1
	mov esi, str1
	mov edx, 32
	syscall

	mov rax, 60
	mov rdi, 0
	syscall