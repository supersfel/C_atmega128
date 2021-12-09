
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega128
;Program type             : Application
;Clock frequency          : 14.745600 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 1024 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : No
;global 'const' stored in FLASH: Yes
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega128
	#pragma AVRPART MEMORY PROG_FLASH 131072
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 4351
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
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
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
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
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
	.DEF _zero_flag=R5
	.DEF _ti_Cnt_1ms=R4
	.DEF _LCD_DelCnt_1ms=R7
	.DEF _Distance_cnt_1ms=R6
	.DEF _ch=R9

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
	JMP  _compare
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
	JMP  _usart1_receive
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x5A:
	.DB  0xC0,0xF9,0xA4,0xB0,0x99,0x92,0x82,0xD8
	.DB  0x80,0x90,0x88,0x83,0xC4,0xA1,0x84,0x8E
_0x5B:
	.DB  0x1F,0x0,0x2F,0x0,0x4F,0x0,0x8F
_0xAF:
	.DB  0x31,0x6D,0x69,0x6E,0x67,0x79,0x75
_0xCE:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x58,0x58,0x58,0x1,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0
_0x12D:
	.DB  0x0,0x0,0x0,0x0,0x0
_0x0:
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0xA,0x20,0x66
	.DB  0x69,0x72,0x73,0x74,0x20,0x73,0x65,0x61
	.DB  0x74,0x20,0x3A,0x20,0xA,0x0,0xA,0x20
	.DB  0x53,0x65,0x63,0x6F,0x6E,0x64,0x20,0x73
	.DB  0x65,0x61,0x74,0x20,0x3A,0x20,0xA,0x0
	.DB  0xA,0x20,0x54,0x68,0x69,0x72,0x64,0x20
	.DB  0x73,0x65,0x61,0x74,0x20,0x3A,0x20,0xA
	.DB  0x0,0x43,0x68,0x6F,0x6F,0x73,0x65,0x20
	.DB  0x53,0x65,0x61,0x74,0x0,0x31,0x20,0x20
	.DB  0x0,0x32,0x20,0x20,0x0,0x33,0x20,0x20
	.DB  0x0,0x53,0x74,0x75,0x64,0x79,0x52,0x6F
	.DB  0x6F,0x6D,0x20,0x20,0x34,0x3A,0x4F,0x55
	.DB  0x54,0x0,0x31,0x3A,0x25,0x63,0x20,0x32
	.DB  0x3A,0x25,0x63,0x20,0x33,0x3A,0x25,0x63
	.DB  0x0,0x25,0x64,0x25,0x64,0x25,0x64,0x25
	.DB  0x64,0x25,0x64,0x25,0x64,0x25,0x64,0x25
	.DB  0x64,0x25,0x64,0x25,0x64,0x25,0x64,0x0
	.DB  0x49,0x6E,0x70,0x75,0x74,0x20,0x50,0x68
	.DB  0x6F,0x6E,0x65,0x4E,0x75,0x6D,0x0,0x53
	.DB  0x6F,0x6D,0x65,0x6F,0x6E,0x65,0x20,0x55
	.DB  0x73,0x65,0x64,0x0,0x44,0x6F,0x6F,0x72
	.DB  0x20,0x4F,0x70,0x65,0x6E,0x0,0x31,0x3A
	.DB  0x59,0x65,0x73,0x20,0x20,0x32,0x3A,0x4E
	.DB  0x6F,0x0,0x45,0x6D,0x70,0x74,0x79,0x20
	.DB  0x53,0x65,0x61,0x74,0x0,0x55,0x73,0x65
	.DB  0x72,0x20,0x43,0x68,0x65,0x63,0x6B,0x0
	.DB  0x47,0x6F,0x6F,0x64,0x20,0x42,0x79,0x65
	.DB  0x0,0x57,0x72,0x6F,0x6E,0x67,0x20,0x50
	.DB  0x61,0x73,0x73,0x77,0x6F,0x72,0x64,0x0

__GLOBAL_INI_TBL:
	.DW  0x15
	.DW  _0xA
	.DW  _0x0*2

	.DW  0x10
	.DW  _Port_char
	.DW  _0x5A*2

	.DW  0x07
	.DW  _Port_fnd
	.DW  _0x5B*2

	.DW  0x07
	.DW  _master_password
	.DW  _0xAF*2

	.DW  0x11
	.DW  _0xBC
	.DW  _0x0*2+21

	.DW  0x12
	.DW  _0xBC+17
	.DW  _0x0*2+38

	.DW  0x11
	.DW  _0xBC+35
	.DW  _0x0*2+56

	.DW  0x0C
	.DW  _0xF7
	.DW  _0x0*2+73

	.DW  0x04
	.DW  _0xF7+12
	.DW  _0x0*2+85

	.DW  0x04
	.DW  _0xF7+16
	.DW  _0x0*2+89

	.DW  0x04
	.DW  _0xF7+20
	.DW  _0x0*2+93

	.DW  0x11
	.DW  _0xF7+24
	.DW  _0x0*2+97

	.DW  0x0F
	.DW  _0xF7+41
	.DW  _0x0*2+152

	.DW  0x0D
	.DW  _0xF7+56
	.DW  _0x0*2+167

	.DW  0x0A
	.DW  _0xF7+69
	.DW  _0x0*2+180

	.DW  0x0C
	.DW  _0xF7+79
	.DW  _0x0*2+190

	.DW  0x0B
	.DW  _0xF7+91
	.DW  _0x0*2+202

	.DW  0x0C
	.DW  _0xF7+102
	.DW  _0x0*2+190

	.DW  0x0B
	.DW  _0xF7+114
	.DW  _0x0*2+213

	.DW  0x09
	.DW  _0xF7+125
	.DW  _0x0*2+224

	.DW  0x0F
	.DW  _0xF7+134
	.DW  _0x0*2+233

	.DW  0x0F
	.DW  _0xF7+149
	.DW  _0x0*2+152

	.DW  0x05
	.DW  0x05
	.DW  _0x12D*2

_0xFFFFFFFF:
	.DW  0

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

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

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
	.ORG 0

	.DSEG
	.ORG 0x500

	.CSEG
;#include <mega128.h>
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
;#include <delay.h>
;#include <stdio.h>
;#include "lcd.h"

	.CSEG
_LCD_PORT_Init:
	LDI  R30,LOW(255)
	OUT  0x1A,R30
	LDI  R30,LOW(31)
	STS  100,R30
	RET
_LCD_Data:
;	ch -> Y+0
	LDS  R30,101
	ORI  R30,4
	CALL SUBOPT_0x0
	ANDI R30,0xFD
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1
	RJMP _0x2060005
_LCD_Comm:
;	ch -> Y+0
	LDS  R30,101
	ANDI R30,0xFB
	CALL SUBOPT_0x0
	ANDI R30,0xFD
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1
	RJMP _0x2060005
_LCD_delay:
;	ms -> Y+0
	LD   R30,Y
	LDI  R31,0
	CALL SUBOPT_0x2
	RJMP _0x2060005
_LCD_Pos:
;	col -> Y+1
;	row -> Y+0
	LDD  R30,Y+1
	LDI  R26,LOW(64)
	MULS R30,R26
	MOVW R30,R0
	LD   R26,Y
	ADD  R30,R26
	ORI  R30,0x80
	ST   -Y,R30
	RCALL _LCD_Comm
	RJMP _0x2060004
_LCD_Char:
;	c -> Y+0
	LD   R30,Y
	ST   -Y,R30
	RCALL _LCD_Data
	CALL SUBOPT_0x3
	RJMP _0x2060005
_LCD_Str:
;	*str -> Y+0
_0x3:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
	CPI  R30,0
	BREQ _0x5
	ST   -Y,R30
	RCALL _LCD_Char
	CALL SUBOPT_0x4
	RJMP _0x3
_0x5:
	RJMP _0x2060004
;	*str -> Y+1
;	loop_count -> R17

	.DSEG
_0xA:
	.BYTE 0x15

	.CSEG
_LCD_Clear:
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _LCD_Comm
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _LCD_delay
	RET
_LCD_Init:
	RCALL _LCD_PORT_Init
	CALL SUBOPT_0x5
	CALL SUBOPT_0x5
	CALL SUBOPT_0x5
	LDI  R30,LOW(14)
	CALL SUBOPT_0x6
	LDI  R30,LOW(6)
	CALL SUBOPT_0x6
	RCALL _LCD_Clear
	RET
;	p -> Y+0
;	p -> Y+0
;#include "twi.h"
_Init_TWI:
	LDI  R30,LOW(50)
	STS  112,R30
	LDI  R30,LOW(4)
	STS  116,R30
	LDI  R30,LOW(0)
	STS  113,R30
	RET
_TWI_TransCheck_ACK:
	ST   -Y,R17
	ST   -Y,R16
;	Stat -> Y+2
;	ExtDev_ErrCnt -> R16,R17
	__GETWRN 16,17,0
_0x12:
	LDS  R30,116
	ANDI R30,LOW(0x80)
	BRNE _0x14
	MOVW R26,R16
	__ADDWRN 16,17,1
	CPI  R26,LOW(0x7D1)
	LDI  R30,HIGH(0x7D1)
	CPC  R27,R30
	BRLO _0x15
	LDI  R30,LOW(1)
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x206000A
_0x15:
	RJMP _0x12
_0x14:
	LDS  R30,113
	ANDI R30,LOW(0xF8)
	MOV  R26,R30
	LDD  R30,Y+2
	CP   R30,R26
	BREQ _0x16
	LDI  R30,LOW(2)
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x206000A
_0x16:
	LDI  R30,LOW(0)
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x206000A
_TWI_Start:
	LDI  R30,LOW(164)
	STS  116,R30
	LDI  R30,LOW(8)
	RJMP _0x206000B
_TWI_Write_SLAW:
;	Addr -> Y+0
	CALL SUBOPT_0x7
	LDI  R30,LOW(24)
	ST   -Y,R30
	RCALL _TWI_TransCheck_ACK
	RJMP _0x2060005
_TWI_Write_Data:
;	Data -> Y+0
	CALL SUBOPT_0x7
	LDI  R30,LOW(40)
	ST   -Y,R30
	RCALL _TWI_TransCheck_ACK
	RJMP _0x2060005
