  org 0x0100

start:
  mov al, 0x30

up:
  call display_char
  inc al
  cmp al, 0x39      ; `cmp` is the same as `sub` except it doesn't alter `al`.
  jne up

down:
  call display_char
  dec al
  cmp al, 0x30
  jne down

  int 0x20

%include "lib-io1.asm"
