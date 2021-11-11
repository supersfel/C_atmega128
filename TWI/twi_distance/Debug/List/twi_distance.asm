
;CodeVisionAVR C Compiler V3.45 Evaluation
;(C) Copyright 1998-2021 Pavel Haiduc, HP InfoTech S.R.L.
;http://www.hpinfotech.ro

;Build configuration    : Debug
;Chip type              : ATmega128
;Program type           : Application
;Clock frequency        : 14.745600 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : long, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 1024 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Mode 2
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega128
	#pragma AVRPART MEMORY PROG_FLASH 131072
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 4096
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU RAMPZ=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETW1P
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETD1P_INC
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	.ENDM

	.MACRO __GETD1P_DEC
	LD   R23,-X
	LD   R22,-X
	LD   R31,-X
	LD   R30,-X
	.ENDM

	.MACRO __PUTDP1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTDP1_DEC
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __CPD10
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	.ENDM

	.MACRO __CPD20
	SBIW R26,0
	SBCI R24,0
	SBCI R25,0
	.ENDM

	.MACRO __ADDD12
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	.ENDM

	.MACRO __ADDD21
	ADD  R26,R30
	ADC  R27,R31
	ADC  R24,R22
	ADC  R25,R23
	.ENDM

	.MACRO __SUBD12
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	.ENDM

	.MACRO __SUBD21
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R25,R23
	.ENDM

	.MACRO __ANDD12
	AND  R30,R26
	AND  R31,R27
	AND  R22,R24
	AND  R23,R25
	.ENDM

	.MACRO __ORD12
	OR   R30,R26
	OR   R31,R27
	OR   R22,R24
	OR   R23,R25
	.ENDM

	.MACRO __XORD12
	EOR  R30,R26
	EOR  R31,R27
	EOR  R22,R24
	EOR  R23,R25
	.ENDM

	.MACRO __XORD21
	EOR  R26,R30
	EOR  R27,R31
	EOR  R24,R22
	EOR  R25,R23
	.ENDM

	.MACRO __COMD1
	COM  R30
	COM  R31
	COM  R22
	COM  R23
	.ENDM

	.MACRO __MULD2_2
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	.ENDM

	.MACRO __LSRD1
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	.ENDM

	.MACRO __LSLD1
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	.ENDM

	.MACRO __ASRB4
	ASR  R30
	ASR  R30
	ASR  R30
	ASR  R30
	.ENDM

	.MACRO __ASRW8
	MOV  R30,R31
	CLR  R31
	SBRC R30,7
	SER  R31
	.ENDM

	.MACRO __LSRD16
	MOV  R30,R22
	MOV  R31,R23
	LDI  R22,0
	LDI  R23,0
	.ENDM

	.MACRO __LSLD16
	MOV  R22,R30
	MOV  R23,R31
	LDI  R30,0
	LDI  R31,0
	.ENDM

	.MACRO __CWD1
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	.ENDM

	.MACRO __CWD2
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	.ENDM

	.MACRO __SETMSD1
	SER  R31
	SER  R22
	SER  R23
	.ENDM

	.MACRO __ADDW1R15
	CLR  R0
	ADD  R30,R15
	ADC  R31,R0
	.ENDM

	.MACRO __ADDW2R15
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	.ENDM

	.MACRO __EQB12
	CP   R30,R26
	LDI  R30,1
	BREQ PC+2
	CLR  R30
	.ENDM

	.MACRO __NEB12
	CP   R30,R26
	LDI  R30,1
	BRNE PC+2
	CLR  R30
	.ENDM

	.MACRO __LEB12
	CP   R30,R26
	LDI  R30,1
	BRGE PC+2
	CLR  R30
	.ENDM

	.MACRO __GEB12
	CP   R26,R30
	LDI  R30,1
	BRGE PC+2
	CLR  R30
	.ENDM

	.MACRO __LTB12
	CP   R26,R30
	LDI  R30,1
	BRLT PC+2
	CLR  R30
	.ENDM

	.MACRO __GTB12
	CP   R30,R26
	LDI  R30,1
	BRLT PC+2
	CLR  R30
	.ENDM

	.MACRO __LEB12U
	CP   R30,R26
	LDI  R30,1
	BRSH PC+2
	CLR  R30
	.ENDM

	.MACRO __GEB12U
	CP   R26,R30
	LDI  R30,1
	BRSH PC+2
	CLR  R30
	.ENDM

	.MACRO __LTB12U
	CP   R26,R30
	LDI  R30,1
	BRLO PC+2
	CLR  R30
	.ENDM

	.MACRO __GTB12U
	CP   R30,R26
	LDI  R30,1
	BRLO PC+2
	CLR  R30
	.ENDM

	.MACRO __CPW01
	CLR  R0
	CP   R0,R30
	CPC  R0,R31
	.ENDM

	.MACRO __CPW02
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	.ENDM

	.MACRO __CPD12
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	.ENDM

	.MACRO __CPD21
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	.ENDM

	.MACRO __BSTB1
	CLT
	TST  R30
	BREQ PC+2
	SET
	.ENDM

	.MACRO __LNEGB1
	TST  R30
	LDI  R30,1
	BREQ PC+2
	CLR  R30
	.ENDM

	.MACRO __LNEGW1
	OR   R30,R31
	LDI  R30,1
	BREQ PC+2
	LDI  R30,0
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD2M
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETW1Z
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETD1Z
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETW2X
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETD2X
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _ti_Cnt_1ms=R5
	.DEF _LCD_DelCnt_1ms=R4

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_comp
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_0x0:
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0x4D,0x65,0x61
	.DB  0x73,0x75,0x72,0x65,0x64,0x20,0x44,0x69
	.DB  0x73,0x74,0x2E,0x3D,0x20,0x0,0x45,0x52
	.DB  0x52,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x4D,0x65,0x61,0x73,0x75,0x72,0x65
	.DB  0x64,0x20,0x44,0x69,0x73,0x74,0x2E,0x29
	.DB  0x3D,0x20,0x0,0x25,0x30,0x31,0x64,0x20
	.DB  0x20,0x25,0x30,0x33,0x64,0x20,0x63,0x6D
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x15
	.DW  _0x21
	.DW  _0x0*2

	.DW  0x11
	.DW  _0x5F
	.DW  _0x0*2+21

	.DW  0x0B
	.DW  _0x5F+17
	.DW  _0x0*2+38

	.DW  0x12
	.DW  _0x5F+28
	.DW  _0x0*2+49

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

	OUT  RAMPZ,R24

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0x00

	.DSEG
	.ORG 0x500

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_Init_TWI:
; .FSTART _Init_TWI
	LDI  R30,LOW(50)
	STS  112,R30
	LDI  R30,LOW(4)
	STS  116,R30
	LDI  R30,LOW(0)
	STS  113,R30
	RET
