section .data
    prompt DB "Nhap so: "
    inp DB 32 dup(0)
    inp2 DB 32 dup(0)
    num1 DB 32 dup(0)
    num2 DB 32 dup(0)
    sum DB 32 dup(0)
    sumof_counter DB 0
    sumof_remainder DB 0
    tests DB "this"
    newline DB 10
section .text
    global _start
_start:
    ; Nhap 2 so
    mov rbx, inp
    call _input
    mov rsi, inp
    mov rbx, num1
    call _reverse

    mov rbx, inp
    call _input
    mov rsi, inp
    mov rbx, num2
    call _reverse

    mov rbx, sum
    call _sumof

    mov rsi, sum
    mov rbx, inp
    call _reverse
    
    mov rdx, 0  ;flag
    mov rcx, 0
    mov [sumof_counter], cl
    call _printSum

    jmp _finish


; Input Function
; Move inputting variable to rbx
_input:
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt
    mov rdx, 9
    syscall

    mov rax, 0
    mov rdi, 1
    mov rsi, rbx
    mov rdx, 32
    syscall
    ret
; Output sum
_printSum:
    movzx rcx, BYTE [sumof_counter]
    cmp rcx, 32
    jl _print
    ret

_print:
    movzx rax, BYTE rbx[rcx]
    sub rax, '0'
    add rax, rdx
    cmp rax, 0
    jne _printSumStart
    inc rcx
    mov [sumof_counter], cl
    jmp _printSum

_printSumStart:
    mov rdx, 1
    mov rsi, rbx
    add rsi, rcx

    mov rax, 1
    mov rdi, 1
    mov rdx, 1
    syscall

    movzx rcx, BYTE [sumof_counter]
    inc rcx
    mov [sumof_counter], cl
    jmp _printSum

; LENGTHOF function
; Count the length of string stored in rsi
; Return value rcx
_lengthof:
    mov rcx, 0
    jmp _lengthof_count
    _lengthof_count:
        cmp rcx, 32
        jge _lengthof_exceed
        movzx rdx, BYTE rsi[rcx]
        cmp dl, 0xa
        jg _lengthof_next
        ret
    _lengthof_next:
        inc rcx
        jmp _lengthof_count
    _lengthof_exceed:
        ret
; REVERSE function
; Reverse the string stored in rsi
; The new string are in rbx
_reverse:
    call _lengthof
;    mov rbx, inp
    sub rcx, 1
    mov rax, 0
    jmp _reverse_loop
    _reverse_loop:
        cmp rcx, 0
        jl _reverse_end
        movzx rdx, BYTE rsi[rcx]
        mov rbx[rax], dl
        sub rcx, 1
        inc rax
        jmp _reverse_loop
    _reverse_end:
        ret

; SUMOF function
; Calculate the sum of reversed number in num1 and num2
; Result stored in rbx
_sumof:
    mov rax, 0
    mov [sumof_counter], al      ; Remainder
    mov [sumof_remainder], al    ; Counter
    jmp _sumof_loop
    _sumof_loop:
        call _sumof_cal
        call _sumof_inc
        cmp rax, 32
        jl _sumof_loop
        ret
        ;=-------------------------------------------?>

    _sumof_inc:
        movzx rax, BYTE [sumof_counter]
        inc rax
        mov [sumof_counter], al
        ret
    _sumof_pre_cal:    ; rdx
        movzx rax, BYTE rdx[rcx]
        cmp al, '0'
        jl _sumof_setToZero
        ret 
    _sumof_setToZero:
        mov rax, '0'
        mov rdx[rcx], al
        ret
    _sumof_cal:
        movzx rcx, BYTE[sumof_counter]
        mov rdx, num1
        call _sumof_pre_cal
        mov rdx, num2
        call _sumof_pre_cal

        movzx rax, BYTE num1[rcx]
        add al, BYTE num2[rcx]
        add al, BYTE [sumof_remainder]
        sub rax, '0'
        cmp rax, '9'
        jg _sumof_remain
        jmp _sumof_noremain
    _sumof_remain:
        mov BYTE [sumof_remainder], 1
        sub rax, 10
        jmp _sumof_store
    _sumof_noremain:
        mov BYTE [sumof_remainder], 0
        jmp _sumof_store
    _sumof_store:
        mov rbx[rcx], al
        ret

_finish:
    mov rax, 60
    mov rdi, 0
    syscall