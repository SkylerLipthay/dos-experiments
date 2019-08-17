; Displays the ASCII character contained in `al`.
display_char:
  push ax
  push bx
  push cx
  push dx
  push si
  push di
  mov ah, 0x0e
  mov bx, 0x000f
  int 0x10
  pop di
  pop si
  pop dx
  pop cx
  pop bx
  pop ax
  ret

; Reads from the keyboard an ASCII character into `al`.
read_char:
  push bx
  push cx
  push dx
  push si
  push di
  mov ah, 0x00
  int 0x16
  pop di
  pop si
  pop dx
  pop cx
  pop bx
  ret

; Displays the value of `ax` as a decimal number.
display_num:
  mov dx, 0
  mov cx, 10
  div cx              ; `ax = ax / cx`; `dx = ax % cx`.
  push dx             ; Push the remainder, recursively.
  cmp ax, 0
  je display_num_rem  ; If `ax` is zero, end the recursion.
  call display_num
display_num_rem:
  pop ax
  add al, '0'
  call display_char
  ret
