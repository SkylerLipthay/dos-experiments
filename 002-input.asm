  org 0x0100

start:
  mov ah, 0x00      ; Read key press.
  int 0x16          ; BIOS interrupt for keyboard services.

  cmp al, 0x1b      ; Escape key code.
  je end            ; If escape is pressed, exit the program.
  mov ah, 0x0e
  mov bx, 0x000f
  int 0x10
  jmp start

end:
  int 0x20
