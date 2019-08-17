org 0x0100

; Set video mode to standard text mode:
mov ax, 0x0002
int 0x10
; Set `es` to `0xb800`:
mov ax, 0xb800
mov es, ax
; Clear the direction flag so that `stosw` increments `di`. `std` would *set*
; the direction flag so that `stosw` would decrement `di` instead.
cld
; Set `di` to 0:
xor di, di
; Blue, light green, 'H'. The lower byte (`0x48` here) is written first (little
; endian).
mov ax, 0x1a48
; Stores a word at `es:di` (right now `0xb8000`) and increases `di` by 2:
stosw
; Blue, light aqua, 'E'
mov ax, 0x1b45
stosw
; Blue, light red, 'L'
mov ax, 0x1c4c
stosw
; Blue, light purple, 'L'
mov ax, 0x1d4c
stosw
; Blue, light yellow, 'L'
mov ax, 0x1e4f
stosw
int 0x20