; .FEND
_TWI_TransCheck_ACK:
; .FSTART _TWI_TransCheck_ACK
	RCALL __SAVELOCR4
	MOV  R19,R26
;	Stat -> R19
;	ExtDev_ErrCnt -> R16,R17
	__GETWRN 16,17,0
_0x3:
	LDS  R30,116
	ANDI R30,LOW(0x80)
	BRNE _0x5
	MOVW R26,R16
	__ADDWRN 16,17,1
	CPI  R26,LOW(0x7D1)
	LDI  R30,HIGH(0x7D1)
	CPC  R27,R30
	BRLO _0x6
	LDI  R30,LOW(1)
	RJMP _0x2060006
_0x6:
	RJMP _0x3
_0x5:
	LDS  R30,113
	ANDI R30,LOW(0xF8)
	CP   R19,R30
	BREQ _0x7
	LDI  R30,LOW(2)
	RJMP _0x2060006
_0x7:
	RJMP _0x2060007
; .FEND
_TWI_Start:
; .FSTART _TWI_Start
	LDI  R30,LOW(164)
	STS  116,R30
	LDI  R26,LOW(8)
	RJMP _0x2060008
; .FEND
_TWI_Write_SLAW:
; .FSTART _TWI_Write_SLAW
	RCALL SUBOPT_0x0
;	Addr -> R17
	LDI  R26,LOW(24)
	RCALL _TWI_TransCheck_ACK
	RJMP _0x2060003
; .FEND
_TWI_Write_Data:
; .FSTART _TWI_Write_Data
	RCALL SUBOPT_0x0
;	Data -> R17
	LDI  R26,LOW(40)
	RCALL _TWI_TransCheck_ACK
	RJMP _0x2060003
; .FEND
_TWI_Stop:
; .FSTART _TWI_Stop
	LDI  R30,LOW(148)
	STS  116,R30
	RET
; .FEND
_TWI_Restart:
; .FSTART _TWI_Restart
	LDI  R30,LOW(164)
	STS  116,R30
	LDI  R26,LOW(16)
_0x2060008:
	RCALL _TWI_TransCheck_ACK
	RET
; .FEND
;	Data -> R19
;	Addr -> R16
;	ret_err -> R17
_TWI_Write_SLAR:
; .FSTART _TWI_Write_SLAR
	ST   -Y,R17
	MOV  R17,R26
;	Addr -> R17
	MOV  R30,R17
	ORI  R30,1
	STS  115,R30
	LDI  R30,LOW(132)
	STS  116,R30
	LDI  R26,LOW(64)
	RCALL _TWI_TransCheck_ACK
	RJMP _0x2060003
; .FEND
;	*Data -> R18,R19
;	ret_err -> R17
_TWI_Read_Data_NACK:
; .FSTART _TWI_Read_Data_NACK
	RCALL __SAVELOCR4
	MOVW R18,R26
