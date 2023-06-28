;--------------------------------------------------------
;
; TODO:
;  swap R register low/high => save 2 instructions, 1 cycle / READ
;  do not always load IMMEDIATE, save 2 instructions, 4 cycles in S0 cycles (and if/when READ_OPCODE used elsewhere)
;  DONE! use direct computed goto to x 64 => save 2 cycles,
;  DONE! move computed goto to video interrput, save 2 cycles
;  do complete cycle analyzes, including video interrupt
; something extra in video generation
; EF2 for casette in
;

     list       
;
     radix      dec
;
		INCLUDE p18cxxx.inc
;
; MEMORY usage in emulation mode (no USB):
;
; RAM   0x0000 0x0100 1 pg 1802 registers and state
;       0x0100 0x0700 7 pg 1.75 kB, Emulated 1802 RAM (emulated address 0x0000)
;
; Flash
; 	0x4000 0x4000 16 kB 1802 instruction emulation code
;	0x2000 0x1000  4 kB Cosmac ROM (emulation address 0x8000)
;
;--------------------------------------------------------
;
;
		extern	video_on
		extern 	video_off
		extern	BEEP_CNTR
;
QLED_PORT	EQU	LATC 
QLED_TRIS	EQU	TRISC 
QLED_BIT	EQU   	2
;
BEEP_PORT	EQU 	LATC
BEEP_TRIS	EQU 	TRISC
BEEP_BIT	EQU	1	

;
		global  init_cdp1802
		global  exec_one_cycle
		global	load_code
		global	test_key
;
		global PCLATLX
		global PCLATHX

;
		global REG0_0, REG0_1
		global REG1_0, REG1_1
		global REG2_0, REG2_1
		global REG3_0, REG3_1
		global REG4_0, REG4_1
		global REG5_0, REG5_1
		global REG6_0, REG6_1
		global REG7_0, REG7_1
		global REG8_0, REG8_1
		global REG9_0, REG9_1
		global REGA_0, REGA_1
		global REGB_0, REGB_1
		global REGC_0, REGC_1
		global REGD_0, REGD_1
		global REGE_0, REGE_1
		global REGF_0, REGF_1

;
		global REG_D
		global REG_DF
		global REG_P
		global REG_N
		global REG_X
		global REG_T
;		global REG_IE
		global REG_Q
		global REG_INTF
;
		global INPUT_EF1
		global INPUT_EF2
		global INPUT_EF3
		global INPUT_EF4
;
		global opcode_00
		global opcode_01
		global opcode_02
		global opcode_03
		global opcode_04
		global opcode_05
		global opcode_06
		global opcode_07
		global opcode_08
		global opcode_09
		global opcode_0A
		global opcode_0B
		global opcode_0C
		global opcode_0D
		global opcode_0E
		global opcode_0F
		global opcode_10
		global opcode_11
		global opcode_12
		global opcode_13
		global opcode_14
		global opcode_15
		global opcode_16
		global opcode_17
		global opcode_18
		global opcode_19
		global opcode_1A
		global opcode_1B
		global opcode_1C
		global opcode_1D
		global opcode_1E
		global opcode_1F
		global opcode_20
		global opcode_21
		global opcode_22
		global opcode_23
		global opcode_24
		global opcode_25
		global opcode_26
		global opcode_27
		global opcode_28
		global opcode_29
		global opcode_2A
		global opcode_2B
		global opcode_2C
		global opcode_2D
		global opcode_2E
		global opcode_2F
		global opcode_30
		global opcode_31
		global opcode_32
		global opcode_33
		global opcode_34
		global opcode_35
		global opcode_36
		global opcode_37
		global opcode_38
		global opcode_39
		global opcode_3A
		global opcode_3B
		global opcode_3C
		global opcode_3D
		global opcode_3E
		global opcode_3F
		global opcode_40
		global opcode_41
		global opcode_42
		global opcode_43
		global opcode_44
		global opcode_45
		global opcode_46
		global opcode_47
		global opcode_48
		global opcode_49
		global opcode_4A
		global opcode_4B
		global opcode_4C
		global opcode_4D
		global opcode_4E
		global opcode_4F
		global opcode_50
		global opcode_51
		global opcode_52
		global opcode_53
		global opcode_54
		global opcode_55
		global opcode_56
		global opcode_57
		global opcode_58
		global opcode_59
		global opcode_5A
		global opcode_5B
		global opcode_5C
		global opcode_5D
		global opcode_5E
		global opcode_5F
		global opcode_60
		global opcode_61
		global opcode_62
		global opcode_63
		global opcode_64
		global opcode_65
		global opcode_66
		global opcode_67
		global opcode_68
		global opcode_69
		global opcode_6A
		global opcode_6B
		global opcode_6C
		global opcode_6D
		global opcode_6E
		global opcode_6F
		global opcode_70
		global opcode_71
		global opcode_72
		global opcode_73
		global opcode_74
		global opcode_75
		global opcode_76
		global opcode_77
		global opcode_78
		global opcode_79
		global opcode_7A
		global opcode_7B
		global opcode_7C
		global opcode_7D
		global opcode_7E
		global opcode_7F
		global opcode_80
		global opcode_81
		global opcode_82
		global opcode_83
		global opcode_84
		global opcode_85
		global opcode_86
		global opcode_87
		global opcode_88
		global opcode_89
		global opcode_8A
		global opcode_8B
		global opcode_8C
		global opcode_8D
		global opcode_8E
		global opcode_8F
		global opcode_90
		global opcode_91
		global opcode_92
		global opcode_93
		global opcode_94
		global opcode_95
		global opcode_96
		global opcode_97
		global opcode_98
		global opcode_99
		global opcode_9A
		global opcode_9B
		global opcode_9C
		global opcode_9D
		global opcode_9E
		global opcode_9F
		global opcode_A0
		global opcode_A1
		global opcode_A2
		global opcode_A3
		global opcode_A4
		global opcode_A5
		global opcode_A6
		global opcode_A7
		global opcode_A8
		global opcode_A9
		global opcode_AA
		global opcode_AB
		global opcode_AC
		global opcode_AD
		global opcode_AE
		global opcode_AF
		global opcode_B0
		global opcode_B1
		global opcode_B2
		global opcode_B3
		global opcode_B4
		global opcode_B5
		global opcode_B6
		global opcode_B7
		global opcode_B8
		global opcode_B9
		global opcode_BA
		global opcode_BB
		global opcode_BC
		global opcode_BD
		global opcode_BE
		global opcode_BF
		global opcode_C0
		global opcode_C1
		global opcode_C2
		global opcode_C3
		global opcode_C4
		global opcode_C5
		global opcode_C6
		global opcode_C7
		global opcode_C8
		global opcode_C9
		global opcode_CA
		global opcode_CB
		global opcode_CC
		global opcode_CD
		global opcode_CE
		global opcode_CF
		global opcode_D0
		global opcode_D1
		global opcode_D2
		global opcode_D3
		global opcode_D4
		global opcode_D5
		global opcode_D6
		global opcode_D7
		global opcode_D8
		global opcode_D9
		global opcode_DA
		global opcode_DB
		global opcode_DC
		global opcode_DD
		global opcode_DE
		global opcode_DF
		global opcode_E0
		global opcode_E1
		global opcode_E2
		global opcode_E3
		global opcode_E4
		global opcode_E5
		global opcode_E6
		global opcode_E7
		global opcode_E8
		global opcode_E9
		global opcode_EA
		global opcode_EB
		global opcode_EC
		global opcode_ED
		global opcode_EE
		global opcode_EF
		global opcode_F0
		global opcode_F1
		global opcode_F2
		global opcode_F3
		global opcode_F4
		global opcode_F5
		global opcode_F6
		global opcode_F7
		global opcode_F8
		global opcode_F9
		global opcode_FA
		global opcode_FB
		global opcode_FC
		global opcode_FD
		global opcode_FE
		global opcode_FF

;--------------------------------------------------------
;    Global variables
;--------------------------------------------------------
;
		UDATA