_TWI_Stop:
	LDI  R30,LOW(148)
	STS  116,R30
	RET
_TWI_Restart:
	LDI  R30,LOW(164)
	STS  116,R30
	LDI  R30,LOW(16)
_0x206000B:
	ST   -Y,R30
	RCALL _TWI_TransCheck_ACK
	RET
;	Data -> Y+2
;	Addr -> Y+1
;	ret_err -> R17
_TWI_Write_SLAR:
;	Addr -> Y+0
	LD   R30,Y
	ORI  R30,1
	STS  115,R30
	LDI  R30,LOW(132)
	STS  116,R30
	LDI  R30,LOW(64)
	ST   -Y,R30
	RCALL _TWI_TransCheck_ACK
	RJMP _0x2060005
;	*Data -> Y+1
;	ret_err -> R17
_TWI_Read_Data_NACK:
	ST   -Y,R17
;	*Data -> Y+1
;	ret_err -> R17
	LDI  R17,0
	LDI  R30,LOW(132)
	STS  116,R30
	LDI  R30,LOW(88)
	ST   -Y,R30
	RCALL _TWI_TransCheck_ACK
	MOV  R17,R30
	LDS  R30,115
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ST   X,R30
	LDI  R30,LOW(0)
	LDD  R17,Y+0
_0x206000A:
	ADIW R28,3
	RET
;	Addr -> Y+4
;	*Data -> Y+2
;	rec_data -> R17
;	ret_err -> R16
;	Slave_Addr -> Y+0
;	*Data -> Y+1
;	ret_err -> R17
;	*Data -> Y+2
;	ret_err -> R17
;	rec_data -> R16
;	devAddr -> Y+5
;	regAddr -> Y+4
;	*Data -> Y+2
;	rec_data -> R17
;	ret_err -> R16
;#include "srf02.h"
_SRF02_I2C_Write:
	ST   -Y,R17
;	address -> Y+3
;	reg -> Y+2
;	data -> Y+1
;	ret_err -> R17
	LDI  R17,0
	RCALL _TWI_Start
	MOV  R17,R30
	LDD  R30,Y+3
	ST   -Y,R30
	RCALL _TWI_Write_SLAW
	MOV  R17,R30
	CPI  R17,0
	BREQ _0x29
	MOV  R30,R17
	LDD  R17,Y+0
	RJMP _0x2060008
_0x29:
	LDD  R30,Y+2
	ST   -Y,R30
	RCALL _TWI_Write_Data
	MOV  R17,R30
	CPI  R17,0
	BREQ _0x2A
	MOV  R30,R17
	LDD  R17,Y+0
	RJMP _0x2060008
_0x2A:
	LDD  R30,Y+1
	ST   -Y,R30
	RCALL _TWI_Write_Data
	MOV  R17,R30
	CPI  R17,0
	BREQ _0x2B
	MOV  R30,R17
	LDD  R17,Y+0
	RJMP _0x2060008
_0x2B:
	RCALL _TWI_Stop
	LDI  R30,LOW(0)
	LDD  R17,Y+0
	RJMP _0x2060008
_SRF02_I2C_Read:
	ST   -Y,R17
	ST   -Y,R16
;	address -> Y+5
;	reg -> Y+4
;	*Data -> Y+2
;	read_data -> R17
;	ret_err -> R16
	LDI  R17,0
	LDI  R16,0
	RCALL _TWI_Start
	MOV  R16,R30
	LDD  R30,Y+5
	ST   -Y,R30
	RCALL _TWI_Write_SLAW
	MOV  R16,R30
	CPI  R16,0
	BREQ _0x2C
	MOV  R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x2060006
_0x2C:
	LDD  R30,Y+4
	ST   -Y,R30
	RCALL _TWI_Write_Data
	MOV  R16,R30
	CPI  R16,0
	BREQ _0x2D
	MOV  R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x2060006
_0x2D:
	RCALL _TWI_Restart
	MOV  R16,R30
	SBI  0x18,3
	CPI  R16,0
	BREQ _0x2E
	MOV  R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x2060006
_0x2E:
	LDD  R30,Y+5
	ST   -Y,R30
	RCALL _TWI_Write_SLAR
	MOV  R16,R30
	SBI  0x18,4
	CPI  R16,0
	BREQ _0x2F
	MOV  R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x2060006
_0x2F:
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R17
	RCALL _TWI_Read_Data_NACK
	POP  R17
	MOV  R16,R30
	SBI  0x18,5
	CPI  R16,0
	BREQ _0x30
	MOV  R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x2060006
_0x30:
	RCALL _TWI_Stop
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R17
	LDI  R30,LOW(0)
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x2060006
_startRanging:
;	addr -> Y+0
	LD   R30,Y
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(81)
	ST   -Y,R30
	RCALL _SRF02_I2C_Write
	RJMP _0x2060005
_getRange:
	ST   -Y,R17
	ST   -Y,R16
;	addr -> Y+4
;	*pDistance -> Y+2
;	temp -> R17
;	res -> R16
	LDI  R16,0
	LDD  R30,Y+4
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R17
	RCALL _SRF02_I2C_Read
	POP  R17
	MOV  R16,R30
	CPI  R16,0
	BRNE _0x2060009
	MOV  R31,R17
	LDI  R30,LOW(0)
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X+,R30
	ST   X,R31
	LDD  R30,Y+4
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R17
	RCALL _SRF02_I2C_Read
	POP  R17
	MOV  R16,R30
	CPI  R16,0
	BRNE _0x2060009
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	MOVW R0,R26
	CALL __GETW1P
	MOVW R26,R30
	CALL SUBOPT_0x8
	OR   R30,R26
	OR   R31,R27
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
_0x2060009:
	MOV  R30,R16
	LDI  R31,0
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
;	ori -> Y+2
;	des -> Y+1
;	res -> R17
;#include "Keypad.h"

	.DSEG

	.CSEG
_FND_PORT_Init:
	IN   R30,0x2
	ORI  R30,LOW(0xF0)
	OUT  0x2,R30
	LDS  R30,97
	ORI  R30,LOW(0xFF)
	STS  97,R30
	IN   R30,0x14
	ORI  R30,LOW(0xF)
	OUT  0x14,R30
	LDS  R30,100
	ORI  R30,0x10
	STS  100,R30
	SBI  0x17,5
	IN   R30,0x15
	ORI  R30,LOW(0xFF)
	OUT  0x15,R30
	RET
_Init_Timer1:
	LDI  R30,LOW(130)
	OUT  0x2F,R30
	LDI  R30,LOW(26)
	OUT  0x2E,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2C+1,R31
	OUT  0x2C,R30
	LDI  R30,LOW(36863)
	LDI  R31,HIGH(36863)
	OUT  0x26+1,R31
	OUT  0x26,R30
	CALL SUBOPT_0x9
	IN   R30,0x37
	ORI  R30,0x10
	RJMP _0x2060003
_compare:
	nop
	RETI
_myDelay_us:
	ST   -Y,R17
	ST   -Y,R16
;	delay -> Y+2
;	loop -> R16,R17
	__GETWRN 16,17,0
_0x5D:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CP   R16,R30
	CPC  R17,R31
	BRSH _0x5E
	__DELAY_USB 5
	__ADDWRN 16,17,1
	RJMP _0x5D
_0x5E:
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x2060008:
	ADIW R28,4
	RET
_Buzzer_play:
	CALL __SAVELOCR4
;	delay -> Y+4
;	loop -> R16,R17
;	Play_Tim -> R19
	LDI  R19,0
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	LDI  R26,LOW(10000)
	LDI  R27,HIGH(10000)
	CALL __DIVW21U
	MOV  R19,R30
	__GETWRN 16,17,0
_0x60:
	MOV  R30,R19
	MOVW R26,R16
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x61
	LDS  R30,101
	ORI  R30,0x10
	CALL SUBOPT_0xA
	LDS  R30,101
	ANDI R30,0xEF
	CALL SUBOPT_0xA
	__ADDWRN 16,17,1
	RJMP _0x60
_0x61:
	RJMP _0x2060007
_KeyScan:
	CALL __SAVELOCR6
;	key_scan_line -> R16,R17
;	key_scan_loop -> R19
;	getPinData -> R18
;	key_num -> R20,R21
	__GETWRN 16,17,254
	LDI  R19,0
	LDI  R18,0
	__GETWRN 20,21,0
	LDI  R19,LOW(0)
_0x63:
	CPI  R19,4
	BRSH _0x64
	OUT  0x15,R16
	__DELAY_USB 5
	IN   R30,0x13
	ANDI R30,LOW(0xF0)
	MOV  R18,R30
	CPI  R18,0
	BREQ _0x65
	MOV  R30,R18
	LDI  R31,0
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0x69
	LDI  R30,LOW(4)
	MUL  R30,R19
	MOVW R30,R0
	ADIW R30,1
	RJMP _0x126
_0x69:
	CPI  R30,LOW(0x20)
	LDI  R26,HIGH(0x20)
	CPC  R31,R26
	BRNE _0x6A
	LDI  R30,LOW(4)
	MUL  R30,R19
	MOVW R30,R0
	ADIW R30,2
	RJMP _0x126
_0x6A:
	CPI  R30,LOW(0x40)
	LDI  R26,HIGH(0x40)
	CPC  R31,R26
	BRNE _0x6B
	LDI  R30,LOW(4)
	MUL  R30,R19
	MOVW R30,R0
	ADIW R30,3
	RJMP _0x126
_0x6B:
	CPI  R30,LOW(0x80)
	LDI  R26,HIGH(0x80)
	CPC  R31,R26
	BRNE _0x68
	LDI  R30,LOW(4)
	MUL  R30,R19
	MOVW R30,R0
	ADIW R30,4
_0x126:
	MOVW R20,R30
_0x68:
	MOV  R30,R20
	CALL __LOADLOCR6
	RJMP _0x2060006
_0x65:
	LSL  R16
	ROL  R17
	SUBI R19,-1
	RJMP _0x63
_0x64:
	CALL __LOADLOCR6
	RJMP _0x2060006
_Changenum:
	ST   -Y,R17
