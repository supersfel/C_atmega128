
;CodeVisionAVR C Compiler V3.45 
;(C) Copyright 1998-2021 Pavel Haiduc, HP InfoTech S.R.L.
;http://www.hpinfotech.ro

;Build configuration    : Debug
;Chip type              : ATmega128
;Program type           : Application
;Clock frequency        : 14.745600 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
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
	.DEF _buffer_count=R5
	.DEF _zero_flag=R4
	.DEF _interrupt_flag=R7
	.DEF _master_password=R8
	.DEF _master_password_msb=R9

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
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
	JMP  _compare
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
	JMP  _usart1_receive
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  LOW(_0x13),HIGH(_0x13)

_0x12:
	.DB  0x0,0x0,0x9,0x0,0x8,0x0,0x7,0x0
	.DB  0x6,0x0,0x5,0x0,0x4,0x0,0x3,0x0
	.DB  0x2,0x0,0x1
_0x14:
	.DB  0xC0,0xF9,0xA4,0xB0,0x99,0x92,0x82,0xD8
	.DB  0x80,0x90,0x88,0x83,0xC4,0xA1,0x84,0x8E
_0x15:
	.DB  0x1F,0x0,0x2F,0x0,0x4F,0x0,0x8F
_0x57:
	.DB  0x2A,0x2A,0x2A,0x2A,0x2A,0x2A,0x2A,0x2A
	.DB  0x2A,0x2A,0x2A,0x2A,0x2A,0x2A,0x20,0x0
	.DB  0x50,0x41,0x53,0x53,0x57,0x4F,0x52,0x44
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
_0x0:
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0x32,0x30,0x31
	.DB  0x37,0x31,0x34,0x32,0x30,0x33,0x37,0x0
	.DB  0x4D,0x41,0x53,0x54,0x45,0x52,0x20,0x4D
	.DB  0x4F,0x44,0x45,0x20,0x20,0x20,0x20,0x0
	.DB  0x2A,0x2A,0x2A,0x2A,0x2A,0x2A,0x2A,0x2A
	.DB  0x2A,0x2A,0x2A,0x2A,0x2A,0x2A,0x0,0x50
	.DB  0x41,0x53,0x53,0x57,0x4F,0x52,0x44,0x20
	.DB  0x53,0x45,0x54,0x0,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x0,0x20,0x2D,0x53,0x55,0x43
	.DB  0x43,0x45,0x53,0x53,0x2D,0x20,0x20,0x20
	.DB  0x20,0x0,0x44,0x4F,0x4F,0x52,0x20,0x4F
	.DB  0x50,0x45,0x4E,0x20,0x20,0x20,0x20,0x0
	.DB  0x20,0x65,0x72,0x72,0x6F,0x72,0x2E,0x2E
	.DB  0x2E,0x2E,0x2E,0x2E,0x2E,0x20,0x20,0x20
	.DB  0x0,0x57,0x61,0x72,0x6E,0x69,0x6E,0x67
	.DB  0x2E,0x2E,0x2E,0x2E,0x2E,0x0,0x20,0x69
	.DB  0x66,0x2E,0x74,0x68,0x65,0x66,0x74,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x45,0x6E,0x74,0x65,0x72,0x20,0x50
	.DB  0x61,0x73,0x73,0x77,0x6F,0x72,0x64,0x20
	.DB  0x20,0xA,0x0,0x2D,0x2D,0x3E,0x20,0x20
	.DB  0xA,0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x06
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x15
	.DW  _0xA
	.DW  _0x0*2

	.DW  0x13
	.DW  _password
	.DW  _0x12*2

	.DW  0x0B
	.DW  _0x13
	.DW  _0x0*2+21

	.DW  0x10
	.DW  _Port_char
	.DW  _0x14*2

	.DW  0x07
	.DW  _Port_fnd
	.DW  _0x15*2

	.DW  0x10
	.DW  _0x19
	.DW  _0x0*2+32

	.DW  0x0F
	.DW  _0x19+16
	.DW  _0x0*2+48

	.DW  0x0D
	.DW  _0x49
	.DW  _0x0*2+63

	.DW  0x0F
	.DW  _0x49+13
	.DW  _0x0*2+76

	.DW  0x0D
	.DW  _0x49+28
	.DW  _0x0*2+63

	.DW  0x0F
	.DW  _0x49+41
	.DW  _0x0*2+91

	.DW  0x0E
	.DW  _0x66
	.DW  _0x0*2+106

	.DW  0x0F
	.DW  _0x66+14
	.DW  _0x0*2+6

	.DW  0x11
	.DW  _0x66+29
	.DW  _0x0*2+120

	.DW  0x10
	.DW  _0x66+46
	.DW  _0x0*2+32

	.DW  0x0D
	.DW  _0x66+62
	.DW  _0x0*2+137

	.DW  0x13
	.DW  _0x66+75
	.DW  _0x0*2+150

	.DW  0x10
	.DW  _0x66+94
	.DW  _0x0*2+32

	.DW  0x12
	.DW  _0x66+110
	.DW  _0x0*2+169

	.DW  0x07
	.DW  _0x66+128
	.DW  _0x0*2+187

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
	RCALL SUBOPT_0x0
;	ch -> R17
	ORI  R30,4
	RCALL SUBOPT_0x1
	ANDI R30,0xFD
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x2
	RJMP _0x2000002
; .FEND
_LCD_Comm:
; .FSTART _LCD_Comm
	RCALL SUBOPT_0x0
;	ch -> R17
	ANDI R30,0xFB
	RCALL SUBOPT_0x1
	ANDI R30,0xFD
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x2
	RJMP _0x2000002
; .FEND
_LCD_delay:
; .FSTART _LCD_delay
	ST   -Y,R17
	MOV  R17,R26
;	ms -> R17
	CLR  R27
	RCALL _delay_ms
	RJMP _0x2000002
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
	RJMP _0x2000002
; .FEND
_LCD_Str:
; .FSTART _LCD_Str
	ST   -Y,R17
	ST   -Y,R16
	MOVW R16,R26
;	*str -> R16,R17
_0x3:
	MOVW R26,R16
	LD   R30,X
	CPI  R30,0
	BREQ _0x5
	LD   R26,X
	RCALL _LCD_Char
	__ADDWRN 16,17,1
	RJMP _0x3
_0x5:
	RJMP _0x2000001
; .FEND
;	*str -> R18,R19
;	loop_count -> R17

	.DSEG
_0xA:
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
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x3
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

	.DSEG
_0x13:
	.BYTE 0xB
;interrupt [31] void usart1_receive(void)
; 0000 001D {

	.CSEG
_usart1_receive:
; .FSTART _usart1_receive
	RCALL SUBOPT_0x4
; 0000 001E if(master_flag)    //마스터모드에서만 동작하게 설정
	SBRS R2,0
	RJMP _0x16
; 0000 001F {
; 0000 0020 str[buffer_count] = UDR1;
	MOV  R26,R5
	LDI  R27,0
	SUBI R26,LOW(-_str)
	SBCI R27,HIGH(-_str)
	LDS  R30,156
	ST   X,R30
; 0000 0021 if(buffer_count >= MAXLEN)
	LDI  R30,LOW(17)
	CP   R5,R30
	BRLO _0x17
; 0000 0022 buffer_count = 0;
	CLR  R5
; 0000 0023 else
	RJMP _0x18
_0x17:
; 0000 0024 buffer_count++;
	INC  R5
; 0000 0025 
; 0000 0026 
; 0000 0027 LCD_Clear();
_0x18:
	RCALL _LCD_Clear
; 0000 0028 LCD_Pos(0,0);
	RCALL SUBOPT_0x5
; 0000 0029 LCD_Str("MASTER MODE    ");
	__POINTW2MN _0x19,0
	RCALL _LCD_Str
; 0000 002A delay_us(1);
	__DELAY_USB 5
; 0000 002B LCD_Pos(1,0);
	RCALL SUBOPT_0x6
; 0000 002C LCD_Str("**************");
	__POINTW2MN _0x19,16
	RCALL _LCD_Str
; 0000 002D LCD_Pos(1,0);
	RCALL SUBOPT_0x6
; 0000 002E delay_us(1);
	__DELAY_USB 5
; 0000 002F LCD_Str(str);
	LDI  R26,LOW(_str)
	LDI  R27,HIGH(_str)
	RCALL _LCD_Str
; 0000 0030 
; 0000 0031 }
; 0000 0032 }
_0x16:
	RJMP _0xB7
; .FEND

	.DSEG
_0x19:
	.BYTE 0x1F
