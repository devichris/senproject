;********************************************************************
; Filename: SeniorProject											*
; Function: Gesture Controlled Fan								*
; Author: Devion WIlson												*
; Date: 09-06-2016													*
;********************************************************************
		#include <P16F877A.INC>	;This is the header file you created for this lab#1



FANSET	EQU		0X20
OSCC	EQU		0X21
HIGHBT	EQU		0X24
LOWBT	EQU		0X25
TESTBIT	EQU		0X26
KEY		EQU		0X2C		;This is the user defined DRAM area that
COUNT	EQU		0X2D		; uses the 68 bytes GPR: range from 0X0C-0X4F
TEMP	EQU		0X2E
TEMP1	EQU		0X2F
TEMP2	EQU		0X30
DVAR	EQU		0X31
DVAR2	EQU		0X32
FLAG	EQU		0X33
;TIME 	EQU		0X9F
VAR1	EQU		0X34
VAR2	EQU		0X35
VAR3 	EQU		0X36
STEMP	EQU		0X37
WTEMP	EQU		0X38
ORIG	EQU		0X39
NEW		EQU		0X3A
;CHANGE	EQU		0X1B
N		EQU		0X3C
CONT	EQU		0X3D
CONT1	EQU		0X3E
TESTBITS	EQU		0X3F
RETULT	EQU		0X40

BYTE	EQU		0X42
count	EQU		0X43

	    
	    	__CONFIG	0X3F32
	    	ORG		0X0000					;RESET or WDT reset vector

	

			
GOTO	START
		    ORG		0X0004					;Regular INT vector
			
		


			call		DELAY10							;This is the area where your interrupt service routine goes
			MOVWF	WTEMP				;SAVE W AND status
			SWAPF	STATUS,W
			MOVWF	STEMP
			MOVF	0X1
			BTFSC	INTCON,RBIF
			XORWF	FLAG,F
		
			
			BTFSC	INTCON,INTF
			INCF	CONT1,F				;INCREMENT COUNTER IF INTF IS SET
			
			SWAPF	STEMP,W				;POP STACK
			MOVWF	STATUS
			SWAPF	WTEMP,F
			SWAPF	WTEMP,W
			MOVF	PORTB,W				;DUMMY OPERATION
			BCF		INTCON,INTF			;CLEAR INTURRUPT FLAG
			BCF		INTCON,RBIF
			RETFIE	


START	
			
			BSF 	STATUS,RP0 			;GO TO BANK 1
			
			MOVLW	0X00
			MOVWF   TRISA				;SET 0-3 FOR INPUT AND 4-7 FOR OUTPUT
			MOVLW	0X81
			MOVWF	TRISB				;SET 0-3 FOR INPUT AND 4-7 FOR OUTPUT
			MOVLW	0X00
			MOVWF	TRISC
			MOVLW	0X00
			MOVWF	TRISD
			MOVLW	0X00					;RE2 as input pin for ADC COnversion
			MOVWF	TRISE
		
	    		BCF		STATUS,RP0	
			BCF		PORTE,0X0
			BCF		PORTE,0X1
			BSF		INTCON,GIE
			BSF		INTCON,INTE
			BSF		INTCON,RBIE
			BSF		OPTION_REG,INTEDG
			MOVLW    0XFA
			MOVWF	N					;OSCILATION COUNTER
			MOVLW	0X00
			MOVWF	CONT1				
			MOVLW	0X01
			MOVWF	RETULT				;SET THE MOTOR DIRECTION (RESULT) 00000001
			MOVLW	0X03
			MOVWF	TESTBITS				;SET THE TESTBIT 00000011
			
STARTER		

			
		
							;TURN MOTOR OFF (SO LATER IT WONT RUN CONTINUEOUSLY)
			MOVLW	0X00
			XORWF	CONT1,0				;CHECK IF BIT IS SET
			BTFSC	STATUS,Z
			call	MOTOR0
			MOVLW	0X01
			XORWF	CONT1,0				;CHECK IF BIT IS SET
			BTFSC	STATUS,Z
			call	MOTOR1
			MOVLW	0X02
			XORWF	CONT1,0				;CHECK IF BIT IS SET
			BTFSC	STATUS,Z
			call	MOTOR2
			MOVLW	0X03
			XORWF	CONT1,0				;CHECK IF BIT IS SET
			BTFSC	STATUS,Z
			call	MOTOR3	
	
			
			MOVLW	0X04
			SUBWF	CONT1,0				;CHECK IF COUNTER HAS PASSED 8
			BTFSC	STATUS,C
			CALL	FIX

			MOVF	CONT1,W
			
			
			MOVWF	PORTA
			BTFSC	FLAG,0X0				;OSCILATES THE MOTOR IF THE FLAG IS SET
			call		OSCL
			BTFSS	FLAG,0X0				;STOPS THE OSCILATION IF THE FLAG IS NOT SET
			CALL	STOPPER

          		GOTO STARTER
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

