include \masm32\include\masm32rt.inc

.data
str1   db "This is a buffer"

.code
start:
    print chr$("Nhap xau: ")
    invoke StdIn, addr str1, sizeof str1
    mov ebx, OFFSET str1
    mov ecx, 0

charCheck:
    mov al, [ebx]
    cmp al, 0x60
    ja uppercase
    jmp nextChar

uppercase:
    mov al, [ebx]
    sub al, 0x20
    mov [ebx], al
    jmp nextChar

nextChar:
    inc ebx
    inc ecx
    mov al, [ebx]
    cmp al, 0x0
    je finish

    cmp ecx, 32
    jg finish
    jmp charCheck
finish:
    print OFFSET str1
    exit
end start