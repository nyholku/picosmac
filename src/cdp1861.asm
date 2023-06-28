;
		list    
;
		radix dec
		INCLUDE p18cxxx.inc
		;
;--------------------------------------------------------
; SPI CLOCK FROM pin 36 CCP2 => pin 34 SCK
;--------------------------------------------------------
; public variables in this module
;--------------------------------------------------------
;
		global  init_cdp1861
		global	video_on,video_off
		global	BEEP_CNTR
;
;--------------------------------------------------------
; extern variables in this module
;--------------------------------------------------------
;
		extern REG0_0
		extern REG0_1
		extern REG_Q
		extern INPUT_EF1
		extern REG_INTF
		extern PCLATHX
		extern PCLATLX
		extern REG_INTF
;
SYNC_PORT	EQU     LATD
SYNC_TRIS	EQU     TRISD
SYNC_BIT	EQU	2
;
BEEP_PORT	EQU 	LATC
BEEP_TRIS	EQU 	TRISC
BEEP_BIT	EQU	1	
;
;--------------------------------------------------------
;    Global variables
;--------------------------------------------------------
;
		UDATA
;
VCOUNTER	RES 1
HCOUNTER	RES 1
VIDEO_CNTR	RES 1
GONEXTH		RES 1
GONEXTL		RES 1
SYNCX		RES 1
BEEP_CNTR	RES 1
;
LINE_BYTES	EQU 14
PRE_BYTES	EQU 3
VIDEO_BYTES	EQU 8
POST_BYTES	EQU LINE_BYTES - PRE_BYTES - VIDEO_BYTES - 1

FRAME_LINES	EQU 300
SYNC_LINES	EQU 16
VIDEO_LINES	EQU 128
TOP_LINES	EQU 60
BOTTOM_LINES	EQU FRAME_LINES - TOP_LINES - VIDEO_LINES - SYNC_LINES
INT_LINES	EQU 2
EF1_LINES	EQU 4
;
;--------------------------------------------------------
; FIXME this is duplicated int cdp1802.asm
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
; 4 cycles
;
CONT_AT   	MACRO x
		MOVLW HIGH(x)
		MOVWF GONEXTH, b
		MOVLW LOW(x)
		MOVWF GONEXTL, b
		ENDM
;
;-------------------------------------------------
;
; 8 cycles
;
YIELD   	MACRO
		LOCAL label
;
		CONT_AT label
;
		MOVFF	PCLATHX, PCLATH
		MOVF	PCLATLX, w, b
		MOVWF   PCL
label:
		ENDM
;
;-------------------------------------------------
;
; 2 cycles
;
REPEAT  	MACRO counter, count
;
		MOVLW count
		MOVWF counter, b
;
		ENDM
;
;-------------------------------------------------
;
; 4 cycles
;
LOOP		MACRO counter, label
;
		DECFSZ counter, f, b
		BRA label
;
		ENDM
;
;-------------------------------------------------
;
; 2 cycles
;
SET_SYNC	MACRO X
	IF (X)
		BSF SYNCX, SYNC_BIT, b
	ELSE
		BCF SYNCX, SYNC_BIT, b
	ENDIF
		ENDM
;
;--------------------------------------------------------
;
; 8 cycles
;
START_VIDEO	MACRO

		MOVLW VIDEO_BYTES ; next yield will only return after all video bytes have been don
		MOVWF VIDEO_CNTR, b

		ENDM
;
;--------------------------------------------------------
;
BEEP		MACRO
		LOCAL label
		DCFSNZ	BEEP_CNTR, f, b
		BTG	BEEP_PORT, BEEP_BIT
label
		ENDM
;              
;--------------------------------------------------------
                                
hi_prio_inte:   code    0x000008

		global timexec
timexec
;
	IF 0
		MOVLW   0xFF                	; fixe/fake video data used for debugging
	ELSE
		MOVF    INDF2, w     	; get next video byte to output
	ENDIF
		MOVF	VIDEO_CNTR, f, b

	IFDEF TARGET_DEBUG
		BRA	video_done
	ELIFDEF TARGET_TRIAL
		BRA	video_done
	ELSE
		BZ      video_done		
	ENDIF

		MOVWF   SSPBUF          	; output the byte, this is the time critical path up to here
		BRA	skipIntVctr
;
		ORG    	0x000018
		GOTO	lowPrinInt
;		
skipIntVctr:
		BCF     PIR1, 3        		; SPI interrupt clear
;
		MOVF    POSTINC2, w     	; increment video pointer
;
		DECF	VIDEO_CNTR, f, b		; decrement video bytes counter
;
		MOVFF	FSR2L, REG0_0
		MOVFF	FSR2H, REG0_1
;
		BEEP
		RETFIE  0                	; We are not done all output for this line yet so just return
;
;-------------------------------------------------
;
; NOTE  actual hardware sync is always one 1802 'cycle' delayed
;
video_done:
		BEEP

		MOVFF   SYNCX,SYNC_PORT    	; this sets also the other bits in PORTA