STOPPER
			MOVLW	0X00
			MOVWF	PORTE
RETURN
OSCL		;MOTOR OSCILATION FUNCTION
			
			
			DECFSZ		N					;SUPPOSED TO COUNT 150 TIMES,WHEN IT HITS 0 IT WILL OSCILATE IN THE NEXT DIRECTION
			RETURN

			CALL		NEXTDIR
			RETURN

NEXTDIR
			MOVLW		0XFA
			MOVWF		N					;RESET THE OSCILATIN MOTOR		
			MOVF		TESTBITS,W
			XORWF		RETULT,F
			MOVF		RETULT,W				;LOAD THE RESULT ONTO PORT E WHICH SHOULD OSCILLATE THE MOTOR BACK AND FOURTH
			MOVWF		PORTE

RETURN
			



MOTOR0		
	
	         		BCF		PORTC,0X5
			BCF		PORTC,0X4
			call DELAY1
			call DELAY1
			call DELAY1
			call DELAY1
			call DELAY1
			call DELAY1
			call DELAY1
			call DELAY1
			call DELAY1
			call DELAY1
			return
MOTOR1		
			BCF		PORTC,0X5           ;SET  PIN3 ON PORTC TO CLEAR
			BSF		PORTC,0X4           ;SET PIN 2 ON PORTC TO 1
		
			call	DELAY1
			call	DELAY1
			call	DELAY1
call	DELAY1
call	DELAY1

	BCF		PORTC,0X4
call DELAY1
call	DELAY1
call	DELAY1
call	DELAY1
call	DELAY1
return

            
MOTOR2		
			BCF		PORTC,0X5
			BSF		PORTC,0X4
		;	CALL	DELAY10	
		;	BCF		PORTC,0X2
		;	CALL	DELAY1
call DELAY1
call	DELAY1
call	DELAY1
call	DELAY1
call	DELAY1
call	DELAY1
call	DELAY1
	BCF		PORTC,0X4

call DELAY1
call	DELAY1
call	DELAY1

return
            

MOTOR3		
			BCF		PORTC,0X5
			BSF		PORTC,0X4
		;;	CALL	DELAY1	
		;	BCF		PORTC,0X2
		;	CALL	DELAY10
;CALL	DELAY1
;CALL	DELAY1
		;	XORLW	0X06
		;	BTFSC	STATUS,Z
		;	GOTO	MOTOR3
        ;    GOTO    STARTER
call DELAY1
call	DELAY1
call	DELAY1
call	DELAY1
call	DELAY1
call	DELAY1
call	DELAY1
call	DELAY1
call	DELAY1
	BCF		PORTC,0X4
call DELAY1
return

FIX
			MOVLW	0X00				;RESET COUNTER
			MOVWF	CONT1
		
			call    STARTER             ;GOTO BEGINNING OF CYCLE




			


DELAY1										;TIME DELAY
		
			MOVLW	0X0F
			MOVWF	VAR2
LOOP2		MOVLW	0X28

			MOVWF	VAR3
LOOP3		
			DECF	VAR3,F
			btfss	STATUS,Z
			GOTO	LOOP3
			DECF	VAR2,F
			BTFSS	STATUS,Z
			GOTO	LOOP2
			


return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DELAY10									;TIME DELAY
		
			MOVLW	0X50
			MOVWF	VAR2
LOOP23		MOVLW	0X00

			MOVWF	VAR3
LOOP33		
			DECF	VAR3,F
			btfss	STATUS,Z
			GOTO	LOOP33
			DECF	VAR2,F
			BTFSS	STATUS,Z
			GOTO	LOOP2
			


            RETURN
DELAY2		
			CLRF	CONT
	
			movlw	0x35
			MOVWF	VAR1
LOOP11		MOVLW	0X99

			MOVWF	VAR2
LOOP21		MOVLW	0X00

			MOVWF	VAR3
LOOP31	
			DECF	VAR3,F
			BTFSS	STATUS,Z
			GOTO	LOOP31
			DECF	VAR2,F
			BTFSS	STATUS,Z
			GOTO	LOOP21
			DECF	VAR1
			BTFSS	STATUS,Z
			GOTO	LOOP11
return		


	END