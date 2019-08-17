; A guessing game for numbers 0 through 7.

  org 0x0100

start:
  in al, 0x40       ; Read the timer counter to get a psuedo-random number.
  and al, 0x07
  add al, 0x30
  mov cl, al

game_loop:
  mov al, '?'
  call display_char
  call read_char
  cmp al, cl
  jne game_loop     ; The guess was not correct.
  call display_char
  mov al, '!'
  call display_char

  int 0x20

%include "lib-io1.asm"
