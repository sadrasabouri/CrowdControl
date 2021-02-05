
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

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
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

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

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
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
	.DEF _second=R4
	.DEF _second_msb=R5
	.DEF _minute=R6
	.DEF _minute_msb=R7
	.DEF _hour=R8
	.DEF _hour_msb=R9
	.DEF _totalcount1_5=R10
	.DEF _totalcount1_5_msb=R11
	.DEF _nobat1_5=R12
	.DEF _nobat1_5_msb=R13

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
	JMP  _timer1_ovf_isr
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

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x1E,0x0,0x7,0x0

_0x0:
	.DB  0x20,0x20,0x20,0x25,0x30,0x32,0x64,0x3A
	.DB  0x25,0x30,0x32,0x64,0x3A,0x25,0x30,0x32
	.DB  0x64,0x20,0x20,0x50,0x4D,0x0,0x20,0x20
	.DB  0x20,0x25,0x30,0x32,0x64,0x3A,0x25,0x30
	.DB  0x32,0x64,0x3A,0x25,0x30,0x32,0x64,0x20
	.DB  0x20,0x41,0x4D,0x0,0x20,0x20,0x20,0x43
	.DB  0x6C,0x69,0x65,0x6E,0x74,0x20,0x23,0x25
	.DB  0x30,0x33,0x64,0x20,0x20,0x20,0x0,0x47
	.DB  0x6F,0x20,0x54,0x6F,0x20,0x43,0x6F,0x75
	.DB  0x6E,0x74,0x65,0x72,0x23,0x25,0x30,0x32
	.DB  0x64,0x21,0x0,0x20,0x25,0x33,0x64,0x20
	.DB  0x43,0x6C,0x69,0x65,0x6E,0x74,0x28,0x73
	.DB  0x29,0x20,0x0,0x20,0x20,0x20,0x42,0x65
	.DB  0x66,0x6F,0x72,0x65,0x20,0x59,0x6F,0x75
	.DB  0x20,0x20,0x20,0x0
_0x2040060:
	.DB  0x1
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0
_0x2060003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  0x06
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  _0x42
	.DW  _0x0*2+21

	.DW  0x01
	.DW  _0x43
	.DW  _0x0*2+21

	.DW  0x01
	.DW  __seed_G102
	.DW  _0x2040060*2

	.DW  0x02
	.DW  __base_y_G103
	.DW  _0x2060003*2

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
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

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
	LDI  R26,__SRAM_START
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
	.ORG 0x260

	.CSEG
