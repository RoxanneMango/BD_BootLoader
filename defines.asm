;===================================================================================================;
; DEFINES																							;
;===================================================================================================;

SCREEN_CHAR_WIDTH 	equ 0x4F

BLANK_CHAR 			equ 0x00
NEW_LINE_CHAR		equ 0x0A
BACK_SPACE_CHAR		equ 0x08

CHAR_LOWER_BOUNDS 	equ 0x20 ; unit seperator (thing before space char)
CHAR_UPPER_BOUNDS 	equ 0x7E ; DEL (thing after ~ char)

%define ENDL 0x0D, 0x0A

;===================================================================================================;
; DATA																								;
;===================================================================================================;

HELLO_WORLD_STR		db 'Hello World!', ENDL, 0

CHAR_@				DW 0x00,0x00,0x7C,0xC6,0x01,0x83,0x83,0x11,0x9F,0xB3,0x11,0xB3,0xB3,0x11,0xB7,0x9B,0x11,0x80,0x80,0x10,0xC3,0x7E,0x00,0x00,0x00,0x00,0x00	; @