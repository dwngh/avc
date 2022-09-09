include \masm32\include\masm32rt.inc

.data
    st1 DB "Nhap xau: ",0
    st2 DB "Xau vua nhap: ", 0
    st3 DB ?

.code
main:
    print OFFSET st1
    mov st3, input()
    print OFFSET st2
    print st3
    exit
 end main
        