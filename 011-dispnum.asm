  org 0x0100

start:
  mov ax, 123
  call display_num

  int 0x20

%include "lib-io2.asm"
