org 100h
	jmp start
prnt_win_msg:
	push cx
	push ax
	push di
	mov ax, 0xb800
	mov es, ax
	mov di, 160
	mov cx, 80
	mov ax, 3
	mul di
	mov di, ax
	mov ax, 0x0720
	push di
	rep stosw
	pop di
	mov ax, [turn]
	or ax, ax
	jnz skip13
	mov word[es:di], 0x0758
	jmp skip14
skip13:	mov word[es:di],0x074f
skip14:	mov cx, [win_size]
	add di, 2
	mov ah, 0x07
	mov si, msg3
	cld
@h8:	lodsb
	stosw
	loop @h8
	pop di
	pop ax
	pop cx 
	ret
prnt_grid:
	push ax
	push cx
	push di
	push si
	push dx
	mov si, grid
	mov ax, 0xb800
	mov es, ax
	xor di, di
	mov cx, 3
@h2:	push cx
	mov cx, 3
	mov ah, 0x07
@h1:	cld
	lodsb
	stosw
	mov word[es:di], 0x0720
	add di, 2
	loop @h1
	pop cx
	mov ax, 3
	sub ax, cx
	inc ax
	xor dx, dx
	mov di, 160
	mul di
	mov di, ax
	loop @h2
	mov ax, [turn]
	or ax, ax
	jnz skip
	mov si, msg1
	jmp skip1
skip:	mov si, msg2
skip1:	mov cx, [size]
	mov ah, 0x07
@h3:	lodsb
	stosw
	loop @h3
	pop dx
	pop si
	pop di
	pop cx
	pop ax
	ret
clear_grid:
	push ax
	push cx
	push di
	mov ax, 0xb800
	mov es, ax
	xor di, di
	mov ax, 0x0720
	mov cx, 320
	rep stosw
	pop di
	pop cx
	pop ax
	ret
is_valid_place:
	push bp
	mov bp, sp
	push cx
	push bx
	push ax
	xor cx, cx
	mov bx, [bp+4]
	cmp bx, 0x30
	jl skip2
	cmp bx, 0x38
	ja skip2
	sub bx, 0x30
	mov al, [grid+bx]
	cmp al, 0x38
	ja skip2
	jmp skip3
skip2:	inc cx
skip3:	mov word[bp+4], cx
	pop ax
	pop bx
	pop cx
	pop bp
	ret
	
check_winner:
	push bp
	mov bp, sp
	push dx
	push ax
	push di
	push si
	push bx
	push cx
	xor dx, dx
	mov ax, ds
	mov es, ax
	mov cx, 3
	mov di, grid
	cld
	xor ah, ah
	mov bx, [turn]
	or bx, bx
	jnz skip5
	mov al, 0x58
	jmp skip4
skip5:	mov al, 0x4f
skip4:	push cx
	mov cx, 3
	repe scasb
	jz win_skip
	add di, cx
	pop cx
	loop skip4
	mov cx, 3
@h5:	push cx
	mov bx, 3
	sub bx, cx
	mov cx, 3
@h4:	cmp al, [grid+bx]
	jne skip6
	add bx, 3
	loop @h4
	jmp win_skip
skip6:	pop cx
	loop @h5
	mov cx, 3
	xor bx, bx
	push cx
@h6:	cmp al, [grid+bx]
	jne skip7
	add bx, 4
	loop @h6
	jmp win_skip
skip7:	pop cx
	mov cx, 3
	mov bx, 2
	push cx
@h7:	cmp al, [grid+bx]
	jne skip8
	add bx, 2
	loop @h7
	jmp win_skip
skip8:  inc dx
win_skip:	
	pop cx
	mov word[bp+4], dx
	pop cx
	pop bx
	pop si
	pop di
	pop ax
	pop dx
	pop bp
	ret
placement:
	push bp
	mov bp, sp
	push bx
	push ax
	push di
	push cx
	mov ax, ds
	mov es, ax
	push si
	mov ax, [turn]
	or ax, ax
	jnz skip10
	mov bx, X_list
	jmp skip9
skip10:	mov bx, O_list
skip9:	cmp word[bx+2], 0x39
	je skip_remove
	mov al, [bx]
	xor ah, ah
	mov di, ax
	sub di, 0x30
	mov byte[grid+di], al
	mov cx, 2
	cld
	mov di, bx
	mov si, bx
	inc si
	rep movsb
	mov ax, [bp+4]
	mov byte[bx+2], al
	jmp done
skip_remove:
	mov cx, 3
	mov di, bx
	mov al, 0x39
	cld
	repne scasb
	dec di
	mov ax, [bp+4]
	mov byte[di], al
done:	sub al, 0x30
	xor ah, ah
	mov bx, ax
	mov ax, [turn]
	or ax, ax
	jnz skip11
	mov byte[grid+bx], 0x58
	jmp skip12
skip11:	mov byte[grid+bx],0x4f
skip12:	pop si
	pop cx
	pop di
	pop ax
	pop bx
	pop bp
	ret 
start:	call clear_grid
	call prnt_grid
	xor ah, ah
	int 16h
	xor ah, ah
	push ax
	call is_valid_place
	pop bx
	or bx, bx
	jnz start
	push ax
	call placement
	push ax
	call check_winner
	pop bx
	or bx, bx
	jz end
	mov ax, [turn]
	inc ax
	mov di, 2
	xor dx, dx
	div di
	mov ax, dx
	mov word[turn], ax
	jmp start
end:    call clear_grid
	call prnt_grid
	call prnt_win_msg
	; push ax 
	; call check_winner
	; pop bx
	mov ax, 4c00h
	int 21h
grid: db '012345678'
msg1: db 'Enter position for X:'
msg2: db 'Enter position for O:'
msg3: db ' wins!'
win_size: dw 6
X_list: db '999'
O_list: db '999'
size: dw 21
turn: dw 0

