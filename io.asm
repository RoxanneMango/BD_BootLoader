%include "cursor.asm"
%include "defines.asm"

;===================================================================================================;
; I/O STUFF (OUTPUT)																				;
;===================================================================================================;

; output a single character to the screen
putchar:
	PUSH AX						; save context of AX
;	CMP AL, 0x0D 				; check if a new line must be printed by looking for '\r' character (=0x0D)
	CMP AL, NEW_LINE_CHAR 		; check if a new line must be printed by looking for '\n' character
	JE .new_line__putchar		; if it was found output '\r\n'
	CMP AL, BACK_SPACE_CHAR		; check if a backspace must happen
	JE .back_space__putchar		; if backspace character was found handle backspace
	CALL __printCharacter		; for all other cases just print the character
	JMP .return__putchar		; and goto return
.new_line__putchar:
	CALL _printNewLine			; output '\r\n'
	JMP .return__putchar		; and goto return
.back_space__putchar:
	CALL _printBackspace		; handle backspace
.return__putchar:
	POP AX						; restore context of AX
	RET							; RETURN

;===================================================================================================;

; output an array of characters to the screen
puts:
	PUSH AX						; save context of AX
	MOV SI, AX					; move start of array in own register
.loop__puts:					; enter loop
	MOV AL, [SI]				; load the current *array_ptr
	OR AL, AL					; check if *array_ptr is '\0'
	JZ .return__puts			; if its '\0' goto return
	CALL putchar				; else call putchar
	INC SI						; and increment array_ptr
	JMP .loop__puts				; goto start of loop again
.return__puts:
	POP AX						; restore context of AX
	RET							; RETURN

;===================================================================================================;
; I/O STUFF (INPUT)																					;
;===================================================================================================;

getchar:
	MOV AH, 0x00	; select 'blocking read character' BIOS function
	INT 0x16		; keyboard services interrupt --> on interupt ascii char gets moved into AL, scancode gets moved into AH
	RET

;===================================================================================================;
; I/O STUFF (HELPER FUNCTIONS)																		;
;===================================================================================================;


; output a character to the current position of the cursor
__printCharacter:
	MOV AH, 0x0E	; BIOS teletype
	MOV BH, 0x00	; 
	MOV BL, 0x0E	;  bg: black; fg: yellow
	INT 0x10
	RET

;===================================================================================================;

; print a return caret and new line character
_printNewLine:
	push AX									; save context of AX
	MOV AL, 0x0D							; push  '\r'
	CALL __printCharacter						; print '\r'
	MOV AL, 0x0A							; push  '\n'
	CALL __printCharacter						; print '\n'
	POP AX									; restore context of AX
	RET										; RETURN

; do a backspace
_printBackspace:
	PUSH AX									; save context of AX
	;
	CALL __getCursorPosition					; get cursor position
	OR DL, DL					; if the cursor column pos is already at the zero position
	JZ .row__printBackspace		; try to decrement row
.col__printBackspace:			; else try to decrement cursor column pos
	DEC DL									; decrement column pos
	CALL __setCursorPosition					; update cursor position
	MOV AL, BLANK_CHAR						; ready blank character
	CALL __printCharacter						; print a blank character
	;
	CALL __getCursorPosition					; get cursor position
	DEC DL									; decrement cursor column position
	CALL __setCursorPosition					; update cursor position
	;
	JMP .return__printBackspace				; goto return
.row__printBackspace:
	OR DH, DH								; check if row can be decremented
	JZ .return__printBackspace				; return if not possible to decrement row further
	;
	MOV DL, SCREEN_CHAR_WIDTH				; set DL to maximum
	DEC DH									; decrement cursor row position
	CALL __setCursorPosition
.loop__printBackspace:						; enter the loop to look for first valid character
	;
	CALL __readCharacterAtCursorPosition		; read character at current cursor position
	CMP AL, 0x7E							; if character is not a valid ASCII char (1/2) (= ~)
	JG .loop_continued__printBackspace		; goto cursor pos decrement segment ...
	CMP AL, 0x21							; if character is not a valid ASCII char (2/2) (= !)	
	JL .loop_continued__printBackspace		; goto find-next-char segment
	;
	JMP .loop_inc_end__printBackspace		; if a valid character was found, exit loop ( character is NOT blank )
.loop_continued__printBackspace:
	CALL __getCursorPosition					; check if DL can be decremented
	OR DL, DL								; if column cursor pos is already at 0
	JZ .loop_end__printBackspace			; set cursor pos to 0 and return
	;
	DEC DL									; decrement cursor column position	
	CALL __setCursorPosition					; set cursor position and size
	;
	JMP .loop__printBackspace 				; restart loop
	;
.loop_inc_end__printBackspace:				; end of loop
	CMP DL, SCREEN_CHAR_WIDTH 				; check if column pos is not already at the max pos
	JE .del_return__printBackspace			; if it is, backspace into that character
	INC DL									; else simply increment cursor column pos
.loop_end__printBackspace:					; and
	CALL __setCursorPosition					; set cursor position and size
	JMP .return__printBackspace				; goto return
.del_return__printBackspace:
	PUSH AX									; save cursor pos
	;
	CALL __setCursorPosition					; set cursor position and size
	MOV AL, BLANK_CHAR						; ready blank character
	CALL __printCharacter						; print a blank character
	;
	POP AX									; restore cursor pos
	CALL __setCursorPosition					; set cursor position and size
.return__printBackspace:
	POP AX									; restore context of AX
	RET										; RETURN
	
;===================================================================================================;

__putPixel:
	PUSH AX
	PUSH AX
	PUSH BX
	MOV AH, 0x0C
	MOV AL, 0xE
	MOV BH, 0
	POP SI
	MOV CX, SI
	POP SI
	MOV DX, SI
	INT 0x10
	POP AX
	RET
	
; output an array of characters to the screen
putPixelArray:
	PUSH AX						; save context of AX
	MOV SI, AX					; move start of array in own register
	MOV DI, 8*8					; i = (8*8)
.loop__putPixelArray:					; enter loop
	DEC DI
	OR DI, DI					; check if *array_ptr is '\0'
	JZ .return__putPixelArray			; if its '\0' goto return
	MOV AL, [SI]				; load the current *array_ptr
	MOV CX, AX
	MOV DX, AX
	CALL __putPixel				; else call putchar
	INC SI						; and increment array_ptr
	JMP .loop__putPixelArray				; goto start of loop again
.return__putPixelArray:
	POP AX						; restore context of AX
	RET							; RETURN