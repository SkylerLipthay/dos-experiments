; Draws a diagonally repeating rainbow pattern using 320px by 200px 256-color
; graphics mode.

cpu 8086
org 0x0100

v_y: equ 0xfa00
v_x: equ 0xfa02

start:
  mov ax, 0x0013
  int 0x10
  mov ax, 0xa000
  mov ds, ax
  mov es, ax

screen:
  xor di, di
  mov ax, 200
  mov [v_y], ax
col:
  mov ax, 320
  mov [v_x], ax
pixel:
  ; Select a color from `0x38` to `0x4f` (inclusive, 24 colors).
  mov ax, word [v_x]
  add ax, word [v_y]
  mov cl, 2
  shr ax, cl
  mov cx, 24
  xor dx, dx
  div cx
  mov ax, dx
  add al, 0x38
  stosb

  dec word [v_x]
  jnz pixel

  dec word [v_y]
  jnz col

  mov ah, 0x00
  int 0x16

  mov ax, 0x0002
  int 0x10
  int 0x20
