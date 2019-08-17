  org 0x0100

start:
  mov al, 0x03
  mov cl, 0x02
  mul cl            ; Multiply `al` by `cl` into `ax`.
  add al, 0x30
  call display_char

  int 0x20

%include "lib-io1.asm"
