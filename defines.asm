;===================================================================================================;
; DEFINES																							;
;===================================================================================================;

SCREEN_CHAR_WIDTH 	equ 0x4F

BLANK_CHAR 			equ 0x00
NEW_LINE_CHAR		equ 0x0A
BACK_SPACE_CHAR		equ 0x08

CHAR_LOWER_BOUNDS 	equ 0x20 ; unit seperator (thing before space char)
CHAR_UPPER_BOUNDS 	equ 0x7E ; DEL (thing after ~ char)

;===================================================================================================;
; DATA																								;
;===================================================================================================;

helloWorld 			db 'Hello World!', 0x0A, 0