;void Init_USART1_IntCon(void)
; 0000 0035 {

	.CSEG
_Init_USART1_IntCon:
; .FSTART _Init_USART1_IntCon
; 0000 0036 // RXCIE1=1(수신 인터럽트 허가), RXEN0=1(수신 허가), TXEN0 = 1(송신 허가)
; 0000 0037 UCSR1B = (1<<RXCIE1)| (1<<RXEN1) | (1 <<TXEN1);
	LDI  R30,LOW(152)
	STS  154,R30
; 0000 0038 UBRR1L = 0x07; // 115200bps 보오 레이트 설정
	LDI  R30,LOW(7)
	STS  153,R30
; 0000 0039 SREG |= 0x80; // 전체 인터럽트 허가
	BSET 7
; 0000 003A }
	RET
; .FEND
;void PORT_Init(void)
; 0000 003E {
_PORT_Init:
; .FSTART _PORT_Init
; 0000 003F DDRE=0xF0;     //FND 출력을 위한 설정
	LDI  R30,LOW(240)
	OUT  0x2,R30
; 0000 0040 DDRF=0xFF;     //FND 출력을 위한 설정
	LDI  R30,LOW(255)
	STS  97,R30
; 0000 0041 DDRC=0x0F;     //키패드를 위한 설정
	LDI  R30,LOW(15)
	OUT  0x14,R30
; 0000 0042 DDRG=0x10;     //부저 출력을 위한 설정
	LDI  R30,LOW(16)
	STS  100,R30
; 0000 0043 DDRB=0x20;     //서브모터 출력을 위한 설정
	LDI  R30,LOW(32)
	OUT  0x17,R30
; 0000 0044 
; 0000 0045 EIMSK = 0x01;    // 외부인터럽트를 0~4까지 선택
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 0046 EICRA = 0xaf;    //INT0,1은 상승에지 INT2,3 하강에지로 선택
	LDI  R30,LOW(175)
	STS  106,R30
; 0000 0047 SREG |= 0x80;    //전체인터럽트 허가
	BSET 7
; 0000 0048 DDRD |= 0x00;    //D를 입력으로 받음(스위치)
	IN   R30,0x11
	OUT  0x11,R30
; 0000 0049 
; 0000 004A 
; 0000 004B 
; 0000 004C PORTC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x15,R30
; 0000 004D }
	RET
; .FEND
;char Num_to_Str(int num)
; 0000 0052 {
_Num_to_Str:
; .FSTART _Num_to_Str
; 0000 0053 char str;
; 0000 0054 switch(num)
	RCALL __SAVELOCR4
	MOVW R18,R26
;	num -> R18,R19
;	str -> R17
	MOVW R30,R18
; 0000 0055 {
; 0000 0056 case 0 :
	SBIW R30,0
	BRNE _0x1D
; 0000 0057 str = '0';
	LDI  R17,LOW(48)
; 0000 0058 break;
	RJMP _0x1C
; 0000 0059 case 1 :
_0x1D:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x1E
; 0000 005A str = '1';
	LDI  R17,LOW(49)
; 0000 005B break;
	RJMP _0x1C
; 0000 005C case 2 :
_0x1E:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x1F
; 0000 005D str = '2';
	LDI  R17,LOW(50)
; 0000 005E break;
	RJMP _0x1C
; 0000 005F case 3 :
_0x1F:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x20
; 0000 0060 str = '3';
	LDI  R17,LOW(51)
; 0000 0061 break;
	RJMP _0x1C
; 0000 0062 case 4 :
_0x20:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x21
; 0000 0063 str = '4';
	LDI  R17,LOW(52)
; 0000 0064 break;
	RJMP _0x1C
; 0000 0065 case 5 :
_0x21:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x22
; 0000 0066 str = '5';
	LDI  R17,LOW(53)
; 0000 0067 break;
	RJMP _0x1C
; 0000 0068 case 6 :
_0x22:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x23
; 0000 0069 str = '6';
	LDI  R17,LOW(54)
; 0000 006A break;
	RJMP _0x1C
; 0000 006B case 7 :
_0x23:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x24
; 0000 006C str = '7';
	LDI  R17,LOW(55)
; 0000 006D break;
	RJMP _0x1C
; 0000 006E case 8 :
_0x24:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x25
; 0000 006F str = '8';
	LDI  R17,LOW(56)
; 0000 0070 break;
	RJMP _0x1C
; 0000 0071 case 9 :
_0x25:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x1C
; 0000 0072 str = '9';
	LDI  R17,LOW(57)
; 0000 0073 break;
; 0000 0074 dafault:
; 0000 0075 break;
; 0000 0076 }
_0x1C:
; 0000 0077 return str;
	MOV  R30,R17
	RJMP _0x2000003
; 0000 0078 
; 0000 0079 }
; .FEND
;void Init_Timer1(void)
; 0000 007C {
_Init_Timer1:
; .FSTART _Init_Timer1
; 0000 007D 
; 0000 007E TCCR1A = (1<<COM1A1) | (1<<WGM11);
	LDI  R30,LOW(130)
	OUT  0x2F,R30
; 0000 007F TCCR1B = (1<<WGM13) | (1<<WGM12) | (1<<CS11);
	LDI  R30,LOW(26)
	OUT  0x2E,R30
; 0000 0080 TCNT1 = 0x00;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2C+1,R31
	OUT  0x2C,R30
; 0000 0081 ICR1 = 36864-1; // TOP 값 : 36864-> 20ms(0.542us X 36864), 0~36863
	LDI  R30,LOW(36863)
	LDI  R31,HIGH(36863)
	OUT  0x26+1,R31
	OUT  0x26,R30
; 0000 0082 OCR1A =2765 ; // 초기 시작 위치 0도
	LDI  R30,LOW(2765)
	LDI  R31,HIGH(2765)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 0083 TIMSK |= (1<<OCIE1A); // Output Compare Match Interrupt 허가
	IN   R30,0x37
	ORI  R30,0x10
	OUT  0x37,R30
; 0000 0084 }
	RET
; .FEND
;interrupt [13] void compare(void)
; 0000 0087 {
_compare:
; .FSTART _compare
; 0000 0088 #asm("nop");          //비교일치 인터럽트 구문
	NOP
; 0000 0089 }
	RETI
; .FEND
;void myDelay_us(unsigned int delay)
; 0000 008C 
; 0000 008D {
_myDelay_us:
; .FSTART _myDelay_us
; 0000 008E unsigned int loop;
; 0000 008F for(loop=0; loop<delay; loop++)
	RCALL SUBOPT_0x7
;	delay -> R18,R19
;	loop -> R16,R17
_0x29:
	__CPWRR 16,17,18,19
	BRSH _0x2A
; 0000 0090 delay_us(1);
	__DELAY_USB 5
	__ADDWRN 16,17,1
	RJMP _0x29
_0x2A:
; 0000 0091 }
	RJMP _0x2000003
; .FEND
;void Buzzer_play(unsigned int delay)
; 0000 0095 {
_Buzzer_play:
; .FSTART _Buzzer_play
; 0000 0096 unsigned int loop;
; 0000 0097 unsigned char Play_Tim=0;
; 0000 0098 Play_Tim = 10000/delay;
	RCALL __SAVELOCR6
	MOVW R20,R26
;	delay -> R20,R21
;	loop -> R16,R17
;	Play_Tim -> R19
	LDI  R19,0
	MOVW R30,R20
	LDI  R26,LOW(10000)
	LDI  R27,HIGH(10000)
	RCALL __DIVW21U
	MOV  R19,R30
; 0000 0099 for(loop=0; loop<Play_Tim; loop++)
	__GETWRN 16,17,0
_0x2C:
	MOV  R30,R19
	MOVW R26,R16
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x2D
; 0000 009A {
; 0000 009B PORTG |= 1<<4;      //buzzer off, PORTG의 4번 핀 on(out 1)
	LDS  R30,101
	ORI  R30,0x10
	RCALL SUBOPT_0x8
; 0000 009C myDelay_us(delay);
; 0000 009D PORTG &= ~(1<<4);   //buzzer on, PORTG의 4번 핀 off(out 0)
	LDS  R30,101
	ANDI R30,0xEF
	RCALL SUBOPT_0x8
; 0000 009E myDelay_us(delay);
; 0000 009F }
	__ADDWRN 16,17,1
	RJMP _0x2C
_0x2D:
; 0000 00A0 }
	RJMP _0x2000004