;	*Data -> R18,R19
;	ret_err -> R17
	LDI  R17,0
	LDI  R30,LOW(132)
	STS  116,R30
	LDI  R26,LOW(88)
	RCALL _TWI_TransCheck_ACK
	MOV  R17,R30
	LDS  R30,115
	MOVW R26,R18
	ST   X,R30
_0x2060007:
	LDI  R30,LOW(0)
_0x2060006:
	RCALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND
;	Addr -> R21
;	*Data -> R18,R19
;	rec_data -> R17
;	ret_err -> R16
;	Slave_Addr -> R17
;	*Data -> R18,R19
;	ret_err -> R17
;	*Data -> R18,R19
;	ret_err -> R17
;	rec_data -> R16
;	devAddr -> R20
;	regAddr -> R21
;	*Data -> R18,R19
;	rec_data -> R17
;	ret_err -> R16
_LCD_PORT_Init:
; .FSTART _LCD_PORT_Init
	LDI  R30,LOW(255)
	OUT  0x1A,R30
	LDI  R30,LOW(31)
	STS  100,R30
	RET
; .FEND
_LCD_Data:
; .FSTART _LCD_Data
	RCALL SUBOPT_0x1
;	ch -> R17
	ORI  R30,4
	RCALL SUBOPT_0x2
	ANDI R30,0xFD
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x3
	RJMP _0x2060003
; .FEND
_LCD_Comm:
; .FSTART _LCD_Comm
	RCALL SUBOPT_0x1
;	ch -> R17
	ANDI R30,0xFB
	RCALL SUBOPT_0x2
	ANDI R30,0xFD
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x3
	RJMP _0x2060003
; .FEND
_LCD_delay:
; .FSTART _LCD_delay
	ST   -Y,R17
	MOV  R17,R26
;	ms -> R17
	CLR  R27
	RCALL _delay_ms
	RJMP _0x2060003
; .FEND
_LCD_Pos:
; .FSTART _LCD_Pos
	ST   -Y,R17
	ST   -Y,R16
	MOV  R17,R26
	LDD  R16,Y+2
;	col -> R16
;	row -> R17
	LDI  R26,LOW(64)
	MULS R16,R26
	MOVW R30,R0
	ADD  R30,R17
	ORI  R30,0x80
	MOV  R26,R30
	RCALL _LCD_Comm
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,3
	RET
; .FEND
_LCD_Char:
; .FSTART _LCD_Char
	ST   -Y,R17
	MOV  R17,R26
;	c -> R17
	RCALL _LCD_Data
	LDI  R26,LOW(1)
	LDI  R27,0
	RCALL _delay_ms
	RJMP _0x2060003
; .FEND
_LCD_Str:
; .FSTART _LCD_Str
	ST   -Y,R17
	ST   -Y,R16
	MOVW R16,R26
;	*str -> R16,R17
_0x1A:
	MOVW R26,R16
	LD   R30,X
	CPI  R30,0
	BREQ _0x1C
	LD   R26,X
	RCALL _LCD_Char
	__ADDWRN 16,17,1
	RJMP _0x1A
_0x1C:
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;	*str -> R18,R19
;	loop_count -> R17

	.DSEG
_0x21:
	.BYTE 0x15

	.CSEG
_LCD_Clear:
; .FSTART _LCD_Clear
	LDI  R26,LOW(1)
	RCALL _LCD_Comm
	LDI  R26,LOW(2)
	RCALL _LCD_delay
	RET
; .FEND
_LCD_Init:
; .FSTART _LCD_Init
	RCALL _LCD_PORT_Init
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x4
	LDI  R26,LOW(14)
	RCALL _LCD_Comm
	LDI  R26,LOW(4)
	RCALL _LCD_delay
	LDI  R26,LOW(6)
	RCALL _LCD_Comm
	LDI  R26,LOW(4)
	RCALL _LCD_delay
	RCALL _LCD_Clear
	RET
; .FEND
;	p -> R17
;	p -> R17
;void Timer0_Init()
; 0000 001A {
_Timer0_Init:
; .FSTART _Timer0_Init
; 0000 001B TCCR0 = (1<<WGM01)|(1<<CS00)|(1<<CS01)|(1<<CS02);
	LDI  R30,LOW(15)
	OUT  0x33,R30
; 0000 001C TCNT0 = 0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 001D OCR2 = 14;
	LDI  R30,LOW(14)
	OUT  0x23,R30
; 0000 001E TIMSK = (1<<OCIE0);
	LDI  R30,LOW(2)
	OUT  0x37,R30
; 0000 001F }
	RET
; .FEND
;interrupt [16] void timer0_comp(void)
; 0000 0022 {
_timer0_comp:
; .FSTART _timer0_comp
	ST   -Y,R30
	IN   R30,SREG
; 0000 0023 ti_Cnt_1ms ++;
	INC  R5
; 0000 0024 LCD_DelCnt_1ms ++;
	INC  R4
; 0000 0025 }
	OUT  SREG,R30
	LD   R30,Y+
	RETI
