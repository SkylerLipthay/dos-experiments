  org 0x0100        ; The first 256 bytes of program memory in DOS are reserved
                    ; for information about the program (command line arguments,
                    ; etc.). So, we use the `org` pseudo-operator to tell DOS to
                    ; tell the assembler to add the offset `0x0100` to all
                    ; absolute addresses mentioned in the program.

start:
  mov bx, string

repeat:
  mov al, [bx]      ; Load character for `int 0x10`.
  test al, al       ; Performs a bitwise AND on the two operands. This is like
                    ; the `and` operator, except the operand (`al` here) isn't
                    ; altered. What's important to us here is that it sets `zf`
                    ; to `1` if `al` is `0`.
  je end            ; Exit loop if `zf` is `1`.
  push bx
  mov ah, 0x0e      ; Teletype output.
  mov bx, 0x0010    ; Page 0, color white.
  int 0x10          ; BIOS interrupt for video services.
  pop bx
  inc bx            ; Move to the next character.
  jmp repeat

end:
  int 0x20          ; Exit to command line.

string:
  db "Hello, World!", 0