; .FEND
;unsigned char KeyScan(void)
; 0000 00A3 {
_KeyScan:
; .FSTART _KeyScan
; 0000 00A4 unsigned int key_scan_line = 0xFE;
; 0000 00A5 unsigned char key_scan_loop =0, getPinData =0;
; 0000 00A6 unsigned int key_num =0;
; 0000 00A7 
; 0000 00A8 for(key_scan_loop =0; key_scan_loop <4;key_scan_loop++)
	RCALL __SAVELOCR6
;	key_scan_line -> R16,R17
;	key_scan_loop -> R19
;	getPinData -> R18
;	key_num -> R20,R21
	__GETWRN 16,17,254
	LDI  R19,0
	LDI  R18,0
	__GETWRN 20,21,0
	LDI  R19,LOW(0)
_0x2F:
	CPI  R19,4
	BRSH _0x30
; 0000 00A9 {
; 0000 00AA PORTC = key_scan_line;
	OUT  0x15,R16
; 0000 00AB delay_us(1);
	__DELAY_USB 5
; 0000 00AC 
; 0000 00AD getPinData = PINC & 0xF0;
	IN   R30,0x13
	ANDI R30,LOW(0xF0)
	MOV  R18,R30
; 0000 00AE 
; 0000 00AF if(getPinData != 0x00)
	CPI  R18,0
	BREQ _0x31
; 0000 00B0 {
; 0000 00B1 switch(getPinData)
	LDI  R31,0
; 0000 00B2 {
; 0000 00B3 case 0x10:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0x35
; 0000 00B4 key_num = key_scan_loop * 4 +1 ;
	LDI  R30,LOW(4)
	MUL  R30,R19
	MOVW R30,R0
	ADIW R30,1
	RJMP _0xB5
; 0000 00B5 break;
; 0000 00B6 case 0x20:
_0x35:
	CPI  R30,LOW(0x20)
	LDI  R26,HIGH(0x20)
	CPC  R31,R26
	BRNE _0x36
; 0000 00B7 key_num = key_scan_loop * 4 +2 ;
	LDI  R30,LOW(4)
	MUL  R30,R19
	MOVW R30,R0
	ADIW R30,2
	RJMP _0xB5
; 0000 00B8 break;
; 0000 00B9 case 0x40:
_0x36:
	CPI  R30,LOW(0x40)
	LDI  R26,HIGH(0x40)
	CPC  R31,R26
	BRNE _0x37
; 0000 00BA key_num = key_scan_loop * 4 +3 ;
	LDI  R30,LOW(4)
	MUL  R30,R19
	MOVW R30,R0
	ADIW R30,3
	RJMP _0xB5
; 0000 00BB break;
; 0000 00BC case 0x80:
_0x37:
	CPI  R30,LOW(0x80)
	LDI  R26,HIGH(0x80)
	CPC  R31,R26
	BRNE _0x34
; 0000 00BD key_num = key_scan_loop * 4 +4 ;
	LDI  R30,LOW(4)
	MUL  R30,R19
	MOVW R30,R0
	ADIW R30,4
_0xB5:
	MOVW R20,R30
; 0000 00BE break;
; 0000 00BF 
; 0000 00C0 }
_0x34:
; 0000 00C1 
; 0000 00C2 return key_num;
	MOV  R30,R20
	RJMP _0x2000004
; 0000 00C3 
; 0000 00C4 
; 0000 00C5 }
; 0000 00C6 key_scan_line = (key_scan_line <<1);
_0x31:
	LSL  R16
	ROL  R17
; 0000 00C7 }
	SUBI R19,-1
	RJMP _0x2F
_0x30:
; 0000 00C8 
; 0000 00C9 }
_0x2000004:
	RCALL __LOADLOCR6
	ADIW R28,6
	RET