;
REG0_0		res 1
REG0_1		res 1
REG1_0		res 1
REG1_1		res 1
REG2_0		res 1
REG2_1		res 1
REG3_0		res 1
REG3_1		res 1
REG4_0		res 1
REG4_1		res 1
REG5_0		res 1
REG5_1		res 1
REG6_0		res 1
REG6_1		res 1
REG7_0		res 1
REG7_1		res 1
REG8_0		res 1
REG8_1		res 1
REG9_0		res 1
REG9_1		res 1
REGA_0		res 1
REGA_1		res 1
REGB_0		res 1
REGB_1		res 1
REGC_0		res 1
REGC_1		res 1
REGD_0		res 1
REGD_1		res 1
REGE_0		res 1
REGE_1		res 1
REGF_0		res 1
REGF_1		res 1
REG_D 		res 1
REG_DF		res 1
REG_P 		res 1
REG_N 		res 1
REG_I 		res 1
REG_X 		res 1
REG_T 		res 1
;REG_IE		res 1
REG_Q 		res 1
REG_INTF 	res 1
INPUT_EF1   	res 1
INPUT_EF2   	res 1
INPUT_EF3   	res 1
INPUT_EF4   	res 1
OPCODE		res 1
TEMP		res 1
TEMP2		res 1
FORCE_A15	res 1
;SAVE_FSR0L	res 1
;SAVE_FSR1L	res 1
;SAVE_FSR1H	res 1
PCLATHX		res 1
PCLATLX		res 1
OUTPUT62	res 1
SCANMASK	res 1
;
REGS_END
;
REGS EQU REG0_1
;
;
;--------------------------------------------------------
;
DEBUG1P		MACRO

		BSF LATD,1
		BCF LATD,1
		ENDM
DEBUG1S		MACRO

		BSF LATD,1
		ENDM
DEBUG1C		MACRO

		BCF LATD,1
		ENDM

DEBUG2P		MACRO

		BSF LATB,4
		BCF LATB,4
		ENDM
DEBUG2S		MACRO

		BSF LATB,4
		ENDM
DEBUG2C		MACRO

		BCF LATB,4
		ENDM
;
;--------------------------------------------------------
;
SET_IE          macro X
	IF X
		BCF REG_INTF,1
	ELSE
		BSF REG_INTF,1
	ENDIF
		endm
;
;--------------------------------------------------------
; FIXME this is duplicated int cdp1861.asm
SET_INT         macro  X
	IF X
		BCF REG_INTF,0
	ELSE
		BSF REG_INTF,0
	ENDIF
		endm
;
;--------------------------------------------------------
;
INPUT           macro N
		endm
;
;--------------------------------------------------------
;
OUTPUT          macro N
                INCREMENT_X
		endm
;
;--------------------------------------------------------
;
SHORT_BRANCH	macro
		GOTO    noShortBranch
		GOTO    shortBranch
		endm
;
;--------------------------------------------------------
;
LONG_BRANCH	macro
		GOTO    noLongBranch
		GOTO    longBranch
		endm
;
;--------------------------------------------------------
;
LONG_SKIP	macro
		GOTO    noLongSkip
		GOTO    longSkip

		FILLN(26)

		endm
;
;--------------------------------------------------------
;
LOAD_R_TO_FSR0	macro N
;
		MOVLW       2*N
		MOVWF       FSR0L           ; FRS0 points to REGS[W]
;
		endm
;
;--------------------------------------------------------
;
LOAD_P_TO_FSR0	macro
;
		MOVFF       REG_P, FSR0L        ; get P  to FSR0
		RLNCF       FSR0L, f         ; multiply by 2, FSR0 now points to M[P]
;
		endm
;
;--------------------------------------------------------
;
LOAD_X_TO_FSR0	macro
		MOVFF       REG_X, FSR0L        ; get X register to W
		RLNCF       FSR0L, f         ; multiply by 2
		endm
;
;--------------------------------------------------------
;
INCREMENT_R	macro   N
		INCF    REG0_0+2*N, f
		BNC     $+4
		INCF    REG0_1+2*N, f
		endm
;
;--------------------------------------------------------
;
DECREMENT_R	macro   N
		DECF    REG0_0+2*N, f
		BC      $+4
		DECF    REG0_1+2*N, f
		endm
;
;--------------------------------------------------------
;
INCREMENT_P    	macro
		LOAD_P_TO_FSR0
		INCF    INDF0, f
		BNC     $+4
		INCF    PREINC0, f
		endm
;
;--------------------------------------------------------
;
INCREMENT_X    macro
		LOAD_X_TO_FSR0
		INCF    INDF0, f
		BNC     $+4
		INCF    PREINC0, f
		endm
;
;--------------------------------------------------------
;
DECREMENT_X    	macro
		LOAD_X_TO_FSR0
		DECF    INDF0, f
		BC      $+4
		DECF    PREINC0, f
		endm
;
;--------------------------------------------------------
;
;
ROM_ADDRESS 	EQU	0x2000
ROM_SIZE 	EQU	0x1000
;
;--------------------------------------------------------
;
;
		CODE
;
;
;--------------------------------------------------------
;
reset_vector:   CODE    0x000000
;
	IFNDEF TARGET_DEBUG
		EXTERN	main_program
		GOTO main_program
	ELSE
		GOTO test0
		
                ORG 0x1000
;
	IF 0
		ORG 0x2000
		DB 0xF8, 0x07, 0xA3, 0xF8, 0x80, 0xB3, 0xD3, 0x64, 0xF8, 0x80, 0xB1, 0xF8, 0x82, 0xA1, 0xF8, 0x03
		DB 0xB2, 0xF8, 0xFF, 0xA2, 0xE2, 0x69, 0x7B, 0x7A, 0x30, 0x16 ;
		ORG 0x2080
		DB 0x72, 0x70, 0x22, 0x78, 0x22, 0x52, 0xF8, 0x01, 0x30, 0x80, 0x30, 0x80, 0xB0, 0xF8, 0x00, 0xA0, 0xC4, 0xC4, 0xE2
		DB 0x80, 0xE2, 0x20, 0xA0, 0xE2, 0x20, 0xA0, 0xE2, 0x20, 0xA0, 0x3C, 0x8F, 0x30, 0x80
	ELIF 0
		ORG 0x2000
		DB 0xF8, 0x06, 0xA3, 0xF8, 0x80, 0xB3, 0xD3, 0x64, 0xF8, 0x80, 0xB1, 0xF8, 0x82, 0xA1, 0xF8, 0x03
		DB 0xB2, 0xF8, 0xFF, 0xA2, 0xE2, 0x69, 0x30, 0x16 ; ,0x7B, 0x7A,
		ORG 0x2080
		DB 0x72, 0x70, 0xC4, 0x22, 0x78, 0x22, 0x52, 0xF8, 0x01, 0x3C, 0x89, 0x30, 0x80, 0xB0, 0xF8, 0x00, 0xA0, 0xC4, 0xC4, 0xE2
		DB 0x80, 0xE2, 0x20, 0xA0, 0xE2, 0x20, 0xA0, 0xE2, 0x20, 0xA0, 0x3C, 0x8F, 0x30, 0x80
	ELIF 0
		ORG 0x2000
		DB 0xF8, 0x06, 0xA3, 0xF8, 0x80, 0xB3, 0xD3, 0x64, 0xF8, 0x80, 0xB1, 0xF8, 0x82, 0xA1, 0xF8, 0x03
		DB 0xB2, 0xF8, 0xFF, 0xA2, 0xE2, 0x69, 0x7B, 0x7A, 0x30, 0x16
		ORG 0x2080
		DB 0x72, 0x70, 0xC4, 0x22, 0x78, 0x22, 0x52, 0xF8, 0x01, 0xB0, 0xF8, 0x00, 0xA0, 0xC4, 0xC4, 0xE2
		DB 0x80, 0xE2, 0x20, 0xA0, 0xE2, 0x20, 0xA0, 0xE2, 0x20, 0xA0, 0x34, 0x8F, 0x30, 0x80
	ELIF 0
		ORG 0x2000
		DB 0xF8, 0x80, 0xB2, 0xF8, 0x40, 0xA2, 0xE2, 0xF8, 0x3C, 0xF1, 0x68
		ORG 0x2040
		DB 0xF0
	ELIF 0
		ORG 0x2000
		DB 0x7B, 0xF8, 0x00, 0xA1, 0xFF, 0x01, 0x3A, 0x04, 0x81, 0xFF, 0x01, 0x3A, 0x03, 0x7A, 0xF8, 0x00
		DB 0xA1, 0xFF, 0x01, 0x3A, 0x11, 0x81, 0xFF, 0x01, 0x3A, 0x10, 0x30, 0x1C, 0x68
	ELIF 0
		ORG 0x2000
		DB 0xF8, 0x06, 0xA3, 0xF8, 0x80, 0xB3, 0xD3, 0x64, 0xF8, 0x80, 0xB1, 0xF8, 0x82, 0xA1, 0xF8, 0x03
		DB 0xB2, 0xF8, 0xFF, 0xA2, 0xE2, 0x69, 0x7B, 0x7A, 0x30, 0x16
		ORG 0x2080
		DB 0x72, 0x70, 0xC4, 0x22, 0x78, 0x22, 0x52, 0xF8, 0x01, 0xB0, 0xF8, 0x00, 0xA0, 0xC4, 0xC4, 0xE2
		DB 0x80, 0xE2, 0x20, 0xA0, 0xE2, 0x20, 0xA0, 0xE2, 0x20, 0xA0, 0x34, 0x8F, 0x30, 0x80
	ENDIF
