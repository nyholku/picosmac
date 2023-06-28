;--------------------------------------------------------
;

		LIST	
		RADIX	dec
		
		INCLUDE p18cxxx.inc
;
;--------------------------------------------------------
;
		GLOBAL 	main_program
;
		EXTERN	brix_ch8
		EXTERN	tetris_ch8
		EXTERN	tank_ch8
		EXTERN	pong_ch8
		EXTERN	kaleidoscope_ch8
		EXTERN	vers_ch8
		EXTERN	vip_pic
;
		EXTERN	init_cdp1802
		EXTERN	init_cdp1861
		EXTERN  test_key
		EXTERN 	load_code
		EXTERN	load_chip8
		EXTERN	load_ch8_code
		EXTERN	init_keyinp
;
;--------------------------------------------------------
;
LOAD_CH8PROG	MACRO	chip8prog
		MOVLW	HIGH(chip8prog)
		MOVWF	TBLPTRH, a
		MOVLW	LOW(chip8prog)
		MOVWF	TBLPTRL, a
		CALL	load_ch8_code
		ENDM
;
;--------------------------------------------------------
;
		CODE
;
;--------------------------------------------------------
;
main_program:
		MOVFF		FSR2L, POSTDEC1
		MOVFF		FSR1L, FSR2L

		BSF	LATB	 , 4

		BCF	TRISB	 , 4

		MOVLW	0xff
		MOVWF	LATD

		CLRF	LATA

		BCF	TRISD	 , 1

		BSF	LATD	 , 1

		BCF	TRISA	 , 0

		BCF	TRISA	 , 1

		BCF	TRISA	 , 2

		MOVLW	0x0f
		MOVWF	ADCON1

		BSF	TRISB	 , 0

		BSF	TRISB	 , 1

		BCF	TRISA	 , 5

		BCF	TRISC	 , 7

		MOVLW	0x40
		MOVWF	SSPSTAT

		MOVLW	0x25
		MOVWF	SSPCON1

		BCF	PIR1	 , 3

		CLRF	ADCON0

		MOVLW	0x0f
		MOVWF	ADCON1

		BCF	T2CON	 , 0

		BCF	T2CON	 , 1

		MOVLW	0x07
		MOVWF	PR2

		MOVLW	0x03
		MOVWF	CCPR2L

		MOVF	CCP2CON	 , W
		ANDLW	0xf0
		IORLW	0x0c
		MOVWF	CCP2CON	 

		CLRF	TMR2

		BSF	LATA	 , 5

		BCF	LATA	 , 5

		BSF	T2CON	 , 2

		BCF	TRISB	 , 3

		BCF	TRISA	 , 0

		BCF	TRISA	 , 1

		BCF	TRISA	 , 2

		CALL	init_keyinp

; Fist check for C key to enter monitor ROM code,
; this important so that we do not change RAM contents
; and can examine it in monitor mode, otherwise, if
; no key is pressed default behaviour is to load Snoopy pic
; which of course destroys RAM contents
		
		MOVLW	0xC	
		CALL	test_key	
		BNZ	start_emulator
;
; Now check keys and based on key load some code to RAM and the start emulator
;		
		MOVLW	1
		CALL	test_key
		BNZ	go_brix
		
		MOVLW	2
		CALL	test_key
		BNZ	go_tetris
		
		MOVLW	3
		CALL	test_key
		BNZ	go_tank
		
		MOVLW	4
		CALL	test_key
		BNZ	go_pong

		MOVLW	5
		CALL	test_key
		BNZ	go_kaleidoscope
		
		MOVLW	6
		CALL	test_key
		BNZ	go_vers
		
;
; if no key is pressed, go and display Snoopy
;		
		BRA 	go_vip_pic
;
; At this point we have the 1802 code in RAM and we
; can start the eumulator, which starts executing 
; 1802 code from the emulated ROM code 
; at 0x8000 emulated address space,
; which is 0x2000 in PIC address space.
;		
start_emulator
		
		CALL	init_cdp1802

		CALL	init_cdp1861
		

		BSF	IPR1	 , 3

		BSF	RCON	 , 7

		BSF	PIE1	 , SSPIE

		BSF	INTCON	 , 6

		BSF	INTCON	 , 7
mainloop:
		BRA	mainloop
;
go_brix
		CALL	load_chip8
		LOAD_CH8PROG(brix_ch8)		
		BRA	start_emulator
		
go_tetris
		CALL	load_chip8
		LOAD_CH8PROG(tetris_ch8)			
		BRA	start_emulator

go_tank
		CALL	load_chip8
		LOAD_CH8PROG(tank_ch8)			
		BRA	start_emulator

go_pong
		CALL	load_chip8
		LOAD_CH8PROG(pong_ch8)			
		BRA	start_emulator
go_kaleidoscope
		CALL	load_chip8
		LOAD_CH8PROG(kaleidoscope_ch8)			
		BRA	start_emulator
go_vers
		CALL	load_chip8
		LOAD_CH8PROG(vers_ch8)			
		BRA	start_emulator
go_vip_pic			
		LFSR	FSR0, 0x0000
		
		MOVLW	HIGH(vip_pic)
		MOVWF   TBLPTRH, a		
		MOVLW	LOW(vip_pic)
		MOVWF   TBLPTRL, a		
		
		CALL	load_code
		BRA	start_emulator
;
;--------------------------------------------------------
;
#ifdef __18F45K50
		CONFIG	CFGPLLEN = ON
;		CONFIG	FOSC = HSH 				;INTOSCIO
		CONFIG	FOSC = INTOSCIO
		CONFIG	PLLSEL = PLL3X
		CONFIG	CPUDIV = NOCLKDIV
		CONFIG	LS48MHZ = SYS48X8
		CONFIG	CCP2MX = RC1
		CONFIG	WDTEN = OFF
		CONFIG	T3CMX = RC0
		CONFIG	SDOMX = RB3
		CONFIG	BOREN = SBORDIS
		CONFIG	PCLKEN = ON
		CONFIG	FCMEN = ON
#endif
;
;--------------------------------------------------------
;
#ifdef __18F4550		
		CONFIG 	 PLLDIV=3 ; was 1 for 4 MHz
		CONFIG 	 CPUDIV=OSC1_PLL2
		CONFIG 	 USBDIV=2
		CONFIG 	 FOSC=HSPLL_HS
		CONFIG 	 FCMEN=OFF
		CONFIG 	 IESO=OFF
		CONFIG 	 VREGEN=ON
		CONFIG 	 BORV=0
		CONFIG 	 BOR=OFF
		CONFIG 	 PWRT=ON
		CONFIG 	 WDT=OFF
		CONFIG 	 WDTPS=32768
		CONFIG 	 CCP2MX=OFF ; 36 
		CONFIG 	 PBADEN=OFF
		CONFIG 	 LPT1OSC=OFF
		CONFIG 	 MCLRE=ON
		CONFIG 	 STVREN=OFF
		CONFIG 	 LVP=OFF
		CONFIG 	 ICPRT=OFF
		CONFIG 	 XINST=OFF
		CONFIG 	 DEBUG=OFF
#endif
;
;--------------------------------------------------------
;
		END
;
;--------------------------------------------------------
