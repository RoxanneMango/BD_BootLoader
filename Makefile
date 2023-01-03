.PHONY: build

build:
	nasm bootloader.asm -f bin -o boot.bin
	dd status=noxfer conv=notrunc if=boot.bin of=bootloader.vfd