;
.sim macro x
  		.direct "e", x
  		endm
;
  		.sim "break e opcode_68"
  		.sim "break e afterfetch"
  		.sim "r macro"
  		.sim "run"
  		.sim "FORCE_A15"
  		.sim "REG_X"
  		.sim "REG_P"
  		.sim "REG1_1"
  		.sim "REG1_0"
  		.sim "REG2_1"
  		.sim "REG2_0"
  		.sim "REG3_1"
  		.sim "REG3_0"
  		.sim "OPCODE"
  		.sim "endm"

  		.sim "run"
		GLOBAL	testloop,afterfetch
test0:
		call		init_cdp1802
testloop:

		call		exec_one_cycle
afterfetch:
		call		exec_one_cycle
		GOTO		testloop
;
		ENDIF
;
;--------------------------------------------------------
;
NEXT_STATE	MACRO label
		MOVLW HIGH(label)
		MOVWF PCLATHX
		MOVLW LOW(label)
		MOVWF PCLATLX
		ENDM
;
;--------------------------------------------------------
;
EXEC_DONE	MACRO
		NEXT_STATE(exec_state_0)
		RETFIE 0
		ENDM
;
;--------------------------------------------------------
;
; opcode decode jump table
;
		org     0x1800

;--------------------------------------------------------
; 
; r = row 0..3 from near to far
; c = column 0..3 from left to right
;
; scan scan_table:
; First byte PORT A0-A3, output one line low at a time
; Second byte to PORT B3-B7, input with pull ups, key pulls line down
;
scan_table	
		DB 0x0E,0x20 ; r/c 0/1 key 0
		DB 0x07,0x10 ; r/c 3/0 key 1
		DB 0x07,0x20 ; r/c 3/1 key 2
		DB 0x07,0x40 ; r/c 3/2 key 3

		DB 0x0B,0x10 ; r/c 2/0 key 4
		DB 0x0B,0x20 ; r/c 2/1 key 5
		DB 0x0B,0x40 ; r/c 2/2 key 6
		DB 0x0D,0x10 ; r/c 1/0 key 7
		
		DB 0x0D,0x20 ; r/c 1/1 key 8
		DB 0x0D,0x40 ; r/c 1/2 key 9
		DB 0x0E,0x10 ; r/c 0/0 key A
		DB 0x0E,0x40 ; r/c 0/2 key B
		
		DB 0x07,0x80 ; r/c 3/3 key C
		DB 0x0B,0x80 ; r/c 2/3 key D
		DB 0x0D,0x80 ; r/c 1/3 key E
		DB 0x0E,0x80 ; r/c 0/3 key F
				
TEST_KEY		MACRO
		LOCAL 	label
		
		BCF	INPUT_EF3, 0
		MOVLW	0xF0
		ANDWF	OUTPUT62, w
		BNZ	label
		
		MOVF 	OUTPUT62, w
		RLNCF 	WREG
		MOVWF 	TBLPTRL
		MOVLW 	HIGH(scan_table)
		MOVWF 	TBLPTRH
		
		TBLRD 	*+			
		MOVF	LATA, w
		ANDLW	0xF0
		IORWF	TABLAT, w
		MOVWF	LATA

		TBLRD 	*+				
		MOVF	PORTB, w
		ANDWF	TABLAT, w
		
		BNZ	label
		BSF	INPUT_EF3, 0
label		
		ENDM			
;
;--------------------------------------------------------
;
test_key
		CALL	check_key
		BZ	no_key
;		
		BSF QLED_PORT, QLED_BIT   	; Q-LED = 0
		BCF BEEP_TRIS, BEEP_BIT 	; make the BEEP pin output
test_key_loop
		DCFSNZ	BEEP_CNTR, f, b
		BTG	BEEP_PORT, BEEP_BIT
		CALL	wait_key
		BNZ	test_key_loop	
		ADDLW	1	
		BCF QLED_PORT, QLED_BIT   	; Q-LED = 0
		BSF BEEP_TRIS, BEEP_BIT 	; make the BEEP pin input
no_key		
		RETURN
;
check_key
		MOVWF	OUTPUT62
wait_key
		TEST_KEY
		MOVF	INPUT_EF3, w
		RETURN					
;
;--------------------------------------------------------

init_cdp1802:
;
		LFSR	FSR0, 0x700
;

clrloop:
		CLRF	POSTINC0
        	BTFSS	FSR0H,3         ; bit 3 tells us that 8 banks = 2 kB has been cleared
		BRA	clrloop
;
		CLRF	TBLPTRU 	; all through code expect TBLPTRU = 0x00
		LFSR  	FSR0, 0x700
		MOVLB	7
;
		MOVLW		0x80 	; FORCE_A15 simulates Telmac monitor ROM address decoding
		MOVwF		FORCE_A15
;
		SET_IE  1
		SET_INT 0

		NEXT_STATE(exec_state_0)
;
		BCF	QLED_TRIS, QLED_BIT
;
		CALL	init_keyinp
;	
		RETURN
;
;--------------------------------------------------------
;		
		GLOBAL	init_keyinp
init_keyinp
		CLRF	INPUT_EF3 
;
		MOVF	TRISA, w	; PORTA0-PORTA3 = outputs
		ANDLW	0xF0
		MOVWF	TRISA 
;
		MOVF	TRISB, w	; PORTB4-PORTB7 = inputs
		IORLW	0xF0
		MOVWF	TRISB 
;
		BCF	INTCON2, 7	; Turn on (weak) pull-ups for PORTB
;
		RETURN
;
;--------------------------------------------------------
;		
load_code		
		TBLRD   *-		
		TBLRD   *-		
		TBLRD   *+		
		MOVFF   TABLAT, FSR1L		
		TBLRD   *+		
		MOVFF   TABLAT, FSR1H		
loop		
		TBLRD   *+		
		MOVFF   TABLAT, POSTINC0
		MOVF	POSTDEC1, w, a
		MOVF	FSR1L, w, a
		IORWF	FSR1H, w, a
		BNZ	loop
;
;	
                RETURN
;
;--------------------------------------------------------
;
READ_MEMORY_X	macro
		MOVFF REG_X, FSR0L
		READ_MEMORY
		endm
;
;--------------------------------------------------------
;
;
; on entry FSR0L contains N = 0..15 ie the register number
;
READ_MEMORY	macro
		local 		ram_read,rom_read,read_done
;
		RLNCF       	FSR0L, f    		; W = W * 2
		MOVF        	PREINC0, w		; move RN.1 to W
		IORWF		FORCE_A15, w		; OR address modifier
		BN         	rom_read		; if RN >= 0x8000 then this is ROM address
ram_read
		MOVWF   	FSR1H		; move it to the FSR1H
		DECF		FSR0L, f		; read RN.0 move it to the FSR1L
		MOVFF       	INDF0, FSR1L		; leave PSR0 to point RN.0
		MOVF		INDF1, w
		BRA             read_done
rom_read
		ADDLW		HIGH(ROM_ADDRESS-0x8000); add the ROM start address
		MOVWF       	TBLPTRH		; set the table pointer high address
		DECF		FSR0L, f		; read RN.0 move it to the FSR1L
		MOVFF       	INDF0, TBLPTRL		;
		TBLRD       	*			; read the data from ROM to TABLAT
		MOVF       	TABLAT, w		; move the ROM data to W
read_done
		endm
;
;--------------------------------------------------------
;
; 21 cycle (worst case ROM read)
;
READ_OPCODE	macro
		local 		ram_read,rom_read,read_done
		MOVFF 		REG_P, FSR0L
		RLNCF       	FSR0L, f    		; W = W * 2

		MOVF		POSTINC0, w		; move R(P).0 to W
		MOVWF		FSR1L
		MOVWF		TBLPTRL

		MOVF        	POSTDEC0, w		; move R(P).1 to W, restore FSR0L
		IORWF		FORCE_A15, w		; OR address modifier
		BN         	rom_read		; if RN >= 0x8000 then this is ROM address
ram_read:
		MOVWF   	FSR1H		; move it to the FSR1H
		MOVF		POSTINC1, w		; read opcode to W and next byte to IMMEDIATE
		BRA             read_done
