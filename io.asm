%include "cursor.asm"
%include "defines.asm"

;===================================================================================================;
; I/O STUFF (OUTPUT)																				;
;===================================================================================================;

printCharacter:
	MOV AH, 0x0E	; BIOS teletype
	MOV BH, 0x00	; 
	MOV BL, 0x0E	;  bg: black; fg: yellow
	INT 0x10
	RET

;===================================================================================================;

printChar:
	CMP AL, NEW_LINE_CHAR 	; AL == new line ?
	JE new_line
	CMP AL, BACK_SPACE_CHAR	; AL == backspace ?
	JE back_space
	CALL printCharacter
	JMP exit_printChar_f
new_line:
	CALL getCursorPosition
	INC DH 			; increment row
	MOV DL, 0x0		; set column position to 0 (\r)
	CALL setCursorPosition
	JMP exit_printChar_f
back_space:
	CALL getCursorPosition
	OR DL, DL
	JZ back_space_row
back_space_column:
	DEC DL		 			; decrement column
	CALL setCursorPosition
	MOV AL, BLANK_CHAR		; make character blank
	CALL printCharacter
	CALL getCursorPosition
	DEC DL					; move cursor back
	CALL setCursorPosition
	JMP exit_printChar_f
back_space_row:
	OR DH, DH
	JZ exit_printChar_f		; only do something if its possible to backspace
	DEC DH
	MOV DL, SCREEN_CHAR_WIDTH
	CALL findNextCharacterInLine
exit_printChar_f:
	RET

;===================================================================================================;

printString:
next_char:
	MOV AL, [SI]
	INC SI
	OR AL, AL	; AL == \0 ?
	JZ exit_printString_f
	CALL printChar
	JMP next_char
exit_printString_f:
	RET

;===================================================================================================;
; I/O STUFF (INPUT)																					;
;===================================================================================================;

getChar:
	MOV AH, 0x00	; select 'blocking read character' BIOS function
	INT 0x16		; keyboard services interrupt --> on interupt ascii char gets moved into AL, scancode gets moved into AH
	CALL printChar	; echo character
	RET

;===================================================================================================;
; I/O STUFF (HANDLING)																				;
;===================================================================================================;

findNextCharacterInLine: ; find the first new valid ASCII character in a line and return its position
find_next_char_loop:					; start of function
	OR DL, DL							; if we reached the end of the line ...
	JZ find_next_char_return			; 	goto return statement
	CALL readCharacterAtCursorPosition	; else ... read the character at current cursor position
	CMP AL, CHAR_LOWER_BOUNDS			;	if character is not a valid ASCII char (1/2)
	JL find_next_char_decrement_column	;		goto cursor pos decrement segment ...
is_a_char_lower_bounds:					;	else ...
	CMP AL, CHAR_UPPER_BOUNDS			; if character is not a valid ASCII char (2/2)
	JG find_next_char_decrement_column	;	goto cursor pos decrement segment ...
	JMP find_next_char_before_return	;	goto find-next-char segment
find_next_char_decrement_column:		; Find the next character by ...
	DEC DL								;	decrementing cursor position
	CALL setCursorPosition				;	setting new cursor position
	JMP find_next_char_loop				;	go back to start of function to restart process
find_next_char_before_return:			; execute before returning ...
	CMP DL, SCREEN_CHAR_WIDTH			; if cursor position is same as line width ...
	JE find_next_char_return			; 	go straight to return segment
	INC DL								; else ... increment cursor position
	CALL setCursorPosition				; and set cursor position
find_next_char_return:					;
	RET									; return