;	num -> Y+1
;	return_num -> R17
	LDI  R17,0
	LDD  R30,Y+1
	CPI  R30,0
	BRNE _0x6D
	LDI  R17,LOW(0)
	RJMP _0x6E
_0x6D:
	CALL SUBOPT_0xB
	SBIW R30,0
	BRNE _0x6F
	CALL SUBOPT_0xC
	SUBI R30,-LOW(12)
	RJMP _0x127
_0x6F:
	CALL SUBOPT_0xC
	SBIW R30,0
	BRNE _0x71
	CALL SUBOPT_0xC
	LSL  R30
	LSL  R30
	MOV  R22,R30
	CALL SUBOPT_0xB
	ADD  R30,R22
	RJMP _0x127
_0x71:
	CALL SUBOPT_0xC
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x73
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
	MOVW R26,R22
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x128
_0x73:
	CALL SUBOPT_0xC
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x75
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
	MOVW R26,R22
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP _0x128
_0x75:
	CALL SUBOPT_0xC
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x77
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
	MOVW R26,R22
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
_0x128:
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
_0x127:
	MOV  R17,R30
_0x77:
_0x6E:
	CPI  R17,11
	BRNE _0x78
	LDI  R17,LOW(0)
	LDI  R30,LOW(1)
	MOV  R5,R30
_0x78:
	MOV  R30,R17
	LDD  R17,Y+0
	RJMP _0x2060004
_OUTFND:
	CALL __SAVELOCR4
;	t -> Y+4
;	FND0 -> R17
;	FND1 -> R16
;	FND2 -> R19
;	FND3 -> R18
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __DIVW21U
	MOV  R18,R30
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __MODW21U
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	MOV  R19,R30
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21U
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	MOV  R16,R30
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21U
	MOV  R17,R30
	LDS  R30,_Port_fnd
	OUT  0x3,R30
	CALL SUBOPT_0x8
	CALL SUBOPT_0xE
	__GETB1MN _Port_fnd,2
	OUT  0x3,R30
	MOV  R30,R16
	CALL SUBOPT_0xF
	__GETB1MN _Port_fnd,4
	OUT  0x3,R30
	MOV  R30,R19
	CALL SUBOPT_0xF
	__GETB1MN _Port_fnd,6
	OUT  0x3,R30
	MOV  R30,R18
	CALL SUBOPT_0xF
_0x2060007:
	CALL __LOADLOCR4
_0x2060006:
	ADIW R28,6
	RET
_buzzer_play_function:
;	t -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x7C
	LDI  R30,LOW(1908)
	LDI  R31,HIGH(1908)
	CALL SUBOPT_0x10
	RJMP _0x7B
_0x7C:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x7D
	LDI  R30,LOW(1700)
	LDI  R31,HIGH(1700)
	CALL SUBOPT_0x10
	RJMP _0x7B
_0x7D:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x7E
	LDI  R30,LOW(1515)
	LDI  R31,HIGH(1515)
	CALL SUBOPT_0x10
	RJMP _0x7B
_0x7E:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x7F
	LDI  R30,LOW(1432)
	LDI  R31,HIGH(1432)
	CALL SUBOPT_0x10
	RJMP _0x7B
_0x7F:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x80
	LDI  R30,LOW(1275)
	LDI  R31,HIGH(1275)
	CALL SUBOPT_0x10
	RJMP _0x7B
_0x80:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x81
	LDI  R30,LOW(1136)
	LDI  R31,HIGH(1136)
	CALL SUBOPT_0x10
	RJMP _0x7B
_0x81:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x82
	LDI  R30,LOW(1012)
	LDI  R31,HIGH(1012)
	CALL SUBOPT_0x10
	RJMP _0x7B
_0x82:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x83
	LDI  R30,LOW(954)
	LDI  R31,HIGH(954)
	CALL SUBOPT_0x10
	RJMP _0x7B
_0x83:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x85
	LDI  R30,LOW(850)
	LDI  R31,HIGH(850)
	CALL SUBOPT_0x10
_0x85:
_0x7B:
	RJMP _0x2060004
;	num -> Y+1
;	str -> R17
;#include "usart.h"
;	baud -> Y+0
_Init_USART1_IntCon:
;	baud -> Y+1
;	Int_type -> Y+0
	LDI  R30,LOW(0)
	STS  155,R30
	LDI  R30,LOW(152)
	STS  154,R30
	LDD  R30,Y+1
	CALL SUBOPT_0x11
	BRNE _0x9D
	LDI  R30,LOW(0)
	STS  152,R30
	LDI  R30,LOW(95)
	STS  153,R30
	RJMP _0x9C
_0x9D:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x9F
	LDI  R30,LOW(0)
	STS  152,R30
	LDI  R30,LOW(7)
	STS  153,R30
_0x9F:
_0x9C:
	LD   R30,Y
	CALL SUBOPT_0x11
	BRNE _0xA3
	LDI  R30,LOW(152)
	RJMP _0x129
_0xA3:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xA4
	LDI  R30,LOW(56)
	RJMP _0x129
_0xA4:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xA2
	LDI  R30,LOW(184)
_0x129:
	STS  154,R30
_0xA2:
	LDI  R30,LOW(6)
	STS  157,R30
	RJMP _0x2060004
_putch_USART1:
;	data -> Y+0
_0xA6:
	LDS  R30,155
	ANDI R30,LOW(0x20)
	BREQ _0xA6
	LD   R30,Y
	STS  156,R30
_0x2060005:
	ADIW R28,1
	RET
_puts_USART1:
;	*str -> Y+0
_0xA9:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
	CPI  R30,0
	BREQ _0xAB
	CALL SUBOPT_0x12
	CALL SUBOPT_0x4
	RJMP _0xA9
_0xAB:
_0x2060004:
	ADIW R28,2
	RET
;
;/*상태 정의*/
;#define NONE 0
;#define START 1
;#define INPUT_PHONE 2
;#define INPUT_PHONE_INIT 3
;#define CHECK_PNUM 4
;#define CHECK_PNUM_INIT 5
;#define EXIT_CHOOSE 6
;#define CHECK_PNUM_OUT 7
;#define CHECK_PNUM_OUT_INIT 8
;#define INPUT_PHONE_OUT 9
;#define INPUT_PHONE_OUT_INIT 10
;
;/*usart 정의*/
;#define ENTER '\r'
;#define MAXLEN 17
;unsigned char str[MAXLEN], str2[MAXLEN];
;unsigned char master_password[] = "1mingyu";

	.DSEG
;char num[3][11];
;
;unsigned char ti_Cnt_1ms;  //초음파 센서구동을위한 cnt
;unsigned char LCD_DelCnt_1ms;
;unsigned char Distance_cnt_1ms; // 시간지나면 자리비움처리를 위한 cnt
;unsigned char ch=0;
;
;interrupt [USART1_RXC] void usart1_receive(void)
; 0000 0024 {

	.CSEG
_usart1_receive:
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
; 0000 0025     unsigned char i;
; 0000 0026 
; 0000 0027     str[ch] = UDR1;          //인터럽트 발생 시 수신된 문자를 str[ch]에 저장
	ST   -Y,R17
;	i -> R17
	MOV  R26,R9
	LDI  R27,0
	SUBI R26,LOW(-_str)
	SBCI R27,HIGH(-_str)
	LDS  R30,156
	ST   X,R30
; 0000 0028 
; 0000 0029 
; 0000 002A      if(str[ch] == ENTER){
	MOV  R30,R9
	LDI  R31,0
	SUBI R30,LOW(-_str)
	SBCI R31,HIGH(-_str)
	LD   R26,Z
	CPI  R26,LOW(0xD)
	BREQ PC+3
	JMP _0xB0
; 0000 002B         char access_cnt = 0;
; 0000 002C         for(i=0;i<MAXLEN;i++) str2[i] = 'a';
	SBIW R28,1
	LDI  R30,LOW(0)
	ST   Y,R30
;	access_cnt -> Y+0
	LDI  R17,LOW(0)
_0xB2:
	CPI  R17,17
	BRSH _0xB3
	CALL SUBOPT_0x8
	SUBI R30,LOW(-_str2)
	SBCI R31,HIGH(-_str2)
	LDI  R26,LOW(97)
	STD  Z+0,R26
	SUBI R17,-1
	RJMP _0xB2
_0xB3:
; 0000 002D for(i=0;i<17;i++) str2[i] = str[i];
	LDI  R17,LOW(0)
_0xB5:
	CPI  R17,17
	BRSH _0xB6
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_str2)
	SBCI R27,HIGH(-_str2)
	CALL SUBOPT_0x8
	SUBI R30,LOW(-_str)
	SBCI R31,HIGH(-_str)
	LD   R30,Z
	ST   X,R30
	SUBI R17,-1
	RJMP _0xB5
_0xB6:
; 0000 002F str[ch-1] = 0x00;
	MOV  R30,R9
	LDI  R31,0
	SBIW R30,1
	SUBI R30,LOW(-_str)
	SBCI R31,HIGH(-_str)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 0030         ch = 0;             //문자열 초기화
	CLR  R9
; 0000 0031 
; 0000 0032         for (i=1;i<7;i++) {
	LDI  R17,LOW(1)
_0xB8:
	CPI  R17,7
	BRSH _0xB9
; 0000 0033             if (master_password[i] == str2[i]) access_cnt ++;
	CALL SUBOPT_0x8
	MOVW R0,R30
	SUBI R30,LOW(-_master_password)
	SBCI R31,HIGH(-_master_password)
	LD   R26,Z
	MOVW R30,R0
	SUBI R30,LOW(-_str2)
	SBCI R31,HIGH(-_str2)
	LD   R30,Z
	CP   R30,R26
	BRNE _0xBA
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
; 0000 0034         }
_0xBA:
	SUBI R17,-1
	RJMP _0xB8
_0xB9:
; 0000 0035         if (access_cnt == 6) {
	LD   R26,Y
	CPI  R26,LOW(0x6)
	BRNE _0xBB
; 0000 0036             puts_USART1("\n first seat : \n");
	__POINTW1MN _0xBC,0
	CALL SUBOPT_0x13
; 0000 0037             for(i=0;i<11;i++)  putch_USART1(num[0][i]);
_0xBE:
	CPI  R17,11
	BRSH _0xBF
	CALL SUBOPT_0x8
	SUBI R30,LOW(-_num)
	SBCI R31,HIGH(-_num)
	LD   R30,Z
	ST   -Y,R30
	RCALL _putch_USART1
	SUBI R17,-1
	RJMP _0xBE
_0xBF:
; 0000 0038 puts_USART1("\n Second seat : \n");
	__POINTW1MN _0xBC,17
	CALL SUBOPT_0x13
; 0000 0039             for(i=0;i<11;i++)  putch_USART1(num[1][i]);
_0xC1:
	CPI  R17,11
	BRSH _0xC2
	__POINTW2MN _num,11
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	CALL SUBOPT_0x12
	SUBI R17,-1
	RJMP _0xC1
_0xC2:
; 0000 003A puts_USART1("\n Third seat : \n");
	__POINTW1MN _0xBC,35
	CALL SUBOPT_0x13
; 0000 003B             for(i=0;i<11;i++)  putch_USART1(num[2][i]);
_0xC4:
	CPI  R17,11
	BRSH _0xC5
	__POINTW2MN _num,22
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	CALL SUBOPT_0x12
	SUBI R17,-1
	RJMP _0xC4
_0xC5:
; 0000 003C }
; 0000 003D 
; 0000 003E         for(i=0;i<MAXLEN;i++) str2[i] = 0;
_0xBB:
	LDI  R17,LOW(0)
_0xC7:
	CPI  R17,17
	BRSH _0xC8
	CALL SUBOPT_0x8
	SUBI R30,LOW(-_str2)
	SBCI R31,HIGH(-_str2)
	LDI  R26,LOW(0)
	STD  Z+0,R26
	SUBI R17,-1
	RJMP _0xC7
_0xC8:
; 0000 003F }
	ADIW R28,1
