.model small

.stack 100h
.data
    tb1 db "Nhap xau: $"
    tb2 db "Xau vua nhap $"
    string db ?
.code

nhapxau proc
    ;write your code here
nhapxau endp

main:
    mov ax, @data
    INVOKE nhapxau
end main
