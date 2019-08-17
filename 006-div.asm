  org 0x0100

start:
  mov ax, 0x64      ; 100
  mov cl, 0x21      ; 33
  div cl            ; Divide 100 by 33 into `al` (result) and `ah` (remainder).
  add al, 0x30
  call display_char ; The result is 3.
  mov al, ah
  add al, 0x30
  call display_char ; The remainder is 1.

  int 0x20

%include "lib-io1.asm"