; 0000 0040      else ch++;
	RJMP _0xC9
_0xB0:
	INC  R9
; 0000 0041      delay_ms(10);
_0xC9:
	CALL SUBOPT_0x14
; 0000 0042 
; 0000 0043 
; 0000 0044 
; 0000 0045     if ( ch >= MAXLEN) ch = 0;    //최대 글자 이상일때 에러모드
	LDI  R30,LOW(17)
	CP   R9,R30
	BRLO _0xCA
	CLR  R9
; 0000 0046 
; 0000 0047 }
_0xCA:
	LD   R17,Y+
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

	.DSEG
_0xBC:
	.BYTE 0x34
;
;
;void Timer0_Init()  //초음파 센서구동 타이머 인터럽트
; 0000 004B {

	.CSEG
_Timer0_Init:
; 0000 004C     TCCR0 = (1<<WGM01)|(1<<CS00)|(1<<CS01)|(1<<CS02);
	LDI  R30,LOW(15)
	OUT  0x33,R30
; 0000 004D     TCNT0 = 0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 004E     OCR0 = 100;
	LDI  R30,LOW(100)
	OUT  0x31,R30
; 0000 004F     TIMSK = (1<<OCIE0);
	LDI  R30,LOW(2)
_0x2060003:
	OUT  0x37,R30
; 0000 0050 }
	RET
;
;interrupt[TIM0_COMP] void timer0_comp(void)    //실제 카운트 증가
; 0000 0053 {
_timer0_comp:
	ST   -Y,R30
	IN   R30,SREG
; 0000 0054     ti_Cnt_1ms++;
	INC  R4
; 0000 0055     LCD_DelCnt_1ms++;
	INC  R7
; 0000 0056 
; 0000 0057 }
	OUT  SREG,R30
	LD   R30,Y+
	RETI