;#include <io.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <stdio.h>
;#include <string.h>
;#include <stdlib.h>
;#include <alcd.h>
;#include <mega32.h>
;
;int second;
;int minute = 30;
;int hour = 7;
;
;int totalcount1_5, nobat1_5;
;int totalcount6, nobat6;
;int totalcount7, nobat7;
;int TotalCount;
;
;int Counter1, Counter2, Counter3, Counter4, Counter5, Counter6, Counter7;
;int Show = 0;
;
;void time_after(int, int*, int*, int*);
;void LCD_Goto_Counter (int, int);
;char GetKey();
;
;int d1,d2,d3 ,d4,d5,d6 ,d7;
;int entezar;
;void LCD_Goto_Counter (int, int);
;void LCD_Show_entezar (int);
;
;int reset = 0;
;int saat_yekonim;
;int Show;
;char lcd_buffer[17];
;
;// Timer Interrupt
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0025 {

	.CSEG
_timer1_ovf_isr:
; .FSTART _timer1_ovf_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0026     // Reinitialize Timer1 value
; 0000 0027     TCNT1H = 0x85EE >> 8;
	LDI  R30,LOW(133)
	OUT  0x2D,R30
; 0000 0028     TCNT1L = 0x85EE & 0xff;
	LDI  R30,LOW(238)
	OUT  0x2C,R30
; 0000 0029 
; 0000 002A     if(second==59){
	LDI  R30,LOW(59)
	LDI  R31,HIGH(59)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x3
; 0000 002B         second=0;
	CLR  R4
	CLR  R5
; 0000 002C         if(minute==59){
	CP   R30,R6
	CPC  R31,R7
	BRNE _0x4
; 0000 002D             minute=0;
	CLR  R6
	CLR  R7
; 0000 002E             if(hour==23)
	LDI  R30,LOW(23)
	LDI  R31,HIGH(23)
	CP   R30,R8
	CPC  R31,R9
	BRNE _0x5
; 0000 002F                 hour=0;
	CLR  R8
	CLR  R9
; 0000 0030             else
	RJMP _0x6
_0x5:
; 0000 0031                 hour++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 0032         }
_0x6:
; 0000 0033         else
	RJMP _0x7
_0x4:
; 0000 0034             minute++;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 0035     }
_0x7:
; 0000 0036     else
	RJMP _0x8
_0x3:
; 0000 0037         second++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 0038 }
_0x8:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;
;// External Interrupt 0
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 003C {
_ext_int0_isr:
; .FSTART _ext_int0_isr
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
; 0000 003D char k;
; 0000 003E k = GetKey();
	ST   -Y,R17
;	k -> R17
	RCALL _GetKey
	MOV  R17,R30
; 0000 003F GICR |= (1 << INTF0);
	IN   R30,0x3B
	ORI  R30,0x40
	OUT  0x3B,R30
; 0000 0040 if(!reset){
	LDS  R30,_reset
	LDS  R31,_reset+1
	SBIW R30,0
	BREQ PC+2
	RJMP _0x9
; 0000 0041         if(k != 0xFF) // dokme feshorde shod
	CPI  R17,255
	BRNE PC+2
	RJMP _0xA
; 0000 0042       {
; 0000 0043         if (hour < 13 || (hour ==13 && minute<=30 )){
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	CP   R8,R30
	CPC  R9,R31
	BRLT _0xC
	CP   R30,R8
	CPC  R31,R9
	BRNE _0xD
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CP   R30,R6
	CPC  R31,R7
	BRGE _0xC
_0xD:
	RJMP _0xB
_0xC:
; 0000 0044             saat_yekonim = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _saat_yekonim,R30
	STS  _saat_yekonim+1,R31
; 0000 0045         }else{
	RJMP _0x10
_0xB:
; 0000 0046             saat_yekonim = 0 ;
	LDI  R30,LOW(0)
	STS  _saat_yekonim,R30
	STS  _saat_yekonim+1,R30
; 0000 0047         }
_0x10:
; 0000 0048       switch(k)
	MOV  R30,R17
	LDI  R31,0
; 0000 0049         {
; 0000 004A         case 1 :
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x14
; 0000 004B             if (saat_yekonim) {
	CALL SUBOPT_0x0
	BRNE PC+2
	RJMP _0x15
; 0000 004C                 TotalCount += 1;
	CALL SUBOPT_0x1
; 0000 004D                 totalcount1_5 += 1;
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
; 0000 004E                 if(Counter1 == 0){
	LDS  R30,_Counter1
	LDS  R31,_Counter1+1
	SBIW R30,0
	BRNE _0x16
; 0000 004F                     Counter1 = 1;
	CALL SUBOPT_0x2
; 0000 0050                     nobat1_5 += 1;
; 0000 0051                     Show = 1;
	CALL SUBOPT_0x3
; 0000 0052                     LCD_Goto_Counter(nobat1_5, 1);
	LDI  R26,LOW(1)
	LDI  R27,0
	RCALL _LCD_Goto_Counter
; 0000 0053                     Show = 0;
	RJMP _0x6A
; 0000 0054 
; 0000 0055                 }
; 0000 0056                 else if (Counter2 == 0){
_0x16:
	LDS  R30,_Counter2
	LDS  R31,_Counter2+1
	SBIW R30,0
	BRNE _0x18
; 0000 0057                     Counter2 = 1;
	CALL SUBOPT_0x4
; 0000 0058                     nobat1_5 += 1;
; 0000 0059                     Show = 1;
	CALL SUBOPT_0x3
; 0000 005A                     LCD_Goto_Counter(nobat1_5, 2);
	LDI  R26,LOW(2)
	LDI  R27,0
	RCALL _LCD_Goto_Counter
; 0000 005B                     Show = 0;
	RJMP _0x6A
; 0000 005C                 }
; 0000 005D                 else if (Counter3 == 0){
_0x18:
	LDS  R30,_Counter3
	LDS  R31,_Counter3+1
	SBIW R30,0
	BRNE _0x1A
; 0000 005E                     Counter3 = 1;
	CALL SUBOPT_0x5
; 0000 005F                     nobat1_5 += 1;
; 0000 0060                     Show = 1;
	CALL SUBOPT_0x3
; 0000 0061                     LCD_Goto_Counter(nobat1_5, 3);
	LDI  R26,LOW(3)
	LDI  R27,0
	RCALL _LCD_Goto_Counter
; 0000 0062                     Show = 0;
	RJMP _0x6A
; 0000 0063                 }
; 0000 0064                 else if (Counter4 == 0){
_0x1A:
	LDS  R30,_Counter4
	LDS  R31,_Counter4+1
	SBIW R30,0
	BRNE _0x1C
; 0000 0065                     Counter4 = 1;
	CALL SUBOPT_0x6
; 0000 0066                     nobat1_5 += 1;
; 0000 0067                     Show = 1;
	CALL SUBOPT_0x3
; 0000 0068                     LCD_Goto_Counter(nobat1_5, 4) ;
	LDI  R26,LOW(4)
	LDI  R27,0
	RCALL _LCD_Goto_Counter
; 0000 0069                     Show = 0;
	RJMP _0x6A
; 0000 006A                 }
; 0000 006B                 else if (Counter5 == 0){
_0x1C:
	LDS  R30,_Counter5
	LDS  R31,_Counter5+1
	SBIW R30,0
	BRNE _0x1E
; 0000 006C                     Counter5 = 1;
	CALL SUBOPT_0x7
; 0000 006D                     nobat1_5 += 1;
; 0000 006E                     Show = 1;
	CALL SUBOPT_0x3
; 0000 006F                     LCD_Goto_Counter(nobat1_5, 5);
	LDI  R26,LOW(5)
	LDI  R27,0
	RCALL _LCD_Goto_Counter
; 0000 0070                     Show = 0;
	RJMP _0x6A
; 0000 0071                 }
; 0000 0072                 else {
_0x1E:
; 0000 0073                     Show = 1;
	CALL SUBOPT_0x8
; 0000 0074                     entezar = totalcount1_5 - nobat1_5;
	MOVW R30,R10
	SUB  R30,R12
	SBC  R31,R13
	STS  _entezar,R30
	STS  _entezar+1,R31
; 0000 0075                     LCD_Show_entezar(entezar);
	LDS  R26,_entezar
	LDS  R27,_entezar+1
	RCALL _LCD_Show_entezar
; 0000 0076                     Show = 0;
_0x6A:
	LDI  R30,LOW(0)
	CALL SUBOPT_0x9
; 0000 0077                 }
; 0000 0078             }
; 0000 0079             break;
_0x15:
	RJMP _0x13
; 0000 007A         case 2 :
_0x14:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x20
; 0000 007B             if(saat_yekonim){
	CALL SUBOPT_0x0
	BREQ _0x21
; 0000 007C                 TotalCount += 1;
	CALL SUBOPT_0x1
; 0000 007D                 totalcount6 += 1;
	LDS  R30,_totalcount6
	LDS  R31,_totalcount6+1
	ADIW R30,1
	STS  _totalcount6,R30
	STS  _totalcount6+1,R31
; 0000 007E                 if(Counter6 == 0){
	LDS  R30,_Counter6
	LDS  R31,_Counter6+1
	SBIW R30,0
	BRNE _0x22
; 0000 007F                     Counter6 = 1;
	CALL SUBOPT_0xA
; 0000 0080                     nobat6 += 1;
; 0000 0081                     Show = 1;
	CALL SUBOPT_0x8
; 0000 0082                     LCD_Goto_Counter(nobat6, 6);
	CALL SUBOPT_0xB
	CALL SUBOPT_0xC
; 0000 0083                     Show = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x9
; 0000 0084                 }
; 0000 0085                 else {
	RJMP _0x23
_0x22:
; 0000 0086                     int entezar6 = totalcount6 - nobat6;
; 0000 0087                     LCD_Show_entezar(entezar6);
	SBIW R28,2
;	entezar6 -> Y+0
	LDS  R26,_nobat6
	LDS  R27,_nobat6+1
	LDS  R30,_totalcount6
	LDS  R31,_totalcount6+1
	CALL SUBOPT_0xD
; 0000 0088                 }
_0x23:
; 0000 0089             }
; 0000 008A             break;
_0x21:
	RJMP _0x13
; 0000 008B         case 3 :
_0x20:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x24
; 0000 008C             if(saat_yekonim){
	CALL SUBOPT_0x0
	BREQ _0x25
; 0000 008D                 TotalCount += 1;
	CALL SUBOPT_0x1
; 0000 008E                 totalcount7 += 1;
	LDS  R30,_totalcount7
	LDS  R31,_totalcount7+1
	ADIW R30,1
	STS  _totalcount7,R30
	STS  _totalcount7+1,R31
; 0000 008F                 if(Counter7 == 0){
	LDS  R30,_Counter7
	LDS  R31,_Counter7+1
	SBIW R30,0
	BRNE _0x26
; 0000 0090                     Counter7 = 1;
	CALL SUBOPT_0xE
; 0000 0091                     nobat7 += 1;
; 0000 0092                     Show = 1;
	CALL SUBOPT_0x8
; 0000 0093                     LCD_Goto_Counter(nobat7, 7) ;
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
; 0000 0094                     Show = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x9
; 0000 0095                 }
; 0000 0096                 else {
	RJMP _0x27
_0x26:
; 0000 0097 
; 0000 0098                     int entezar7 = totalcount7 - nobat7;
; 0000 0099                     LCD_Show_entezar(entezar7);
	SBIW R28,2
;	entezar7 -> Y+0
	LDS  R26,_nobat7
	LDS  R27,_nobat7+1
	LDS  R30,_totalcount7
	LDS  R31,_totalcount7+1
	CALL SUBOPT_0xD
; 0000 009A                 }
_0x27:
; 0000 009B             }
; 0000 009C             break;
_0x25:
	RJMP _0x13
; 0000 009D         case 9 : //Counter1
_0x24:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x28
; 0000 009E             Counter1 = 0;
	CALL SUBOPT_0x11
; 0000 009F             if (totalcount1_5 > nobat1_5){
	__CPWRR 12,13,10,11
	BRGE _0x29
; 0000 00A0                 Show = 1;
	CALL SUBOPT_0x8
; 0000 00A1                 d1 = nobat1_5 + 1;
	MOVW R30,R12
	ADIW R30,1
	STS  _d1,R30
	STS  _d1+1,R31
; 0000 00A2                 LCD_Goto_Counter(d1, 1);
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1)
	LDI  R27,0
	RCALL _LCD_Goto_Counter
; 0000 00A3                 Counter1 = 1;
	CALL SUBOPT_0x2
; 0000 00A4                 nobat1_5 += 1;
; 0000 00A5                 Show = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x9
; 0000 00A6             }
; 0000 00A7             break;
_0x29:
	RJMP _0x13
; 0000 00A8         case 8 : //Counter2
_0x28:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x2A
; 0000 00A9             Counter2 = 0;
	CALL SUBOPT_0x12
; 0000 00AA             if (totalcount1_5 > nobat1_5){
	__CPWRR 12,13,10,11
	BRGE _0x2B
; 0000 00AB                 Show = 1;
	CALL SUBOPT_0x8
; 0000 00AC                 d2 = nobat1_5 + 1;
	MOVW R30,R12
	ADIW R30,1
	STS  _d2,R30
	STS  _d2+1,R31
; 0000 00AD                 LCD_Goto_Counter(d2, 2);
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(2)
	LDI  R27,0
	RCALL _LCD_Goto_Counter
; 0000 00AE                 Counter2 = 1;
	CALL SUBOPT_0x4
; 0000 00AF                 nobat1_5 += 1;
; 0000 00B0                 Show = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x9
; 0000 00B1             }
; 0000 00B2             break;
_0x2B:
	RJMP _0x13
; 0000 00B3         case 7 : //Counter3
_0x2A:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x2C
; 0000 00B4             Counter3 = 0;
	CALL SUBOPT_0x13
; 0000 00B5             if (totalcount1_5 > nobat1_5){
	__CPWRR 12,13,10,11
	BRGE _0x2D
; 0000 00B6                 Show = 1;
	CALL SUBOPT_0x8
; 0000 00B7                 d3 = nobat1_5 + 1;
	MOVW R30,R12
	ADIW R30,1
	STS  _d3,R30
	STS  _d3+1,R31
; 0000 00B8                 LCD_Goto_Counter(d3, 3);
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(3)
	LDI  R27,0
	RCALL _LCD_Goto_Counter
; 0000 00B9                 Counter3 = 1;
	CALL SUBOPT_0x5
; 0000 00BA                 nobat1_5 += 1;
; 0000 00BB                 Show = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x9
; 0000 00BC             }
; 0000 00BD             break;
_0x2D:
	RJMP _0x13
; 0000 00BE         case 6 : //Counter4
_0x2C:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x2E
; 0000 00BF             Counter4 = 0;
	CALL SUBOPT_0x14
; 0000 00C0             if (totalcount1_5 > nobat1_5){
	__CPWRR 12,13,10,11
	BRGE _0x2F
; 0000 00C1                 Show = 1;
	CALL SUBOPT_0x8
; 0000 00C2                 d4 = nobat1_5 + 1;
	MOVW R30,R12
	ADIW R30,1
	STS  _d4,R30
	STS  _d4+1,R31
; 0000 00C3                 LCD_Goto_Counter(d4, 4) ;
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(4)
	LDI  R27,0
	RCALL _LCD_Goto_Counter
; 0000 00C4                 Counter4 = 1;
	CALL SUBOPT_0x6
; 0000 00C5                 nobat1_5 += 1;
; 0000 00C6                 Show = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x9
; 0000 00C7             }
; 0000 00C8             break;
_0x2F:
	RJMP _0x13
; 0000 00C9         case 5 : //Counter5
_0x2E:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x30
; 0000 00CA             Counter5 = 0;
	CALL SUBOPT_0x15
; 0000 00CB             if (totalcount1_5 > nobat1_5){
	__CPWRR 12,13,10,11
	BRGE _0x31
; 0000 00CC                 Show = 1;
	CALL SUBOPT_0x8
; 0000 00CD                 d5 = nobat1_5 + 1;
	MOVW R30,R12
	ADIW R30,1
	STS  _d5,R30
	STS  _d5+1,R31
; 0000 00CE                 LCD_Goto_Counter(d5, 5);
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(5)
	LDI  R27,0
	RCALL _LCD_Goto_Counter
; 0000 00CF                 Counter5 = 1;
	CALL SUBOPT_0x7
; 0000 00D0                 nobat1_5 += 1;
; 0000 00D1                 Show = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x9
; 0000 00D2             }
; 0000 00D3             break;
_0x31:
	RJMP _0x13
; 0000 00D4         case 4 : //Counter6
_0x30:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x32
; 0000 00D5             Counter6 = 0;
	CALL SUBOPT_0x16
; 0000 00D6             if (totalcount6 > nobat6){
	CALL SUBOPT_0xB
	LDS  R26,_totalcount6
	LDS  R27,_totalcount6+1
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x33
; 0000 00D7                 Show = 1;
	CALL SUBOPT_0x8
; 0000 00D8                 d6 = nobat6 + 1;
	CALL SUBOPT_0xB
	ADIW R30,1
	STS  _d6,R30
	STS  _d6+1,R31
; 0000 00D9                 LCD_Goto_Counter(d6, 6);
	CALL SUBOPT_0xC
; 0000 00DA                 Counter6 = 1;
	CALL SUBOPT_0xA
; 0000 00DB                 nobat6 += 1;
; 0000 00DC                 Show = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x9
; 0000 00DD             }
; 0000 00DE             break;
_0x33:
	RJMP _0x13
; 0000 00DF         case 0 : //Counter7
_0x32:
	SBIW R30,0
	BRNE _0x13
; 0000 00E0             Counter7 = 0;
	CALL SUBOPT_0x17
; 0000 00E1             if (totalcount7 > nobat7){
	CALL SUBOPT_0xF
	LDS  R26,_totalcount7
	LDS  R27,_totalcount7+1
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x35
; 0000 00E2                 Show = 1;
	CALL SUBOPT_0x8
; 0000 00E3                 d7 = nobat7 + 1;
	CALL SUBOPT_0xF
	ADIW R30,1
	STS  _d7,R30
	STS  _d7+1,R31
; 0000 00E4                 LCD_Goto_Counter(d7, 7);
	CALL SUBOPT_0x10
; 0000 00E5                 Counter7 = 1;
	CALL SUBOPT_0xE
; 0000 00E6                 nobat7 += 1;
; 0000 00E7                 Show = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x9
; 0000 00E8             }
; 0000 00E9             break;
_0x35:
; 0000 00EA 
; 0000 00EB         }
_0x13:
; 0000 00EC       }
; 0000 00ED 
; 0000 00EE         }
_0xA:
; 0000 00EF         else{
	RJMP _0x36
_0x9:
; 0000 00F0             totalcount1_5 = 0, nobat1_5 = 0;
	CALL SUBOPT_0x18
; 0000 00F1             totalcount6 = 0, nobat6 = 0;
; 0000 00F2             totalcount7 = 0, nobat7 = 0;
; 0000 00F3             TotalCount = 0;
; 0000 00F4             Counter1 = 0, Counter2 = 0, Counter3 = 0, Counter4 = 0, Counter5 = 0, Counter6 = 0, Counter7 = 0;
	CALL SUBOPT_0x12
	CALL SUBOPT_0x13
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 00F5             Show = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x9
; 0000 00F6             //tanzimat saat
; 0000 00F7         }
_0x36:
; 0000 00F8     }
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
; .FEND
;
;void main(void)
; 0000 00FB {
_main:
; .FSTART _main
; 0000 00FC     DDRB = 0xFF;    //  Port B as output - To LCD
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 00FD     PORTB = 0x00;   //  Initialize it by 0000_0000
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 00FE     DDRC = 0xF0;    //  Port C as half input half output - From Keypad
	LDI  R30,LOW(240)
	OUT  0x14,R30
; 0000 00FF     PORTC = 0x0F;   //  Initialize it by 0000_1111
	LDI  R30,LOW(15)
	OUT  0x15,R30
; 0000 0100 
; 0000 0101     // External Interrupt(s) initialization
; 0000 0102     // INT0: On
; 0000 0103     // INT0 Mode: Falling Edge
; 0000 0104     // INT1: Off
; 0000 0105     // INT2: Off
; 0000 0106     GICR |= (0<<INT1) | (1<<INT0) | (0<<INT2);
	IN   R30,0x3B
	ORI  R30,0x40
	OUT  0x3B,R30
; 0000 0107     MCUCR = (0<<ISC11) | (0<<ISC10) | (1<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(2)
	OUT  0x35,R30
; 0000 0108     MCUCSR = (0<<ISC2);
	LDI  R30,LOW(0)
	OUT  0x34,R30
; 0000 0109     GIFR = (0<<INTF1) | (1<<INTF0) | (0<<INTF2);
	LDI  R30,LOW(64)
	OUT  0x3A,R30
; 0000 010A 
; 0000 010B     // Timer/Counter 1 initialization
; 0000 010C     // Clock source: System Clock
; 0000 010D     // Clock value: 31/250 kHz
; 0000 010E     // Mode: Normal top=0xFFFF
; 0000 010F     // OC1A output: Disconnected
; 0000 0110     // OC1B output: Disconnected
; 0000 0111     // Noise Canceler: Off
; 0000 0112     // Input Capture on Falling Edge
; 0000 0113     // Timer Period: 1 s
; 0000 0114     // Timer1 Overflow Interrupt: On
; 0000 0115     // Input Capture Interrupt: Off
; 0000 0116     // Compare A Match Interrupt: Off
; 0000 0117     // Compare B Match Interrupt: Off
; 0000 0118     TCCR1A = (0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 0119     TCCR1B = (0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (1<<CS12) | (0<<CS11) | (0<<CS10);
	LDI  R30,LOW(4)
	OUT  0x2E,R30
; 0000 011A     TCNT1H = 0x85;
	LDI  R30,LOW(133)
	OUT  0x2D,R30
; 0000 011B     TCNT1L = 0xEE;
	LDI  R30,LOW(238)
	OUT  0x2C,R30
; 0000 011C     ICR1H = 0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0000 011D     ICR1L = 0x00;
	OUT  0x26,R30
; 0000 011E     OCR1AH = 0x00;
	OUT  0x2B,R30
; 0000 011F     OCR1AL = 0x00;
	OUT  0x2A,R30
; 0000 0120     OCR1BH = 0x00;
	OUT  0x29,R30
; 0000 0121     OCR1BL = 0x00;
	OUT  0x28,R30
; 0000 0122 
; 0000 0123     // Global Enable Interrupts
; 0000 0124     #asm("sei")
	sei
; 0000 0125 
; 0000 0126     totalcount1_5 = 0, nobat1_5 = 0;
	CALL SUBOPT_0x18
; 0000 0127     totalcount6 = 0, nobat6 = 0;
; 0000 0128     totalcount7 = 0, nobat7 = 0;
; 0000 0129     TotalCount = 0;
; 0000 012A     Counter1 = 0, Counter2 = 0, Counter3 = 0, Counter4 = 0, Counter5 = 0, Counter6 = 0, Counter7 = 0;
	CALL SUBOPT_0x12
	CALL SUBOPT_0x13
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 012B     Show = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x9
; 0000 012C     saat_yekonim = 0;
	LDI  R30,LOW(0)
	STS  _saat_yekonim,R30
	STS  _saat_yekonim+1,R30
; 0000 012D     lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 012E     second = 0 ;
	CLR  R4
	CLR  R5
; 0000 012F 
; 0000 0130     while (1)
_0x37:
; 0000 0131         {
; 0000 0132             if (hour == 1 || hour == 12)
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R8
	CPC  R31,R9
	BREQ _0x3B
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CP   R30,R8
	CPC  R31,R9
	BRNE _0x3A
_0x3B:
; 0000 0133                 sprintf(lcd_buffer,"   %02d:%02d:%02d  PM", hour, minute, second);
	LDI  R30,LOW(_lcd_buffer)
	LDI  R31,HIGH(_lcd_buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,0
	RJMP _0x6B
; 0000 0134             else
_0x3A:
; 0000 0135                 sprintf(lcd_buffer,"   %02d:%02d:%02d  AM", hour, minute, second);
	LDI  R30,LOW(_lcd_buffer)
	LDI  R31,HIGH(_lcd_buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,22
_0x6B:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R8
	CALL SUBOPT_0x19
	MOVW R30,R6
	CALL SUBOPT_0x19
	MOVW R30,R4
	CALL SUBOPT_0x19
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
; 0000 0136             lcd_gotoxy(0,0);
	CALL SUBOPT_0x1A
; 0000 0137             lcd_puts(lcd_buffer);
	LDI  R26,LOW(_lcd_buffer)
	LDI  R27,HIGH(_lcd_buffer)
	CALL _lcd_puts
; 0000 0138             delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 0139             time_after(1000, &hour, &minute, &second);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL SUBOPT_0x1B
; 0000 013A             lcd_clear();
; 0000 013B     }
	RJMP _0x37
; 0000 013C }
_0x3E:
	RJMP _0x3E
; .FEND
;
;void time_after(int n, int* pthour, int* ptminute, int* ptsecond)
; 0000 013F {
_time_after:
; .FSTART _time_after
; 0000 0140     unsigned char second = *ptsecond;
; 0000 0141     unsigned char minute = *ptminute;
; 0000 0142     unsigned char hour = *pthour;
; 0000 0143 
; 0000 0144     n = n / 1000;
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR4
;	n -> Y+10
;	*pthour -> Y+8
;	*ptminute -> Y+6
;	*ptsecond -> Y+4
;	second -> R17
;	minute -> R16
;	hour -> R19
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LD   R30,X
	MOV  R17,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R30,X
	MOV  R16,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LD   R30,X
	MOV  R19,R30
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __DIVW21
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 0145     second += n;
	LDD  R30,Y+10
	ADD  R17,R30
; 0000 0146     if (second > 59)
	CPI  R17,60
	BRLO _0x3F
; 0000 0147     {
; 0000 0148         minute += 1;
	SUBI R16,-LOW(1)
; 0000 0149         second = second % 60;
	MOV  R26,R17
	CLR  R27
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CALL __MODW21
	MOV  R17,R30
; 0000 014A     }
; 0000 014B     if (minute > 59)
_0x3F:
	CPI  R16,60
	BRLO _0x40
; 0000 014C     {
; 0000 014D         hour += 1;
	SUBI R19,-LOW(1)
; 0000 014E         minute = minute % 60;
	MOV  R26,R16
	CLR  R27
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CALL __MODW21
	MOV  R16,R30
; 0000 014F     }
; 0000 0150     if (hour > 12)
_0x40:
	CPI  R19,13
	BRLO _0x41
; 0000 0151         hour = hour % 12;
	MOV  R26,R19
	CLR  R27
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CALL __MODW21
	MOV  R19,R30
; 0000 0152 
; 0000 0153     *ptsecond = second;
_0x41:
	MOV  R30,R17
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
; 0000 0154     *ptminute = minute;
	MOV  R30,R16
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
; 0000 0155     *pthour = hour;
	MOV  R30,R19
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
; 0000 0156 }
	CALL __LOADLOCR4
	ADIW R28,12
	RET
; .FEND
;
;void LCD_Goto_Counter(int clinet_number, int counter_number)
; 0000 0159 {
_LCD_Goto_Counter:
; .FSTART _LCD_Goto_Counter
; 0000 015A     char* tmp_buffer = "";
; 0000 015B 
; 0000 015C     lcd_clear();
	CALL SUBOPT_0x1C
;	clinet_number -> Y+4
;	counter_number -> Y+2
;	*tmp_buffer -> R16,R17
	__POINTWRMN 16,17,_0x42,0
	CALL _lcd_clear
; 0000 015D 
; 0000 015E     sprintf(tmp_buffer,"   Client #%03d   ", clinet_number);
	ST   -Y,R17
	ST   -Y,R16
	__POINTW1FN _0x0,44
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1D
; 0000 015F     lcd_gotoxy(0, 0);
	CALL SUBOPT_0x1A
; 0000 0160     lcd_puts(tmp_buffer);
	MOVW R26,R16
	CALL _lcd_puts
; 0000 0161 
; 0000 0162     sprintf(tmp_buffer,"Go To Counter#%02d!", counter_number);
	ST   -Y,R17
	ST   -Y,R16
	__POINTW1FN _0x0,63
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1D
; 0000 0163     lcd_gotoxy(0, 1);
	CALL SUBOPT_0x1F
; 0000 0164     lcd_puts(tmp_buffer);
; 0000 0165 
; 0000 0166     delay_ms(3000);
; 0000 0167     time_after(3000, &hour, &minute, &second);
; 0000 0168     lcd_clear();
; 0000 0169 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,6
	RET
; .FEND

	.DSEG
_0x42:
	.BYTE 0x1
;
;void LCD_Show_entezar(int togo_number)
; 0000 016C {

	.CSEG
_LCD_Show_entezar:
; .FSTART _LCD_Show_entezar
; 0000 016D     char* tmp_buffer = "";
; 0000 016E 
; 0000 016F     lcd_clear();
	CALL SUBOPT_0x1C
;	togo_number -> Y+2
;	*tmp_buffer -> R16,R17
	__POINTWRMN 16,17,_0x43,0
	CALL _lcd_clear
; 0000 0170 
; 0000 0171     sprintf(tmp_buffer," %3d Client(s) ", togo_number);
	ST   -Y,R17
	ST   -Y,R16
	__POINTW1FN _0x0,83
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1D
; 0000 0172     lcd_gotoxy(0, 0);
	CALL SUBOPT_0x1A
; 0000 0173     lcd_puts(tmp_buffer);
	MOVW R26,R16
	CALL _lcd_puts
; 0000 0174 
; 0000 0175     sprintf(tmp_buffer,"   Before You   ", togo_number);
	ST   -Y,R17
	ST   -Y,R16
	__POINTW1FN _0x0,99
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1D
; 0000 0176     lcd_gotoxy(0, 1);
	CALL SUBOPT_0x1F
; 0000 0177     lcd_puts(tmp_buffer);
; 0000 0178 
; 0000 0179     delay_ms(3000);
; 0000 017A     time_after(3000, &hour, &minute, &second);
; 0000 017B     lcd_clear();
; 0000 017C }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	RET
; .FEND

	.DSEG
_0x43:
	.BYTE 0x1
;
;char GetKey()
; 0000 017F {

	.CSEG
_GetKey:
; .FSTART _GetKey
; 0000 0180 unsigned char key_code = 0xFF;
; 0000 0181 unsigned char columns;
; 0000 0182 
; 0000 0183 PORTC = 0xFF;
	ST   -Y,R17
	ST   -Y,R16
;	key_code -> R17
;	columns -> R16
	LDI  R17,255
	LDI  R30,LOW(255)
	OUT  0x15,R30
; 0000 0184 // first row
; 0000 0185 PORTC.4 = 0;
	CBI  0x15,4
; 0000 0186 columns = PINC & 0x07;
	CALL SUBOPT_0x20
; 0000 0187 if(columns != 0x07)
	BREQ _0x46
; 0000 0188   {
; 0000 0189   switch(columns)
	CALL SUBOPT_0x21
; 0000 018A     {
; 0000 018B     case 0b110 : key_code = 1; break;
	BRNE _0x4A
	LDI  R17,LOW(1)
	RJMP _0x49
; 0000 018C     case 0b101 : key_code = 2; break;
_0x4A:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x4B
	LDI  R17,LOW(2)
	RJMP _0x49
; 0000 018D     case 0b011 : key_code = 3; break;
_0x4B:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x49
	LDI  R17,LOW(3)
; 0000 018E     }
_0x49:
; 0000 018F   }
; 0000 0190 PORTC.4 = 1;
_0x46:
	SBI  0x15,4
; 0000 0191 // second row
; 0000 0192 PORTC.5 = 0;
	CBI  0x15,5
; 0000 0193 columns = PINC & 0x07;
	CALL SUBOPT_0x20
; 0000 0194 if(columns != 0x07)
	BREQ _0x51
; 0000 0195   {
; 0000 0196   switch(columns)
	CALL SUBOPT_0x21
; 0000 0197     {
; 0000 0198     case 0b110 : key_code = 4; break;
	BRNE _0x55
	LDI  R17,LOW(4)
	RJMP _0x54
; 0000 0199     case 0b101 : key_code = 5; break;
_0x55:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x56
	LDI  R17,LOW(5)
	RJMP _0x54
; 0000 019A     case 0b011 : key_code = 6; break;
_0x56:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x54
	LDI  R17,LOW(6)
; 0000 019B     }
_0x54:
; 0000 019C   }
; 0000 019D PORTC.5 = 1;
_0x51:
	SBI  0x15,5
; 0000 019E // third row
; 0000 019F PORTC.6 = 0;
	CBI  0x15,6
; 0000 01A0 columns = PINC & 0x07;
	CALL SUBOPT_0x20
; 0000 01A1 if(columns != 0x07)
	BREQ _0x5C
; 0000 01A2   {
; 0000 01A3   switch(columns)
	CALL SUBOPT_0x21
; 0000 01A4     {
; 0000 01A5     case 0b110 : key_code = 7; break;
	BRNE _0x60
	LDI  R17,LOW(7)
	RJMP _0x5F
; 0000 01A6     case 0b101 : key_code = 8; break;
_0x60:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x61
	LDI  R17,LOW(8)
	RJMP _0x5F
; 0000 01A7     case 0b011 : key_code = 9; break;
_0x61:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x5F
	LDI  R17,LOW(9)
; 0000 01A8     }
_0x5F:
; 0000 01A9   }
; 0000 01AA PORTC.6 = 1;
_0x5C:
	SBI  0x15,6
; 0000 01AB // fourth row
; 0000 01AC PORTC.7 = 0;
	CBI  0x15,7
; 0000 01AD if(!PINC.1) key_code = 0;
	SBIS 0x13,1
	LDI  R17,LOW(0)
; 0000 01AE PORTC.7 = 1;
	SBI  0x15,7
; 0000 01AF 
; 0000 01B0 PORTC = 0x0F;
	LDI  R30,LOW(15)
	OUT  0x15,R30
; 0000 01B1 return key_code;
	MOV  R30,R17
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 01B2 }
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G100:
; .FSTART _put_buff_G100
	CALL SUBOPT_0x1C
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
_0x2000013:
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
	ADIW R28,5
	RET
; .FEND
__print_G100:
; .FSTART __print_G100
	ST   -Y,R27
	ST   -Y,R26
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
	CALL SUBOPT_0x22
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	CALL SUBOPT_0x22
	RJMP _0x20000CC
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
	BREQ PC+2
	RJMP _0x200001B
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
	CALL SUBOPT_0x23
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x24
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	CALL SUBOPT_0x23
	CALL SUBOPT_0x25
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	CALL SUBOPT_0x23
	CALL SUBOPT_0x25
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
	BREQ PC+2
	RJMP _0x2000071
_0x2000040:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	CALL SUBOPT_0x23
	CALL SUBOPT_0x26
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
	CALL SUBOPT_0x23
	CALL SUBOPT_0x26
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
	CALL SUBOPT_0x22
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
	CALL SUBOPT_0x22
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
	RJMP _0x20000CD
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
_0x20000CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x24
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	CALL SUBOPT_0x22
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
	CALL SUBOPT_0x24
	RJMP _0x200006E
_0x2000070:
_0x200006D:
_0x2000071:
_0x2000030:
_0x20000CC:
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
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x27
	SBIW R30,0
	BRNE _0x2000072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0002
_0x2000072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x27
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
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20C0002:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

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

	.DSEG

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G103:
; .FSTART __lcd_write_nibble_G103
	ST   -Y,R26
	IN   R30,0x18
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x18,R30
	__DELAY_USB 13
	SBI  0x18,2
	__DELAY_USB 13
	CBI  0x18,2
	__DELAY_USB 13
	RJMP _0x20C0001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G103
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G103
	__DELAY_USB 133
	RJMP _0x20C0001
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G103)
	SBCI R31,HIGH(-__base_y_G103)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x28
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x28
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2060005
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2060004
_0x2060005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2060007
	RJMP _0x20C0001
_0x2060007:
_0x2060004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x18,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x18,0
	RJMP _0x20C0001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2060008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x206000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2060008
_0x206000A:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x17
	ORI  R30,LOW(0xF0)
	OUT  0x17,R30
	SBI  0x17,2
	SBI  0x17,0
	SBI  0x17,1
	CBI  0x18,2
	CBI  0x18,0
	CBI  0x18,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G103,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G103,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x29
	CALL SUBOPT_0x29
	CALL SUBOPT_0x29
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G103
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20C0001:
	ADIW R28,1
	RET
; .FEND

	.CSEG

	.CSEG

	.DSEG
_totalcount6:
	.BYTE 0x2
_nobat6:
	.BYTE 0x2
_totalcount7:
	.BYTE 0x2
_nobat7:
	.BYTE 0x2
_TotalCount:
	.BYTE 0x2
_Counter1:
	.BYTE 0x2
_Counter2:
	.BYTE 0x2
_Counter3:
	.BYTE 0x2
_Counter4:
	.BYTE 0x2
_Counter5:
	.BYTE 0x2
_Counter6:
	.BYTE 0x2
_Counter7:
	.BYTE 0x2
_Show:
	.BYTE 0x2
_d1:
	.BYTE 0x2
_d2:
	.BYTE 0x2
_d3:
	.BYTE 0x2
_d4:
	.BYTE 0x2
_d5:
	.BYTE 0x2
_d6:
	.BYTE 0x2
_d7:
	.BYTE 0x2
_entezar:
	.BYTE 0x2
_reset:
	.BYTE 0x2
_saat_yekonim:
	.BYTE 0x2
_lcd_buffer:
	.BYTE 0x11
__seed_G102:
	.BYTE 0x4
__base_y_G103:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	LDS  R30,_saat_yekonim
	LDS  R31,_saat_yekonim+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1:
	LDS  R30,_TotalCount
	LDS  R31,_TotalCount+1
	ADIW R30,1
	STS  _TotalCount,R30
	STS  _TotalCount+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _Counter1,R30
	STS  _Counter1+1,R31
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _Show,R30
	STS  _Show+1,R31
	ST   -Y,R13
	ST   -Y,R12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _Counter2,R30
	STS  _Counter2+1,R31
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _Counter3,R30
	STS  _Counter3+1,R31
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _Counter4,R30
	STS  _Counter4+1,R31
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _Counter5,R30
	STS  _Counter5+1,R31
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _Show,R30
	STS  _Show+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x9:
	STS  _Show,R30
	STS  _Show+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _Counter6,R30
	STS  _Counter6+1,R31
	LDS  R30,_nobat6
	LDS  R31,_nobat6+1
	ADIW R30,1
	STS  _nobat6,R30
	STS  _nobat6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	LDS  R30,_nobat6
	LDS  R31,_nobat6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(6)
	LDI  R27,0
	JMP  _LCD_Goto_Counter

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xD:
	SUB  R30,R26
	SBC  R31,R27
	ST   Y,R30
	STD  Y+1,R31
	LD   R26,Y
	LDD  R27,Y+1
	CALL _LCD_Show_entezar
	ADIW R28,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _Counter7,R30
	STS  _Counter7+1,R31
	LDS  R30,_nobat7
	LDS  R31,_nobat7+1
	ADIW R30,1
	STS  _nobat7,R30
	STS  _nobat7+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	LDS  R30,_nobat7
	LDS  R31,_nobat7+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(7)
	LDI  R27,0
	JMP  _LCD_Goto_Counter

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(0)
	STS  _Counter1,R30
	STS  _Counter1+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(0)
	STS  _Counter2,R30
	STS  _Counter2+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(0)
	STS  _Counter3,R30
	STS  _Counter3+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	LDI  R30,LOW(0)
	STS  _Counter4,R30
	STS  _Counter4+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(0)
	STS  _Counter5,R30
	STS  _Counter5+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x16:
	LDI  R30,LOW(0)
	STS  _Counter6,R30
	STS  _Counter6+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x17:
	LDI  R30,LOW(0)
	STS  _Counter7,R30
	STS  _Counter7+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:26 WORDS
SUBOPT_0x18:
	CLR  R10
	CLR  R11
	CLR  R12
	CLR  R13
	LDI  R30,LOW(0)
	STS  _totalcount6,R30
	STS  _totalcount6+1,R30
	STS  _nobat6,R30
	STS  _nobat6+1,R30
	STS  _totalcount7,R30
	STS  _totalcount7+1,R30
	STS  _nobat7,R30
	STS  _nobat7+1,R30
	STS  _TotalCount,R30
	STS  _TotalCount+1,R30
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x19:
	CALL __CWD1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1A:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x1B:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(4)
	LDI  R27,HIGH(4)
	CALL _time_after
	JMP  _lcd_clear

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1D:
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1E:
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RJMP SUBOPT_0x19

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1F:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
	MOVW R26,R16
	CALL _lcd_puts
	LDI  R26,LOW(3000)
	LDI  R27,HIGH(3000)
	CALL _delay_ms
	LDI  R30,LOW(3000)
	LDI  R31,HIGH(3000)
	RJMP SUBOPT_0x1B

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	IN   R30,0x13
	ANDI R30,LOW(0x7)
	MOV  R16,R30
	CPI  R16,7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x21:
	MOV  R30,R16
	LDI  R31,0
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x22:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x23:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x24:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x25:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x26:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x29:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G103
	__DELAY_USW 200
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
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

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
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

;END OF CODE MARKER
__END_OF_CODE:
