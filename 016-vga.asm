cpu 8086
org 0x0100

; Using these locations (right past visible VGA memory) to store the current
; pixel index.
v_y: equ 0xfa00
v_x: equ 0xfa02

start:
  ; Set video mode to 320x200x256
  mov ax, 0x0013
  int 0x10
  ; Set data/extended segments to video memory:
  mov ax, 0xa000
  mov ds, ax
  mov es, ax

m4:
  mov ax, 127
  mov [v_y], ax
m0:
  mov ax, 127
  mov [v_x], ax
m1:
  mov ax, [v_y]
  mov dx, 320
  mul dx
  add ax, [v_x]
  ; The saves one byte in comparison to `mov ax, di` because `ax` is the first
  ; operand. It just swaps the values of `ax` and `di` (`ax` as garbage after
  ; the swap because `di` means nothing at this point):
  xchg ax, di

  mov ax, [v_y]
  and ax, 0x78
  add ax, ax

  mov bx, [v_x]
  and bx, 0x78
  mov cl, 3
  shr bx, cl
  add ax, bx
  stosb

  ; Loop through columns of the row:
  dec word [v_x]
  jns m1

  ; Loop through rows:
  dec word [v_y]
  jns m0

  ; Wait for key press:
  mov ah, 0x00
  int 0x16

  ; Reset back to standard text video mode:
  mov ax, 0x0002
  int 0x10

  int 0x20