; .FEND
;unsigned char SRF02_I2C_Write(char address, char reg, char data)
; 0000 002A {
_SRF02_I2C_Write:
; .FSTART _SRF02_I2C_Write
; 0000 002B unsigned char ret_err = 0;
; 0000 002C ret_err = TWI_Start();
	RCALL __SAVELOCR4
	MOV  R16,R26
	LDD  R19,Y+4
	LDD  R18,Y+5
;	address -> R18
;	reg -> R19
;	data -> R16
;	ret_err -> R17
	LDI  R17,0
	RCALL _TWI_Start
	MOV  R17,R30
; 0000 002D ret_err = TWI_Write_SLAW(address);
	MOV  R26,R18
	RCALL _TWI_Write_SLAW
	MOV  R17,R30
; 0000 002E if(ret_err !=0) return ret_err;
	CPI  R17,0
	BREQ _0x29
	RJMP _0x2060005
; 0000 002F ret_err = TWI_Write_Data(reg);
_0x29:
	MOV  R26,R19
	RCALL _TWI_Write_Data
	MOV  R17,R30
; 0000 0030 if(ret_err != 0) return ret_err;
	CPI  R17,0
	BREQ _0x2A
	RJMP _0x2060005
; 0000 0031 ret_err = TWI_Write_Data(data);
_0x2A:
	MOV  R26,R16
	RCALL _TWI_Write_Data
	MOV  R17,R30
; 0000 0032 if(ret_err != 0) return ret_err;
	CPI  R17,0
	BREQ _0x2B
	RJMP _0x2060005
; 0000 0033 TWI_Stop();
_0x2B:
	RCALL _TWI_Stop
; 0000 0034 return 0;
	LDI  R30,LOW(0)
_0x2060005:
	RCALL __LOADLOCR4
	ADIW R28,6
	RET
; 0000 0035 
; 0000 0036 }
; .FEND
;unsigned char SRF02_I2C_Read(char address, char reg, unsigned char* Data)
; 0000 0039 {
_SRF02_I2C_Read:
; .FSTART _SRF02_I2C_Read
; 0000 003A char read_data = 0;
; 0000 003B unsigned char ret_err = 0;
; 0000 003C ret_err = TWI_Start();
	RCALL __SAVELOCR6
	MOVW R18,R26
	LDD  R21,Y+6
	LDD  R20,Y+7
;	address -> R20
;	reg -> R21
;	*Data -> R18,R19
;	read_data -> R17
;	ret_err -> R16
	LDI  R17,0
	LDI  R16,0
	RCALL _TWI_Start
	MOV  R16,R30
; 0000 003D 
; 0000 003E ret_err = TWI_Write_SLAW(address);
	MOV  R26,R20
	RCALL _TWI_Write_SLAW
	MOV  R16,R30
; 0000 003F if(ret_err !=0) return ret_err;
	CPI  R16,0
	BREQ _0x2C
	RJMP _0x2060004
; 0000 0040 ret_err = TWI_Write_Data(reg);
_0x2C:
	MOV  R26,R21
	RCALL _TWI_Write_Data
	MOV  R16,R30
; 0000 0041 if(ret_err !=0) return ret_err;
	CPI  R16,0
	BREQ _0x2D
	RJMP _0x2060004
; 0000 0042 
; 0000 0043 ret_err = TWI_Restart();
_0x2D:
	RCALL _TWI_Restart
	MOV  R16,R30
; 0000 0044 PORTB|= 0x08;
	SBI  0x18,3
; 0000 0045 if(ret_err !=0) return ret_err;
	CPI  R16,0
	BREQ _0x2E
	RJMP _0x2060004
; 0000 0046 
; 0000 0047 ret_err = TWI_Write_SLAR(address);
_0x2E:
	MOV  R26,R20
	RCALL _TWI_Write_SLAR
	MOV  R16,R30
; 0000 0048 PORTB |= 0x10;
	SBI  0x18,4
; 0000 0049 if(ret_err !=0) return ret_err;
	CPI  R16,0
	BREQ _0x2F
	RJMP _0x2060004
; 0000 004A 
; 0000 004B ret_err = TWI_Read_Data_NACK(&read_data);
_0x2F:
	IN   R26,SPL
	IN   R27,SPH
	PUSH R17
	RCALL _TWI_Read_Data_NACK
	POP  R17
	MOV  R16,R30
; 0000 004C PORTB |= 0x20;
	SBI  0x18,5
; 0000 004D if(ret_err !=0) return ret_err;
	CPI  R16,0
	BREQ _0x30
	RJMP _0x2060004
; 0000 004E TWI_Stop();
_0x30:
	RCALL _TWI_Stop
; 0000 004F *Data = read_data;
	MOV  R30,R17
	MOVW R26,R18
	ST   X,R30
; 0000 0050 return 0;
	LDI  R30,LOW(0)
_0x2060004:
	RCALL __LOADLOCR6
	ADIW R28,8
	RET
; 0000 0051 }
; .FEND
;unsigned char startRanging(char addr)
; 0000 0054 {
_startRanging:
; .FSTART _startRanging
; 0000 0055 return SRF02_I2C_Write(addr, COM_REG, SRF02_Return_Cm);
	ST   -Y,R17
	MOV  R17,R26
;	addr -> R17
	ST   -Y,R17
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(81)
	RCALL _SRF02_I2C_Write
_0x2060003:
	LD   R17,Y+
	RET
; 0000 0056 }
; .FEND
;unsigned int getRange(char addr, unsigned int*pDistance)
; 0000 0059 {
_getRange:
; .FSTART _getRange
; 0000 005A unsigned char temp;
; 0000 005B unsigned char res = 0;
; 0000 005C res = SRF02_I2C_Read(addr,2,&temp);
	RCALL __SAVELOCR6
	MOVW R18,R26
	LDD  R21,Y+6
;	addr -> R21
;	*pDistance -> R18,R19
;	temp -> R17
;	res -> R16
	LDI  R16,0
	ST   -Y,R21
	LDI  R30,LOW(2)
	ST   -Y,R30
	IN   R26,SPL
	IN   R27,SPH
	PUSH R17
	RCALL _SRF02_I2C_Read
	POP  R17
	MOV  R16,R30
; 0000 005D if(res) return res;
	CPI  R16,0
	BREQ _0x31
	LDI  R31,0
	RJMP _0x2060002
; 0000 005E *pDistance = temp << 8;
_0x31:
	MOV  R31,R17
	LDI  R30,LOW(0)
	MOVW R26,R18
	ST   X+,R30
	ST   X,R31
; 0000 005F res = SRF02_I2C_Read(addr,3,&temp);
	ST   -Y,R21
	LDI  R30,LOW(3)
	ST   -Y,R30
	IN   R26,SPL
	IN   R27,SPH
	PUSH R17
	RCALL _SRF02_I2C_Read
	POP  R17
	MOV  R16,R30
; 0000 0060 if(res) return res;
	CPI  R16,0
	BREQ _0x32
	LDI  R31,0
	RJMP _0x2060002
; 0000 0061 *pDistance |= temp;
_0x32:
	MOVW R30,R18
	MOVW R0,R30
	MOVW R26,R30
	LD   R30,X+
	LD   R31,X+
	MOVW R26,R30
	MOV  R30,R17
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
; 0000 0062 
; 0000 0063 return res;
	MOV  R30,R16
	LDI  R31,0
	RJMP _0x2060002
; 0000 0064 }
; .FEND
;unsigned char change_Sonar_Addr(unsigned char ori, unsigned char des)
; 0000 0068 {
; 0000 0069 unsigned char res = 0;
; 0000 006A switch(des)
;	ori -> R19
;	des -> R16
;	res -> R17
; 0000 006B {
; 0000 006C case 0xE0:
; 0000 006D case 0xE2:
; 0000 006E case 0xE4:
; 0000 006F case 0xE6:
; 0000 0070 case 0xE8:
; 0000 0071 case 0xEA:
; 0000 0072 case 0xEC:
; 0000 0073 case 0xEE:
; 0000 0074 case 0xF0:
; 0000 0075 case 0xF2:
; 0000 0076 case 0xF4:
; 0000 0077 case 0xF6:
; 0000 0078 case 0xF8:
; 0000 0079 case 0xFA:
; 0000 007A case 0xFC:
; 0000 007B case 0xFE:
; 0000 007C 
; 0000 007D res = SRF02_I2C_Write(ori, COM_REG, SRF02_1st_Seq_change);
; 0000 007E if(res) return res;
; 0000 007F res = SRF02_I2C_Write(ori, COM_REG, SRF02_2nd_Seq_change);
; 0000 0080 if(res) return res;
; 0000 0081 res = SRF02_I2C_Write(ori, COM_REG, SRF02_3rd_Seq_change);
; 0000 0082 if(res) return res;
; 0000 0083 
; 0000 0084 res = SRF02_I2C_Write(ori,COM_REG,des);
; 0000 0085 if(res) return res;
; 0000 0086 break;
; 0000 0087 default:
; 0000 0088 return -1;
; 0000 0089 }
; 0000 008A return 0;
; 0000 008B 
; 0000 008C 
; 0000 008D 
; 0000 008E 
; 0000 008F }
;void main(void)
; 0000 0095 {
_main:
; .FSTART _main
; 0000 0096 
; 0000 0097 char Sonar_Addr = 0xE0;
; 0000 0098 unsigned int Sonar_range;
; 0000 0099 char Message[40];
; 0000 009A int readCnt = 0;
; 0000 009B unsigned char res = 0;
; 0000 009C DDRD |= 0x03;
	SBIW R28,40
;	Sonar_Addr -> R17
;	Sonar_range -> R18,R19
;	Message -> Y+0
;	readCnt -> R20,R21
;	res -> R16
	LDI  R17,224
	__GETWRN 20,21,0
	LDI  R16,0
	IN   R30,0x11
	ORI  R30,LOW(0x3)
	OUT  0x11,R30
; 0000 009D 
; 0000 009E LCD_Init();
	RCALL _LCD_Init
; 0000 009F Timer0_Init();
	RCALL _Timer0_Init
; 0000 00A0 Init_TWI();
	RCALL _Init_TWI
; 0000 00A1 delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0000 00A2 SREG|=0x80;
	BSET 7
; 0000 00A3 
; 0000 00A4 startRanging(Sonar_Addr);
	MOV  R26,R17
	RCALL _startRanging
; 0000 00A5 ti_Cnt_1ms = 0;
	CLR  R5
; 0000 00A6 LCD_DelCnt_1ms = 0;
	CLR  R4
; 0000 00A7 
; 0000 00A8 
; 0000 00A9 while (1)
_0x5A:
; 0000 00AA {
; 0000 00AB if(ti_Cnt_1ms > 66){
	LDI  R30,LOW(66)
	CP   R30,R5
	BRSH _0x5D
; 0000 00AC res = getRange(Sonar_Addr, &Sonar_range);
	ST   -Y,R17
	IN   R26,SPL
	IN   R27,SPH
	SBIW R26,1
	PUSH R19
	PUSH R18
	RCALL _getRange
	POP  R18
	POP  R19
	MOV  R16,R30
; 0000 00AD if(res)
	CPI  R16,0
	BREQ _0x5E
; 0000 00AE {
; 0000 00AF LCD_Pos(0,0);
	RCALL SUBOPT_0x5
; 0000 00B0 LCD_Str("Measured Dist.= ");
	__POINTW2MN _0x5F,0
	RCALL _LCD_Str
; 0000 00B1 
; 0000 00B2 LCD_Pos(1,5);
	RCALL SUBOPT_0x6
; 0000 00B3 LCD_Str("ERR       ");
	__POINTW2MN _0x5F,17
	RCALL _LCD_Str
; 0000 00B4 
; 0000 00B5 }
; 0000 00B6 else if(LCD_DelCnt_1ms > 100)
	RJMP _0x60
_0x5E:
	LDI  R30,LOW(100)
	CP   R30,R4
	BRSH _0x61
; 0000 00B7 {
; 0000 00B8 LCD_Pos(0,0);
	RCALL SUBOPT_0x5
; 0000 00B9 LCD_Str("Measured Dist.)= ");
	__POINTW2MN _0x5F,28
	RCALL _LCD_Str
; 0000 00BA 
; 0000 00BB sprintf(Message, "%01d  %03d cm",readCnt,Sonar_range);
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,67
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	RCALL SUBOPT_0x7
	RCALL __PUTPARD1
	MOVW R30,R18
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDI  R24,8
	RCALL _sprintf
	ADIW R28,12
; 0000 00BC LCD_Pos(1,5);
	RCALL SUBOPT_0x6
; 0000 00BD LCD_Str(Message);
	MOVW R26,R28
	RCALL _LCD_Str
; 0000 00BE 
; 0000 00BF LCD_DelCnt_1ms = 0;
	CLR  R4
; 0000 00C0 }
; 0000 00C1 
; 0000 00C2 startRanging(Sonar_Addr);
_0x61:
_0x60:
	MOV  R26,R17
	RCALL _startRanging
; 0000 00C3 ti_Cnt_1ms = 0;
	CLR  R5
; 0000 00C4 readCnt = (readCnt + 1)%10;
	MOVW R26,R20
	ADIW R26,1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	MOVW R20,R30
; 0000 00C5 }
; 0000 00C6 
; 0000 00C7 }
_0x5D:
	RJMP _0x5A
; 0000 00C8 }
_0x62:
	RJMP _0x62
