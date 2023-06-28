;
; This file was generated on 2023-02-24 from CHIP8 file 'Maze.ch8' with MakeChip8.java 
;
; Note that the generated code uses gpasm DW directive to encode the 16 bit CHIP8 commands,
; which results in little-endian data in Flash memory, the PIC load_ch8_code routine in 
; CDP1802 emulator swaps the bytes when it copies the code from Flash to RAM.
;
		GLOBAL	maze_ch8
;
		LIST
;

		RADIX	DEC
;
		CODE
;
		DW 0x0022
;
maze_ch8
		DW 0xA21E, 0xC201, 0x3201, 0xA21A, 0xD014, 0x7004, 0x3040, 0x1200
		DW 0x6000, 0x7104, 0x3120, 0x1200, 0x1218, 0x8040, 0x2010, 0x2040
		DW 0x8010
;
		END
;
