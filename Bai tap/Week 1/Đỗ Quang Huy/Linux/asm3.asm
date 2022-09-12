section .data
	prompt1 DB "Nhap xau: "
section .bss
	str1 resb 32
section .text
	global _start
_start:
	mov rax, 1
	mov rdi, 1
	mov rsi, prompt1
	mov rdx, 10
	syscall

	mov rax, 0
	mov rdi, 1
	mov rsi, str1
	mov rdx, 32
	syscall

	mov rbx, str1
	mov ecx, 0
	jmp _iterate

_printChar:
	mov rax, 1
	mov rdi, 1
	mov rsi, rbx
	mov rdx, 1
	syscall
	jmp _nextChar
_upcase:
	mov ax, [rbx]

	cmp al, 0x7B		; ky tu {
	ja _printChar

	sub ax, 0x20  
	mov [rbx], ax
	jmp _printChar
_iterate:
	mov al, BYTE [rbx]
	cmp al, 0x0
	je _finish

	cmp al, 0x60	; ky tu 'a'
	ja _upcase
  	jmp _printChar

_nextChar:
	inc rbx
	jmp _iterate

_finish:
	mov rax, 60
	mov rdi, 0
	syscall