; .FEND
;unsigned char Changenum(unsigned char num)
; 0000 00CB //상황에 맞게 변환
; 0000 00CC {
_Changenum:
; .FSTART _Changenum
; 0000 00CD 
; 0000 00CE unsigned char return_num=0;
; 0000 00CF if(num ==0){
	ST   -Y,R17
	ST   -Y,R16
	MOV  R16,R26
;	num -> R16
;	return_num -> R17
	LDI  R17,0
	CPI  R16,0
	BRNE _0x39
; 0000 00D0 return_num =0;
	LDI  R17,LOW(0)
; 0000 00D1 }
; 0000 00D2 else if (num%4 ==0){                      // 1 2 3   13
	RJMP _0x3A
_0x39:
	MOV  R26,R16
	CLR  R27
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RCALL __MODW21
	SBIW R30,0
	BRNE _0x3B
; 0000 00D3 return_num = 12 + num/4;                 // 4 5 6   14
	RCALL SUBOPT_0x9
	SUBI R30,-LOW(12)
	MOV  R17,R30
; 0000 00D4 // 7 8 9   15
; 0000 00D5 }                                         // 10 0 12 16
; 0000 00D6 else if( num/4 ==0){                      // 위처럼 인식되게 변환
	RJMP _0x3C
_0x3B:
	RCALL SUBOPT_0x9
	SBIW R30,0
	BRNE _0x3D
; 0000 00D7 return_num = (4*(num/4) +num%4)  ;
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xA
	ADD  R30,R0
	MOV  R17,R30
; 0000 00D8 
; 0000 00D9 }
; 0000 00DA else if( num/4 ==1){
	RJMP _0x3E
_0x3D:
	RCALL SUBOPT_0x9
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x3F
; 0000 00DB return_num = (4*(num/4) +num%4) -1 ;
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xA
	MOV  R26,R0
	ADD  R26,R30
	SUBI R26,LOW(1)
	RJMP _0xB6
; 0000 00DC 
; 0000 00DD }
; 0000 00DE else if( num/4 ==2){
_0x3F:
	RCALL SUBOPT_0x9
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x41
; 0000 00DF return_num = (4*(num/4) +num%4) -2 ;
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xA
	MOV  R26,R0
	ADD  R26,R30
	SUBI R26,LOW(2)
	RJMP _0xB6
; 0000 00E0 
; 0000 00E1 }
; 0000 00E2 else if( num/4 ==3){
_0x41:
	RCALL SUBOPT_0x9
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x43
; 0000 00E3 return_num = (4*(num/4) +num%4) -3 ;
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xA
	MOV  R26,R0
	ADD  R26,R30
	SUBI R26,LOW(3)
_0xB6:
	MOV  R17,R26
; 0000 00E4 
; 0000 00E5 }
; 0000 00E6 
; 0000 00E7 if (return_num ==11){
_0x43:
_0x3E:
_0x3C:
_0x3A:
	CPI  R17,11
	BRNE _0x44
; 0000 00E8 return_num =0;
	LDI  R17,LOW(0)
; 0000 00E9 
; 0000 00EA zero_flag =1;   // 아무것도 누르지 않을때도 0이 저장되기에
	LDI  R30,LOW(1)
	MOV  R4,R30
; 0000 00EB // 0을 누를때 zero_flag동작되게 설정
; 0000 00EC 
; 0000 00ED 
; 0000 00EE 
; 0000 00EF }
; 0000 00F0 return return_num;
_0x44:
	MOV  R30,R17
	RJMP _0x2000001
; 0000 00F1 }
; .FEND
;void OUTFND( int FND[] )
; 0000 00FB {
_OUTFND:
; .FSTART _OUTFND
; 0000 00FC int i=0;
; 0000 00FD for(i=0;i<4;i++ )
	RCALL SUBOPT_0x7
;	FND -> R18,R19
;	i -> R16,R17
	__GETWRN 16,17,0
_0x46:
	__CPWRN 16,17,4
	BRGE _0x47
; 0000 00FE {
; 0000 00FF 
; 0000 0100 
; 0000 0101 PORTE = Port_fnd[i];
	MOVW R30,R16
	LDI  R26,LOW(_Port_fnd)
	LDI  R27,HIGH(_Port_fnd)
	RCALL SUBOPT_0xB
	LD   R30,X
	OUT  0x3,R30
; 0000 0102 PORTF = Port_char[FND[i]];
	MOVW R30,R16
	MOVW R26,R18
	RCALL SUBOPT_0xB
	LD   R30,X+
	LD   R31,X+
	SUBI R30,LOW(-_Port_char)
	SBCI R31,HIGH(-_Port_char)
	LD   R30,Z
	STS  98,R30
; 0000 0103 delay_ms(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	RCALL _delay_ms
; 0000 0104 
; 0000 0105 
; 0000 0106 
; 0000 0107 }
	__ADDWRN 16,17,1
	RJMP _0x46
_0x47:
; 0000 0108 }
_0x2000003:
	RCALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND
;interrupt [2] void ext_int0_isr(void)
; 0000 010D {
_ext_int0_isr:
; .FSTART _ext_int0_isr
	RCALL SUBOPT_0x4
; 0000 010E int i=0;
; 0000 010F delay_ms(50);
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,0
	LDI  R26,LOW(50)
	LDI  R27,0
	RCALL _delay_ms
; 0000 0110 if(interrupt_flag ==0)  //flag가0일시 비밀번호 set상태
	TST  R7
	BRNE _0x48
; 0000 0111 {
; 0000 0112 delay_ms(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	RCALL _delay_ms
; 0000 0113 LCD_Comm(0x0f); // 모든 기능을 ON 한다.
	RCALL SUBOPT_0xC
; 0000 0114 LCD_delay(2);// 1.64㎳ 이상을 기다림
; 0000 0115 
; 0000 0116 
; 0000 0117 LCD_Pos(0,0); // 문자열 위치 0행 1열 지정
; 0000 0118 LCD_Str("PASSWORD SET"); // 문자열 str을 LCD 첫번째 라인에 출력
	__POINTW2MN _0x49,0
	RCALL SUBOPT_0xD
; 0000 0119 delay_us(10);
; 0000 011A LCD_Pos(1,0); // 문자열 위치 1행 1열 지정
; 0000 011B LCD_Str("--------------"); // 문자열 str을 LCD 두번째 라인에 출력
	__POINTW2MN _0x49,13
	RCALL _LCD_Str
; 0000 011C LCD_Pos(1,0);
	RCALL SUBOPT_0x6
; 0000 011D delay_us(10);
	__DELAY_USB 49
; 0000 011E 
; 0000 011F 
; 0000 0120 
; 0000 0121 
; 0000 0122 for(i=0;i<14;i++) {
	__GETWRN 16,17,0
_0x4B:
	__CPWRN 16,17,14
	BRGE _0x4C
; 0000 0123 fnd[i] = 0; }
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0xF
	__ADDWRN 16,17,1
	RJMP _0x4B
_0x4C:
; 0000 0124 
; 0000 0125 interrupt_flag =1;
	LDI  R30,LOW(1)
	MOV  R7,R30
; 0000 0126 
; 0000 0127 }
; 0000 0128 else    //들어온 비밀번호를 저장
	RJMP _0x4D
_0x48:
; 0000 0129 {
; 0000 012A 
; 0000 012B 
; 0000 012C LCD_Pos(0,0); // 문자열 위치 0행 1열 지정
	RCALL SUBOPT_0x5
; 0000 012D LCD_Str("PASSWORD SET"); // 문자열 str을 LCD 첫번째 라인에 출력
	__POINTW2MN _0x49,28
	RCALL SUBOPT_0xD
; 0000 012E delay_us(10);
; 0000 012F LCD_Pos(1,0); // 문자열 위치 1행 1열 지정
; 0000 0130 LCD_Str(" -SUCCESS-    "); // 문자열 str을 LCD 두번째 라인에 출력
	__POINTW2MN _0x49,41
	RCALL _LCD_Str
; 0000 0131 LCD_Pos(1,0);
	RCALL SUBOPT_0x6
; 0000 0132 delay_us(10);
	__DELAY_USB 49
; 0000 0133 
; 0000 0134 delay_ms(500);
	RCALL SUBOPT_0x10
; 0000 0135 LCD_Clear();
; 0000 0136 
; 0000 0137 
; 0000 0138 Buzzer_play(Do);
	RCALL SUBOPT_0x11
; 0000 0139 delay_ms(500);
; 0000 013A Buzzer_play(Re);
	LDI  R26,LOW(1700)
	LDI  R27,HIGH(1700)
	RCALL SUBOPT_0x12
; 0000 013B delay_ms(500);
; 0000 013C Buzzer_play(Mi);
	LDI  R26,LOW(1515)
	LDI  R27,HIGH(1515)
	RCALL _Buzzer_play
; 0000 013D 
; 0000 013E 
; 0000 013F 
; 0000 0140 for(i=0;i<14;i++)
	__GETWRN 16,17,0
_0x4F:
	__CPWRN 16,17,14
	BRGE _0x50
; 0000 0141 {
; 0000 0142 password[i] = fnd[i];    //새 비밀번호를 저장
	MOVW R30,R16
	LDI  R26,LOW(_password)
	LDI  R27,HIGH(_password)
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x14
; 0000 0143 }
	__ADDWRN 16,17,1
	RJMP _0x4F
_0x50:
; 0000 0144 
; 0000 0145 interrupt_flag = 0;
	CLR  R7
; 0000 0146 
; 0000 0147 }
_0x4D:
; 0000 0148 
; 0000 0149 }
	LD   R16,Y+
	LD   R17,Y+
_0xB7:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND

	.DSEG
_0x49:
	.BYTE 0x38
;void putch_USART(char data)
; 0000 014B {

	.CSEG
_putch_USART:
; .FSTART _putch_USART
; 0000 014C while(!(UCSR1A & (1<<UDRE1)));
	ST   -Y,R17
	MOV  R17,R26
;	data -> R17
_0x51:
	LDS  R30,155
	ANDI R30,LOW(0x20)
	BREQ _0x51
; 0000 014D UDR1 = data;
	STS  156,R17
; 0000 014E }
_0x2000002:
	LD   R17,Y+
	RET
; .FEND
;void puts_USART(char *str)
; 0000 0151 {
_puts_USART:
; .FSTART _puts_USART
; 0000 0152 while(*str!= 0)
	ST   -Y,R17
	ST   -Y,R16
	MOVW R16,R26
;	*str -> R16,R17
_0x54:
	MOVW R26,R16
	LD   R30,X
	CPI  R30,0
	BREQ _0x56
; 0000 0153 {
; 0000 0154 putch_USART(*str);
	LD   R26,X
	RCALL _putch_USART
; 0000 0155 str++;
	__ADDWRN 16,17,1
; 0000 0156 }
	RJMP _0x54
_0x56:
; 0000 0157 }
_0x2000001:
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;void main (void)
; 0000 015D {
_main:
; .FSTART _main
; 0000 015E int key_num=0;        //키패드로 받은 숫자
; 0000 015F char count =0;        //count 변수_fnd에서 숫자받을때 사용
; 0000 0160 char p_count=0;       //password 일치확인할때 사용
; 0000 0161 char Rock_count =0;   //3번이상 틀릴때 rock되게 사용
; 0000 0162 char master_count=1;  //위험감지시 사이렌모드로 동작하게 사용
; 0000 0163 int star_count=0;     //*이 3초이상 눌리는지 감지할때 사용
; 0000 0164 int mastermode_count=0; //mastermode에 들어갔는지 감지에 사용
; 0000 0165 int i=0;   //for문을 돌리기 위한 변수
; 0000 0166 
; 0000 0167 unsigned char  loop_count=0;
; 0000 0168 unsigned char  str_password[] = "PASSWORD        ";
; 0000 0169 unsigned char  str_star[] = "************** ";
; 0000 016A 
; 0000 016B 
; 0000 016C Init_USART1_IntCon();
	SBIW R28,40
	LDI  R24,40
	__GETWRN 22,23,0
	LDI  R30,LOW(_0x57*2)
	LDI  R31,HIGH(_0x57*2)
	RCALL __INITLOCB
;	key_num -> R16,R17
;	count -> R19
;	p_count -> R18
;	Rock_count -> R21
;	master_count -> R20
;	star_count -> Y+38
;	mastermode_count -> Y+36
;	i -> Y+34
;	loop_count -> Y+33
;	str_password -> Y+16
;	str_star -> Y+0
	__GETWRN 16,17,0
	LDI  R19,0
	LDI  R18,0
	LDI  R21,0
	LDI  R20,1
	RCALL _Init_USART1_IntCon
; 0000 016D Init_Timer1();  // 타이머 초기설정
	RCALL _Init_Timer1
; 0000 016E PORT_Init();    // 포트들 입출력 초기 설정
	RCALL _PORT_Init
; 0000 016F LCD_PORT_Init; // LCD 출력 포트 설정
	LDI  R30,LOW(_LCD_PORT_Init)
	LDI  R31,HIGH(_LCD_PORT_Init)
; 0000 0170 LCD_Init(); // LCD 초기화
	RCALL _LCD_Init
; 0000 0171 OCR1A = 4710; //모터 초기설정(잠김)
	RCALL SUBOPT_0x15
; 0000 0172 
; 0000 0173 
; 0000 0174 
; 0000 0175 while(1)
_0x58:
; 0000 0176 {
; 0000 0177 
; 0000 0178 
; 0000 0179 key_num= Changenum(KeyScan());  //keyscan으로 받은 값을 변환하여 저장
	RCALL _KeyScan
	MOV  R26,R30
	RCALL _Changenum
	MOV  R16,R30
	CLR  R17
; 0000 017A 
; 0000 017B if(key_num<10 & key_num>0 )   //숫자가 눌리면 새로운 값을 저장하도록 count값 설정
	MOVW R26,R16
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __LTW12
	MOV  R0,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RCALL __GTW12
	AND  R30,R0
	BREQ _0x5B
; 0000 017C {
; 0000 017D count++;
	RCALL SUBOPT_0x16
; 0000 017E delay_ms(50);
; 0000 017F 
; 0000 0180 }
; 0000 0181 else if(key_num==0 & zero_flag)   //zero_flag가 실행된 경우에만 0으로 입력
	RJMP _0x5C
_0x5B:
	MOVW R26,R16
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RCALL __EQW12
	AND  R30,R4
	BREQ _0x5D
; 0000 0182 {
; 0000 0183 count++;
	RCALL SUBOPT_0x16
; 0000 0184 delay_ms(50);
; 0000 0185 }
; 0000 0186 else if(key_num == 10 )
	RJMP _0x5E
_0x5D:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R30,R16
	CPC  R31,R17
	BREQ PC+2
	RJMP _0x5F
; 0000 0187 {
; 0000 0188 for(i=0;i<14;i++)   //비밀번호 일치하는지 확인
	LDI  R30,LOW(0)
	STD  Y+34,R30
	STD  Y+34+1,R30
_0x61:
	LDD  R26,Y+34
	LDD  R27,Y+34+1
	SBIW R26,14
	BRGE _0x62
; 0000 0189 {
; 0000 018A if(fnd[i] == password[i])
	RCALL SUBOPT_0x17
	LD   R0,X+
	LD   R1,X
	LDD  R30,Y+34
	LDD  R31,Y+34+1
	LDI  R26,LOW(_password)
	LDI  R27,HIGH(_password)
	RCALL SUBOPT_0xB
	__GETW1P
	CP   R30,R0
	CPC  R31,R1
	BRNE _0x63
; 0000 018B {
; 0000 018C p_count ++;
	SUBI R18,-1
; 0000 018D }
; 0000 018E else
	RJMP _0x64
_0x63:
; 0000 018F {
; 0000 0190 p_count =0;
	LDI  R18,LOW(0)
; 0000 0191 }
_0x64:
; 0000 0192 
; 0000 0193 }
	RCALL SUBOPT_0x18
	RJMP _0x61
_0x62:
; 0000 0194 
; 0000 0195 if(p_count == 14)  //비밀번호 일치시
	CPI  R18,14
	BRNE _0x65
; 0000 0196 {
; 0000 0197 LCD_Pos(0,0); // 문자열 위치 0행 1열 지정
	RCALL SUBOPT_0x5
; 0000 0198 LCD_Str("DOOR OPEN    "); // 문자열 str을 LCD 첫번째 라인에 출력
	__POINTW2MN _0x66,0
	RCALL SUBOPT_0xD
; 0000 0199 delay_us(10);
; 0000 019A LCD_Pos(1,0); // 문자열 위치 1행 1열 지정
; 0000 019B LCD_Str("              "); // 문자열 str을 LCD 두번째 라인에 출력
	__POINTW2MN _0x66,14
	RCALL _LCD_Str
; 0000 019C LCD_Pos(1,0);
	RCALL SUBOPT_0x6
; 0000 019D 
; 0000 019E Buzzer_play(Do);
	RCALL SUBOPT_0x11
; 0000 019F delay_ms(500);
; 0000 01A0 Buzzer_play(Mi);
	LDI  R26,LOW(1515)
	LDI  R27,HIGH(1515)
	RCALL SUBOPT_0x12
; 0000 01A1 delay_ms(500);
; 0000 01A2 Buzzer_play(Sol);
	LDI  R26,LOW(1275)
	LDI  R27,HIGH(1275)
	RCALL SUBOPT_0x12
; 0000 01A3 delay_ms(500);
; 0000 01A4 Buzzer_play(Do/2);
	LDI  R26,LOW(954)
	LDI  R27,HIGH(954)
	RCALL _Buzzer_play
; 0000 01A5 delay_ms(500);
	RCALL SUBOPT_0x10
; 0000 01A6 LCD_Clear();
; 0000 01A7 
; 0000 01A8 OCR1A = 3000;    //모터 해제
	LDI  R30,LOW(3000)
	LDI  R31,HIGH(3000)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 01A9 for(i=0;i<14;i++) {
	LDI  R30,LOW(0)
	STD  Y+34,R30
	STD  Y+34+1,R30
_0x68:
	LDD  R26,Y+34
	LDD  R27,Y+34+1
	SBIW R26,14
	BRGE _0x69
; 0000 01AA fnd[i] = 0; }  //받은 fnd값 초기화
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x18
	RJMP _0x68
_0x69:
; 0000 01AB 
; 0000 01AC p_count=0;
	LDI  R18,LOW(0)
; 0000 01AD }
; 0000 01AE else  //비밀번호 오류시
	RJMP _0x6A
_0x65:
; 0000 01AF {
; 0000 01B0 LCD_Pos(0,0); // 문자열 위치 0행 1열 지정
	RCALL SUBOPT_0x5
; 0000 01B1 LCD_Str(str_password); // 문자열 str을 LCD 첫번째 라인에 출력
	MOVW R26,R28
	ADIW R26,16
	RCALL SUBOPT_0xD
; 0000 01B2 delay_us(10);
; 0000 01B3 LCD_Pos(1,0); // 문자열 위치 1행 1열 지정
; 0000 01B4 LCD_Str(" error.......   "); // 문자열 str을 LCD 두번째 라인에 출력
	__POINTW2MN _0x66,29
	RCALL _LCD_Str
; 0000 01B5 LCD_Pos(1,0);
	RCALL SUBOPT_0x6
; 0000 01B6 
; 0000 01B7 
; 0000 01B8 
; 0000 01B9 Buzzer_play(La);
	LDI  R26,LOW(1136)
	LDI  R27,HIGH(1136)
	RCALL SUBOPT_0x12
; 0000 01BA delay_ms(500);
; 0000 01BB Buzzer_play(La);
	LDI  R26,LOW(1136)
	LDI  R27,HIGH(1136)
	RCALL SUBOPT_0x12
; 0000 01BC delay_ms(500);
; 0000 01BD Buzzer_play(La);
	LDI  R26,LOW(1136)
	LDI  R27,HIGH(1136)
	RCALL _Buzzer_play
; 0000 01BE delay_ms(500);
	RCALL SUBOPT_0x10
; 0000 01BF LCD_Clear();
; 0000 01C0 
; 0000 01C1 
; 0000 01C2 for(i=0;i<14;i++) {
	LDI  R30,LOW(0)
	STD  Y+34,R30
	STD  Y+34+1,R30
_0x6C:
	LDD  R26,Y+34
	LDD  R27,Y+34+1
	SBIW R26,14
	BRGE _0x6D
; 0000 01C3 fnd[i] = 0; }
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x18
	RJMP _0x6C
_0x6D:
; 0000 01C4 
; 0000 01C5 p_count=0;
	LDI  R18,LOW(0)
; 0000 01C6 Rock_count ++;    //오류시 Rock_count가 증가함
	SUBI R21,-1
; 0000 01C7 
; 0000 01C8 }
_0x6A:
; 0000 01C9 
; 0000 01CA 
; 0000 01CB 
; 0000 01CC 
; 0000 01CD 
; 0000 01CE }
; 0000 01CF 
; 0000 01D0 
; 0000 01D1 else if(key_num==12)   //#버튼에 해당
	RJMP _0x6E
_0x5F:
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x6F
; 0000 01D2 {
; 0000 01D3 LCD_Comm(0x0f); // 모든 기능을 ON 한다.
	RCALL SUBOPT_0xC
; 0000 01D4 LCD_delay(2);// 1.64㎳ 이상을 기다림
; 0000 01D5 
; 0000 01D6 
; 0000 01D7 LCD_Pos(0,0); // 문자열 위치 0행 1열 지정
; 0000 01D8 LCD_Str(str_password); // 문자열 str을 LCD 첫번째 라인에 출력
	MOVW R26,R28
	ADIW R26,16
	RCALL SUBOPT_0xD
; 0000 01D9 delay_us(10);
; 0000 01DA LCD_Pos(1,0); // 문자열 위치 1행 1열 지정
; 0000 01DB LCD_Str(str_star); // 문자열 str을 LCD 두번째 라인에 출력
	RCALL SUBOPT_0x19
; 0000 01DC LCD_Pos(1,0);
; 0000 01DD delay_us(10);
	RCALL SUBOPT_0x1A
; 0000 01DE 
; 0000 01DF for(i=0;i<14;i++)  //fnd값 초기화
	STD  Y+34,R30
	STD  Y+34+1,R30
_0x71:
	LDD  R26,Y+34
	LDD  R27,Y+34+1
	SBIW R26,14
	BRGE _0x72
; 0000 01E0 {
; 0000 01E1 fnd[i] =0;
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0xF
; 0000 01E2 }
	RCALL SUBOPT_0x18
	RJMP _0x71
_0x72:
; 0000 01E3 
; 0000 01E4 for(i=0;i<17;i++)
	LDI  R30,LOW(0)
	STD  Y+34,R30
	STD  Y+34+1,R30
_0x74:
	LDD  R26,Y+34
	LDD  R27,Y+34+1
	SBIW R26,17
	BRGE _0x75
; 0000 01E5 {
; 0000 01E6 str[i] = '*';  //마스터모드에서 잘못 입력하였을때 사용
	RCALL SUBOPT_0x1B
	LDI  R26,LOW(42)
	STD  Z+0,R26
; 0000 01E7 }
	RCALL SUBOPT_0x18
	RJMP _0x74
_0x75:
; 0000 01E8 buffer_count=0;
	CLR  R5
; 0000 01E9 master_flag=0;
	CLT
	BLD  R2,0
; 0000 01EA 
; 0000 01EB }
; 0000 01EC else if(key_num==13) // FND 출력숫자 리셋버튼 기능
	RJMP _0x76
_0x6F:
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x77
; 0000 01ED {
; 0000 01EE for(i=0;i<14;i++)
	LDI  R30,LOW(0)
	STD  Y+34,R30
	STD  Y+34+1,R30
_0x79:
	LDD  R26,Y+34
	LDD  R27,Y+34+1
	SBIW R26,14
	BRGE _0x7A
; 0000 01EF fnd[i] =0;
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x18
	RJMP _0x79
_0x7A:
; 0000 01F0 }
; 0000 01F1 
; 0000 01F2 if((key_num)| zero_flag)
_0x77:
_0x76:
_0x6E:
_0x5E:
_0x5C:
	MOV  R30,R4
	LDI  R31,0
	OR   R30,R16
	OR   R31,R17
	SBIW R30,0
	BREQ _0x7B
; 0000 01F3 {
; 0000 01F4 if((count%2) ==1){   //count가 홀수일때 들어온 t값을 저장하고
	MOV  R26,R19
	CLR  R27
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RCALL __MODW21
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x7C
; 0000 01F5 //다시 count를 짝수로 만듬
; 0000 01F6 
; 0000 01F7 for(i=13;i>0;i--) //키패드로 입력되는 수들을 fnd배열에 저장
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	STD  Y+34,R30
	STD  Y+34+1,R31
_0x7E:
	LDD  R26,Y+34
	LDD  R27,Y+34+1
	__CPW02
	BRGE _0x7F
; 0000 01F8 {
; 0000 01F9 fnd[i] = fnd[i-1];
	LDD  R30,Y+34
	LDD  R31,Y+34+1
	LDI  R26,LOW(_fnd)
	LDI  R27,HIGH(_fnd)
	RCALL SUBOPT_0x13
	LDD  R30,Y+34
	LDD  R31,Y+34+1
	SBIW R30,1
	LDI  R26,LOW(_fnd)
	LDI  R27,HIGH(_fnd)
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0x14
; 0000 01FA delay_ms(20);
	LDI  R26,LOW(20)
	LDI  R27,0
	RCALL _delay_ms
; 0000 01FB }
	LDD  R30,Y+34
	LDD  R31,Y+34+1
	SBIW R30,1
	STD  Y+34,R30
	STD  Y+34+1,R31
	RJMP _0x7E
_0x7F:
; 0000 01FC 
; 0000 01FD fnd[0] = key_num;
	__PUTWMRN _fnd,0,16,17
; 0000 01FE 
; 0000 01FF 
; 0000 0200 count++;
	RCALL SUBOPT_0x16
; 0000 0201 delay_ms(50);
; 0000 0202 
; 0000 0203 LCD_Char ( Num_to_Str(key_num));//입력되면 lcd에 출력
	MOVW R26,R16
	RCALL _Num_to_Str
	MOV  R26,R30
	RCALL _LCD_Char
; 0000 0204 
; 0000 0205 }
; 0000 0206 
; 0000 0207 
; 0000 0208 if(zero_flag) //0이 발생시 zeroflag를 다시 0으로만들어 0을 다시 받을수 있게함
_0x7C:
	TST  R4
	BREQ _0x80
; 0000 0209 {
; 0000 020A zero_flag = 0;
	CLR  R4
; 0000 020B }
; 0000 020C }
_0x80:
; 0000 020D 
; 0000 020E 
; 0000 020F 
; 0000 0210 
; 0000 0211 if(PINC.4 && PINC.6)
_0x7B:
	SBIS 0x13,4
	RJMP _0x82
	SBIC 0x13,6
	RJMP _0x83
_0x82:
	RJMP _0x81
_0x83:
; 0000 0212 {
; 0000 0213 while(PINC.4 && PINC.6){  // *과 #을 동시에 누른 상태
_0x84:
	SBIS 0x13,4
	RJMP _0x87
	SBIC 0x13,6
	RJMP _0x88
_0x87:
	RJMP _0x86
_0x88:
; 0000 0214 delay_ms(10);
	RCALL SUBOPT_0x1C
; 0000 0215 mastermode_count++;  //초 카운트
; 0000 0216 
; 0000 0217 if(mastermode_count >  300)  //3초 카운트
	BRLT _0x89
; 0000 0218 {
; 0000 0219 LCD_Pos(0,0); // 문자열 위치 0행 1열 지정
	RCALL SUBOPT_0x5
; 0000 021A LCD_Str("MASTER MODE    "); // 문자열 str을 LCD 첫번째 라인에 출력
	__POINTW2MN _0x66,46
	RCALL SUBOPT_0xD
; 0000 021B delay_us(10);
; 0000 021C LCD_Pos(1,0); // 문자열 위치 1행 1열 지정
; 0000 021D LCD_Str(str_star); // 문자열 str을 LCD 두번째 라인에 출력
	RCALL SUBOPT_0x19
; 0000 021E LCD_Pos(1,0);
; 0000 021F delay_us(10);
	RCALL SUBOPT_0x1A
; 0000 0220 
; 0000 0221 mastermode_count =0;
	RCALL SUBOPT_0x1D
; 0000 0222 master_flag=1;  //마스터 모드 들어감
; 0000 0223 }
; 0000 0224 
; 0000 0225 }
_0x89:
	RJMP _0x84
_0x86:
; 0000 0226 }
; 0000 0227 else
	RJMP _0x8A
_0x81:
; 0000 0228 {
; 0000 0229 
; 0000 022A while(PINC.4){    // *만 꾹 누르고 있는 상태
_0x8B:
	SBIS 0x13,4
	RJMP _0x8D
; 0000 022B delay_ms(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	RCALL _delay_ms
; 0000 022C star_count++;
	LDD  R30,Y+38
	LDD  R31,Y+38+1
	ADIW R30,1
	STD  Y+38,R30
	STD  Y+38+1,R31
; 0000 022D if(star_count > 300)
	LDD  R26,Y+38
	LDD  R27,Y+38+1
	CPI  R26,LOW(0x12D)
	LDI  R30,HIGH(0x12D)
	CPC  R27,R30
	BRLT _0x8E
; 0000 022E {
; 0000 022F Buzzer_play(Sol);
	LDI  R26,LOW(1275)
	LDI  R27,HIGH(1275)
	RCALL SUBOPT_0x12
; 0000 0230 delay_ms(500);
; 0000 0231 Buzzer_play(Fa);
	LDI  R26,LOW(1432)
	LDI  R27,HIGH(1432)
	RCALL SUBOPT_0x12
; 0000 0232 delay_ms(500);
; 0000 0233 Buzzer_play(Mi);
	LDI  R26,LOW(1515)
	LDI  R27,HIGH(1515)
	RCALL SUBOPT_0x12
; 0000 0234 delay_ms(500);
; 0000 0235 Buzzer_play(Re);
	LDI  R26,LOW(1700)
	LDI  R27,HIGH(1700)
	RCALL _Buzzer_play
; 0000 0236 
; 0000 0237 OCR1A = 4710;  // 금고 잠금
	RCALL SUBOPT_0x15
; 0000 0238 
; 0000 0239 star_count =0;
	LDI  R30,LOW(0)
	STD  Y+38,R30
	STD  Y+38+1,R30
; 0000 023A }
; 0000 023B }
_0x8E:
	RJMP _0x8B
_0x8D:
; 0000 023C }
_0x8A:
; 0000 023D 
; 0000 023E /*
; 0000 023F if(PINB.7 == 1)  //진동센서 감지시
; 0000 0240 {
; 0000 0241 LCD_Pos(0,0); // 문자열 위치 0행 1열 지정
; 0000 0242 LCD_Str("Warning....."); // 문자열 str을 LCD 첫번째 라인에 출력
; 0000 0243 delay_us(10);
; 0000 0244 LCD_Pos(1,0); // 문자열 위치 1행 1열 지정
; 0000 0245 LCD_Str(" stealing!!!    "); // 문자열 str을 LCD 두번째 라인에 출력
; 0000 0246 LCD_Pos(1,0);
; 0000 0247 delay_us(10);
; 0000 0248 master_count = 1;
; 0000 0249 
; 0000 024A 
; 0000 024B while(master_count) // 마스터모드에서 해제하지 않으면 무한 반복
; 0000 024C {
; 0000 024D 
; 0000 024E for(i=0;i<20;i++){    //사이렌 소리
; 0000 024F Buzzer_play(Sol/2);
; 0000 0250 delay_ms(10);
; 0000 0251 }
; 0000 0252 delay_ms(10);
; 0000 0253 for(i=0;i<20;i++){
; 0000 0254 Buzzer_play(Re/2);
; 0000 0255 delay_ms(10);
; 0000 0256 }
; 0000 0257 
; 0000 0258 
; 0000 0259 while(PINC.4 && PINC.6){ //사이렌모드에서 마스터모드로 접근
; 0000 025A delay_ms(10);
; 0000 025B 
; 0000 025C mastermode_count++;
; 0000 025D if(mastermode_count >  300)
; 0000 025E {
; 0000 025F LCD_Pos(0,0); // 문자열 위치 0행 1열 지정
; 0000 0260 LCD_Str("MASTER MODE    "); // 문자열 str을 LCD 첫번째 라인에 출력
; 0000 0261 delay_us(10);
; 0000 0262 LCD_Pos(1,0); // 문자열 위치 1행 1열 지정
; 0000 0263 LCD_Str(str_star); // 문자열 str을 LCD 두번째 라인에 출력
; 0000 0264 LCD_Pos(1,0);
; 0000 0265 delay_us(10);
; 0000 0266 
; 0000 0267 puts_USART("Enter Password  \n");
; 0000 0268 puts_USART("-->  \n");
; 0000 0269 
; 0000 026A buffer_count=0;
; 0000 026B mastermode_count =0;
; 0000 026C master_flag=1;
; 0000 026D 
; 0000 026E }
; 0000 026F }
; 0000 0270 for(i=0;i<10;i++)
; 0000 0271 {
; 0000 0272 if(str[i] == master_password[i]) //pc에서 받은 str과 학번을 비교
; 0000 0273 {
; 0000 0274 p_count ++;
; 0000 0275 }
; 0000 0276 else
; 0000 0277 {
; 0000 0278 p_count =0;
; 0000 0279 }
; 0000 027A 
; 0000 027B }
; 0000 027C 
; 0000 027D if(p_count == 10)  // 비밀번호 일치시
; 0000 027E {
; 0000 027F master_count =0; //사이렌 탈출
; 0000 0280 master_flag=0;   //마스터모드 해제
; 0000 0281 p_count =0;      //비밀번호 카운트 초기화
; 0000 0282 delay_ms(500);
; 0000 0283 LCD_Clear();
; 0000 0284 }
; 0000 0285 }
; 0000 0286 
; 0000 0287 }
; 0000 0288 */
; 0000 0289 
; 0000 028A 
; 0000 028B if(Rock_count >= 3) //에러 3번이상 발생시
	CPI  R21,3
	BRSH PC+2
	RJMP _0x8F
; 0000 028C {
; 0000 028D LCD_Pos(0,0); // 문자열 위치 0행 1열 지정
	RCALL SUBOPT_0x5
; 0000 028E LCD_Str("Warning....."); // 문자열 str을 LCD 첫번째 라인에 출력
	__POINTW2MN _0x66,62
	RCALL SUBOPT_0xD
; 0000 028F delay_us(10);
; 0000 0290 LCD_Pos(1,0); // 문자열 위치 1행 1열 지정
; 0000 0291 LCD_Str(" if.theft         "); // 문자열 str을 LCD 두번째 라인에 출력
	__POINTW2MN _0x66,75
	RCALL _LCD_Str
; 0000 0292 LCD_Pos(1,0);
	RCALL SUBOPT_0x6
; 0000 0293 delay_us(10);
	__DELAY_USB 49
; 0000 0294 master_count = 1;
	LDI  R20,LOW(1)
; 0000 0295 
; 0000 0296 while(master_count)   //이하 내용은 진동센서와 동일
_0x90:
	CPI  R20,0
	BRNE PC+2
	RJMP _0x92
; 0000 0297 {                     // 단 Rock_count초기화 하는기능이 마지막에 추가
; 0000 0298 for(i=0;i<20;i++){
	LDI  R30,LOW(0)
	STD  Y+34,R30
	STD  Y+34+1,R30
_0x94:
	LDD  R26,Y+34
	LDD  R27,Y+34+1
	SBIW R26,20
	BRGE _0x95
; 0000 0299 Buzzer_play(Sol/2);
	LDI  R26,LOW(637)
	LDI  R27,HIGH(637)
	RCALL SUBOPT_0x1E
; 0000 029A delay_ms(10);
; 0000 029B }
	RCALL SUBOPT_0x18
	RJMP _0x94
_0x95:
; 0000 029C delay_ms(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	RCALL _delay_ms
; 0000 029D for(i=0;i<20;i++){
	LDI  R30,LOW(0)
	STD  Y+34,R30
	STD  Y+34+1,R30
_0x97:
	LDD  R26,Y+34
	LDD  R27,Y+34+1
	SBIW R26,20
	BRGE _0x98
; 0000 029E Buzzer_play(Re/2);
	LDI  R26,LOW(850)
	LDI  R27,HIGH(850)
	RCALL SUBOPT_0x1E
; 0000 029F delay_ms(10);
; 0000 02A0 }
	RCALL SUBOPT_0x18
	RJMP _0x97
_0x98:
; 0000 02A1 
; 0000 02A2 while(PINC.4 && PINC.6){
_0x99:
	SBIS 0x13,4
	RJMP _0x9C
	SBIC 0x13,6
	RJMP _0x9D
_0x9C:
	RJMP _0x9B
_0x9D:
; 0000 02A3 delay_ms(10);
	RCALL SUBOPT_0x1C
; 0000 02A4 
; 0000 02A5 
; 0000 02A6 mastermode_count++;
; 0000 02A7 
; 0000 02A8 if(mastermode_count >  300)
	BRLT _0x9E
; 0000 02A9 {
; 0000 02AA LCD_Pos(0,0); // 문자열 위치 0행 1열 지정
	RCALL SUBOPT_0x5
; 0000 02AB LCD_Str("MASTER MODE    "); // 문자열 str을 LCD 첫번째 라인에 출력
	__POINTW2MN _0x66,94
	RCALL SUBOPT_0xD
; 0000 02AC delay_us(10);
; 0000 02AD LCD_Pos(1,0); // 문자열 위치 1행 1열 지정
; 0000 02AE LCD_Str(str_star); // 문자열 str을 LCD 두번째 라인에 출력
	RCALL SUBOPT_0x19
; 0000 02AF LCD_Pos(1,0);
; 0000 02B0 delay_us(10);
	__DELAY_USB 49
; 0000 02B1 
; 0000 02B2 puts_USART("Enter Password  \n");
	__POINTW2MN _0x66,110
	RCALL _puts_USART
; 0000 02B3 puts_USART("-->  \n");
	__POINTW2MN _0x66,128
	RCALL _puts_USART
; 0000 02B4 
; 0000 02B5 buffer_count=0;
	CLR  R5
; 0000 02B6 mastermode_count =0;
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x1D
; 0000 02B7 master_flag=1;
; 0000 02B8 }
; 0000 02B9 }
_0x9E:
	RJMP _0x99
_0x9B:
; 0000 02BA for(i=0;i<10;i++)
	LDI  R30,LOW(0)
	STD  Y+34,R30
	STD  Y+34+1,R30
_0xA0:
	LDD  R26,Y+34
	LDD  R27,Y+34+1
	SBIW R26,10
	BRGE _0xA1
; 0000 02BB {
; 0000 02BC if(str[i] == master_password[i])
	RCALL SUBOPT_0x1B
	LD   R26,Z
	LDD  R30,Y+34
	LDD  R31,Y+34+1
	ADD  R30,R8
	ADC  R31,R9
	LD   R30,Z
	CP   R30,R26
	BRNE _0xA2
; 0000 02BD {
; 0000 02BE p_count ++;
	SUBI R18,-1
; 0000 02BF }
; 0000 02C0 else
	RJMP _0xA3
_0xA2:
; 0000 02C1 {
; 0000 02C2 p_count =0;
	LDI  R18,LOW(0)
; 0000 02C3 }
_0xA3:
; 0000 02C4 }
	RCALL SUBOPT_0x18
	RJMP _0xA0
_0xA1:
; 0000 02C5 
; 0000 02C6 if(p_count == 10)
	CPI  R18,10
	BRNE _0xA4
; 0000 02C7 {
; 0000 02C8 master_count =0;
	LDI  R20,LOW(0)
; 0000 02C9 Rock_count =0;
	LDI  R21,LOW(0)
; 0000 02CA master_flag=0;
	CLT
	BLD  R2,0
; 0000 02CB p_count =0;
	LDI  R18,LOW(0)
; 0000 02CC 
; 0000 02CD delay_ms(500);
	RCALL SUBOPT_0x10
; 0000 02CE LCD_Clear();
; 0000 02CF }
; 0000 02D0 }
_0xA4:
	RJMP _0x90
_0x92:
; 0000 02D1 
; 0000 02D2 
; 0000 02D3 }
; 0000 02D4 
; 0000 02D5 OUTFND(fnd);  //fnd출력
_0x8F:
	LDI  R26,LOW(_fnd)
	LDI  R27,HIGH(_fnd)
	RCALL _OUTFND
; 0000 02D6 
; 0000 02D7 
; 0000 02D8 switch(key_num)     //각 키패드마다 나오는 음 설정
	MOVW R30,R16
; 0000 02D9 {
; 0000 02DA case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xA8
; 0000 02DB Buzzer_play(Do);
	LDI  R26,LOW(1908)
	LDI  R27,HIGH(1908)
	RCALL _Buzzer_play
; 0000 02DC break;
	RJMP _0xA7
; 0000 02DD case 2:
_0xA8:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xA9
; 0000 02DE Buzzer_play(Re);
	LDI  R26,LOW(1700)
	LDI  R27,HIGH(1700)
	RCALL _Buzzer_play
; 0000 02DF break;
	RJMP _0xA7
; 0000 02E0 case 3:
_0xA9:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xAA
; 0000 02E1 Buzzer_play(Mi);
	LDI  R26,LOW(1515)
	LDI  R27,HIGH(1515)
	RCALL _Buzzer_play
; 0000 02E2 break;
	RJMP _0xA7
; 0000 02E3 case 4:
_0xAA:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xAB
; 0000 02E4 Buzzer_play(Fa);
	LDI  R26,LOW(1432)
	LDI  R27,HIGH(1432)
	RCALL _Buzzer_play
; 0000 02E5 break;
	RJMP _0xA7
; 0000 02E6 case 5:
_0xAB:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xAC
; 0000 02E7 Buzzer_play(Sol);
	LDI  R26,LOW(1275)
	LDI  R27,HIGH(1275)
	RCALL _Buzzer_play
; 0000 02E8 break;
	RJMP _0xA7
; 0000 02E9 case 6:
_0xAC:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0xAD
; 0000 02EA Buzzer_play(La);
	LDI  R26,LOW(1136)
	LDI  R27,HIGH(1136)
	RCALL _Buzzer_play
; 0000 02EB break;
	RJMP _0xA7
; 0000 02EC case 7:
_0xAD:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0xAE
; 0000 02ED Buzzer_play(Si);
	LDI  R26,LOW(1012)
	LDI  R27,HIGH(1012)
	RCALL _Buzzer_play
; 0000 02EE break;
	RJMP _0xA7
; 0000 02EF case 8:
_0xAE:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0xAF
; 0000 02F0 Buzzer_play(Do/2);
	LDI  R26,LOW(954)
	LDI  R27,HIGH(954)
	RCALL _Buzzer_play
; 0000 02F1 break;
	RJMP _0xA7
; 0000 02F2 case 9:
_0xAF:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0xB1
; 0000 02F3 Buzzer_play(Re/2);
	LDI  R26,LOW(850)
	LDI  R27,HIGH(850)
	RCALL _Buzzer_play
; 0000 02F4 break;
; 0000 02F5 
; 0000 02F6 default:
_0xB1:
; 0000 02F7 break;
; 0000 02F8 }
_0xA7:
; 0000 02F9 }
	RJMP _0x58
; 0000 02FA }
_0xB2:
	RJMP _0xB2
; .FEND

	.DSEG
_0x66:
	.BYTE 0x87

	.DSEG
_str:
	.BYTE 0x11
_fnd:
	.BYTE 0x1C
_password:
	.BYTE 0x1C
_Port_char:
	.BYTE 0x10
_Port_fnd:
	.BYTE 0x8

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	ST   -Y,R17
	MOV  R17,R26
	LDS  R30,101
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1:
	STS  101,R30
	LDS  R30,101
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x2:
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
SUBOPT_0x3:
	LDI  R26,LOW(56)
	RCALL _LCD_Comm
	LDI  R26,LOW(4)
	RJMP _LCD_delay

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x4:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP _LCD_Pos

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:49 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP _LCD_Pos

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	RCALL __SAVELOCR4
	MOVW R18,R26
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	STS  101,R30
	MOVW R26,R20
	RJMP _myDelay_us

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0x9:
	MOV  R26,R16
	LDI  R27,0
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RCALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0xA:
	LSL  R30
	LSL  R30
	MOV  R0,R30
	MOV  R30,R16
	LDI  R31,0
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	RCALL __MANDW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:28 WORDS
SUBOPT_0xB:
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xC:
	LDI  R26,LOW(15)
	RCALL _LCD_Comm
	LDI  R26,LOW(2)
	RCALL _LCD_delay
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:26 WORDS
SUBOPT_0xD:
	RCALL _LCD_Str
	__DELAY_USB 49
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	MOVW R30,R16
	LDI  R26,LOW(_fnd)
	LDI  R27,HIGH(_fnd)
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x10:
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _delay_ms
	RJMP _LCD_Clear

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	LDI  R26,LOW(1908)
	LDI  R27,HIGH(1908)
	RCALL _Buzzer_play
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x12:
	RCALL _Buzzer_play
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x13:
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x14:
	LD   R30,X+
	LD   R31,X+
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(4710)
	LDI  R31,HIGH(4710)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x16:
	SUBI R19,-1
	LDI  R26,LOW(50)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x17:
	LDD  R30,Y+34
	LDD  R31,Y+34+1
	LDI  R26,LOW(_fnd)
	LDI  R27,HIGH(_fnd)
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0x18:
	LDD  R30,Y+34
	LDD  R31,Y+34+1
	ADIW R30,1
	STD  Y+34,R30
	STD  Y+34+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x19:
	MOVW R26,R28
	RCALL _LCD_Str
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	__DELAY_USB 49
	LDI  R30,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	LDD  R30,Y+34
	LDD  R31,Y+34+1
	SUBI R30,LOW(-_str)
	SBCI R31,HIGH(-_str)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x1C:
	LDI  R26,LOW(10)
	LDI  R27,0
	RCALL _delay_ms
	LDD  R30,Y+36
	LDD  R31,Y+36+1
	ADIW R30,1
	STD  Y+36,R30
	STD  Y+36+1,R31
	LDD  R26,Y+36
	LDD  R27,Y+36+1
	CPI  R26,LOW(0x12D)
	LDI  R30,HIGH(0x12D)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	STD  Y+36,R30
	STD  Y+36+1,R30
	SET
	BLD  R2,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	RCALL _Buzzer_play
	LDI  R26,LOW(10)
	LDI  R27,0
	RJMP _delay_ms

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

__INITLOCB:
__INITLOCW:
	PUSH R26
	PUSH R27
	MOVW R26,R22
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	POP  R27
	POP  R26
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__EQW12:
	CP   R30,R26
	CPC  R31,R27
	LDI  R30,1
	BREQ __EQW12T
	CLR  R30
__EQW12T:
	RET

__LTW12:
	CP   R26,R30
	CPC  R27,R31
	LDI  R30,1
	BRLT __LTW12T
	CLR  R30
__LTW12T:
	RET

__GTW12:
	CP   R30,R26
	CPC  R31,R27
	LDI  R30,1
	BRLT __GTW12T
	CLR  R30
__GTW12T:
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

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
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

__MANDW12:
	CLT
	SBRS R31,7
	RJMP __MANDW121
	RCALL __ANEGW1
	SET
__MANDW121:
	AND  R30,R26
	AND  R31,R27
	BRTC __MANDW122
	RCALL __ANEGW1
__MANDW122:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	NEG  R27
	NEG  R26
	SBCI R27,0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
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
