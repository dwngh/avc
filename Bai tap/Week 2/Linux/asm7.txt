section .data
	msg DB "Nhap N: "
	n DB 0
	n_str DB 32 dup(0)
	itoa_n DB 0
	itoa_i DB 0
	itoa_ln DB 10
	fib1 DB 0
	fib2 DB 1
	fibc DB 1
section .text
	global _start
_start:
	mov rax, 1
	mov rdi, 1
	mov rsi, msg
	mov rdx, 8
	syscall

	mov rax, 0
	mov rdi, 1
	mov rsi, n_str
	mov rdx, 32
	syscall

	mov rbx, n_str
	call _atoi

	movzx rax, BYTE [n]
	cmp rax, 0
	je _finish 
	call _fib
	jmp _finish

;------------------------------------------------------------------
_atoi:
	movzx rax, BYTE [rbx]
	cmp rax, 10
	jne _atoi_iterate
	ret

_atoi_iterate:
	sub rax, '0'
	movzx rcx, BYTE [n]
	imul rcx, 10
	add rcx, rax
	mov [n], cl
	inc rbx
	jmp _atoi


;-----------------------------------------------------------------
_itoa:
	call _itoa_init
	jmp _itoa_loop

_itoa_loop:
	movzx rax, BYTE [itoa_n]
	mov rdx, 0
	mov rcx, 10
	div rcx
	add rdx, '0'
	movzx rbx, BYTE [itoa_i]
	mov n_str[rbx], dl

	inc rbx
	mov [itoa_n], al
	mov [itoa_i], bl

	cmp rax, 0
	jne _itoa_loop
	sub rbx, 1
	mov [itoa_i], bl
	ret

_itoa_init:
	mov [itoa_n], al
	mov al, 0
	mov [itoa_i], al
	ret

_itoa_print:
	movzx rcx, BYTE [itoa_i]
	mov rsi, n_str
	add rsi, rcx

	mov rax, 1
	mov rdi, 1
	mov rdx, 1
	syscall

	movzx rcx, BYTE [itoa_i]
	sub rcx, 1
	mov [itoa_i], cl
	cmp rcx, 0
	jge _itoa_print
	
	mov rax, 1
	mov rdi, 1
	mov rsi, itoa_ln
	mov rdx, 1
	syscall
	ret
;-----------------------------------------------------------------
_fib_print:
	movzx rax, BYTE [fib2]
	call _itoa
	call _itoa_print
	ret
_fib_next:
	movzx rax, BYTE [fib1]
	movzx rbx, BYTE [fib2]
	xchg rax, rbx
	add rbx, rax
	mov [fib1], al
	mov [fib2], bl
	movzx rax, BYTE [fibc]
	inc rax
	mov [fibc], al
	jmp _fib

_fib:
	call _fib_print
	movzx rax, BYTE [n]
	movzx rbx, BYTE [fibc]
	cmp rax, rbx
	ja _fib_next
	ret
;-----------------------------------------------------------------
_finish:
	mov rax, 60
	mov rdi, 0
	syscall