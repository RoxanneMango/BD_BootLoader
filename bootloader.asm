[BITS 16]
[ORG 0x7C00]

JMP _start
NOP
RET

;===================================================================================================;
; MAIN LOOP																							;
;===================================================================================================;

_start:
	MOV SI, helloWorld
	MOV AH, 0x00
	MOV AX, 0x0012		; Select 640x480 16-color graphics video mode
	int 0x10
	CALL printString
main_loop:
	CALL getChar
	CMP AL, 0x71		; char == q ? shutdown
	JE _exit
	JMP main_loop
_exit:
	MOV AX, 0x5307
	MOV CX, 0x0003
	INT 0x15			; advanced power management --shutdown interrupt

%include "io.asm"

;===================================================================================================;
; PADDING + BOOTLOADER-SIGN																			;
;===================================================================================================;

TIMES 510 - ($ - $$) db 0
DW 0xAA55