; .FEND

	.DSEG
_0x5F:
	.BYTE 0x2E
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G100:
; .FSTART _put_buff_G100
	RCALL __SAVELOCR6
	MOVW R18,R26
	LDD  R21,Y+6
	ADIW R26,2
	__GETW1P
	SBIW R30,0
	BREQ _0x2000010
	MOVW R26,R18
	RCALL SUBOPT_0x8
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2000012
	__CPWRN 16,17,2
	BRLO _0x2000013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1RNS 18,4
_0x2000012:
	MOVW R26,R18
	ADIW R26,2
	RCALL SUBOPT_0x9
	SBIW R30,1
	ST   Z,R21
_0x2000013:
	MOVW R26,R18
	__GETW1P
	TST  R31
	BRMI _0x2000014
	RCALL SUBOPT_0x9
_0x2000014:
	RJMP _0x2000015
_0x2000010:
	MOVW R26,R18
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2000015:
_0x2060002:
	RCALL __LOADLOCR6
	ADIW R28,7
	RET
; .FEND
__print_G100:
; .FSTART __print_G100
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,11
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000016:
	LDD  R30,Y+23
	LDD  R31,Y+23+1
	ADIW R30,1
	STD  Y+23,R30
	STD  Y+23+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001C
	CPI  R18,37
	BRNE _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	RCALL SUBOPT_0xA
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	RCALL SUBOPT_0xA
	RJMP _0x20000D2
