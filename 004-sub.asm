  org 0x0100

start:
  mov al, 0x04
  sub al, 0x03
  add al, 0x30
  call display_char

  int 0x20

%include "lib-io1.asm"