;
;
;
;
;
;
;int SRF_Run(char Sonar_Addr){    //SRF 주소로 값을 받아옴
; 0000 005E int SRF_Run(char Sonar_Addr){
_SRF_Run:
; 0000 005F     unsigned char res;
; 0000 0060     unsigned int Sonar_range;
; 0000 0061 
; 0000 0062     res = getRange(Sonar_Addr, &Sonar_range);
	CALL __SAVELOCR4
;	Sonar_Addr -> Y+4
;	res -> R17
;	Sonar_range -> R18,R19
	LDD  R30,Y+4
	ST   -Y,R30
	IN   R30,SPL
	IN   R31,SPH
	SBIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	PUSH R19
	PUSH R18
	RCALL _getRange
	POP  R18
	POP  R19
	MOV  R17,R30
; 0000 0063         if(res)
	CPI  R17,0
	BREQ _0xCB
; 0000 0064         {
; 0000 0065             return 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __LOADLOCR4
	JMP  _0x2060002
; 0000 0066         }
; 0000 0067         else if(LCD_DelCnt_1ms > 100)
_0xCB:
	LDI  R30,LOW(100)
	CP   R30,R7
	BRSH _0xCD
; 0000 0068         {
; 0000 0069             LCD_DelCnt_1ms = 0;
	CLR  R7
; 0000 006A             return Sonar_range;
	MOVW R30,R18
	CALL __LOADLOCR4
	JMP  _0x2060002
; 0000 006B         }
; 0000 006C }
_0xCD:
	CALL __LOADLOCR4
	JMP  _0x2060002
;
;
;void main(void)
; 0000 0070 {
_main:
; 0000 0071     unsigned char res;
; 0000 0072     char Sonar_Addr = 0xE0;
; 0000 0073     unsigned int Sonar_range[3]={0,};
; 0000 0074     char Message[40];
; 0000 0075     int readCnt = 0;
; 0000 0076     int t=0; //키패드로 받은 숫자
; 0000 0077     int count =0; //count 변수
; 0000 0078     int finalnum=0; //FND에 출력으로 넣어줄 변수
; 0000 0079     int fnd[12]={0,};
; 0000 007A     signed int angle=0; // 서브모터 각도로 넣을 변수
; 0000 007B     char STATE = START;
; 0000 007C     char user_state[3] = {'X','X','X'};
; 0000 007D     int i = 0;
; 0000 007E     char user_pnumber[3][11]; //유저 비밀번호 저장
; 0000 007F     char check_pnumber[11]; //비밀번호 일치확인을위한 공간
; 0000 0080     char user_name; //1~3번중 어느좌석 유저를 가르키는지 저장
; 0000 0081 
; 0000 0082     char empty_cnt[3]={0,};
; 0000 0083 
; 0000 0084     DDRD |= 0x03;
	SBIW R28,63
	SBIW R28,63
	SBIW R28,4
	LDI  R24,130
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0xCE*2)
	LDI  R31,HIGH(_0xCE*2)
	CALL __INITLOCB
;	res -> R17
;	Sonar_Addr -> R16
;	Sonar_range -> Y+124
;	Message -> Y+84
;	readCnt -> R18,R19
;	t -> R20,R21
;	count -> Y+82
;	finalnum -> Y+80
;	fnd -> Y+56
;	angle -> Y+54
;	STATE -> Y+53
;	user_state -> Y+50
;	i -> Y+48
;	user_pnumber -> Y+15
;	check_pnumber -> Y+4
;	user_name -> Y+3
;	empty_cnt -> Y+0
	LDI  R16,224
	__GETWRN 18,19,0
	__GETWRN 20,21,0
	IN   R30,0x11
	ORI  R30,LOW(0x3)
	OUT  0x11,R30
; 0000 0085 
; 0000 0086     LCD_Init();
	RCALL _LCD_Init
; 0000 0087     Timer0_Init();
	RCALL _Timer0_Init
; 0000 0088     FND_PORT_Init(); // 포트들 입출력 초기 설정
	RCALL _FND_PORT_Init
; 0000 0089     Init_TWI();
	RCALL _Init_TWI
; 0000 008A     Init_Timer1();
	RCALL _Init_Timer1
; 0000 008B     delay_ms(1000);
	CALL SUBOPT_0x15
; 0000 008C     SREG |= 0x80;
	BSET 7
; 0000 008D 
; 0000 008E     OCR1A =4710;
	CALL SUBOPT_0x9
; 0000 008F     startRanging(Sonar_Addr);
	ST   -Y,R16
	RCALL _startRanging
; 0000 0090     ti_Cnt_1ms = 0;
	CLR  R4
; 0000 0091     LCD_DelCnt_1ms = 0;
	CLR  R7
; 0000 0092 
; 0000 0093     Init_USART1_IntCon(0,RX_Int);
	CALL SUBOPT_0x16
	RCALL _Init_USART1_IntCon
; 0000 0094     DDRD.7 =1;
	SBI  0x11,7
; 0000 0095 
; 0000 0096 
; 0000 0097 
; 0000 0098     while(1)
_0xD1:
; 0000 0099     {
; 0000 009A         if(ti_Cnt_1ms > 100)  //2초에 한번정도 한센서씩 갱신
	LDI  R30,LOW(100)
	CP   R30,R4
	BRLO PC+3
	JMP _0xD4
; 0000 009B         {
; 0000 009C             if (Sonar_Addr == 0xE0){
	CPI  R16,224
	BRNE _0xD5
; 0000 009D                 Sonar_Addr = 0xEC;
	LDI  R16,LOW(236)
; 0000 009E                 startRanging(Sonar_Addr);
	ST   -Y,R16
	RCALL _startRanging
; 0000 009F                 Sonar_range[0] = SRF_Run(Sonar_Addr);
	ST   -Y,R16
	RCALL _SRF_Run
	__PUTW1SX 124
; 0000 00A0 
; 0000 00A1 
; 0000 00A2             }
; 0000 00A3             else if (Sonar_Addr == 0xEC) {
	RJMP _0xD6
_0xD5:
	CPI  R16,236
	BRNE _0xD7
; 0000 00A4                 Sonar_Addr = 0xE2;
	LDI  R16,LOW(226)
; 0000 00A5                 startRanging(Sonar_Addr);
	CALL SUBOPT_0x17
; 0000 00A6                 Sonar_range[1] = SRF_Run(Sonar_Addr);
	ADIW R30,2
	PUSH R31
	PUSH R30
	ST   -Y,R16
	RCALL _SRF_Run
	POP  R26
	POP  R27
	RJMP _0x12A
; 0000 00A7 
; 0000 00A8             }
; 0000 00A9             else{
_0xD7:
; 0000 00AA                 Sonar_Addr = 0xE0;
	LDI  R16,LOW(224)
; 0000 00AB                 startRanging(Sonar_Addr);
	CALL SUBOPT_0x17
; 0000 00AC                 Sonar_range[2] = SRF_Run(Sonar_Addr);
	ADIW R30,4
	PUSH R31
	PUSH R30
	ST   -Y,R16
	RCALL _SRF_Run
	POP  R26
	POP  R27
_0x12A:
	ST   X+,R30
	ST   X,R31
; 0000 00AD 
; 0000 00AE             }
_0xD6:
; 0000 00AF 
; 0000 00B0 
; 0000 00B1             /*   초음파 확 인 *//*
; 0000 00B2             LCD_Clear();
; 0000 00B3             sprintf(Message, "%03dcm", Sonar_range[0]);
; 0000 00B4             LCD_Pos(0,0);
; 0000 00B5             LCD_Str(Message);
; 0000 00B6 
; 0000 00B7             sprintf(Message, "%03dcm", Sonar_range[1]);
; 0000 00B8             LCD_Pos(1,0);
; 0000 00B9             LCD_Str(Message);
; 0000 00BA 
; 0000 00BB             sprintf(Message, "%03dcm", Sonar_range[2]);
; 0000 00BC             LCD_Pos(1,5);
; 0000 00BD             LCD_Str(Message); */
; 0000 00BE 
; 0000 00BF             /* 자리비움 처리 */
; 0000 00C0             for (i=0;i<3;i++){
	LDI  R30,LOW(0)
	STD  Y+48,R30
	STD  Y+48+1,R30
_0xDA:
	LDD  R26,Y+48
	LDD  R27,Y+48+1
	SBIW R26,3
	BRGE _0xDB
; 0000 00C1                 if ( (Sonar_range[i] > 30)&&(user_state[i] == 'O') ){
	LDD  R30,Y+48
	LDD  R31,Y+48+1
	MOVW R26,R28
	SUBI R26,LOW(-(124))
	SBCI R27,HIGH(-(124))
	CALL SUBOPT_0x18
	SBIW R30,31
	BRLO _0xDD
	CALL SUBOPT_0x19
	LD   R26,X
	CPI  R26,LOW(0x4F)
	BREQ _0xDE
_0xDD:
	RJMP _0xDC
_0xDE:
; 0000 00C2                    empty_cnt[i] ++;
	CALL SUBOPT_0x1A
	LD   R30,X
	SUBI R30,-LOW(1)
	RJMP _0x12B
; 0000 00C3                     /*sprintf(Message, "%03dcm", empty_cnt[i]);
; 0000 00C4                     LCD_Clear();
; 0000 00C5                     LCD_Pos(0,0);
; 0000 00C6                     LCD_Str(Message);  */ //cnt확인용
; 0000 00C7                 }
; 0000 00C8                 else empty_cnt[i] =0;
_0xDC:
	CALL SUBOPT_0x1A
	LDI  R30,LOW(0)
_0x12B:
	ST   X,R30
; 0000 00C9 
; 0000 00CA                 if (empty_cnt[i] > 15 ) {
	CALL SUBOPT_0x1A
	LD   R26,X
	CPI  R26,LOW(0x10)
	BRLO _0xE0
; 0000 00CB                  user_state[i] ='E';
	CALL SUBOPT_0x19
	LDI  R30,LOW(69)
	ST   X,R30
; 0000 00CC                  if (STATE == NONE ) STATE = START;
	LDD  R30,Y+53
	CPI  R30,0
	BRNE _0xE1
	LDI  R30,LOW(1)
	STD  Y+53,R30
; 0000 00CD                 }
_0xE1:
; 0000 00CE             }
_0xE0:
	LDD  R30,Y+48
	LDD  R31,Y+48+1
	ADIW R30,1
	STD  Y+48,R30
	STD  Y+48+1,R31
	RJMP _0xDA
_0xDB:
; 0000 00CF 
; 0000 00D0 
; 0000 00D1 
; 0000 00D2             LCD_DelCnt_1ms = 0;
	CLR  R7
; 0000 00D3             ti_Cnt_1ms = 0;
	CLR  R4
; 0000 00D4         }
; 0000 00D5 
; 0000 00D6 
; 0000 00D7         /*
; 0000 00D8         if(PIND.7 == 1){
; 0000 00D9            LCD_Clear();
; 0000 00DA               LCD_Pos(0,0); // 문자열 위치 0행 1열 지정
; 0000 00DB               LCD_Str("Warning....."); // 문자열 str을 LCD 첫번째 라인에 출력
; 0000 00DC               delay_us(10);
; 0000 00DD               LCD_Pos(1,0); // 문자열 위치 1행 1열 지정
; 0000 00DE                LCD_Str("Fire!!!    "); // 문자열 str을 LCD 두번째 라인에 출력
; 0000 00DF              LCD_Pos(1,0);
; 0000 00E0               delay_us(10);
; 0000 00E1 
; 0000 00E2             while(1)
; 0000 00E3             {
; 0000 00E4 
; 0000 00E5                  for(i=0;i<20;i++){    //사이렌 소리
; 0000 00E6                   Buzzer_play(Sol/2);
; 0000 00E7                   delay_ms(10);
; 0000 00E8                 }
; 0000 00E9                 delay_ms(10);
; 0000 00EA                 for(i=0;i<20;i++){
; 0000 00EB                     Buzzer_play(Re/2);
; 0000 00EC                     delay_ms(10);
; 0000 00ED                 }
; 0000 00EE             }
; 0000 00EF 
; 0000 00F0         }
; 0000 00F1             else{
; 0000 00F2 
; 0000 00F3         }*/
; 0000 00F4 
; 0000 00F5 
; 0000 00F6 
; 0000 00F7 
; 0000 00F8         t= Changenum(KeyScan());
_0xD4:
	RCALL _KeyScan
	ST   -Y,R30
	RCALL _Changenum
	MOV  R20,R30
	CLR  R21
; 0000 00F9         if(t<11 & t>0 ) //숫자가 눌리면 새로운 값을 저장하도록 count값 설정
	MOVW R26,R20
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	CALL __LTW12
	MOV  R0,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __GTW12
	AND  R30,R0
	BREQ _0xE2
; 0000 00FA             {
; 0000 00FB                 count++;
	CALL SUBOPT_0x1B
; 0000 00FC                 delay_ms(50);
	CALL SUBOPT_0x1C
; 0000 00FD             }
; 0000 00FE         else if(t==0 & zero_flag) //zero_flag가 실행된 경우에만 0으로 입력
	RJMP _0xE3
_0xE2:
	MOVW R26,R20
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EQW12
	AND  R30,R5
	BREQ _0xE4
; 0000 00FF             {
; 0000 0100                 count++;
	CALL SUBOPT_0x1B
; 0000 0101                 zero_flag =0; //계속 0으로 입력된 상태가 안되게 zero_flag를 다시 0으로
	CLR  R5
; 0000 0102                 delay_ms(50);
	CALL SUBOPT_0x1C
; 0000 0103             }
; 0000 0104         else if(t==13) // FND 출력숫자 리셋버튼 기능
	RJMP _0xE5
_0xE4:
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	CP   R30,R20
	CPC  R31,R21
	BRNE _0xE6
; 0000 0105             {
; 0000 0106                 fnd[0]=0,fnd[1]=0,fnd[2]=0,fnd[3]=0;
	CALL SUBOPT_0x1D
	LDI  R30,LOW(0)
	STD  Y+60,R30
	STD  Y+60+1,R30
	STD  Y+62,R30
	STD  Y+62+1,R30
; 0000 0107             }
; 0000 0108         else if (t ==14)
	RJMP _0xE7
_0xE6:
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	CP   R30,R20
	CPC  R31,R21
	BRNE _0xE8
; 0000 0109             {
; 0000 010A                STATE = START;
	LDI  R30,LOW(1)
	STD  Y+53,R30
; 0000 010B             }
; 0000 010C 
; 0000 010D         if((count%2) ==0){ //count가 짝수일때 들어온 t값을 저장하고
_0xE8:
_0xE7:
_0xE5:
_0xE3:
	__GETW2SX 82
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __MODW21
	SBIW R30,0
	BRNE _0xE9
; 0000 010E                             //다시 count를 홀수로 만듬
; 0000 010F             for(i=11;i>0;i--) {
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	STD  Y+48,R30
	STD  Y+48+1,R31
_0xEB:
	LDD  R26,Y+48
	LDD  R27,Y+48+1
	CALL __CPW02
	BRGE _0xEC
; 0000 0110                 fnd[i] = fnd[i-1];
	LDD  R30,Y+48
	LDD  R31,Y+48+1
	MOVW R26,R28
	ADIW R26,56
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	LDD  R30,Y+48
	LDD  R31,Y+48+1
	SBIW R30,1
	MOVW R26,R28
	ADIW R26,56
	CALL SUBOPT_0x18
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
; 0000 0111                 delay_us(10);
	__DELAY_USB 49
; 0000 0112             }
	LDD  R30,Y+48
	LDD  R31,Y+48+1
	SBIW R30,1
	STD  Y+48,R30
	STD  Y+48+1,R31
	RJMP _0xEB
_0xEC:
; 0000 0113             fnd[0] = t;
	__PUTWSR 20,21,56
; 0000 0114             count++;
	CALL SUBOPT_0x1B
; 0000 0115             delay_ms(50);
	CALL SUBOPT_0x1C
; 0000 0116         }
; 0000 0117         finalnum = 1000*fnd[3] + 100*fnd[2] + 10*fnd[1] + fnd[0];
_0xE9:
	LDD  R30,Y+62
	LDD  R31,Y+62+1
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL __MULW12
	MOVW R22,R30
	LDD  R30,Y+60
	LDD  R31,Y+60+1
	LDI  R26,LOW(100)
	LDI  R27,HIGH(100)
	CALL __MULW12
	__ADDWRR 22,23,30,31
	LDD  R30,Y+58
	LDD  R31,Y+58+1
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	ADD  R30,R22
	ADC  R31,R23
	LDD  R26,Y+56
	LDD  R27,Y+56+1
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1SX 80
; 0000 0118         OUTFND(finalnum); //FND 출력
	ST   -Y,R31
	ST   -Y,R30
	RCALL _OUTFND
; 0000 0119         buzzer_play_function(t); //숫자에 맞는 음 출력
	ST   -Y,R21
	ST   -Y,R20
	RCALL _buzzer_play_function
; 0000 011A 
; 0000 011B 
; 0000 011C 
; 0000 011D 
; 0000 011E 
; 0000 011F 
; 0000 0120         switch (STATE) {  //LCD처
	LDD  R30,Y+53
	CALL SUBOPT_0x11
; 0000 0121 
; 0000 0122             case NONE: //기본 상태
	BRNE _0xF0
; 0000 0123                 if (fnd[1] <=3 && fnd[1] >0 && fnd[0] == 10) {
	LDD  R26,Y+58
	LDD  R27,Y+58+1
	SBIW R26,4
	BRGE _0xF2
	LDD  R26,Y+58
	LDD  R27,Y+58+1
	CALL __CPW02
	BRGE _0xF2
	LDD  R26,Y+56
	LDD  R27,Y+56+1
	SBIW R26,10
	BREQ _0xF3
_0xF2:
	RJMP _0xF1
_0xF3:
; 0000 0124                     user_name = fnd[1]-1;
	LDD  R30,Y+58
	LDD  R31,Y+58+1
	SBIW R30,1
	STD  Y+3,R30
; 0000 0125                     STATE=INPUT_PHONE_INIT ;
	LDI  R30,LOW(3)
	STD  Y+53,R30
; 0000 0126                 }
; 0000 0127                 if (fnd[1]==4 && fnd[0] == 10) { //탈출 모드
_0xF1:
	LDD  R26,Y+58
	LDD  R27,Y+58+1
	SBIW R26,4
	BRNE _0xF5
	LDD  R26,Y+56
	LDD  R27,Y+56+1
	SBIW R26,10
	BREQ _0xF6
_0xF5:
	RJMP _0xF4
_0xF6:
; 0000 0128                     LCD_Clear();
	CALL SUBOPT_0x1E
; 0000 0129                     LCD_Pos(0,0);
	RCALL _LCD_Pos
; 0000 012A                     LCD_Str("Choose Seat");
	__POINTW1MN _0xF7,0
	CALL SUBOPT_0x1F
; 0000 012B                     LCD_Pos(1,0);
	CALL SUBOPT_0x20
; 0000 012C                     if (user_state[0] == 'O') LCD_Str("1  ");
	LDD  R26,Y+50
	CPI  R26,LOW(0x4F)
	BRNE _0xF8
	__POINTW1MN _0xF7,12
	CALL SUBOPT_0x1F
; 0000 012D                     if (user_state[1] == 'O') LCD_Str("2  ");
_0xF8:
	LDD  R26,Y+51
	CPI  R26,LOW(0x4F)
	BRNE _0xF9
	__POINTW1MN _0xF7,16
	CALL SUBOPT_0x1F
; 0000 012E                     if (user_state[2] == 'O') LCD_Str("3  ");
_0xF9:
	LDD  R26,Y+52
	CPI  R26,LOW(0x4F)
	BRNE _0xFA
	__POINTW1MN _0xF7,20
	CALL SUBOPT_0x1F
; 0000 012F                     STATE=EXIT_CHOOSE ;
_0xFA:
	LDI  R30,LOW(6)
	STD  Y+53,R30
; 0000 0130                 }
; 0000 0131                 break;
_0xF4:
	RJMP _0xEF
; 0000 0132 
; 0000 0133             case START: //업로드
_0xF0:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xFB
; 0000 0134                 LCD_Pos(0,0);
	CALL SUBOPT_0x16
	RCALL _LCD_Pos
; 0000 0135                 LCD_Str("StudyRoom  4:OUT");
	__POINTW1MN _0xF7,24
	CALL SUBOPT_0x1F
; 0000 0136                 sprintf(Message, "1:%c 2:%c 3:%c", user_state[0],user_state[1],user_state[2]);
	MOVW R30,R28
	SUBI R30,LOW(-(84))
	SBCI R31,HIGH(-(84))
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,114
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+54
	CALL SUBOPT_0x21
	LDD  R30,Y+59
	CALL SUBOPT_0x21
	__GETB1SX 64
	CALL SUBOPT_0x21
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
; 0000 0137                 LCD_Pos(1,0);
	CALL SUBOPT_0x20
; 0000 0138                 LCD_Str(Message);
	MOVW R30,R28
	SUBI R30,LOW(-(84))
	SBCI R31,HIGH(-(84))
	CALL SUBOPT_0x1F
; 0000 0139                 STATE = NONE;
	LDI  R30,LOW(0)
	RJMP _0x12C
; 0000 013A                 break;
; 0000 013B 
; 0000 013C             case INPUT_PHONE: //입장 : 폰번호 입력
_0xFB:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xFC
; 0000 013D 
; 0000 013E                 if (fnd[0] == 10){
	LDD  R26,Y+56
	LDD  R27,Y+56+1
	SBIW R26,10
	BRNE _0xFD
; 0000 013F                     sprintf(user_pnumber[user_name], "%d%d%d%d%d%d%d%d%d%d%d", fnd[11],fnd[10],fnd[9],fnd[8],fnd[7],fnd[6],fnd[5],fnd[4],fnd[3],fnd[2],fnd[1]);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
	CALL SUBOPT_0x24
; 0000 0140                     user_state[user_name] ='X';
	CALL SUBOPT_0x25
	LDI  R30,LOW(88)
	ST   X,R30
; 0000 0141                     for(i=0;i<11;i++){
	LDI  R30,LOW(0)
	STD  Y+48,R30
	STD  Y+48+1,R30
_0xFF:
	LDD  R26,Y+48
	LDD  R27,Y+48+1
	SBIW R26,11
	BRGE _0x100
; 0000 0142                         num[user_name][i] = user_pnumber[user_name][i];
	CALL SUBOPT_0x22
	SUBI R30,LOW(-_num)
	SBCI R31,HIGH(-_num)
	LDD  R26,Y+48
	LDD  R27,Y+48+1
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	MOVW R30,R0
	CALL SUBOPT_0x23
	LDD  R26,Y+48
	LDD  R27,Y+48+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	MOVW R26,R22
	ST   X,R30
; 0000 0143                     }
	LDD  R30,Y+48
	LDD  R31,Y+48+1
	ADIW R30,1
	STD  Y+48,R30
	STD  Y+48+1,R31
	RJMP _0xFF
_0x100:
; 0000 0144                     STATE = CHECK_PNUM_INIT;
	LDI  R30,LOW(5)
	STD  Y+53,R30
; 0000 0145                 }
; 0000 0146                 delay_ms(10);
_0xFD:
	CALL SUBOPT_0x14
; 0000 0147                 break;
	RJMP _0xEF
; 0000 0148 
; 0000 0149             case INPUT_PHONE_INIT:
_0xFC:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x101
; 0000 014A                 fnd[0]=0;
	CALL SUBOPT_0x26
; 0000 014B                 LCD_Clear();
; 0000 014C                 LCD_Pos(0,0);
	RCALL _LCD_Pos
; 0000 014D                 LCD_Str("Input PhoneNum") ;
	__POINTW1MN _0xF7,41
	CALL SUBOPT_0x1F
; 0000 014E                 STATE = INPUT_PHONE;
	LDI  R30,LOW(2)
	STD  Y+53,R30
; 0000 014F 
; 0000 0150                 if (user_state[user_name] == 'O'){
	CALL SUBOPT_0x25
	LD   R26,X
	CPI  R26,LOW(0x4F)
	BRNE _0x102
; 0000 0151                     LCD_Clear();
	CALL SUBOPT_0x1E
; 0000 0152                     LCD_Pos(0,0);
	RCALL _LCD_Pos
; 0000 0153                     LCD_Str("Someone Used");
	__POINTW1MN _0xF7,56
	CALL SUBOPT_0x1F
; 0000 0154                     delay_ms(1000);
	CALL SUBOPT_0x15
; 0000 0155                     STATE = START;
	LDI  R30,LOW(1)
	STD  Y+53,R30
; 0000 0156                 }
; 0000 0157 
; 0000 0158                 break;
_0x102:
	RJMP _0xEF
; 0000 0159             case CHECK_PNUM:
_0x101:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x103
; 0000 015A 
; 0000 015B                 if (fnd[1] == 1 && fnd[0] == 10){
	LDD  R26,Y+58
	LDD  R27,Y+58+1
	SBIW R26,1
	BRNE _0x105
	LDD  R26,Y+56
	LDD  R27,Y+56+1
	SBIW R26,10
	BREQ _0x106
_0x105:
	RJMP _0x104
_0x106:
; 0000 015C                     user_state[user_name] = 'O';
	CALL SUBOPT_0x25
	LDI  R30,LOW(79)
	ST   X,R30
; 0000 015D                     OCR1A = 3000;
	LDI  R30,LOW(3000)
	LDI  R31,HIGH(3000)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 015E                     LCD_Clear();
	CALL SUBOPT_0x1E
; 0000 015F                     LCD_Pos(0,0);
	RCALL _LCD_Pos
; 0000 0160                     LCD_Str("Door Open") ;
	__POINTW1MN _0xF7,69
	CALL SUBOPT_0x1F
; 0000 0161                     delay_ms(5000);
	LDI  R30,LOW(5000)
	LDI  R31,HIGH(5000)
	CALL SUBOPT_0x2
; 0000 0162                     OCR1A = 4710;
	CALL SUBOPT_0x9
; 0000 0163                     STATE = START;
	LDI  R30,LOW(1)
	STD  Y+53,R30
; 0000 0164                     fnd[0]=0;
	LDI  R30,LOW(0)
	STD  Y+56,R30
	STD  Y+56+1,R30
; 0000 0165                     user_name = 4;
	LDI  R30,LOW(4)
	STD  Y+3,R30
; 0000 0166                 }
; 0000 0167                 else if (fnd[1] == 2 && fnd[0] == 10) STATE = INPUT_PHONE_INIT;
	RJMP _0x107
_0x104:
	LDD  R26,Y+58
	LDD  R27,Y+58+1
	SBIW R26,2
	BRNE _0x109
	LDD  R26,Y+56
	LDD  R27,Y+56+1
	SBIW R26,10
	BREQ _0x10A
_0x109:
	RJMP _0x108
_0x10A:
	LDI  R30,LOW(3)
	STD  Y+53,R30
; 0000 0168             break;
_0x108:
_0x107:
	RJMP _0xEF
; 0000 0169             case CHECK_PNUM_INIT:
_0x103:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x10B
; 0000 016A                 fnd[0]=0;
	CALL SUBOPT_0x26
; 0000 016B                 LCD_Clear();
; 0000 016C                 LCD_Pos(0,0);
	RCALL _LCD_Pos
; 0000 016D                 LCD_Str(user_pnumber[user_name]);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
	CALL SUBOPT_0x1F
; 0000 016E                 LCD_Pos(1,0);
	CALL SUBOPT_0x20
; 0000 016F                 LCD_Str("1:Yes  2:No");
	__POINTW1MN _0xF7,79
	CALL SUBOPT_0x1F
; 0000 0170                 fnd[1] = 0;
	LDI  R30,LOW(0)
	STD  Y+58,R30
	STD  Y+58+1,R30
; 0000 0171                 STATE = CHECK_PNUM;
	LDI  R30,LOW(4)
	RJMP _0x12C
; 0000 0172             break;
; 0000 0173 
; 0000 0174             case EXIT_CHOOSE:  //퇴장 번호 선
_0x10B:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x10C
; 0000 0175 
; 0000 0176                 user_name = fnd[1]-1;
	LDD  R30,Y+58
	LDD  R31,Y+58+1
	SBIW R30,1
	STD  Y+3,R30
; 0000 0177                 if (fnd[1] <=3 && fnd[1] >0 && fnd[0] == 10){
	LDD  R26,Y+58
	LDD  R27,Y+58+1
	SBIW R26,4
	BRGE _0x10E
	LDD  R26,Y+58
	LDD  R27,Y+58+1
	CALL __CPW02
	BRGE _0x10E
	LDD  R26,Y+56
	LDD  R27,Y+56+1
	SBIW R26,10
	BREQ _0x10F
_0x10E:
	RJMP _0x10D
_0x10F:
; 0000 0178 
; 0000 0179                     STATE = INPUT_PHONE_OUT_INIT;
	LDI  R30,LOW(10)
	STD  Y+53,R30
; 0000 017A 
; 0000 017B                     if (user_state[user_name] != 'O'){
	CALL SUBOPT_0x25
	LD   R26,X
	CPI  R26,LOW(0x4F)
	BREQ _0x110
; 0000 017C                         LCD_Clear();
	CALL SUBOPT_0x1E
; 0000 017D                         LCD_Pos(0,0);
	RCALL _LCD_Pos
; 0000 017E                         LCD_Str("Empty Seat");
	__POINTW1MN _0xF7,91
	CALL SUBOPT_0x1F
; 0000 017F                         delay_ms(1000);
	CALL SUBOPT_0x15
; 0000 0180                         fnd[0]=0;
	LDI  R30,LOW(0)
	STD  Y+56,R30
	STD  Y+56+1,R30
; 0000 0181                         STATE = START;
	LDI  R30,LOW(1)
	STD  Y+53,R30
; 0000 0182                     }
; 0000 0183                 }
_0x110:
; 0000 0184 
; 0000 0185 
; 0000 0186 
; 0000 0187             break;
_0x10D:
	RJMP _0xEF
; 0000 0188              case CHECK_PNUM_OUT_INIT:
_0x10C:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x111
; 0000 0189                  fnd[0]=0;
	CALL SUBOPT_0x1D
; 0000 018A                  fnd[1] = 0;
; 0000 018B                  LCD_Clear();
	CALL SUBOPT_0x1E
; 0000 018C                  LCD_Pos(0,0);
	RCALL _LCD_Pos
; 0000 018D                  LCD_Str(check_pnumber);
	MOVW R30,R28
	ADIW R30,4
	CALL SUBOPT_0x1F
; 0000 018E                  LCD_Pos(1,0);
	CALL SUBOPT_0x20
; 0000 018F 
; 0000 0190                  LCD_Str("1:Yes  2:No");
	__POINTW1MN _0xF7,102
	CALL SUBOPT_0x1F
; 0000 0191                  STATE = CHECK_PNUM_OUT;
	LDI  R30,LOW(7)
	RJMP _0x12C
; 0000 0192 
; 0000 0193 
; 0000 0194             break;
; 0000 0195             case CHECK_PNUM_OUT:   //비밀번호 일치시 탈출
_0x111:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x112
; 0000 0196 
; 0000 0197                  if (fnd[1] == 1 && fnd[0] == 10){
	LDD  R26,Y+58
	LDD  R27,Y+58+1
	SBIW R26,1
	BRNE _0x114
	LDD  R26,Y+56
	LDD  R27,Y+56+1
	SBIW R26,10
	BREQ _0x115
_0x114:
	RJMP _0x113
_0x115:
; 0000 0198                    int cnt=0;
; 0000 0199                    for(i=0;i<11;i++){
	SBIW R28,2
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
;	Sonar_range -> Y+126
;	Message -> Y+86
;	count -> Y+84
;	finalnum -> Y+82
;	fnd -> Y+58
;	angle -> Y+56
;	STATE -> Y+55
;	user_state -> Y+52
;	i -> Y+50
;	user_pnumber -> Y+17
;	check_pnumber -> Y+6
;	user_name -> Y+5
;	empty_cnt -> Y+2
;	cnt -> Y+0
	STD  Y+50,R30
	STD  Y+50+1,R30
_0x117:
	LDD  R26,Y+50
	LDD  R27,Y+50+1
	SBIW R26,11
	BRGE _0x118
; 0000 019A                       if(num[user_name][i] == check_pnumber[i] ) cnt ++;  }
	LDD  R30,Y+5
	LDI  R26,LOW(11)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(-_num)
	SBCI R31,HIGH(-_num)
	LDD  R26,Y+50
	LDD  R27,Y+50+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R0,X
	LDD  R30,Y+50
	LDD  R31,Y+50+1
	MOVW R26,R28
	ADIW R26,6
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	CP   R30,R0
	BRNE _0x119
	CALL SUBOPT_0x4
_0x119:
	LDD  R30,Y+50
	LDD  R31,Y+50+1
	ADIW R30,1
	STD  Y+50,R30
	STD  Y+50+1,R31
	RJMP _0x117
_0x118:
; 0000 019B 
; 0000 019C                     if (cnt == 11 ){  //비밀번호 일치
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,11
	BRNE _0x11A
; 0000 019D                        LCD_Clear();
	CALL SUBOPT_0x1E
; 0000 019E                        LCD_Pos(0,0);
	RCALL _LCD_Pos
; 0000 019F                        LCD_Str("User Check") ;
	__POINTW1MN _0xF7,114
	CALL SUBOPT_0x1F
; 0000 01A0                        LCD_Pos(1,0);
	CALL SUBOPT_0x20
; 0000 01A1                        LCD_Str("Good Bye") ;
	__POINTW1MN _0xF7,125
	CALL SUBOPT_0x1F
; 0000 01A2                        OCR1A = 3000;
	LDI  R30,LOW(3000)
	LDI  R31,HIGH(3000)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 01A3                         delay_ms(5000);
	LDI  R30,LOW(5000)
	LDI  R31,HIGH(5000)
	CALL SUBOPT_0x2
; 0000 01A4                         OCR1A = 4710;
	CALL SUBOPT_0x9
; 0000 01A5                       user_state[user_name] ='X';
	LDD  R30,Y+5
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,52
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(88)
	ST   X,R30
; 0000 01A6                       STATE = START;
	LDI  R30,LOW(1)
	STD  Y+55,R30
; 0000 01A7                       fnd[0] = 0;
	LDI  R30,LOW(0)
	STD  Y+58,R30
	STD  Y+58+1,R30
; 0000 01A8                     }
; 0000 01A9                     else{ //비밀번호 불일치
	RJMP _0x11B
_0x11A:
; 0000 01AA                       LCD_Clear();
	CALL SUBOPT_0x1E
; 0000 01AB                       LCD_Pos(0,0);
	RCALL _LCD_Pos
; 0000 01AC                       LCD_Str("Wrong Password") ;
	__POINTW1MN _0xF7,134
	CALL SUBOPT_0x1F
; 0000 01AD                       delay_ms(2000);
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	CALL SUBOPT_0x2
; 0000 01AE                       fnd[0] = 0;
	LDI  R30,LOW(0)
	STD  Y+58,R30
	STD  Y+58+1,R30
; 0000 01AF                       STATE = START;
	LDI  R30,LOW(1)
	STD  Y+55,R30
; 0000 01B0                     }
_0x11B:
; 0000 01B1                 }
	ADIW R28,2
; 0000 01B2                 else if (fnd[1] == 2 && fnd[0] == 10) STATE = INPUT_PHONE_OUT_INIT;
	RJMP _0x11C
_0x113:
	LDD  R26,Y+58
	LDD  R27,Y+58+1
	SBIW R26,2
	BRNE _0x11E
	LDD  R26,Y+56
	LDD  R27,Y+56+1
	SBIW R26,10
	BREQ _0x11F
_0x11E:
	RJMP _0x11D
_0x11F:
	LDI  R30,LOW(10)
	STD  Y+53,R30
; 0000 01B3 
; 0000 01B4 
; 0000 01B5             break;
_0x11D:
_0x11C:
	RJMP _0xEF
; 0000 01B6             case INPUT_PHONE_OUT: //퇴장 : 폰번호 입력
_0x112:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x120
; 0000 01B7 
; 0000 01B8                 if (fnd[0] == 10){
	LDD  R26,Y+56
	LDD  R27,Y+56+1
	SBIW R26,10
	BRNE _0x121
; 0000 01B9                     sprintf(check_pnumber, "%d%d%d%d%d%d%d%d%d%d%d", fnd[11],fnd[10],fnd[9],fnd[8],fnd[7],fnd[6],fnd[5],fnd[4],fnd[3],fnd[2],fnd[1]);
	MOVW R30,R28
	ADIW R30,4
	CALL SUBOPT_0x24
; 0000 01BA 
; 0000 01BB                     STATE = CHECK_PNUM_OUT_INIT;
	LDI  R30,LOW(8)
	STD  Y+53,R30
; 0000 01BC                 }
; 0000 01BD                 delay_ms(10);
_0x121:
	CALL SUBOPT_0x14
; 0000 01BE                 break;
	RJMP _0xEF
; 0000 01BF 
; 0000 01C0              case INPUT_PHONE_OUT_INIT: //퇴장 : 폰번호 입력
_0x120:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0xEF
; 0000 01C1 
; 0000 01C2 
; 0000 01C3                 fnd[0]=0;
	CALL SUBOPT_0x26
; 0000 01C4                 LCD_Clear();
; 0000 01C5                 LCD_Pos(0,0);
	RCALL _LCD_Pos
; 0000 01C6                 LCD_Str("Input PhoneNum") ;
	__POINTW1MN _0xF7,149
	CALL SUBOPT_0x1F
; 0000 01C7                 STATE = INPUT_PHONE_OUT;
	LDI  R30,LOW(9)
_0x12C:
	STD  Y+53,R30
; 0000 01C8                 break;
; 0000 01C9 
; 0000 01CA 
; 0000 01CB         }
_0xEF:
; 0000 01CC 
; 0000 01CD     }
	RJMP _0xD1
; 0000 01CE }
_0x123:
	RJMP _0x123

	.DSEG
