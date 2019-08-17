org 0x0100

start:
  mov ax, 0x0002
  int 0x10

  mov ax, 0xb800
  mov ds, ax
  mov es, ax
  mov bx, sin_table

main_loop:
  ; Read from clock
  mov ah, 0x00
  int 0x1a
  ; The lower part of the clock is in `dx`:
  mov al, dl
  ; Is bit 6 a one?
  test al, 0x40
  ; If not, then jump:
  jz m2
  ; This bit-flipping process allows the animation to reverse direction at every
  ; 64 (`0x40`) ticks instead of jerking back to frame 0 after frame 63:
  not al
m2:
  ; Isolate lower 6 bits:
  and al, 0x3f
  ; Range from -32 to 31:
  sub al, 0x20
  cbw
  mov cx, ax
  mov di, 0x0000
  mov dh, 0
m0:
  mov dl, 0
m1:
  push dx

  ; `dh` is our row index:
  mov al, dh
  ; Multiply row index by 2 to get a more circular and less oval aspect ratio,
  ; since each text character is 9px wide and 16px tall:
  shl al, 1
  and al, 0x3f
  ; Essentially performs `mov al, [cs:bx + al]`. The `cs` prefix is necessary
  ; because xlat performs `mov al, [ds:bx + al]` by default, and our `sin_table`
  ; is stored locally in the code segment:
  cs xlat
  cbw
  push ax

  ; `dl` is our column index:
  mov al, dl
  and al, 0x3f
  cs xlat
  cbw
  pop dx
  add ax, dx
  add ax, cx
  mov ah, al
  mov al, 0x07
  stosw

  pop dx
  inc dl
  cmp dl, 80
  jne m1

  inc dh
  cmp dh, 25
  jne m0

  mov ah, 0x01
  int 0x16
  jne key_pressed
  jmp main_loop

key_pressed:
  int 0x20

; 64-entry table of the values of 360 degrees of sine ranging from -64 to 64.
sin_table:
  db 0, 6, 12, 19, 24, 30, 36, 41
  db 45, 49, 53, 56, 59, 61, 63, 64
  db 64, 64, 63, 61, 59, 56, 53, 49
  db 45, 41, 36, 30, 24, 19, 12, 6
  db 0, -6, -12, -19, -24, -30, -36, -41
  db -45, -49, -53, -56, -59, -61, -63, -64
  db -64, -64, -63, -61, -59, -56, -53, -49
  db -45, -41, -36, -30, -24, -19, -12, -6