rom_read:
		ADDLW		HIGH(ROM_ADDRESS-0x8000); add the ROM start address
		MOVWF       	TBLPTRH		; set the table pointer high address
		TBLRD       	*+			; read opcode to W  and next byte to IMMEDIATE
		MOVF       	TABLAT, w		;
read_done:
		INCF    INDF0, f			; increment R[P]
		BNC     $+4
		INCF    PREINC0, f
;

;
		endm
;
;--------------------------------------------------------
;
READ_IMMEDIATE	macro
		READ_OPCODE
		endm
;
;--------------------------------------------------------
;
READ_MEMORY_R	macro		N
		local 		ram_read,rom_read,read_done

		MOVLW       	2*N    			; W = N * 2
		MOVWF       	FSR0L      		; FRS0 now points to REGS[N]
		MOVF        	PREINC0, w		; move RN.1 to W
		IORWF		FORCE_A15, w		; OR address modifier
		BN         	rom_read		; if RN >= 0x8000 then this is ROM address
ram_read
		MOVWF   	FSR1H		; move it to the FSR1H
		DECF		FSR0L, f		; read RN.0 move it to the FSR1L
		MOVFF       	INDF0, FSR1L
		MOVF		INDF1, w
		BRA             read_done
rom_read
		ADDLW		HIGH(ROM_ADDRESS-0x8000); add the ROM start address
		MOVWF       	TBLPTRH		; set the table pointer high address
		DECF		FSR0L, f		; read RN.0 move it to the FSR1L
		MOVFF       	INDF0, TBLPTRL		; read RN.0 move it to he table pointer low address
		TBLRD       	*			; read the data from ROM to TABLAT
		MOVF       	TABLAT, w		; move the ROM data to W
read_done
		endm
;
;--------------------------------------------------------
;
;
; on entry W contain N = 0..15 ie the register number
;
WRITE_MEMORY	macro
		RLNCF       	WREG, f    		; W = W * 2
		MOVWF       	FSR0L      		; FRS0 now points to REGS[N]
		MOVF        	PREINC0, w		; move RN.1 to W
;;; not really necessary		IORWF		FORCE_A15, w		; OR address modifier
;
		MOVWF   	FSR1H		; move it to the FSR1H
		DECF		FSR0L, f		; read RN.0 move it to the FSR1L
		MOVFF       	INDF0, FSR1L
		MOVFF		TEMP, INDF1
		endm
;
;--------------------------------------------------------
;
WRITE_MEMORY_R	macro		N
;
		MOVLW       	2*N	    		; W = N * 2
		MOVWF       	FSR0L      		; FRS0 now points to REGS[N]
		MOVF        	PREINC0, w		; move RN.1 to W
		IORWF		FORCE_A15, w		; OR address modifier
;
		MOVWF   	FSR1H		; move it to the FSR1H
		DECF		FSR0L, f		; read RN.0 move it to the FSR1L
		MOVFF       	INDF0, FSR1L
		MOVFF		TEMP, INDF1
		endm
;
;--------------------------------------------------------
;
; a call to this routine executes one 1802 cycle
; (2 or 3 cycles are required to execute one 1802 opcode)
;
; at this point we haves used max ~ 29 cycles
;
exec_one_cycle:

		MOVFF	PCLATHX, PCLATH
		MOVF	PCLATLX, w
		MOVWF   PCL
;
;--------------------------------------------------------
;
; read OPCODE from program counter and advance it
;
;--------------------------------------------------------
;
; fetch OPCODE
;
; at this point we have used max ~ 34 cycles
;
exec_state_0:
		MOVFF	REG0_0, FSR2L
		MOVFF	REG0_1, FSR2H
;
		MOVF	REG_INTF, w
		BZ	interrupt   ;
;
		READ_OPCODE
;
		MULLW 64
;
		MOVLW HIGH(0x4000)
		ADDWF PRODH, w
		MOVWF PCLATHX
		MOVFF PRODL, PCLATLX
;
;
		RETFIE 0           ;

wait_int:

		MOVF	REG_INTF, w
		BZ	interrupt   ;
		RETFIE 0           ;

interrupt:

		MOVLW 16
		MULWF REG_X
		MOVF PRODL, w
		IORWF REG_P, w
		MOVWF REG_T
;
		MOVLW  1
		MOVWF REG_P
;
		MOVLW  2
		MOVWF REG_X
;
		SET_IE  0
;
		NEXT_STATE(exec_interrupt)
		RETFIE 0
;--------------------------------------------------------
;
exec_interrupt:
		EXEC_DONE
;--------------------------------------------------------
;
exec_state_1x
		EXEC_DONE
;
;--------------------------------------------------------
;
longSkip
		INCREMENT_P
		NEXT_STATE(exec_longSkip)
		RETFIE 0
exec_longSkip
		INCREMENT_P
		EXEC_DONE
;--------------------------------------------------------
;
noLongSkip
		NEXT_STATE(exec_noLongSkip)
		RETFIE 0
exec_noLongSkip
		EXEC_DONE
;
;--------------------------------------------------------
;
longBranch
		READ_IMMEDIATE
		MOVWF TEMP2
		NEXT_STATE(exec_longBranch)
		RETFIE 0
exec_longBranch
		READ_OPCODE ; FIXME this does not have to increment P so this is subobtimal
		MOVWF TEMP
		LOAD_P_TO_FSR0
		MOVFF TEMP,POSTINC0
		MOVFF TEMP2,INDF0
		EXEC_DONE
;
;--------------------------------------------------------
;
noLongBranch
		READ_IMMEDIATE
		MOVWF TEMP2
		NEXT_STATE(exec_noLongBranch)
		RETFIE 0
exec_noLongBranch
		INCREMENT_P
		EXEC_DONE
;
;--------------------------------------------------------
;
shortBranch
		READ_IMMEDIATE
		LOAD_P_TO_FSR0
		MOVWF INDF0
		EXEC_DONE
;
;--------------------------------------------------------
;
noShortBranch
		INCREMENT_P
		EXEC_DONE
;
;--------------------------------------------------------
;
exec_longskip:
		EXEC_DONE
;--------------------------------------------------------
;
;
;
FILLN		MACRO N
		FILL 0xF000, N*2
		ENDM

;
;---------------------------------------
;
opcode_LDN	macro N
		READ_MEMORY_R(N)
		MOVWF	REG_D
		EXEC_DONE

		FILLN(7)

		endm
;
;---------------------------------------
;
opcode_LDA	macro N
		MOVLW N
		READ_MEMORY_R(N)
		MOVWF REG_D
		INCREMENT_R(N)
		EXEC_DONE

		FILLN(3)

		endm
;
;---------------------------------------
;
opcode_SEP	macro N

		MOVLW N
		MOVWF REG_P
		EXEC_DONE

		FILLN(25)

		endm
;
;---------------------------------------
;
opcode_SEX	macro N

		MOVLW N
		MOVWF REG_X
		EXEC_DONE

		FILLN(25)

		endm
;
;---------------------------------------
;
opcode_STR	macro N
		MOVFF REG_D,TEMP
		WRITE_MEMORY_R(N)
		EXEC_DONE

		FILLN(14)

		endm
;
;---------------------------------------
;
opcode_INC	macro N
		INCREMENT_R(N)
		EXEC_DONE

		FILLN(24)

		endm
;
;---------------------------------------
;
opcode_DEC	macro N
		DECREMENT_R(N)
		EXEC_DONE

		FILLN(24)

		endm
;
;---------------------------------------
;
opcode_GLO	macro N
		LOAD_R_TO_FSR0(N)
		MOVFF INDF0,REG_D
		EXEC_DONE

		FILLN(23)

		endm
;
;---------------------------------------
;
opcode_GHI	macro N
		LOAD_R_TO_FSR0(N)
		MOVFF PREINC0,REG_D
		EXEC_DONE

		FILLN(23)

		endm
;
;---------------------------------------
;
opcode_PLO	macro N
		LOAD_R_TO_FSR0(N)
		MOVFF REG_D,INDF0
		EXEC_DONE

		FILLN(23)

		endm
;
;---------------------------------------
;
opcode_PHI	macro 	N
		LOAD_R_TO_FSR0(N)
		MOVFF REG_D,PREINC0
		EXEC_DONE

		FILLN(23)

		endm
;
;---------------------------------------
;
		ORG 0x4000
opcode_00:
		NEXT_STATE(wait_int)
		RETFIE 0
;
;---------------------------------------
;
		ORG 0x4040
opcode_01:
		opcode_LDN(1)
;
;---------------------------------------
;
		ORG 0x4080