_0xF7:
	.BYTE 0xA4
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
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2000010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2000012
	__CPWRN 16,17,2
	BRLO _0x2000013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2000012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2000014
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2000014:
_0x2000013:
	RJMP _0x2000015
_0x2000010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2000015:
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x2060002:
	ADIW R28,5
	RET
__print_G100:
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001C
	CPI  R18,37
	BRNE _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	CALL SUBOPT_0x27
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	CALL SUBOPT_0x27
	RJMP _0x20000C9
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
	BREQ PC+3
	JMP _0x200001B
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
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x200002F
	CALL SUBOPT_0x28
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x29
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	CALL SUBOPT_0x28
	CALL SUBOPT_0x2A
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	CALL SUBOPT_0x28
	CALL SUBOPT_0x2A
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x64)
	BREQ _0x2000039
	CPI  R30,LOW(0x69)
	BRNE _0x200003A
_0x2000039:
	ORI  R16,LOW(4)
	RJMP _0x200003B
_0x200003A:
	CPI  R30,LOW(0x75)
	BRNE _0x200003C
_0x200003B:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x200003D
_0x200003C:
	CPI  R30,LOW(0x58)
	BRNE _0x200003F
	ORI  R16,LOW(8)
	RJMP _0x2000040
_0x200003F:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x2000071
_0x2000040:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	CALL SUBOPT_0x28
	CALL SUBOPT_0x2B
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2000043:
	CPI  R20,0
	BREQ _0x2000044
	SUBI R17,-LOW(1)
	RJMP _0x2000045
