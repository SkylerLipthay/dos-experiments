  org 0x0100

start:
  mov al, 0x04      ; Start with 4.
  add al, 0x03      ; Add 3.
  add al, 0x30      ; `0x30` is ASCII for `0`. `0x37` is ASCII for `7`.
  call display_char ; Display `7`!

  int 0x20

%include "lib-io1.asm"
