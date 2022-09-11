include \masm32\include\masm32rt.inc

.data
buffer   db "This is a buffer"
   db 0

.code
start:
   print chr$("Nhap xau: ")
   invoke StdIn, addr buffer, sizeof buffer
   print chr$("Xau vua nhap: ")
   print offset buffer, 13, 10
   exit

end start