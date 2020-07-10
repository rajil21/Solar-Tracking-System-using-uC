ORG 0000H
   ;LABEL ASSIGNING FOR PINS
   CLK EQU P3.7
   OE EQU P3.6
   EOC EQU P3.5
   SC EQU P2.0
   ALE EQU P3.3
   ADC EQU P3.2
   ADB EQU P3.1
   ADA EQU P3.0
   E EQU P2.3
   RW EQU P2.2
   RS EQU P2.1
   A1 EQU P2.7
   A2 EQU P2.6
   A3 EQU P2.5
   A4 EQU P2.4
   LJMP MAIN
   
ORG 000BH
    CPL CLK
    RETI
   
ORG 0030H
   MAIN:
   MOV P3,#00H
   SETB EOC
   MOV TMOD,#02H
   MOV IE,#82H
   MOV TH0,#0FEH
   SETB TR0
   ACALL LCD_LINE1
   
   AGAIN:
   ACALL READ_LDR1
   ACALL DELAY
   ACALL READ_LDR2
   ACALL DELAY
   ACALL READ_LDR3
   ACALL DELAY
   ACALL LCD_LINE2
   ACALL COMPARE
   SJMP AGAIN
      
   ;SUB ROUTINE PROGRAMS
   DELAY:
   MOV R0,#255
   L:DJNZ R0,L
   RET
   
   DELAY2:
   MOV R6,#50
   LO1:
   ACALL DELAY
   DJNZ R6,LO1
   RET
   
   READ_LDR1:
   MOV A ,#00H
   SETB ALE
   SETB SC
   ;ADDRESS LINE CHOICE FOR IN0 '0,0,0'
   CLR ADA
   CLR ADB
   CLR ADC
   ACALL DELAY
   CLR ALE
   CLR SC
   HERE:JB EOC, HERE
   HERE1:JNB EOC,HERE1
   SETB OE
   MOV A,P1
   MOV 20H,A
   ACALL DELAY
   CLR OE
   RET
   
   READ_LDR2:
   MOV A ,#00H
   SETB ALE
   SETB SC
   ;ADDRESS LINE CHOICE FOR IN1 '0,0,1'
   SETB ADA
   CLR ADB
   CLR ADC
   ACALL DELAY
   CLR ALE
   CLR SC
   HERE2:JB EOC, HERE2
   HERE3:JNB EOC,HERE3
   
   SETB OE
   MOV A,P1
   MOV 21H,A
   ACALL DELAY
   CLR OE
   RET
   
   READ_LDR3:
   MOV A ,#00H
   SETB ALE
   SETB SC

   ;ADDRESS LINE CHOICE FOR IN1 '0,1,0'
   CLR ADA
   SETB ADB
   CLR ADC
   ACALL DELAY
   CLR ALE
   CLR SC
   HERE4:JB EOC, HERE4
   HERE5:JNB EOC,HERE5
   SETB OE
   MOV A,P1
   MOV 22H,A
   ACALL DELAY
   CLR OE
   RET
   
   ;MOTOR PROGRAMS
   MORNING:
   CLR A1
   CLR A2
   CLR A3
   CLR A4
   ACALL DELAY1
   SETB A1
   RET
   
   NOON:
    CLR A1
   CLR A2
   CLR A3
   CLR A4
   ACALL DELAY1
   SETB A2
   RET
   
   EVENING:
   CLR A1
   CLR A2
   CLR A3
   CLR A4
   ACALL DELAY1
   SETB A4
   RET
   
   ;MOTOR DELAY 
   DELAY1: 
   MOV R4,#255
   KO: 
   ACALL DELAY
   DJNZ R4,KO
   
   RET 
   
   ;COMPARE PROGRAM
   COMPARE:
        MOV R0,20H
	MOV R1,21H
	MOV R2,22H
	MOV A,R0
	CJNE A,21H,OVER
	SJMP LO
	OVER: JNC OVER1
	SJMP LO
	OVER1:MOV A,R1
	LO : CJNE A,22H,OVER2
	SJMP EXIT
	OVER2: JNC OVER3
	SJMP EXIT
	OVER3: MOV A,R2
	EXIT:NOP
	
	CJNE A,20H,M0
	ACALL MORNING
	M0:SJMP EXIT1

	CJNE A,21H,M1
	ACALL NOON
	M1:SJMP EXIT1

	CJNE A,22H,M2
	ACALL EVENING
	M2:SJMP EXIT1
	EXIT1:NOP

   RET
   
   ;LCD PROGRAMS
   
   COMNWRT: ; send command to LCD 
   MOV P0, A ; copy reg A to port 1 
   CLR RS ; RS=0 for command 
   CLR RW ; R/W=0 for write 
   SETB E ; E=1 for high pulse 
   ACALL DELAY ; give LCD some time 
   CLR E ; E=0 for H-to-L pulse 
   RET
   
   DATAWRT: ; write data to LCD 
   MOV P0, A ; copy reg A to port 1 
   SETB RS ; RS=1 for data 
   CLR RW ; R/W=0 for write 
   SETB E ; E=1 for high pulse 
   ACALL DELAY ; give LCD some time 
   CLR E; E=0 for H-to-L pulse 
   RET
   
   LCD_LINE1:
    MOV A, #38H ; INITIALIZE 2x16 LCD
    ACALL COMNWRT ; call command subroutine
    ACALL DELAY ; give LCD some time
    MOV A, #0EH ; display on, cursor on
    ACALL COMNWRT ; call command subroutine
    ACALL DELAY ; give LCD some time
    MOV A, #01 ; clear LCD 
    ACALL COMNWRT ; call command subroutine
    ACALL DELAY ; give LCD some time
    MOV A, #0CH ; display on, cursor on
    ACALL COMNWRT ; call command subroutine
    ACALL DELAY ; give LCD some time
    
    MOV A, #80H ; cursor at line 1, pos. 0
    ACALL COMNWRT ; call command subroutine
    ACALL DELAY ; give LCD some time
    MOV A, #'L' ; display letter L
    ACALL DATAWRT ; call display subroutine
    ACALL DELAY ; give LCD some time
    MOV A, #'D' ; display letter D
    ACALL DATAWRT ; call display subroutine
    ACALL DELAY
    MOV A, #'R' ; display letter R
    ACALL DATAWRT ; call display subroutine
    ACALL DELAY ; give LCD some time
    MOV A, #'1' ; display letter 1
    ACALL DATAWRT ; call display subroutine
    ACALL DELAY ; give LCD some time
     
    MOV A, #86H ; cursor at line 1, pos. 6
    ACALL COMNWRT ; call command subroutine
    ACALL DELAY ; give LCD some time
    MOV A, #'L' ; display letter L
    ACALL DATAWRT ; call display subroutine
    ACALL DELAY ; give LCD some time
    MOV A, #'D' ; display letter D
    ACALL DATAWRT ; call display subroutine
    ACALL DELAY
    MOV A, #'R' ; display letter R
    ACALL DATAWRT ; call display subroutine
    ACALL DELAY ; give LCD some time
    MOV A, #'2' ; display letter 2
    ACALL DATAWRT ; call display subroutine
    ACALL DELAY ; give LCD some time
    
     
    MOV A, #8CH ; cursor at line 1, pos. 12
    ACALL COMNWRT ; call command subroutine
    ACALL DELAY ; give LCD some time
    MOV A, #'L' ; display letter L
    ACALL DATAWRT ; call display subroutine
    ACALL DELAY ; give LCD some time
    MOV A, #'D' ; display letter D
    ACALL DATAWRT ; call display subroutine
    ACALL DELAY
    MOV A, #'R' ; display letter R
    ACALL DATAWRT ; call display subroutine
    ACALL DELAY ; give LCD some time
    MOV A, #'3' ; display letter 3
    ACALL DATAWRT ; call display subroutine
    ACALL DELAY ; give LCD some time
    RET
    
    LCD_LINE2:
    ;MOV A, #38H ; INITIALIZE 2x16 LCD
    ;ACALL COMNWRT ; call command subroutine
    ;ACALL DELAY ; give LCD some time
   
  
    
    MOV A, #0C0H ; cursor at line 2, pos. 0
    ACALL COMNWRT ; call command subroutine
    ACALL DELAY ; give LCD some time
    MOV A, 20H; display LDR1 number
    ACALL NUM
    MOV A, #0C6H ; cursor at line 2, pos. 6
    ACALL COMNWRT ; call command subroutine
    ACALL DELAY ; give LCD some time
    MOV A, 21H; display LDR2 number
    JZ SKIP
    ACALL NUM
    SJMP S
    SKIP:
    ADD A,#48
    ACALL DATAWRT
    ACALL DELAY
    S:
    MOV A, #0CCH ; cursor at line 2, pos 12
    ACALL COMNWRT ; call command subroutine
    ACALL DELAY ; give LCD some time
    MOV A, 22H; display LDR3 number
    JZ SKIP1
    ACALL NUM
    SJMP S1
    SKIP1:
    ADD A,#48
    ACALL DATAWRT
    ACALL DELAY
    S1:
    RET
    
    ;NUMBER PRINT
    NUM:
    MOV R5,A
    
    MOV A,R5
    MOV B,#100
    DIV AB
    ADD A,#48
    ACALL DATAWRT
    ACALL DELAY
    
   
   MOV A,R5
   MOV B,#100
   DIV AB
   MOV A,B
   MOV B,#10
   DIV AB
   ADD A,#48
   ACALL DATAWRT
   ACALL DELAY
   
   MOV A,R5
   MOV B,#10
   DIV AB
   MOV A,B
   ADD A,#48
   ACALL DATAWRT
   ACALL DELAY
  
   RET
   
END