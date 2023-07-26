;===================================================================================================;
; HARDWARE AND SYSTEM WIDE MANAGEMENT																;
;===================================================================================================;

; advanced power management --shutdown interrupt
__shutdown:
	MOV AX, 0x5307									;
	MOV CX, 0x0003									;
	INT 0x15										; call hardware management interrupt
	RET												; RETURN

;===================================================================================================;

; Select 640x480 16-color graphics video mode
__setVideoMode_16color_graphics_640x480:
	PUSH AX											; save context of AX
	MOV AH, 0x00									; 
	MOV AX, 0x0012									; set video mode to 12h
	int 0x10										; call video interrupt
	POP AX											; restore context of AX
	RET												; RETURN
	

; Select 40x25 chars color text video mode
__setVideoMode_16color_text_80x25_chars:
	PUSH AX											; save context of AX
	CALL __getCursorPosition
	PUSH AX	
	MOV AH, 0x00									; 
	MOV AX, 0x0003									; set video mode to 03h
	MOV AL, 0b1000_0000
	int 0x10										; call video interrupt
	POP AX											
	CALL __setCursorPosition
	POP AX											; restore context of AX
	RET												; RETURN