;
		BCF     PIR1, 3        		; SPI interrupt clear

;
		MOVFF	GONEXTH, PCLATH
		MOVF	GONEXTL, w, b
		MOVWF	PCL			; 4 instructions here + 6 for the YIELD, just to continue where we left off
;-------------------------------------------------
;
start:
;
		REPEAT VCOUNTER, TOP_LINES - INT_LINES
top_loop:
		SET_SYNC 0
		YIELD

		SET_SYNC 1
		REPEAT HCOUNTER, LINE_BYTES-1
top_line:
		YIELD
		LOOP HCOUNTER, top_line
		LOOP VCOUNTER, top_loop
;
;-------------------------------------------------
;
		REPEAT VCOUNTER, INT_LINES
		SET_INT 1
int_loop:
		SET_SYNC 0
		YIELD

		SET_SYNC 1                    ; 11+2
		REPEAT HCOUNTER, LINE_BYTES-1 ; 11+2+4 = 16 cycles
int_line:
		YIELD                         ; 11+2+4+6 = 19 cycles
		LOOP HCOUNTER, int_line
		LOOP VCOUNTER, int_loop
;
		SET_INT 0
;
;-------------------------------------------------
;
		NOP
		REPEAT VCOUNTER, 10
xvideo_loop:
		SET_SYNC 0
		YIELD 				; 11+18 = 29 cycles since interrupt

		SET_SYNC 1
		REPEAT HCOUNTER, PRE_BYTES
xloop_pre:
		YIELD
		LOOP HCOUNTER, xloop_pre 	;[4]

		START_VIDEO

		REPEAT HCOUNTER, POST_BYTES  	;[2]
xloop_post:
		YIELD			  	;[6]
		LOOP HCOUNTER, xloop_post
		LOOP VCOUNTER, xvideo_loop
		NOP
;
;-------------------------------------------------
;
		REPEAT VCOUNTER, VIDEO_LINES - EF1_LINES -10
video_loop:
		SET_SYNC 0
		YIELD 				; 11+18 = 29 cycles since interrupt

		SET_SYNC 1
		REPEAT HCOUNTER, PRE_BYTES
loop_pre:
		YIELD
		LOOP HCOUNTER, loop_pre 	;[4]

		START_VIDEO

		REPEAT HCOUNTER, POST_BYTES  	;[2]
loop_post:
		YIELD			  	;[6]
		LOOP HCOUNTER, loop_post
		LOOP VCOUNTER, video_loop
;
;-------------------------------------------------
;
		BSF	INPUT_EF1,0, b
;
		REPEAT VCOUNTER, EF1_LINES
ef1_loop:
		SET_SYNC 0
		YIELD

		SET_SYNC 1
		REPEAT HCOUNTER, PRE_BYTES
ef1_pre:
		YIELD
		LOOP HCOUNTER, ef1_pre

		START_VIDEO

		REPEAT HCOUNTER, POST_BYTES
ef1_post:
		YIELD
		LOOP HCOUNTER, ef1_post
		LOOP VCOUNTER, ef1_loop
;
		BCF	INPUT_EF1,0, b
;
;-------------------------------------------------
;

		REPEAT VCOUNTER, BOTTOM_LINES
bottom_loop:
		SET_SYNC 0
		YIELD

		SET_SYNC 1
		REPEAT HCOUNTER, LINE_BYTES-1
bottom_line:
		YIELD
		LOOP HCOUNTER, bottom_line
		LOOP VCOUNTER, bottom_loop
;
;-------------------------------------------------
;
		REPEAT VCOUNTER, SYNC_LINES
vsync_loop:
		SET_SYNC 1
		YIELD
		SET_SYNC 0
		REPEAT HCOUNTER, LINE_BYTES-1
vsync_line:
		YIELD
		LOOP HCOUNTER, vsync_line
		LOOP VCOUNTER, vsync_loop
;
;-------------------------------------------------
;
		BRA	start
;
;-------------------------------------------------
;
init_cdp1861:
		CALL video_off 
;
		BCF SYNC_TRIS, SYNC_BIT  
		BCF SYNC_PORT, SYNC_BIT  
;
		CLRF SYNCX, b
		MOVLW 1
		MOVWF REG_INTF, b

;		EXTERN load_vip_pic
;		CALL load_vip_pic

		LFSR 2,0 ; is this necessary? 
;
		RETURN
;
;-------------------------------------------------
;
video_on	
		CONT_AT start
		RETURN
;
;-------------------------------------------------
;
video_off
		CONT_AT no_video
		RETURN
;		
;-------------------------------------------------
;
no_video
		YIELD
		BRA	no_video
;
;-------------------------------------------------
lowPrinInt:
		BCF	PIR1, TMR1IF
		BTG 	LATD,1	
		RETURN
;
		END
