;===================================================================================================;
; CURSOR STUFF																						;
;===================================================================================================;

; DH = row (0x00 is top)
; DL = colum (0x00 is left)

getCursorPosition:
	MOV AH, 0x3		; get cursor position and size
	MOV BH, 0x0		; page number (0 in graphics modes)
	INT 0x10		; video interrupt
	RET

;===================================================================================================;

setCursorPosition:
	MOV AH, 0x2		; get cursor position and size
	MOV BH, 0x0		; page number (0 in graphics modes)
	INT 0x10		; video interrupt
	RET	

;===================================================================================================;

readCharacterAtCursorPosition:
	MOV AH, 0x08
	MOV BH, 0x00
	INT 0x10
	RET