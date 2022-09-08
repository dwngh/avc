include \masm32\include\masm32rt.inc

.data
    a SDWORD ?
    b SDWORD ?
    tong SDWORD ?
.code

nhap proc
    print chr$("Nhap so thu nhat: ")
    mov a, sval(input())
    print chr$(13, 10)
    print chr$("Nhap so thu hai: ")
    mov b, sval(input())
    print chr$(13, 10)
    ret
nhap endp

tinh proc n1: SDWORD, n2:SDWORD
    mov eax, n1
    add eax, n2
    mov tong, eax
    ret
tinh endp

main:
    invoke nhap
    invoke tinh, a, b
    print chr$("Tong cua hai so la: ")
    print str$(tong)
    ret
end main