_0x2000044:
	ANDI R16,LOW(251)
_0x2000045:
	RJMP _0x2000046
_0x2000042:
	CALL SUBOPT_0x28
	CALL SUBOPT_0x2B
_0x2000046:
_0x2000036:
	SBRC R16,0
	RJMP _0x2000047
_0x2000048:
	CP   R17,R21
	BRSH _0x200004A
	SBRS R16,7
	RJMP _0x200004B
	SBRS R16,2
	RJMP _0x200004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x200004D
_0x200004C:
	LDI  R18,LOW(48)
_0x200004D:
	RJMP _0x200004E
_0x200004B:
	LDI  R18,LOW(32)
_0x200004E:
	CALL SUBOPT_0x27
	SUBI R21,LOW(1)
	RJMP _0x2000048
_0x200004A:
_0x2000047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x200004F
_0x2000050:
	CPI  R19,0
	BREQ _0x2000052
	SBRS R16,3
	RJMP _0x2000053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2000054
_0x2000053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000054:
	CALL SUBOPT_0x27
	CPI  R21,0
	BREQ _0x2000055
	SUBI R21,LOW(1)
_0x2000055:
	SUBI R19,LOW(1)
	RJMP _0x2000050
_0x2000052:
	RJMP _0x2000056
_0x200004F:
_0x2000058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x200005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x200005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x200005A
_0x200005C:
	CPI  R18,58
	BRLO _0x200005D
	SBRS R16,3
	RJMP _0x200005E
	SUBI R18,-LOW(7)
	RJMP _0x200005F