opcode_02:
		opcode_LDN(2)
;
;---------------------------------------
;
		ORG 0x40C0
opcode_03:
		opcode_LDN(3)
;
;---------------------------------------
;
		ORG 0x4100
opcode_04:
		opcode_LDN(4)
;
;---------------------------------------
;
		ORG 0x4140
opcode_05:
		opcode_LDN(5)

;---------------------------------------
;
		ORG 0x4180
opcode_06:
		opcode_LDN(6)
;
;---------------------------------------
;
		ORG 0x41C0
opcode_07:
		opcode_LDN(7)

;---------------------------------------
;
		ORG 0x4200
opcode_08:
		opcode_LDN(8)
;
;---------------------------------------
;
		ORG 0x4240
opcode_09:
		opcode_LDN(9)
;
;---------------------------------------
;
		ORG 0x4280
opcode_0A:
		opcode_LDN(10)
;
;---------------------------------------
;
		ORG 0x42C0
opcode_0B:
		opcode_LDN(11)
;
;---------------------------------------
;
		ORG 0x4300
opcode_0C:
		opcode_LDN(12)
;
;---------------------------------------
;
		ORG 0x4340
opcode_0D:
		opcode_LDN(13)
;
;---------------------------------------
;
		ORG 0x4380
opcode_0E:
		opcode_LDN(14)

;---------------------------------------
;
		ORG 0x43C0
opcode_0F:
		opcode_LDN(15)
;
;---------------------------------------
;
		ORG 0x4400
opcode_10:
		opcode_INC(0)
;
;---------------------------------------
;
		ORG 0x4440
opcode_11:
		opcode_INC(1)
;
;---------------------------------------
;
		ORG 0x4480
opcode_12:
		opcode_INC(2)
;
;---------------------------------------
;
		ORG 0x44C0
opcode_13:
		opcode_INC(3)
;
;---------------------------------------
;
		ORG 0x4500
opcode_14:
		opcode_INC(4)
;
;---------------------------------------
;
		ORG 0x4540
opcode_15:
		opcode_INC(5)

;---------------------------------------
;
		ORG 0x4580
opcode_16:
		opcode_INC(6)
;
;---------------------------------------
;
		ORG 0x45C0
opcode_17:
		opcode_INC(7)

;---------------------------------------
;
		ORG 0x4600
opcode_18:
		opcode_INC(8)
;
;---------------------------------------
;
		ORG 0x4640
opcode_19:
		opcode_INC(9)
;
;---------------------------------------
;
		ORG 0x4680
opcode_1A:
		opcode_INC(10)
;
;---------------------------------------
;
		ORG 0x46C0
opcode_1B:
		opcode_INC(11)
;
;---------------------------------------
;
		ORG 0x4700
opcode_1C:
		opcode_INC(12)
;
;---------------------------------------
;
		ORG 0x4740
opcode_1D:
		opcode_INC(13)
;
;---------------------------------------
;
		ORG 0x4780
opcode_1E:
		opcode_INC(14)

;---------------------------------------
;
		ORG 0x47C0
opcode_1F:
		opcode_INC(15)
;
;---------------------------------------
;
		ORG 0x4800
opcode_20:
		opcode_DEC(0)
;
;---------------------------------------
;
		ORG 0x4840
opcode_21:
		opcode_DEC(1)
;
;---------------------------------------
;
		ORG 0x4880
opcode_22:
		opcode_DEC(2)
;
;---------------------------------------
;
		ORG 0x48C0
opcode_23:
		opcode_DEC(3)
;
;---------------------------------------
;
		ORG 0x4900
opcode_24:
		opcode_DEC(4)
;
;---------------------------------------
;
		ORG 0x4940
opcode_25:
		opcode_DEC(5)

;---------------------------------------
;
		ORG 0x4980
opcode_26:
		opcode_DEC(6)
;
;---------------------------------------
;
		ORG 0x49C0
opcode_27:
		opcode_DEC(7)

;---------------------------------------
;
		ORG 0x4A00
opcode_28:
		opcode_DEC(8)
;
;---------------------------------------
;
		ORG 0x4A40
opcode_29:
		opcode_DEC(9)
;
;---------------------------------------
;
		ORG 0x4A80
opcode_2A:
		opcode_DEC(10)
;
;---------------------------------------
;
		ORG 0x4AC0
opcode_2B:
		opcode_DEC(11)
;
;---------------------------------------
;
		ORG 0x4B00
opcode_2C:
		opcode_DEC(12)
;
;---------------------------------------
;
		ORG 0x4B40
opcode_2D:
		opcode_DEC(13)
;
;---------------------------------------
;
		ORG 0x4B80
opcode_2E:
		opcode_DEC(14)

;---------------------------------------
;
		ORG 0x4BC0
opcode_2F:
		opcode_DEC(15)
;
;---------------------------------------
;
		ORG 0x4C00
opcode_30:
		BRA $+6
		SHORT_BRANCH
		FILLN(27)
;
;---------------------------------------
;
		ORG 0x4C40
opcode_31:
		MOVF		REG_Q, w
		BNZ $+6
		SHORT_BRANCH
		FILLN(26)
;
;---------------------------------------
;
		ORG 0x4C80
opcode_32:
		MOVF		REG_D, w
		BZ $+6
		SHORT_BRANCH
		FILLN(26)
;
;---------------------------------------
;
		ORG 0x4CC0
opcode_33:
		MOVF		REG_DF, w
		BNZ $+6
		SHORT_BRANCH
		FILLN(26)
;
;---------------------------------------
;
		ORG 0x4D00
opcode_34:
		MOVF		INPUT_EF1, w
		BNZ $+6
		SHORT_BRANCH
		FILLN(26)
;
;---------------------------------------
;
		ORG 0x4D40
opcode_35:
		MOVF		INPUT_EF2, w
		BNZ $+6
		SHORT_BRANCH
		FILLN(26)
;
;---------------------------------------
;
		ORG 0x4D80
opcode_36:
		TEST_KEY
		MOVF		INPUT_EF3, w
		BNZ $+6
		SHORT_BRANCH
		FILLN(5)
;
;---------------------------------------
;
		ORG 0x4DC0
opcode_37:
		MOVF		INPUT_EF4, w
		BNZ $+6
		SHORT_BRANCH
		FILLN(26)
;
;---------------------------------------
;
		ORG 0x4E00
opcode_38:
		SHORT_BRANCH
		FILLN(28)
;
;---------------------------------------
;
		ORG 0x4E40
opcode_39:
		MOVF		REG_Q, w
		BZ $+6
		SHORT_BRANCH
		FILLN(26)
;
;---------------------------------------
;
		ORG 0x4E80
opcode_3A:
		MOVF		REG_D, w
		BNZ $+6
		SHORT_BRANCH
		FILLN(26)
;
;---------------------------------------
;
		ORG 0x4EC0
opcode_3B:
		MOVF		REG_DF, w
		BZ $+6
		SHORT_BRANCH
		FILLN(26)
;
;---------------------------------------
;
		ORG 0x4F00
opcode_3C:

		MOVF		INPUT_EF1, w
		BZ $+6
		SHORT_BRANCH
		FILLN(26)
;
;---------------------------------------
;
		ORG 0x4F40
opcode_3D:
		MOVF		INPUT_EF2, w
		BZ $+6
		SHORT_BRANCH
		FILLN(26)
;
;---------------------------------------
;
		ORG 0x4F80
opcode_3E:
		TEST_KEY
		MOVF		INPUT_EF3, w
		BZ $+6
		SHORT_BRANCH
		FILLN(5)
;
;---------------------------------------
;
		ORG 0x4FC0
opcode_3F:
		MOVF		INPUT_EF4, w
		BZ $+6
		SHORT_BRANCH
		FILLN(26)
;
;---------------------------------------
;
		ORG 0x5000
opcode_40:
		opcode_LDA(0)
;
;---------------------------------------
;
		ORG 0x5040
opcode_41:
		opcode_LDA(1)
;
;---------------------------------------
;
		ORG 0x5080
opcode_42:
		opcode_LDA(2)
;
;---------------------------------------
;
		ORG 0x50C0
opcode_43:
		opcode_LDA(3)
;
;---------------------------------------
;
		ORG 0x5100
opcode_44:
		opcode_LDA(4)
;
;---------------------------------------
;
		ORG 0x5140
opcode_45:
		opcode_LDA(5)

;---------------------------------------
;
		ORG 0x5180
opcode_46:
		opcode_LDA(6)
;
;---------------------------------------
;
		ORG 0x51C0
opcode_47:
		opcode_LDA(7)

;---------------------------------------
;
		ORG 0x5200
