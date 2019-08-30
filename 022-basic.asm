cpu 8086
org 0x0100

vars: equ 0x7e00
running: equ 0x7e7e
line: equ 0x7e80
program: equ 0x7f00
stack: equ 0xff00
max_line: equ 1000
max_length: equ 20
max_size: equ max_line * max_length

start:
  cld
  mov di, program
  mov al, 0x0d
  mov cx, max_size
  rep stosb

main_loop:
  mov sp, stack
  mov ax, main_loop
  push ax
  xor ax, ax
  mov [running], ax
  mov al, '>'
  call input_line
  call input_number
  or ax, ax
  je statement
  call find_line
  xchg ax, di

  rep movsb
  ret

if_statement:
  call expr
  or ax, ax
  je f6
statement:
  call spaces
  cmp byte [si], 0x0d
  je f6
  mov di, statements
f5:
  mov al, [di]
  inc di
  and ax, 0x00ff
  je f4
  xchg ax, cx
  push si
f16:
  rep cmpsb
  jne f3
  pop ax
  call spaces
  jmp word [di]

f3:
  add di,cx
  inc di
  inc di
  pop si
  jmp f5

f4:
  call get_variable
  push ax
  lodsb
  cmp al, '='
  je assignment

error:
  mov si, error_message
  call print_2
  jmp main_loop

error_message:
  db "@#!", 0x0d

list_statement:
  xor ax, ax
f29:
  push ax
  call find_line
  xchg ax, si
  cmp byte [si], 0x0d
  je f30
  pop ax
  push ax
  call output_number
f32:
  lodsb
  call output
  jne f32
f30:
  pop ax
  inc ax
  cmp ax, max_line
  jne f29
f6:
  ret

input_statement:
  call get_variable
  push ax
  mov al, '?'
  call input_line

assignment:
  call expr
  pop di
  stosw
  ret

expr:
  call expr1
f20:
  cmp byte [si], '-'
  je f19
  cmp byte [si], '+'
  jne f6
  push ax
  call expr1_2
f15:
  pop cx
  add ax, cx
  jmp f20

f19:
  push ax
  call expr1_2
  neg ax
  jmp f15

expr1_2:
  inc si
expr1:
  call expr2
f21:
  cmp byte [si], '/'
  je f23
  cmp byte [si], '*'
  jne f6

  push ax
  call expr2_2
  pop cx
  imul cx
  jmp f21

f23:
  push ax
  call expr2_2
  pop cx
  xchg ax, cx
  cwd
  idiv cx
  jmp f21

expr2_2:
  inc si
expr2:
  call spaces
  lodsb
  cmp al, '('
  jne f24
  call expr
  cmp byte [si], ')'
  jne error
  jmp spaces_2

f24:
  cmp al, 0x40
  jnc f25
  dec si
  call input_number
  jmp spaces

f25:
  call get_variable_2
  xchg ax, bx
  mov ax, [bx]
  ret

get_variable:
  lodsb
get_variable_2:
  and al, 0x1f
  add al, al
  mov ah, vars >> 8

spaces:
  cmp byte [si], ' '
  jne f22

spaces_2:
  inc si
  jmp spaces

output_number:
f26:
  xor dx, dx
  mov cx, 10
  div cx
  or ax, ax
  push dx
  je f8
  call f26
f8:
  pop ax
  add al, '0'
  jmp output

input_number:
  xor bx, bx
f11:
  lodsb
  sub al, '0'
  cmp al, 10
  cbw
  xchg ax, bx
  jnc f12
  mov cx, 10
  mul cx
  add bx, ax
  jmp f11

f12:
  dec si
f22:
  ret

system_statement:
  int 0x20

goto_statement:
  call expr
  db 0xb9

run_statement:
  xor ax, ax
f10:
  call find_line
f27:
  cmp word [running], 0
  je f31
  mov [running], ax
  ret
f31:
  push ax
  pop si
  add ax, max_length
  mov [running], ax
  call statement
  mov ax, [running]
  cmp ax, program + max_size
  jne f31
  ret

find_line:
  mov cx, max_length
  mul cx
  add ax, program
  ret

input_line:
  call output
  mov si, line
  push si
  pop di
f1:
  call input_key
  stosb
  cmp al, 0x08
  jne f2
  dec di
  dec di
f2:
  cmp al, 0x0d
  jne f1
  ret

print_statement:
  lodsb
  cmp al, 0x0d
  je new_line
  cmp al, '"'
  jne f7
print_2:
f9:
  lodsb
  cmp al, '"'
  je f18
  call output
  jne f9
  ret

f7:
  dec si
  call expr
  call output_number
f18:
  lodsb
  cmp al, ';'
  jne new_line
  ret

input_key:
  mov ah, 0x00
  int 0x16

output:
  cmp al, 0x0d
  jne f17

new_line:
  mov al, 0x0a
  call f17
  mov al, 0x0d
f17:
  mov ah, 0x0e
  mov bx, 0x0007
  int 0x10
  cmp al, 0x0d
  ret


statements:
  db 3, "new"
  dw start

  db 4, "list"
  dw list_statement

  db 3, "run"
  dw run_statement

  db 5, "print"
  dw print_statement

  db 5, "input"
  dw input_statement

  db 2, "if"
  dw if_statement

  db 4, "goto"
  dw goto_statement

  db 6, "system"
  dw system_statement

  db 0
