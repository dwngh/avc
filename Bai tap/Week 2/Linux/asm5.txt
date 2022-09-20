section .data
    str_s DB 100 dup(0)
    str_c DB 10 dup(0)
    str_s_i DB 0
    str_c_i DB 0
    str_s_len DB 0
    str_c_len DB 0
    result_count DB 0
    result_pos DB 100 dup(-1)
    result_iter DB 0
    itoa_n DB 0
    itoa_i DB 0
    chr_newline DB 10
    chr_separator DB " "
section .text
    global _start:
_start:
    mov rax, 0
    mov rdi, 1
    mov rsi, str_s
    mov rdx, 100
    syscall
    mov rsi, str_s
    call _lengthof
    mov [str_s_len], cl

    mov rax, 0
    mov rdi, 1
    mov rsi, str_c
    mov rdx, 10
    syscall
    mov rsi, str_c
    call _lengthof
    mov [str_c_len], cl

    call _substr_main
    call _result_print
    jmp _finish

; Input function
; Store value to rbx
_input:
    mov rax, 0
    mov rdi, 1
    mov rsi, rbx
    mov rdx, 32
    syscall
    ret

; LENGTHOF function
; Count the length of string stored in rsi
; Return value rcx
_lengthof:
    mov rcx, 0
    jmp _lengthof_count
    _lengthof_count:
        movzx rdx, BYTE rsi[rcx]
        cmp dl, 0xa
        jg _lengthof_next
        ret
    _lengthof_next:
        inc rcx
        jmp _lengthof_count

; Substring prototype
;--------------------------------------------------------------------
; Comparing two char
; Return value in rdx
_substr_compare:
    mov rcx, str_c
    movzx rdx, BYTE [str_c_i]
    movzx rbx, BYTE rcx[rdx]
    mov rcx, str_s
    movzx rdx, BYTE [str_s_i]
    movzx rax, BYTE rcx[rdx]
    cmp rax, rbx
    je _substr_compare_equal
    mov rdx, 0
    ret
_substr_compare_equal:
    mov rdx, 1
    ret

; Next char when iterate S
; If it exceeded its length, the rdx will set to 1. 0 Otherwise
_substr_next:
    movzx rax, BYTE [str_s_i]
    movzx rbx, BYTE [str_s_len]
    inc rax
    mov [str_s_i], al
    cmp rax, rbx
    jge _substr_next_exceed
    mov rdx, 0
    ret
_substr_next_exceed:
    mov rdx, 1
    ret

; Next char when iterate C
; If it exceeded its length, the rdx will set to 1. 0 Otherwise.
; And also C index will become 0
_substr_sub_next:
    movzx rax, BYTE [str_c_i]
    movzx rbx, BYTE [str_c_len]
    inc rax
    mov [str_c_i], al
    cmp rax, rbx
    jge _substr_sub_next_exceed
    mov rdx, 0
    ret
_substr_sub_next_exceed:
    mov rdx, 1
    mov rax, 0
    mov [str_c_i], al
    ret

; Store value when it suited.
; Incease result_count and push current pos to result_pos
_substr_store:
    movzx rbx, BYTE [str_s_i]
    movzx rax, BYTE [str_c_len]
    sub rbx, rax
    inc rbx
    call _result_push
    ret

_substr_main:
    call _substr_compare
    cmp rdx, 1
    je _substr_main_equal
    jmp _substr_main_next
_substr_main_equal:
    call _substr_sub_next
    cmp rdx, 1
    je _substr_compare_equal_store
    jmp _substr_main_next
_substr_compare_equal_store:
    call _substr_store
    jmp _substr_main_next
_substr_main_next:
    call _substr_next
    cmp rdx, 1
    je _substr_end
    jmp _substr_main
_substr_end:
    ret
;--------------------------------------------------------------------
; Result related prototype

; Push a pos into the result
; It will also increase the count var
; The pos's get at rbx
_result_push:
    movzx rax, BYTE [result_count]
    mov result_pos[rax], bl
    inc rax
    mov [result_count], al
    ret

_result_print:
    movzx rax, BYTE [result_count]
    call _itoa
    call _itoa_print

    mov rax, 1
	mov rdi, 1
	mov rsi, chr_newline
	mov rdx, 1
	syscall

    mov rax, 0
    mov [result_iter], al
    jmp _result_print_loop

_result_print_loop:
    movzx rbx, BYTE [result_iter]
    movzx rax, BYTE result_pos[rbx]
    call _itoa
    call _itoa_print
    mov rax, 1
	mov rdi, 1
	mov rsi, chr_separator
	mov rdx, 1
	syscall
    movzx rbx, BYTE [result_iter]
    inc rbx
    mov [result_iter], bl
    movzx rax, BYTE [result_count]
    cmp rbx, rax
    jl _result_print_loop
    ret
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
	mov str_s[rbx], dl

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
	mov rsi, str_s
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
	ret

;----------------------------------------------------
_finish:
    mov rax, 60
    mov rdi, 0
    syscall