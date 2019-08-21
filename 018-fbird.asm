cpu 8086
org 0x0100

pipe: equ 0x0fa0
score: equ 0x0fa2
grav: equ 0x0fa4
next: equ 0x0fa6
bird: equ 0x0fa8
tall: equ 0x0faa
frame: equ 0x0fac

start:
  mov ax, 0x0002
  int 0x10
  cld
  mov ax, 0xb800
  mov ds, ax
  mov es, ax

fb21:
  mov di, pipe
  xor ax, ax
  stosw
  stosw
  stosw
  mov al, 0xa0
  stosw
  mov al, 0x60
  stosw

  mov di, 0x004a
  mov ax, 0x0f46
  stosw
  mov al, 'B'
  stosw
  mov al, 'I'
  stosw
  mov al, 'R'
  stosw
  mov al, 'D'
  stosw

  mov cx, 80

fb1:
  push cx
  call scroll_scenery
  pop cx
  loop fb1

fb23:
  mov ah, 0x01
  int 0x16
  pushf
  xor ax, ax
  int 0x16
  popf
  jnz fb23

fb12:
  ; Apply gravity:
  mov al, [bird]
  add al, [grav]
  mov [bird], al

  and al, 0xf8
  mov ah, 0x14
  mul ah
  add ax, 0x0020
  xchg ax, di
  mov al, [frame]
  and al, 4
  jz fb15
  mov al, [di - 160]
  mov word [di - 160], 0x0d1e
  add al, [di]
  shr al, 1
  mov word [di], 0x0d14
  jmp fb16
fb15:
  mov al, [di]
  mov word [di], 0x0d1f
fb16:
  add al, [di + 2]
  mov word [di + 2], 0x0d10

  cmp al, 0x40
  jz fb19
  mov byte [di], 0x2a
  mov byte [di + 2], 0x2a
  mov di, 0x07ca
  mov ax, 0x0f42
  stosw
  mov al, 'O'
  stosw
  mov al, 'N'
  stosw
  mov al, 'K'
  stosw
  mov al, '!'
  stosw
  mov cx, 20
fb20:
  push cx
  call wait_frame
  pop cx
  loop fb20
  jmp fb21

fb19:
  call wait_frame
  mov al, [frame]
  and al, 7
  jnz fb17
  inc word [grav]
fb17:
  mov al, 0x20
  mov [di - 160], al
  mov [di + 2], al
  stosb
  call scroll_scenery
  call scroll_scenery
  cmp byte [0x00a0], 0xb0
  jz fb27
  cmp byte [0x00a2], 0xb0
fb27:
  jnz fb24
  inc word [score]
  mov ax, [score]
  mov di, 0x008e
fb25:
  xor dx, dx
  mov bx, 10
  div bx
  add dx, 0x0c30
  xchg ax, dx
  std
  stosw
  mov byte [di], 0x20
  cld
  xchg ax, dx
  or ax, ax
  jnz fb25
fb24:
  mov ah, 0x01
  int 0x16
  jz fb26
  mov ah, 0x00
  int 0x16
  ; Check if escape key pressed:
  cmp al, 0x1b
  jne fb4
  int 0x20
fb4:
  mov ax, [bird]
  sub ax, 0x10
  cmp ax, 0x08
  jb fb18
  mov [bird], ax
fb18:
  mov byte [grav], 0
  ; Make flapping sound:
  mov al, 0xb6
  out 0x43, al
  mov al, 0x90
  out 0x42, al
  mov al, 0x4a
  out 0x42, al
  in al, 0x61
  or al, 0x03
  out 0x61, al
fb26:
  jmp fb12

scroll_scenery:
  mov si, 0x00a2
  mov di, 0x00a0
fb2:
  mov cx, 79
  repz
  movsw
  mov ax, 0x0e20
  stosw
  lodsw
  cmp si, 0xfa2
  jnz fb2
  mov word [0x0f9e], 0x02df
  ; Generate pseudo-random number:
  in al, 0x40
  and al, 0x70
  jz fb5
  mov bx, 0x0408
  mov [0x0efe], bx
  mov di, 0x0e5e
  and al, 0x20
  jz fb3
  mov [di], bx
  sub di, 0x00a0
fb3:
  mov word [di], 0x091e
fb5:
  dec word [next]
  mov bx, [next]
  cmp bx, 0x03
  ja fb6
  jne fb8
  in al, 0x40
  and ax, 0x0007
  add al, 0x04
  mov [tall], ax
fb8:
  mov cx, [tall]
  or bx, bx
  mov dl, 0xb0
  jz fb7
  mov dl, 0xdb
  cmp bx, 0x03
  jb fb7
  mov dl, 0xb1
fb7:
  mov di, 0x013e
  mov ah, 0x0a
  mov al, dl
fb9:
  stosw
  add di, 0x009e
  loop fb9
  mov al, 0xc4
  stosw
  add di, 0x009e * 6 + 10
  mov al, 0xdf
  stosw
  add di, 0x009e
fb10:
  mov al, dl
  stosw
  add di, 0x009e
  cmp di, 0x0f00
  jb fb10
  or bx, bx
  jnz fb6
  mov ax, [pipe]
  inc ax
  mov [pipe], ax
  mov cl, 3
  shr ax, cl
  mov ah, 0x50
  sub ah, al
  cmp ah, 0x10
  ja fb11
  mov ah, 0x10
fb11:
  mov [next], ah
fb6:
  ret

wait_frame:
  mov ah, 0x00
  int 0x1a
fb14:
  push dx
  mov ah, 0x00
  int 0x1a
  pop bx
  cmp bx, dx
  jz fb14
  inc word [frame]
  in al, 0x61
  and al, 0xfc
  out 0x61, al
  ret
