# BD_BootLoader

- The _start entry can be found in `bootloader.asm`
- The `objconv` utility was missing for me so I had to compile it from source and manually add it to the PATH.
- Nasm is used as the assembler
- Makefile will assemble the code into a binary file called `boot.bin`. This file is written to a virtual floppy disk called `bootloader.vfd` which can be loaded into Virtual Box.
- Project is still very much a work in progress and doesn't do anything besides echoing back user input.
- Just a fun project to practise my ASM and explore the way that bootloaders work.