opcode_48:
		opcode_LDA(8)
;
;---------------------------------------
;
		ORG 0x5240
opcode_49:
		opcode_LDA(9)
;
;---------------------------------------
;
		ORG 0x5280
opcode_4A:
		opcode_LDA(10)
;
;---------------------------------------
;
		ORG 0x52C0
opcode_4B:
		opcode_LDA(11)
;
;---------------------------------------
;
		ORG 0x5300
opcode_4C:
		opcode_LDA(12)
;
;---------------------------------------
;
		ORG 0x5340
opcode_4D:
		opcode_LDA(13)
;
;---------------------------------------
;
		ORG 0x5380
opcode_4E:
		opcode_LDA(14)

;---------------------------------------
;
		ORG 0x53C0
opcode_4F:
		opcode_LDA(15)
;
;---------------------------------------
;
		ORG 0x5400
opcode_50:
		opcode_STR(0)
;
;---------------------------------------
;
		ORG 0x5440
opcode_51:
		opcode_STR(1)
;
;---------------------------------------
;
		ORG 0x5480
opcode_52:
		opcode_STR(2)
;
;---------------------------------------
;
		ORG 0x54C0
opcode_53:
		opcode_STR(3)
;
;---------------------------------------
;
		ORG 0x5500
opcode_54:
		opcode_STR(4)
;
;---------------------------------------
;
		ORG 0x5540
opcode_55:
		opcode_STR(5)

;---------------------------------------
;
		ORG 0x5580
opcode_56:
		opcode_STR(6)
;
;---------------------------------------
;
		ORG 0x55C0
opcode_57:
		opcode_STR(7)

;---------------------------------------
;
		ORG 0x5600
opcode_58:
		opcode_STR(8)
;
;---------------------------------------
;
		ORG 0x5640
opcode_59:
		opcode_STR(9)
;
;---------------------------------------
;
		ORG 0x5680
opcode_5A:
		opcode_STR(10)
;
;---------------------------------------
;
		ORG 0x56C0
opcode_5B:
		opcode_STR(11)
;
;---------------------------------------
;
		ORG 0x5700
opcode_5C:
		opcode_STR(12)
;
;---------------------------------------
;
		ORG 0x5740
opcode_5D:
		opcode_STR(13)
;
;---------------------------------------
;
		ORG 0x5780
opcode_5E:
		opcode_STR(14)

;---------------------------------------
;
		ORG 0x57C0
opcode_5F:
		opcode_STR(15)
;
;---------------------------------------
;
		ORG 0x5800
opcode_60:
		INCREMENT_X
		EXEC_DONE
;
;---------------------------------------
;
		ORG 0x5840
opcode_61:
		OUTPUT(1)
		CALL video_off
		EXEC_DONE
;
;---------------------------------------
;
		ORG 0x5880
opcode_62:
		READ_MEMORY_X
		MOVWF OUTPUT62
		INCREMENT_X
		EXEC_DONE
;
;---------------------------------------
;
		ORG 0x58C0
opcode_63:
		OUTPUT(3)
		EXEC_DONE
;
;---------------------------------------
;
		ORG 0x5900
opcode_64:
		OUTPUT(4)
		CLRF FORCE_A15
		EXEC_DONE
;
;---------------------------------------
;
		ORG 0x5940
opcode_65:
		OUTPUT(5)
		EXEC_DONE
;
;---------------------------------------
;
		ORG 0x5980
opcode_66:
		OUTPUT(6)
		EXEC_DONE
;
;---------------------------------------
;
		ORG 0x59C0
opcode_67:
		OUTPUT(7)
		EXEC_DONE
;
;---------------------------------------
;
		ORG 0x5A00
opcode_68:

		DECREMENT_R 3

		EXEC_DONE
;
;---------------------------------------
;
		ORG 0x5A40
opcode_69:
		INPUT(1)
		CALL video_on
		EXEC_DONE
;
;---------------------------------------
;
		ORG 0x5A80
opcode_6A:
		INPUT(2)
		EXEC_DONE
;
;---------------------------------------
;
		ORG 0x5AC0
opcode_6B:
		INPUT(3)
		EXEC_DONE
;
;---------------------------------------
;
		ORG 0x5B00
opcode_6C:
		INPUT(4)
		EXEC_DONE
;
;---------------------------------------
;
		ORG 0x5B40
opcode_6D:
		INPUT(5)
		EXEC_DONE
;
;---------------------------------------
;
		ORG 0x5B80
opcode_6E:
		INPUT(6)
		EXEC_DONE
;
;---------------------------------------
;
		ORG 0x5BC0
opcode_6F:
		INPUT(7)
		EXEC_DONE
;
;---------------------------------------
;
opcode_70_done:
opcode_71_done:
		MOVWF REG_T
		MOVWF REG_P
		MOVWF REG_X

		SWAPF REG_X, f

		MOVLW 0xF
		ANDWF REG_X, f
		ANDWF REG_P, f

		EXEC_DONE

;---------------------------------------
;
		ORG 0x5C00
opcode_70:
		READ_MEMORY_X

		INCF    INDF0, f
		BNC     $+4
		INCF    PREINC0, f

		SET_IE 1

		BRA opcode_70_done
;
;---------------------------------------
;
		ORG 0x5C40
opcode_71:
		READ_MEMORY_X

		INCF    INDF0, f
		BNC     $+4
		INCF    PREINC0, f

		SET_IE  0

		BRA opcode_71_done
;
;---------------------------------------
;
		ORG 0x5C80
opcode_72:
		READ_MEMORY_X
		MOVWF	REG_D
		INCREMENT_X
		EXEC_DONE
;
;---------------------------------------
;
		ORG 0x5CC0
opcode_73:
		MOVFF REG_D,TEMP
		MOVF REG_X, w
		WRITE_MEMORY
		DECREMENT_X
		EXEC_DONE
;
;---------------------------------------
;
		ORG 0x5D00
opcode_74:
		READ_MEMORY_X
		MOVWF TEMP
		RRCF REG_DF, w
		MOVF TEMP, w
		ADDWFC REG_D, f
		CLRF REG_DF
		RLCF REG_DF, f
		EXEC_DONE
;
;---------------------------------------
;
		ORG 0x5D40
opcode_75:
		READ_MEMORY_X
		MOVWF TEMP
		RRCF REG_DF, w
		MOVF TEMP, w
		SUBFWB REG_D, f
		CLRF REG_DF
		RLCF REG_DF, f
		EXEC_DONE
;
;---------------------------------------
;
		ORG 0x5D80
opcode_76:
		RRCF REG_DF ,w 
		RRCF REG_D, f
		CLRF REG_DF
		RLCF REG_DF, f
		EXEC_DONE
;
;---------------------------------------
;
		ORG 0x5DC0
opcode_77:
		READ_MEMORY_X
		MOVWF TEMP
		RRCF REG_DF, w
		MOVF TEMP, w
		SUBWFB REG_D, f
		CLRF REG_DF
		RLCF REG_DF, f
		EXEC_DONE
;
;---------------------------------------
;
		ORG 0x5E00
opcode_78:
		MOVFF REG_T,TEMP
		MOVF REG_X, w
		WRITE_MEMORY
		EXEC_DONE
;
;---------------------------------------
;
		ORG 0x5E40
opcode_79:
		MOVF REG_X, w
		MULLW 16
		MOVF REG_P, w
		IORWF PRODL, w
		MOVWF REG_T
		MOVFF REG_T,TEMP
		WRITE_MEMORY_R(2)
		MOVFF REG_P,REG_X
		DECREMENT_R(2)
		EXEC_DONE
;
;---------------------------------------
;
		ORG 0x5E80
opcode_7A:
		BCF REG_Q, 0
		BCF QLED_PORT, QLED_BIT   	; Q-LED = 0
		BSF BEEP_TRIS, BEEP_BIT 	; make the BEEP pin input
;
		EXEC_DONE
;
;---------------------------------------
;
		ORG 0x5EC0
opcode_7B:
		BSF REG_Q, 0
		BSF QLED_PORT, QLED_BIT   	; Q-LED = 1
		BCF BEEP_TRIS, BEEP_BIT		; make the BEEP pin output
;
		EXEC_DONE
;
;---------------------------------------
;
		ORG 0x5F00
opcode_7C:
		READ_IMMEDIATE
		MOVWF TEMP
		RRCF REG_DF, w
		MOVF TEMP, w
		ADDWFC REG_D, f
		CLRF REG_DF
		RLCF REG_DF, f
		EXEC_DONE
;
;---------------------------------------
;
		ORG 0x5F40
