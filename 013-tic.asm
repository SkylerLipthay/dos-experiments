; This is an implementation of Tic-Tac-Toe

org 0x0100

board: equ 0x0300

start:
  ; Initialize the board with characters `1`-`9`, indicating the keys to press
  ; to fill the respective spots on the board.
  mov bx, board
  mov cx, 9
  mov al, '1'
init:
  mov [bx], al
  inc al
  inc bx
  loop init

game_loop:
  call show_board
  call check_win
  call get_movement
  mov byte [bx], 'X'
  call show_board
  call check_win
  call get_movement
  mov byte [bx], 'O'
  jmp game_loop

show_board:
  mov bx, board
  call show_row
  call show_div
  mov bx, board + 3
  call show_row
  call show_div
  mov bx, board + 6
  ; Abuse `show_row`'s inner `ret` so we don't have to waste space with `ret`
  ; ourselves. This happens many times throughout this program:
  jmp show_row

get_movement:
  call read_char
  ; Check for escape key:
  cmp al, 0x1b
  je exit
  sub al, '1'
  ; Less than '1'. Invalid input, try again:
  jb get_movement
  cmp al, 9
  ; Greater than '9'. Invalid input, try again:
  jae get_movement
  ; Extend `al` to `ax` using bit 7 (the sign bit), 0 in this case:
  cbw
  ; `ax` is now between 0 and 8 and represents an offset from the beginning
  ; `board`.
  mov bx, board
  ; `cbw` was necesary for this moment:
  add bx, ax
  mov al, [bx]
  cmp al, '9'
  ; This square is already marked as 'O' or 'X'. Invalid move, try again:
  ja get_movement
  jmp show_crlf

exit:
  int 0x20

show_row:
  call show_square
  mov al, 0xb3
  call display_char
  call show_square
  mov al, 0xb3
  call display_char
  call show_square
show_crlf:
  mov al, 0x0d
  call display_char
  mov al, 0x0a
  jmp display_char

show_div:
  mov al, 0xc4
  call display_char
  mov al, 0xc3
  call display_char
  mov al, 0xc4
  call display_char
  mov al, 0xc3
  call display_char
  mov al, 0xc4
  call display_char
  jmp show_crlf

show_square:
  mov al, [bx]
  inc bx
  jmp display_char

check_win:
check_win_row_0:
  mov al, [board]
  cmp al, [board + 1]
  jne check_win_col_0
  cmp al, [board + 2]
  je won
check_win_col_0:
  cmp al, [board + 3]
  jne check_win_dia_0
  cmp al, [board + 6]
  je won
check_win_dia_0:
  cmp al, [board + 4]
  jne check_win_row_1
  cmp al, [board + 8]
  je won
check_win_row_1:
  mov al, [board + 3]
  cmp al, [board + 4]
  jne check_win_row_2
  cmp al, [board + 5]
  je won
check_win_row_2:
  mov al, [board + 6]
  cmp al, [board + 7]
  jne check_win_col_1
  cmp al, [board + 8]
  je won
check_win_col_1:
  mov al, [board + 1]
  cmp al, [board + 4]
  jne check_win_col_2
  cmp al, [board + 7]
  je won
check_win_col_2:
  mov al, [board + 2]
  cmp al, [board + 5]
  jne check_win_dia_1
  cmp al, [board + 8]
  je won
check_win_dia_1:
  cmp al, [board + 4]
  jne no_won
  cmp al, [board + 6]
  je won
no_won:
  ret

won:
  call display_char
  mov al, ' '
  call display_char
  mov al, 'w'
  call display_char
  mov al, 'i'
  call display_char
  mov al, 'n'
  call display_char
  mov al, 's'
  call display_char
  int 0x20

%include "lib-io1.asm"
