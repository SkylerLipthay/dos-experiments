; Loops a colorful sine wave display using the standard text video mode.

org 0x0100

start:
  mov ax, 0x0002
  int 0x10

  mov ax, 0xb800
  mov ds, ax
  mov es, ax
  mov bx, sin_table

main_loop:
  mov di, 0x0000
  mov ah, 0x00
  int 0x1a
  mov ch, 25
  mov dh, dl
one_row:
  mov dl, dh
  mov cl, 80
one_cell:
  and dl, 0x7f
  mov al, dl
  cs xlat
  push dx
  mov dl, al
  xor ax, ax
  inc dl
  cmp dl, ch
  jnz one_cell_blank
  mov ah, dl
  xor ah, dh
  and ah, 0x0f
  mov al, 0x07
one_cell_blank:
  stosw
  pop dx
  inc dl
  dec cl
  cmp cl, 0
  jne one_cell
  dec ch
  cmp ch, 0
  jne one_row

  mov ah, 0x01
  int 0x16
  jne exit
  jmp main_loop

exit:
  int 0x20

; 128-entry table of the values of 360 degrees of sine ranging from 0 to 24.
sin_table:
  db 12, 13, 13, 14, 14, 15, 15, 16, 17, 17, 18, 18, 19, 19, 20, 20
  db 20, 21, 21, 22, 22, 22, 23, 23, 23, 23, 23, 24, 24, 24, 24, 24
  db 24, 24, 24, 24, 24, 24, 23, 23, 23, 23, 23, 22, 22, 22, 21, 21
  db 20, 20, 20, 19, 19, 18, 18, 17, 17, 16, 15, 15, 14, 14, 13, 13
  db 12, 11, 11, 10, 10, 9, 9, 8, 7, 7, 6, 6, 5, 5, 4, 4
  db 4, 3, 3, 2, 2, 2, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0
  db 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 2, 2, 3, 3
  db 4, 4, 4, 5, 5, 6, 6, 7, 7, 8, 9, 9, 10, 10, 11, 11