opcode_7D:
		READ_IMMEDIATE
		MOVWF TEMP
		RRCF REG_DF, w
		MOVF TEMP, w
		SUBFWB REG_D, f
		CLRF REG_DF
		RLCF REG_DF, f
		EXEC_DONE
;
;---------------------------------------
;
		ORG 0x5F80
opcode_7E:
		RRCF REG_DF ,w 
		RLCF REG_D, f
		CLRF REG_DF
		RLCF REG_DF, f
		EXEC_DONE
;
;---------------------------------------
;
		ORG 0x5FC0
opcode_7F:
		READ_IMMEDIATE
		MOVWF TEMP
		RRCF REG_DF, w
		MOVF TEMP, w
		SUBWFB REG_D, f ; M(R(P)) - REG_D
		CLRF REG_DF
		RLCF REG_DF, f
		EXEC_DONE
;
;---------------------------------------
;
		ORG 0x6000
opcode_80:
		opcode_GLO(0)
;
;---------------------------------------
;
		ORG 0x6040
opcode_81:
		opcode_GLO(1)
;
;---------------------------------------
;
		ORG 0x6080
opcode_82:
		opcode_GLO(2)
;
;---------------------------------------
;
		ORG 0x60C0
opcode_83:
		opcode_GLO(3)
;
;---------------------------------------
;
		ORG 0x6100
opcode_84:
		opcode_GLO(4)
;
;---------------------------------------
;
		ORG 0x6140
opcode_85:
		opcode_GLO(5)

;---------------------------------------
;
		ORG 0x6180
opcode_86:
		opcode_GLO(6)
;
;---------------------------------------
;
		ORG 0x61C0
opcode_87:
		opcode_GLO(7)

;---------------------------------------
;
		ORG 0x6200
opcode_88:
		opcode_GLO(8)
;
;---------------------------------------
;
		ORG 0x6240
opcode_89:
		opcode_GLO(9)
;
;---------------------------------------
;
		ORG 0x6280
opcode_8A:
		opcode_GLO(10)
;
;---------------------------------------
;
		ORG 0x62C0
opcode_8B:
		opcode_GLO(11)
;
;---------------------------------------
;
		ORG 0x6300
opcode_8C:
		opcode_GLO(12)
;
;---------------------------------------
;
		ORG 0x6340
opcode_8D:
		opcode_GLO(13)
;
;---------------------------------------
;
		ORG 0x6380
opcode_8E:
		opcode_GLO(14)

;---------------------------------------
;
		ORG 0x63C0
opcode_8F:
		opcode_GLO(15)
;
;---------------------------------------
;
		ORG 0x6400
opcode_90:
		opcode_GHI(0)
;
;---------------------------------------
;
		ORG 0x6440
opcode_91:
		opcode_GHI(1)
;
;---------------------------------------
;
		ORG 0x6480
opcode_92:
		opcode_GHI(2)
;
;---------------------------------------
;
		ORG 0x64C0
opcode_93:
		opcode_GHI(3)
;
;---------------------------------------
;
		ORG 0x6500
opcode_94:
		opcode_GHI(4)
;
;---------------------------------------
;
		ORG 0x6540
opcode_95:
		opcode_GHI(5)

;---------------------------------------
;
		ORG 0x6580
opcode_96:
		opcode_GHI(6)
;
;---------------------------------------
;
		ORG 0x65C0
opcode_97:
		opcode_GHI(7)

;---------------------------------------
;
		ORG 0x6600
opcode_98:
		opcode_GHI(8)
;
;---------------------------------------
;
		ORG 0x6640
opcode_99:
		opcode_GHI(9)
;
;---------------------------------------
;
		ORG 0x6680
opcode_9A:
		opcode_GHI(10)
;
;---------------------------------------
;
		ORG 0x66C0
opcode_9B:
		opcode_GHI(11)
;
;---------------------------------------
;
		ORG 0x6700
opcode_9C:
		opcode_GHI(12)
;
;---------------------------------------
;
		ORG 0x6740
opcode_9D:
		opcode_GHI(13)
;
;---------------------------------------
;
		ORG 0x6780
opcode_9E:
		opcode_GHI(14)

;---------------------------------------
;
		ORG 0x67C0
opcode_9F:
		opcode_GHI(15)
;
;---------------------------------------
;
		ORG 0x6800
opcode_A0:
		opcode_PLO(0)
;
;---------------------------------------
;
		ORG 0x6840
opcode_A1:
		opcode_PLO(1)
;
;---------------------------------------
;
		ORG 0x6880
opcode_A2:
		opcode_PLO(2)
;
;---------------------------------------
;
		ORG 0x68C0
opcode_A3:
		opcode_PLO(3)
;
;---------------------------------------
;
		ORG 0x6900
opcode_A4:
		opcode_PLO(4)
;
;---------------------------------------
;
		ORG 0x6940
opcode_A5:
		opcode_PLO(5)

;---------------------------------------
;
		ORG 0x6980
opcode_A6:
		opcode_PLO(6)
;
;---------------------------------------
;
		ORG 0x69C0
opcode_A7:
		opcode_PLO(7)

;---------------------------------------
;
		ORG 0x6A00
opcode_A8:
		opcode_PLO(8)
;
;---------------------------------------
;
		ORG 0x6A40
opcode_A9:
		opcode_PLO(9)
;
;---------------------------------------
;
		ORG 0x6A80
opcode_AA:
		opcode_PLO(10)
;
;---------------------------------------
;
		ORG 0x6AC0
opcode_AB:
		opcode_PLO(11)
;
;---------------------------------------
;
		ORG 0x6B00
opcode_AC:
		opcode_PLO(12)
;
;---------------------------------------
;
		ORG 0x6B40
opcode_AD:
		opcode_PLO(13)
;
;---------------------------------------
;
		ORG 0x6B80
opcode_AE:
		opcode_PLO(14)

;---------------------------------------
;
		ORG 0x6BC0
opcode_AF:
		opcode_PLO(15)
;
;---------------------------------------
;
		ORG 0x6C00
opcode_B0:
		opcode_PHI(0)
;
;---------------------------------------
;
		ORG 0x6C40
opcode_B1:
		opcode_PHI(1)
;
;---------------------------------------
;
		ORG 0x6C80
opcode_B2:
		opcode_PHI(2)
;
;---------------------------------------
;
		ORG 0x6CC0
opcode_B3:
		opcode_PHI(3)
;
;---------------------------------------
;
		ORG 0x6D00
opcode_B4:
		opcode_PHI(4)
;
;---------------------------------------
;
		ORG 0x6D40
opcode_B5:
		opcode_PHI(5)

;---------------------------------------
;
		ORG 0x6D80
opcode_B6:
		opcode_PHI(6)
;
;---------------------------------------
;
		ORG 0x6DC0
opcode_B7:
		opcode_PHI(7)

;---------------------------------------
;
		ORG 0x6E00
opcode_B8:
		opcode_PHI(8)
;
;---------------------------------------
;
		ORG 0x6E40
opcode_B9:
		opcode_PHI(9)
;
;---------------------------------------
;
		ORG 0x6E80
opcode_BA:
		opcode_PHI(10)
;
;---------------------------------------
;
		ORG 0x6EC0
opcode_BB:
		opcode_PHI(11)
;
;---------------------------------------
;
		ORG 0x6F00
opcode_BC:
		opcode_PHI(12)
;
;---------------------------------------
;
		ORG 0x6F40
opcode_BD:
		opcode_PHI(13)
;
;---------------------------------------
;
		ORG 0x6F80
opcode_BE:
		opcode_PHI(14)

;---------------------------------------
;
		ORG 0x6FC0
opcode_BF:
		opcode_PHI(15)
;
;---------------------------------------
;
		ORG 0x7000
opcode_C0:
		BRA $+6
		LONG_BRANCH
;
;---------------------------------------
;
		ORG 0x7040
opcode_C1:
		MOVF		REG_Q, w
		BNZ $+6
		LONG_BRANCH
;
;---------------------------------------
;
		ORG 0x7080
opcode_C2:
		MOVF		REG_D, w
		BZ $+6
		LONG_BRANCH
;
;---------------------------------------
;
		ORG 0x70C0
opcode_C3:
		MOVF		REG_DF, w
		BNZ $+6
		LONG_BRANCH
;
;---------------------------------------
;
		ORG 0x7100
opcode_C4:
		LONG_SKIP
;
;---------------------------------------
;
		ORG 0x7140
opcode_C5:
		MOVF		REG_Q, w
		BZ $+6
		LONG_SKIP
;
;---------------------------------------
;
		ORG 0x7180
