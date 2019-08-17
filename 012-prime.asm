; This is an implementation of the Sieve of Erathosthenes, a very simple method
; for finding prime numbers.
;
; I'm trying a new style of code formatting here that fits my personal taste. No
; more comments trailing after operations.

org 0x0100

; Put the seive table at memory address 0x8000:
table: equ 0x8000
; Calculate primes from 0 to 999:
table_size: equ 1000

start:
  mov bx, table
  mov cx, table_size
  mov al, 0

p1:
  ; Fill `table` with zeroes:
  mov [bx], al
  inc bx
  ; Jumps back to `p1` and decrement `cx` until `cx` is 0:
  loop p1

  ; Start at number (we know 0 and 1 aren't considered prime. So really, the
  ; first two bytes of the `table` are a waste of space.
  mov ax, 2

p2:
  mov bx, table
  add bx, ax
  ; This is marked as `cmp byte` because `cmp [bx]` would grab; the entire
  ; 16-bit word at `bx`:
  cmp byte [bx], 0
  jne p3
  ; The current number is known to be prime.
  push ax
  call display_num
  mov al, ','
  call display_char
  pop ax

p4:
  ; Now, mark all multiples of `ax`:
  add bx, ax
  cmp bx, table + table_size
  ; Bail if `bx >= table + table_size`:
  jnc p3
  ; Mark the current number as non-prime:
  mov byte [bx], 1
  jmp p4

p3:
  inc ax
  cmp ax, table_size
  jne p2

  int 0x20

%include "lib-io2.asm"
