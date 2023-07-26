[BITS 16]
[ORG 0x7C00]

JMP _start

;===================================================================================================;
; MAIN LOOP																							;
;===================================================================================================;

; Beginning of the code
_start:
	CALL __setVideoMode_16color_graphics_640x480	; move from text mode to color mode
	MOV AX, HELLO_WORLD_STR							; move string into register as first function param
	CALL puts										; call puts(AX)
	CALL puts										; call puts(AX)
;	MOV AX, CHAR_@
	MOV AX, 50
	MOV BX, 70
	CALL __putPixel
	MOV AX, 51
	MOV BX, 71
	CALL __putPixel
.loop__start:				; enter loop
	CALL getchar			; wait for char input
	CALL putchar			; echo getchar output
	CMP AL, 0x71			; if getchar output is equal to 'q'
	JE .shutdown__start		; goto shutdown to power off the pc
	JMP .loop__start		; else return to start of loop
.shutdown__start:
	CALL __shutdown			; power off the pc
_exit:
	HLT						; halt
	RET						; RETURN

%include "io.asm"
%include "sys.asm"

;===================================================================================================;
; PADDING + BOOTLOADER-SIGN																			;
;===================================================================================================;

TIMES 510 - ($ - $$) db 0
DW 0xAA55