_0x200005E:
	SUBI R18,-LOW(39)
_0x200005F:
_0x200005D:
	SBRC R16,4
	RJMP _0x2000061
	CPI  R18,49
	BRSH _0x2000063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2000062
_0x2000063:
	RJMP _0x20000CA
_0x2000062:
	CP   R21,R19
	BRLO _0x2000067
	SBRS R16,0
	RJMP _0x2000068
_0x2000067:
	RJMP _0x2000066
_0x2000068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2000069
	LDI  R18,LOW(48)
_0x20000CA:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x29
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	CALL SUBOPT_0x27
	CPI  R21,0
	BREQ _0x200006C
	SUBI R21,LOW(1)
_0x200006C:
_0x2000066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2000059
	RJMP _0x2000058
_0x2000059:
_0x2000056:
	SBRS R16,0
	RJMP _0x200006D
_0x200006E:
	CPI  R21,0
	BREQ _0x2000070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x29
	RJMP _0x200006E
_0x2000070:
_0x200006D:
_0x2000071:
_0x2000030:
_0x20000C9:
	LDI  R17,LOW(0)
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x2C
	SBIW R30,0
	BRNE _0x2000072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2060001
_0x2000072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x2C
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,10
	ST   -Y,R31
	ST   -Y,R30
	RCALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2060001:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET

	.CSEG

	.CSEG
_strlen:
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
_strlenf:
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

	.DSEG
_Port_char:
	.BYTE 0x10
_Port_fnd:
	.BYTE 0x8
_str:
	.BYTE 0x11
_str2:
	.BYTE 0x11
_master_password:
	.BYTE 0x8
_num:
	.BYTE 0x21

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	STS  101,R30
	LDS  R30,101
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1:
	ORI  R30,1
	STS  101,R30
	__DELAY_USB 246
	LD   R30,Y
	OUT  0x1B,R30
	__DELAY_USB 246
	LDS  R30,101
	ANDI R30,0xFE
	STS  101,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0x2:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(56)
	ST   -Y,R30
	CALL _LCD_Comm
	LDI  R30,LOW(4)
	ST   -Y,R30
	JMP  _LCD_delay

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	ST   -Y,R30
	CALL _LCD_Comm
	LDI  R30,LOW(4)
	ST   -Y,R30
	JMP  _LCD_delay

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LD   R30,Y
	STS  115,R30
	LDI  R30,LOW(132)
	STS  116,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x8:
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(4710)
	LDI  R31,HIGH(4710)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	STS  101,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ST   -Y,R31
	ST   -Y,R30
	JMP  _myDelay_us

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xB:
	LDD  R26,Y+1
	CLR  R27
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __MODW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0xC:
	LDD  R26,Y+1
	LDI  R27,0
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	CALL __LSLW2
	MOVW R22,R30
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xE:
	SUBI R30,LOW(-_Port_char)
	SBCI R31,HIGH(-_Port_char)
	LD   R30,Z
	STS  98,R30
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF:
	LDI  R31,0
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x10:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _Buzzer_play

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	LDI  R31,0
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	LD   R30,X
	ST   -Y,R30
	JMP  _putch_USART1

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	ST   -Y,R31
	ST   -Y,R30
	CALL _puts_USART1
	LDI  R17,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x16:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	ST   -Y,R16
	CALL _startRanging
	MOVW R30,R28
	SUBI R30,LOW(-(124))
	SBCI R31,HIGH(-(124))
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	LDD  R30,Y+48
	LDD  R31,Y+48+1
	MOVW R26,R28
	ADIW R26,50
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1A:
	LDD  R30,Y+48
	LDD  R31,Y+48+1
	MOVW R26,R28
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1B:
	MOVW R26,R28
	SUBI R26,LOW(-(82))
	SBCI R27,HIGH(-(82))
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	LDI  R30,LOW(0)
	STD  Y+56,R30
	STD  Y+56+1,R30
	STD  Y+58,R30
	STD  Y+58+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x1E:
	CALL _LCD_Clear
	RJMP SUBOPT_0x16

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0x1F:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _LCD_Str

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x20:
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _LCD_Pos

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x21:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	LDD  R30,Y+3
	LDI  R26,LOW(11)
	MUL  R30,R26
	MOVW R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	MOVW R26,R28
	ADIW R26,15
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:115 WORDS
SUBOPT_0x24:
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,129
	ST   -Y,R31
	ST   -Y,R30
	__GETW1SX 82
	CALL __CWD1
	CALL __PUTPARD1
	__GETW1SX 84
	CALL __CWD1
	CALL __PUTPARD1
	__GETW1SX 86
	CALL __CWD1
	CALL __PUTPARD1
	__GETW1SX 88
	CALL __CWD1
	CALL __PUTPARD1
	__GETW1SX 90
	CALL __CWD1
	CALL __PUTPARD1
	__GETW1SX 92
	CALL __CWD1
	CALL __PUTPARD1
	__GETW1SX 94
	CALL __CWD1
	CALL __PUTPARD1
	__GETW1SX 96
	CALL __CWD1
	CALL __PUTPARD1
	__GETW1SX 98
	CALL __CWD1
	CALL __PUTPARD1
	__GETW1SX 100
	CALL __CWD1
	CALL __PUTPARD1
	__GETW1SX 102
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,44
	CALL _sprintf
	ADIW R28,48
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x25:
	LDD  R30,Y+3
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,50
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x26:
	LDI  R30,LOW(0)
	STD  Y+56,R30
	STD  Y+56+1,R30
	RJMP SUBOPT_0x1E

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x27:
	ST   -Y,R18
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x28:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x29:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2A:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2B:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2C:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xE66
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
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

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
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

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
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

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

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
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