opcode_C6:
		MOVF		REG_D, w
		BNZ $+6
		LONG_SKIP
;
;---------------------------------------
;
		ORG 0x71C0
opcode_C7:
		MOVF		REG_DF, w
		BZ $+6
		LONG_SKIP
;
;---------------------------------------
;
		ORG 0x7200
opcode_C8:
		BRA $+6
		LONG_SKIP
;
;---------------------------------------
;
		ORG 0x7240
opcode_C9:
		MOVF		REG_Q, w
		BZ $+6
		LONG_BRANCH
;
;---------------------------------------
;
		ORG 0x7280
opcode_CA:
		MOVF		REG_D, w
		BNZ $+6
		LONG_BRANCH
;
;---------------------------------------
;
		ORG 0x72C0
opcode_CB:
		MOVF		REG_DF, w
		BZ $+6
		LONG_BRANCH
;
;---------------------------------------
;
		ORG 0x7300
opcode_CC:
		RRCF REG_INTF,w	; IE is active 0, in bit 1, so get rid of bit 0, which is INT flag
		BZ $+6		; Zero means Interrupt Enabled
		LONG_SKIP
;
;---------------------------------------
;
		ORG 0x7340
opcode_CD:
		MOVF		REG_Q, w
		BNZ $+6
		LONG_SKIP
;
;---------------------------------------
;
		ORG 0x7380
opcode_CE:
		MOVF		REG_D, w
		BZ $+6
		LONG_SKIP
;
;---------------------------------------
;
		ORG 0x73C0
opcode_CF:
		MOVF		REG_DF, w
		BNZ $+6
		LONG_SKIP
;
;
;---------------------------------------
;
		ORG 0x7400
opcode_D0:
		opcode_SEP(0)
;
;---------------------------------------
;
		ORG 0x7440
opcode_D1:
		opcode_SEP(1)
;
;---------------------------------------
;
		ORG 0x7480
opcode_D2:
		opcode_SEP(2)
;
;---------------------------------------
;
		ORG 0x74C0
opcode_D3:
		opcode_SEP(3)
;
;---------------------------------------
;
		ORG 0x7500
opcode_D4:
		opcode_SEP(4)
;
;---------------------------------------
;
		ORG 0x7540
opcode_D5:
		opcode_SEP(5)
;
;---------------------------------------
;
		ORG 0x7580
opcode_D6:
		opcode_SEP(6)
;
;---------------------------------------
;
		ORG 0x75C0
opcode_D7:
		MOVLW (7)
		MOVWF REG_P
		EXEC_DONE
;
;---------------------------------------
;
		ORG 0x7600
opcode_D8:
		opcode_SEP(8)
;
;---------------------------------------
;
		ORG 0x7640
opcode_D9:
		opcode_SEP(9)
;
;---------------------------------------
;
		ORG 0x7680
opcode_DA:
		opcode_SEP(10)
;
;---------------------------------------
;
		ORG 0x76C0
opcode_DB:
		opcode_SEP(11)
;
;---------------------------------------
;
		ORG 0x7700
opcode_DC:
		opcode_SEP(12)
;
;---------------------------------------
;
		ORG 0x7740
opcode_DD:
		opcode_SEP(13)
;
;---------------------------------------
;
		ORG 0x7780
opcode_DE:
		opcode_SEP(14)
;
;---------------------------------------
;
		ORG 0x77C0
opcode_DF:
		opcode_SEP(15)
;
;---------------------------------------
;
		ORG 0x7800
opcode_E0:
		opcode_SEX(0)
;
;---------------------------------------
;
		ORG 0x7840
opcode_E1:
		opcode_SEX(1)
;
;---------------------------------------
;
		ORG 0x7880
opcode_E2:
		opcode_SEX(2)
;
;---------------------------------------
;
		ORG 0x78C0
opcode_E3:
		opcode_SEX(3)
;
;---------------------------------------
;
		ORG 0x7900
opcode_E4:
		opcode_SEX(4)

;---------------------------------------
;
		ORG 0x7940
opcode_E5:
		opcode_SEX(5)

;---------------------------------------
;
		ORG 0x7980
opcode_E6:
		opcode_SEX(6)
;
;---------------------------------------
;
		ORG 0x79C0
opcode_E7:
		opcode_SEX(7)
;
;---------------------------------------
;
		ORG 0x7A00
opcode_E8:
		opcode_SEX(8)

;---------------------------------------
;
		ORG 0x7A40
opcode_E9:
		opcode_SEX(9)
;
;---------------------------------------
;
		ORG 0x7A80
opcode_EA:
		opcode_SEX(10)
;
;---------------------------------------
;
		ORG 0x7AC0
opcode_EB:
		opcode_SEX(11)
;
;---------------------------------------
;
		ORG 0x7B00
opcode_EC:
		opcode_SEX(12)
;
;---------------------------------------
;
		ORG 0x7B40
opcode_ED:
		opcode_SEX(13)
;
;---------------------------------------
;
		ORG 0x7B80
opcode_EE:
		opcode_SEX(14)
;
;---------------------------------------
;
		ORG 0x7BC0
opcode_EF:
		opcode_SEX(15)
;
;
;---------------------------------------
;
		ORG 0x7C00
opcode_F0:
		READ_MEMORY_X
		MOVWF REG_D
		EXEC_DONE
;
;---------------------------------------
;
		ORG 0x7C40
opcode_F1:
		READ_MEMORY_X
		IORWF REG_D, f
		EXEC_DONE
;
;---------------------------------------
;
		ORG 0x7C80
opcode_F2:
		READ_MEMORY_X
		ANDWF REG_D, f
		EXEC_DONE
;
;---------------------------------------
;
		ORG 0x7CC0
opcode_F3:
		READ_MEMORY_X
		XORWF REG_D, f
		EXEC_DONE
;
;---------------------------------------
;
		ORG 0x7D00
opcode_F4:
		READ_MEMORY_X
		ADDWF REG_D, f
		CLRF REG_DF
		RLCF REG_DF, f
		EXEC_DONE
;
;---------------------------------------
;
		ORG 0x7D40
opcode_F5:
		READ_MEMORY_X
		MOVWF TEMP
		MOVLW 1
		RRCF WREG, f
		MOVF TEMP, w
		SUBFWB REG_D, f
		CLRF REG_DF
		RLCF REG_DF, f
		EXEC_DONE
;
;---------------------------------------
;
		ORG 0x7D80
opcode_F6:
		CLRF WREG
		RRCF WREG, w
		RRCF REG_D, f
		CLRF REG_DF
		RLCF REG_DF, f
		EXEC_DONE
;
;---------------------------------------
;
		ORG 0x7DC0
opcode_F7:
		READ_MEMORY_X
		SUBWF REG_D, f
		CLRF REG_DF
		RLCF REG_DF, f
		EXEC_DONE
;
;---------------------------------------
;
		ORG 0x7E00
opcode_F8:
		READ_IMMEDIATE
		MOVWF REG_D
		EXEC_DONE
;
;---------------------------------------
;
		ORG 0x7E40
opcode_F9:
		READ_IMMEDIATE
		IORWF REG_D, f
		EXEC_DONE
;
;---------------------------------------
;
		ORG 0x7E80
opcode_FA:
		READ_IMMEDIATE
		ANDWF REG_D, f
		EXEC_DONE
;
;---------------------------------------
;
		ORG 0x7EC0
opcode_FB:
		READ_IMMEDIATE
		XORWF REG_D, f
		EXEC_DONE
;
;---------------------------------------
;
		ORG 0x7F00
opcode_FC:
		READ_IMMEDIATE
		ADDWF REG_D, f
		CLRF REG_DF
		RLCF REG_DF, f
		EXEC_DONE
;
;---------------------------------------
;
		ORG 0x7F40
opcode_FD:
		READ_IMMEDIATE
		MOVWF TEMP
		MOVLW 1
		RRCF WREG, w
		MOVF TEMP, w
		SUBFWB REG_D, f
		CLRF REG_DF
		RLCF REG_DF, f
		EXEC_DONE
;
;---------------------------------------
;
		ORG 0x7F80
opcode_FE:
		CLRF WREG
		RRCF WREG ,w 
		RLCF REG_D, f
		CLRF REG_DF
		RLCF REG_DF, f
		EXEC_DONE
;
;---------------------------------------
;
		ORG 0x7FC0
opcode_FF:
		READ_IMMEDIATE
		SUBWF REG_D, f
		CLRF REG_DF
		RLCF REG_DF, f
		EXEC_DONE
;
;--------------------------------------------------------
;
		END
;
;--------------------------------------------------------
