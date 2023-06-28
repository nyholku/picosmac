;
; This file was generated on 2023-02-24 from CHIP8 file 'brix.ch8' with MakeChip8.java 
;
; Note that the generated code uses gpasm DW directive to encode the 16 bit CHIP8 commands,
; which results in little-endian data in Flash memory, the PIC load_ch8_code routine in 
; CDP1802 emulator swaps the bytes when it copies the code from Flash to RAM.
;
		GLOBAL	brix_ch8
;
		LIST
;

		RADIX	DEC
;
		CODE
;
		DW 0x0118
;
brix_ch8
		DW 0x6E05, 0x6500, 0x6B06, 0x6A00, 0xA30C, 0xDAB1, 0x7A04, 0x3A40
		DW 0x1208, 0x7B02, 0x3B12, 0x1206, 0x6C20, 0x6D1F, 0xA310, 0xDCD1
		DW 0x22F6, 0x6000, 0x6100, 0xA312, 0xD011, 0x7008, 0xA30E, 0xD011
		DW 0x6040, 0xF015, 0xF007, 0x3000, 0x1234, 0xC60F, 0x671E, 0x6801
		DW 0x69FF, 0xA30E, 0xD671, 0xA310, 0xDCD1, 0x6004, 0xE0A1, 0x7CFE
		DW 0x6006, 0xE0A1, 0x7C02, 0x603F, 0x8C02, 0xDCD1, 0xA30E, 0xD671
		DW 0x8684, 0x8794, 0x603F, 0x8602, 0x611F, 0x8712, 0x471F, 0x12AC
		DW 0x4600, 0x6801, 0x463F, 0x68FF, 0x4700, 0x6901, 0xD671, 0x3F01
		DW 0x12AA, 0x471F, 0x12AA, 0x6005, 0x8075, 0x3F00, 0x12AA, 0x6001
		DW 0xF018, 0x8060, 0x61FC, 0x8012, 0xA30C, 0xD071, 0x60FE, 0x8903
		DW 0x22F6, 0x7501, 0x22F6, 0x4560, 0x12DE, 0x1246, 0x69FF, 0x8060
		DW 0x80C5, 0x3F01, 0x12CA, 0x6102, 0x8015, 0x3F01, 0x12E0, 0x8015
		DW 0x3F01, 0x12EE, 0x8015, 0x3F01, 0x12E8, 0x6020, 0xF018, 0xA30E
		DW 0x7EFF, 0x80E0, 0x8004, 0x6100, 0xD011, 0x3E00, 0x1230, 0x12DE
		DW 0x78FF, 0x48FE, 0x68FF, 0x12EE, 0x7801, 0x4802, 0x6801, 0x6004
		DW 0xF018, 0x69FF, 0x1270, 0xA314, 0xF533, 0xF265, 0xF129, 0x6337
		DW 0x6400, 0xD345, 0x7305, 0xF229, 0xD345, 0x00EE, 0xE000, 0x8000
		DW 0xFC00, 0xAA00, 0x0000, 0x0000
;
		END
;