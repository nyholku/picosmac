;
; This file was generated on 2023-02-24 from CHIP8 file 'Pong.ch8' with MakeChip8.java 
;
; Note that the generated code uses gpasm DW directive to encode the 16 bit CHIP8 commands,
; which results in little-endian data in Flash memory, the PIC load_ch8_code routine in 
; CDP1802 emulator swaps the bytes when it copies the code from Flash to RAM.
;
		GLOBAL	pong_ch8
;
		LIST
;

		RADIX	DEC
;
		CODE
;
		DW 0x00F6
;
pong_ch8
		DW 0x6A02, 0x6B0C, 0x6C3F, 0x6D0C, 0xA2EA, 0xDAB6, 0xDCD6, 0x6E00
		DW 0x22D4, 0x6603, 0x6802, 0x6060, 0xF015, 0xF007, 0x3000, 0x121A
		DW 0xC717, 0x7708, 0x69FF, 0xA2F0, 0xD671, 0xA2EA, 0xDAB6, 0xDCD6
		DW 0x6001, 0xE0A1, 0x7BFE, 0x6004, 0xE0A1, 0x7B02, 0x601F, 0x8B02
		DW 0xDAB6, 0x600C, 0xE0A1, 0x7DFE, 0x600D, 0xE0A1, 0x7D02, 0x601F
		DW 0x8D02, 0xDCD6, 0xA2F0, 0xD671, 0x8684, 0x8794, 0x603F, 0x8602
		DW 0x611F, 0x8712, 0x4602, 0x1278, 0x463F, 0x1282, 0x471F, 0x69FF
		DW 0x4700, 0x6901, 0xD671, 0x122A, 0x6802, 0x6301, 0x8070, 0x80B5
		DW 0x128A, 0x68FE, 0x630A, 0x8070, 0x80D5, 0x3F01, 0x12A2, 0x6102
		DW 0x8015, 0x3F01, 0x12BA, 0x8015, 0x3F01, 0x12C8, 0x8015, 0x3F01
		DW 0x12C2, 0x6020, 0xF018, 0x22D4, 0x8E34, 0x22D4, 0x663E, 0x3301
		DW 0x6603, 0x68FE, 0x3301, 0x6802, 0x1216, 0x79FF, 0x49FE, 0x69FF
		DW 0x12C8, 0x7901, 0x4902, 0x6901, 0x6004, 0xF018, 0x7601, 0x4640
		DW 0x76FE, 0x126C, 0xA2F2, 0xFE33, 0xF265, 0xF129, 0x6414, 0x6500
		DW 0xD455, 0x7415, 0xF229, 0xD455, 0x00EE, 0x8080, 0x8080, 0x8080
		DW 0x8000, 0x0000, 0x0000
;
		END
;
