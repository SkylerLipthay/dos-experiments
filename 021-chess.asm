cpu 286
org 0x0100

start:
  cld
  mov di, board - 8
  mov cx, di
sr1:
  push di
  pop ax
  and al, 0x88
  jz sr2
  mov al, 0x07
sr2:
  stosb
  loop sr1

  mov si, initial
  mov di, board
  mov cl, 0x08
sr3:
  lodsb
  stosb
  or al, 8
  mov [di + 0x6f], al
  inc byte [di + 0x0f]
  mov byte [di + 0x5f], 0x09
  loop sr3

sr21:
  push sr21
  push play
  push display_board
  push sr28
  mov si, key2
  push si
  push si

display_board:
  mov si, board - 8

  mov cl, 73
sr4:
  lodsb
  mov bx, chars
  xlatb
  cmp al, 0x0d
  jnz sr5
  add si, byte 7
  call display
  mov al, 0x0a
sr5:
  call display
  loop sr4
  ret

sr14:
  inc dx
  dec dh
  jnz sr12
sr17:
  inc si
sr6:
  cmp si, board + 120
  jne sr7
  pop di
  pop si
  test cl, cl
  jne sr24
  cmp bp, byte -127
  jl sr24
sr28:
  movsb
  mov byte [si - 1], 0
sr24:
  ret

play:
  mov bp, -256
  push bp
  push bp

  mov si, board
sr7:
  lodsb
  xor al, ch
  dec ax
  cmp al, 6
  jnc sr6
  or al, al
  jnz sr8
  or ch, ch
  jnz sr25
sr8:
  inc ax
sr25:
  dec si
  add al, 0x04
  mov ah, al
  and ah, 0x0c
  mov bl, offsets - 4
  xlatb
  xchg dx, ax
sr12:
  mov di, si
sr9:
  mov bl, dl
  xchg ax, di
  add al, [bx]
  xchg ax, di
  mov al, [di]
  inc ax
  mov ah, [si]
  cmp dl, 16 + displacement
  dec al
  jz sr10
  jc sr27
  cmp dh, 3
  jb sr17
sr27:
  xor al, ch
  sub al, 0x09
  cmp al, 0x05
  mov al, [di]
  ja sr18

  jne sr20
  dec cl
  mov bp, 78
  jne sr26
  add bp, bp
sr26:
  pop ax
  pop ax
  ret

sr20:
  push ax
  and al, 7
  mov bl, scores
  xlatb
  cbw

  cmp cl, 3

  jnc sr22
  pusha
  call sr28
  xor ch, 8
  inc cx
  call play
  mov bx, sp
  sub [bx + 14], bp
  popa
sr22:
  cmp bp, ax
  jg sr23
  xchg ax, bp
  jne sr23
  in al, (0x40)
  cmp al, 0xaa
sr23:
  pop ax
  mov [si], ah
  mov [di], al
  jg sr18
  add sp, byte 4
  push si
  push di

sr18:
  dec ah
  xor ah, ch
  jz sr16
  cmp ah, 0x04
  jnc sr16
  or al, al
  jz sr9
sr16:
  jmp sr14

sr10:
  jc sr20
  cmp dh, 2
  ja sr18
  jnz short sr20
  xchg ax, si
  push ax
  sub al, 0x20
  cmp al, 0x40
  pop ax
  xchg ax, si
  sbb dh, al
  jmp short sr20

key2:
  xchg si, di
  call key
  xchg di, ax

key:
  mov ah, 0
  int 0x16

display:
  pusha
  mov ah, 0x0e
  mov bh, 0x00
  int 0x10
  popa
  and ax, 0x0f
  imul bp, ax, -0x10
  lea di, [bp + di + board + 127]
  ret

initial:
  db 2, 5, 3, 4, 6, 3, 5, 2
scores:
  db 0, 1, 5, 3, 9, 3

chars:
  db ".prbqnk", 0x0d, ".PRBQNK"

offsets:
  db (16 + displacement - start) & 255
  db (20 + displacement - start) & 255
  db (8 + displacement - start) & 255
  db (12 + displacement - start) & 255
  db (8 + displacement - start) & 255
  db (0 + displacement - start) & 255
  db (8 + displacement - start) & 255

displacement:
  db -33, -31, -18, -14, 14, 18, 31, 33
  db -16, 16, -1, 1
  db 15, 17, -15, -17
  db -15, -17, -16, -32
  db 15, 17, 16, 32

board:  equ 0x0300