_0x2000020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000021
	LDI  R16,LOW(1)
	RJMP _0x200001B
_0x2000021:
	CPI  R18,43
	BRNE _0x2000022
	LDI  R20,LOW(43)
	RJMP _0x200001B
_0x2000022:
	CPI  R18,32
	BRNE _0x2000023
	LDI  R20,LOW(32)
	RJMP _0x200001B
_0x2000023:
	RJMP _0x2000024
_0x200001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000025
_0x2000024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000026
	ORI  R16,LOW(128)
	RJMP _0x200001B
_0x2000026:
	RJMP _0x2000027
_0x2000025:
	CPI  R30,LOW(0x3)
	BRNE _0x2000028
_0x2000027:
	CPI  R18,48
	BRLO _0x200002A
	CPI  R18,58
	BRLO _0x200002B
_0x200002A:
	RJMP _0x2000029
_0x200002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001B
_0x2000029:
	CPI  R18,108
	BRNE _0x200002C
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x200001B
_0x200002C:
	RJMP _0x200002D
_0x2000028:
	CPI  R30,LOW(0x5)
	BREQ PC+2
	RJMP _0x200001B
_0x200002D:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2000032
	RCALL SUBOPT_0xB
	LDD  R30,Y+21
	LDD  R31,Y+21+1
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0xC
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x73)
	BRNE _0x2000035
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0xD
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x70)
	BRNE _0x2000038
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0xD
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000036:
	ANDI R16,LOW(127)
	LDI  R30,LOW(0)
	STD  Y+16,R30
	LDI  R19,LOW(0)
	RJMP _0x2000039
