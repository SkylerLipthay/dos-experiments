  org 0x0100

start:
  mov al, 0x32
  and al, 0x0f
  add al, 0x30
  call display_char

  int 0x20

%include "lib-io1.asm"