_0x2000038:
	CPI  R30,LOW(0x64)
	BREQ _0x200003C
	CPI  R30,LOW(0x69)
	BRNE _0x200003D
_0x200003C:
	ORI  R16,LOW(4)
	RJMP _0x200003E
_0x200003D:
	CPI  R30,LOW(0x75)
	BRNE _0x200003F
_0x200003E:
	LDI  R30,LOW(10)
	STD  Y+16,R30
	SBRS R16,1
	RJMP _0x2000040
	__GETD1N 0x3B9ACA00
	RCALL SUBOPT_0xE
	LDI  R17,LOW(10)
	RJMP _0x2000041
_0x2000040:
	__GETD1N 0x2710
	RCALL SUBOPT_0xE
	LDI  R17,LOW(5)
	RJMP _0x2000041
_0x200003F:
	CPI  R30,LOW(0x58)
	BRNE _0x2000043
	ORI  R16,LOW(8)
	RJMP _0x2000044
_0x2000043:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2000077
_0x2000044:
	LDI  R30,LOW(16)
	STD  Y+16,R30
	SBRS R16,1
	RJMP _0x2000046
	__GETD1N 0x10000000
	RCALL SUBOPT_0xE
	LDI  R17,LOW(8)
	RJMP _0x2000041
_0x2000046:
	__GETD1N 0x1000
	RCALL SUBOPT_0xE
	LDI  R17,LOW(4)
_0x2000041:
	SBRS R16,1
	RJMP _0x2000047
	RCALL SUBOPT_0xB
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	ADIW R26,4
	RCALL __GETD1P
	RJMP _0x20000D3
_0x2000047:
	SBRS R16,2
	RJMP _0x2000049
	RCALL SUBOPT_0xB
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x7
	RJMP _0x20000D3
_0x2000049:
	RCALL SUBOPT_0xB
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	RCALL SUBOPT_0x8
	CLR  R22
	CLR  R23
_0x20000D3:
	__PUTD1S 12
	SBRS R16,2
	RJMP _0x200004B
	LDD  R26,Y+15
	TST  R26
	BRPL _0x200004C
	__GETD1S 12
	RCALL __ANEGD1
	RCALL SUBOPT_0xF
	LDI  R20,LOW(45)
_0x200004C:
	CPI  R20,0
	BREQ _0x200004D
	SUBI R17,-LOW(1)
	RJMP _0x200004E
_0x200004D:
	ANDI R16,LOW(251)
_0x200004E:
_0x200004B:
_0x2000039:
	SBRC R16,0
	RJMP _0x200004F
_0x2000050:
	CP   R17,R21
	BRSH _0x2000052
	SBRS R16,7
	RJMP _0x2000053
	SBRS R16,2
	RJMP _0x2000054
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x2000055
_0x2000054:
	LDI  R18,LOW(48)
_0x2000055:
	RJMP _0x2000056
_0x2000053:
	LDI  R18,LOW(32)
_0x2000056:
	RCALL SUBOPT_0xA
	SUBI R21,LOW(1)
	RJMP _0x2000050
_0x2000052:
_0x200004F:
	MOV  R19,R17
	LDD  R30,Y+16
	CPI  R30,0
	BRNE _0x2000057
_0x2000058:
	CPI  R19,0
	BREQ _0x200005A
	SBRS R16,3
	RJMP _0x200005B
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x200005C
_0x200005B:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x200005C:
	RCALL SUBOPT_0xA
	CPI  R21,0
	BREQ _0x200005D
	SUBI R21,LOW(1)
_0x200005D:
	SUBI R19,LOW(1)
	RJMP _0x2000058
_0x200005A:
	RJMP _0x200005E
_0x2000057:
_0x2000060:
	RCALL SUBOPT_0x10
	RCALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x2000062
	SBRS R16,3
	RJMP _0x2000063
	SUBI R18,-LOW(55)
	RJMP _0x2000064
_0x2000063:
	SUBI R18,-LOW(87)
_0x2000064:
	RJMP _0x2000065
_0x2000062:
	SUBI R18,-LOW(48)
_0x2000065:
	SBRC R16,4
	RJMP _0x2000067
	CPI  R18,49
	BRSH _0x2000069
	RCALL SUBOPT_0x11
	__CPD2N 0x1
	BRNE _0x2000068
_0x2000069:
	RJMP _0x200006B
_0x2000068:
	CP   R21,R19
	BRLO _0x200006D
	SBRS R16,0
	RJMP _0x200006E
_0x200006D:
	RJMP _0x200006C
_0x200006E:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x200006F
	LDI  R18,LOW(48)
_0x200006B:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2000070
	ANDI R16,LOW(251)
	ST   -Y,R20
	RCALL SUBOPT_0xC
	CPI  R21,0
	BREQ _0x2000071
	SUBI R21,LOW(1)
_0x2000071:
_0x2000070:
_0x200006F:
_0x2000067:
	RCALL SUBOPT_0xA
	CPI  R21,0
	BREQ _0x2000072
	SUBI R21,LOW(1)
_0x2000072:
_0x200006C:
	SUBI R19,LOW(1)
	RCALL SUBOPT_0x10
	RCALL __MODD21U
	RCALL SUBOPT_0xF
	LDD  R30,Y+16
	RCALL SUBOPT_0x11
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __DIVD21U
	RCALL SUBOPT_0xE
	__GETD1S 8
	__CPD10
	BREQ _0x2000061
	RJMP _0x2000060
_0x2000061:
_0x200005E:
	SBRS R16,0
	RJMP _0x2000073
_0x2000074:
	CPI  R21,0
	BREQ _0x2000076
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0xC
	RJMP _0x2000074
_0x2000076:
_0x2000073:
_0x2000077:
_0x2000033:
_0x20000D2:
	LDI  R17,LOW(0)
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	LD   R30,X+
	LD   R31,X+
	RCALL __LOADLOCR6
	ADIW R28,25
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	RCALL __SAVELOCR6
	MOVW R30,R28
	__ADDW1R15
	__GETWRZ 20,21,14
	MOV  R0,R20
	OR   R0,R21
	BRNE _0x2000078
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2060001
_0x2000078:
	MOVW R26,R28
	ADIW R26,8
	__ADDW2R15
	MOVW R16,R26
	__PUTWSR 20,21,8
	LDI  R30,LOW(0)
	STD  Y+10,R30
	STD  Y+10+1,R30
	MOVW R26,R28
	ADIW R26,12
	__ADDW2R15
	LD   R30,X+
	LD   R31,X+
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,12
	RCALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2060001:
	RCALL __LOADLOCR6
	ADIW R28,12
	POP  R15
	RET
; .FEND

	.CSEG

	.CSEG
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x0:
	ST   -Y,R17
	MOV  R17,R26
	STS  115,R17
	LDI  R30,LOW(132)
	STS  116,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	ST   -Y,R17
	MOV  R17,R26
	LDS  R30,101
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2:
	STS  101,R30
	LDS  R30,101
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x3:
	ORI  R30,1
	STS  101,R30
	__DELAY_USB 246
	OUT  0x1B,R17
	__DELAY_USB 246
	LDS  R30,101
	ANDI R30,0xFE
	STS  101,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4:
	LDI  R26,LOW(56)
	RCALL _LCD_Comm
	LDI  R26,LOW(4)
	RJMP _LCD_delay

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP _LCD_Pos

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(5)
	RJMP _LCD_Pos

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	__CWD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x8:
	ADIW R26,4
	__GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x9:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0xA:
	ST   -Y,R18
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0xB:
	LDD  R30,Y+21
	LDD  R31,Y+21+1
	SBIW R30,4
	STD  Y+21,R30
	STD  Y+21+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xC:
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xD:
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	ADIW R26,4
	LD   R30,X+
	LD   R31,X+
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xE:
	__PUTD1S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x10:
	__GETD1S 8
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	__GETD2S 8
	RET

;RUNTIME LIBRARY

	.CSEG
__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	MOVW R20,R0
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	NEG  R27
	NEG  R26
	SBCI R27,0
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0xE66
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
