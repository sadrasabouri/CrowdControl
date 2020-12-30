
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 8/000000 MHz
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
	.DB  0x43,0x6C,0x6F,0x63,0x6B,0x3A,0x20,0x25
	.DB  0x64,0x3A,0x25,0x64,0x3A,0x25,0x64,0x0
	.DB  0x67,0x6F,0x20,0x74,0x6F,0x20,0x62,0x61
	.DB  0x64,0x6A,0x65,0x20,0x3A,0x20,0x0,0x20
	.DB  0x6E,0x61,0x66,0x61,0x72,0x20,0x6A,0x6F
	.DB  0x6C,0x6F,0x79,0x65,0x20,0x73,0x68,0x6F
	.DB  0x6D,0x61,0x20,0x68,0x61,0x73,0x74,0x61
	.DB  0x6E,0x64,0x0
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
;int second  ;
;int minute = 30 ;
;int hour = 7 ;
;int totalcount1_5, nobat1_5 ;
;int totalcount6, nobat6 ;
;int totalcount7, nobat7;
;int TotalCount ;
;int badje1, badje2, badje3, badje4, badje5, badje6, badje7;
;int namayesh = 0;
;void LCD_namayesh_go_to_badje (int a, int b);
;char GetKey();
;int d1,d2,d3 ,d4,d5,d6 ,d7;
;int entezar;
;void LCD_namayesh_go_to_badje (int a, int b);
;void LCD_namayesh_entezar (int a);
;char str2[10];
;char str3[17];
;int reset = 0 ;
;int saat_yekonim;
;char str1[10];
;int namayesh;
;char lcd_buffer[17];
;//=================================================================================================
;// timer interrupt
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0021 {

	.CSEG
_timer1_ovf_isr:
; .FSTART _timer1_ovf_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0022 // Reinitialize Timer1 value
; 0000 0023 TCNT1H=0x85EE >> 8;
	LDI  R30,LOW(133)
	OUT  0x2D,R30
; 0000 0024 TCNT1L=0x85EE & 0xff;
	LDI  R30,LOW(238)
	OUT  0x2C,R30
; 0000 0025 // Place your code here
; 0000 0026 if(second==59){
	LDI  R30,LOW(59)
	LDI  R31,HIGH(59)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x3
; 0000 0027 second=0;
	CLR  R4
	CLR  R5
; 0000 0028 if(minute==59){
	CP   R30,R6
	CPC  R31,R7
	BRNE _0x4
; 0000 0029 minute=0;
	CLR  R6
	CLR  R7
; 0000 002A if(hour==23)
	LDI  R30,LOW(23)
	LDI  R31,HIGH(23)
	CP   R30,R8
	CPC  R31,R9
	BRNE _0x5
; 0000 002B hour=0;
	CLR  R8
	CLR  R9
; 0000 002C else
	RJMP _0x6
_0x5:
; 0000 002D hour++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 002E }
_0x6:
; 0000 002F else
	RJMP _0x7
_0x4:
; 0000 0030 minute++;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 0031 }
_0x7:
; 0000 0032 else
	RJMP _0x8
_0x3:
; 0000 0033 second++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 0034 }
_0x8:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;//===================================================================================================
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 0038 {
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
; 0000 0039 char k;
; 0000 003A k = GetKey();
	ST   -Y,R17
;	k -> R17
	RCALL _GetKey
	MOV  R17,R30
; 0000 003B GICR |= (1 << INTF0);
	IN   R30,0x3B
	ORI  R30,0x40
	OUT  0x3B,R30
; 0000 003C if(!reset){
	LDS  R30,_reset
	LDS  R31,_reset+1
	SBIW R30,0
	BREQ PC+2
	RJMP _0x9
; 0000 003D         if(k != 0xFF) // dokme feshorde shod
	CPI  R17,255
	BRNE PC+2
	RJMP _0xA
; 0000 003E       {
; 0000 003F         if (hour < 13 || (hour ==13 && minute<=30 )){
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
; 0000 0040             saat_yekonim = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _saat_yekonim,R30
	STS  _saat_yekonim+1,R31
; 0000 0041         }else{
	RJMP _0x10
_0xB:
; 0000 0042             saat_yekonim = 0 ;
	LDI  R30,LOW(0)
	STS  _saat_yekonim,R30
	STS  _saat_yekonim+1,R30
; 0000 0043         }
_0x10:
; 0000 0044       switch(k)
	MOV  R30,R17
	LDI  R31,0
; 0000 0045         {
; 0000 0046         case 1 :
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x14
; 0000 0047             if (saat_yekonim) {
	CALL SUBOPT_0x0
	BRNE PC+2
	RJMP _0x15
; 0000 0048                 TotalCount += 1;
	CALL SUBOPT_0x1
; 0000 0049                 totalcount1_5 += 1;
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
; 0000 004A                 if(badje1 == 0){
	LDS  R30,_badje1
	LDS  R31,_badje1+1
	SBIW R30,0
	BRNE _0x16
; 0000 004B                     badje1 = 1;
	CALL SUBOPT_0x2
; 0000 004C                     nobat1_5 += 1;
; 0000 004D                     namayesh = 1;
	CALL SUBOPT_0x3
; 0000 004E                     LCD_namayesh_go_to_badje(nobat1_5, 1);
	LDI  R26,LOW(1)
	LDI  R27,0
	RCALL _LCD_namayesh_go_to_badje
; 0000 004F                     namayesh = 0;
	RJMP _0x61
; 0000 0050 
; 0000 0051                 }
; 0000 0052                 else if (badje2 == 0){
_0x16:
	LDS  R30,_badje2
	LDS  R31,_badje2+1
	SBIW R30,0
	BRNE _0x18
; 0000 0053                     badje2 = 1;
	CALL SUBOPT_0x4
; 0000 0054                     nobat1_5 += 1;
; 0000 0055                     namayesh = 1;
	CALL SUBOPT_0x3
; 0000 0056                     LCD_namayesh_go_to_badje(nobat1_5, 2);
	LDI  R26,LOW(2)
	LDI  R27,0
	RCALL _LCD_namayesh_go_to_badje
; 0000 0057                     namayesh = 0;
	RJMP _0x61
; 0000 0058                 }
; 0000 0059                 else if (badje3 == 0){
_0x18:
	LDS  R30,_badje3
	LDS  R31,_badje3+1
	SBIW R30,0
	BRNE _0x1A
; 0000 005A                     badje3 = 1;
	CALL SUBOPT_0x5
; 0000 005B                     nobat1_5 += 1;
; 0000 005C                     namayesh = 1;
	CALL SUBOPT_0x3
; 0000 005D                     LCD_namayesh_go_to_badje(nobat1_5, 3);
	LDI  R26,LOW(3)
	LDI  R27,0
	RCALL _LCD_namayesh_go_to_badje
; 0000 005E                     namayesh = 0;
	RJMP _0x61
; 0000 005F                 }
; 0000 0060                 else if (badje4 == 0){
_0x1A:
	LDS  R30,_badje4
	LDS  R31,_badje4+1
	SBIW R30,0
	BRNE _0x1C
; 0000 0061                     badje4 = 1;
	CALL SUBOPT_0x6
; 0000 0062                     nobat1_5 += 1;
; 0000 0063                     namayesh = 1;
	CALL SUBOPT_0x3
; 0000 0064                     LCD_namayesh_go_to_badje(nobat1_5, 4) ;
	LDI  R26,LOW(4)
	LDI  R27,0
	RCALL _LCD_namayesh_go_to_badje
; 0000 0065                     namayesh = 0;
	RJMP _0x61
; 0000 0066                 }
; 0000 0067                 else if (badje5 == 0){
_0x1C:
	LDS  R30,_badje5
	LDS  R31,_badje5+1
	SBIW R30,0
	BRNE _0x1E
; 0000 0068                     badje5 = 1;
	CALL SUBOPT_0x7
; 0000 0069                     nobat1_5 += 1;
; 0000 006A                     namayesh = 1;
	CALL SUBOPT_0x3
; 0000 006B                     LCD_namayesh_go_to_badje(nobat1_5, 5);
	LDI  R26,LOW(5)
	LDI  R27,0
	RCALL _LCD_namayesh_go_to_badje
; 0000 006C                     namayesh = 0;
	RJMP _0x61
; 0000 006D                 }
; 0000 006E                 else {
_0x1E:
; 0000 006F                     namayesh = 1;
	CALL SUBOPT_0x8
; 0000 0070                     entezar = totalcount1_5 - nobat1_5;
	MOVW R30,R10
	SUB  R30,R12
	SBC  R31,R13
	STS  _entezar,R30
	STS  _entezar+1,R31
; 0000 0071                     LCD_namayesh_entezar(entezar);
	LDS  R26,_entezar
	LDS  R27,_entezar+1
	RCALL _LCD_namayesh_entezar
; 0000 0072                     namayesh = 0;
_0x61:
	LDI  R30,LOW(0)
	CALL SUBOPT_0x9
; 0000 0073                 }
; 0000 0074             }
; 0000 0075             break;
_0x15:
	RJMP _0x13
; 0000 0076         case 2 :
_0x14:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x20
; 0000 0077             if(saat_yekonim){
	CALL SUBOPT_0x0
	BREQ _0x21
; 0000 0078                 TotalCount += 1;
	CALL SUBOPT_0x1
; 0000 0079                 totalcount6 += 1;
	LDS  R30,_totalcount6
	LDS  R31,_totalcount6+1
	ADIW R30,1
	STS  _totalcount6,R30
	STS  _totalcount6+1,R31
; 0000 007A                 if(badje6 == 0){
	LDS  R30,_badje6
	LDS  R31,_badje6+1
	SBIW R30,0
	BRNE _0x22
; 0000 007B                     badje6 = 1;
	CALL SUBOPT_0xA
; 0000 007C                     nobat6 += 1;
; 0000 007D                     namayesh = 1;
	CALL SUBOPT_0x8
; 0000 007E                     LCD_namayesh_go_to_badje(nobat6, 6);
	CALL SUBOPT_0xB
	CALL SUBOPT_0xC
; 0000 007F                     namayesh = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x9
; 0000 0080                 }
; 0000 0081                 else {
	RJMP _0x23
_0x22:
; 0000 0082                     int entezar6 = totalcount6 - nobat6;
; 0000 0083                     LCD_namayesh_entezar(entezar6);
	SBIW R28,2
;	entezar6 -> Y+0
	LDS  R26,_nobat6
	LDS  R27,_nobat6+1
	LDS  R30,_totalcount6
	LDS  R31,_totalcount6+1
	CALL SUBOPT_0xD
; 0000 0084                 }
_0x23:
; 0000 0085             }
; 0000 0086             break;
_0x21:
	RJMP _0x13
; 0000 0087         case 3 :
_0x20:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x24
; 0000 0088             if(saat_yekonim){
	CALL SUBOPT_0x0
	BREQ _0x25
; 0000 0089                 TotalCount += 1;
	CALL SUBOPT_0x1
; 0000 008A                 totalcount7 += 1;
	LDS  R30,_totalcount7
	LDS  R31,_totalcount7+1
	ADIW R30,1
	STS  _totalcount7,R30
	STS  _totalcount7+1,R31
; 0000 008B                 if(badje7 == 0){
	LDS  R30,_badje7
	LDS  R31,_badje7+1
	SBIW R30,0
	BRNE _0x26
; 0000 008C                     badje7 = 1;
	CALL SUBOPT_0xE
; 0000 008D                     nobat7 += 1;
; 0000 008E                     namayesh = 1;
	CALL SUBOPT_0x8
; 0000 008F                     LCD_namayesh_go_to_badje(nobat7, 7) ;
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
; 0000 0090                     namayesh = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x9
; 0000 0091                 }
; 0000 0092                 else {
	RJMP _0x27
_0x26:
; 0000 0093 
; 0000 0094                     int entezar7 = totalcount7 - nobat7;
; 0000 0095                     LCD_namayesh_entezar(entezar7);
	SBIW R28,2
;	entezar7 -> Y+0
	LDS  R26,_nobat7
	LDS  R27,_nobat7+1
	LDS  R30,_totalcount7
	LDS  R31,_totalcount7+1
	CALL SUBOPT_0xD
; 0000 0096                 }
_0x27:
; 0000 0097             }
; 0000 0098             break;
_0x25:
	RJMP _0x13
; 0000 0099         case 9 : //badje1
_0x24:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x28
; 0000 009A             badje1 = 0;
	CALL SUBOPT_0x11
; 0000 009B             if (totalcount1_5 > nobat1_5){
	__CPWRR 12,13,10,11
	BRGE _0x29
; 0000 009C                 namayesh = 1;
	CALL SUBOPT_0x8
; 0000 009D                 d1 = nobat1_5 + 1;
	MOVW R30,R12
	ADIW R30,1
	STS  _d1,R30
	STS  _d1+1,R31
; 0000 009E                 LCD_namayesh_go_to_badje(d1, 1);
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1)
	LDI  R27,0
	RCALL _LCD_namayesh_go_to_badje
; 0000 009F                 badje1 = 1;
	CALL SUBOPT_0x2
; 0000 00A0                 nobat1_5 += 1;
; 0000 00A1                 namayesh = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x9
; 0000 00A2             }
; 0000 00A3             break;
_0x29:
	RJMP _0x13
; 0000 00A4         case 8 : //badje2
_0x28:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x2A
; 0000 00A5             badje2 = 0;
	CALL SUBOPT_0x12
; 0000 00A6             if (totalcount1_5 > nobat1_5){
	__CPWRR 12,13,10,11
	BRGE _0x2B
; 0000 00A7                 namayesh = 1;
	CALL SUBOPT_0x8
; 0000 00A8                 d2 = nobat1_5 + 1;
	MOVW R30,R12
	ADIW R30,1
	STS  _d2,R30
	STS  _d2+1,R31
; 0000 00A9                 LCD_namayesh_go_to_badje(d2, 2);
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(2)
	LDI  R27,0
	RCALL _LCD_namayesh_go_to_badje
; 0000 00AA                 badje2 = 1;
	CALL SUBOPT_0x4
; 0000 00AB                 nobat1_5 += 1;
; 0000 00AC                 namayesh = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x9
; 0000 00AD             }
; 0000 00AE             break;
_0x2B:
	RJMP _0x13
; 0000 00AF         case 7 : //badje3
_0x2A:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x2C
; 0000 00B0             badje3 = 0;
	CALL SUBOPT_0x13
; 0000 00B1             if (totalcount1_5 > nobat1_5){
	__CPWRR 12,13,10,11
	BRGE _0x2D
; 0000 00B2                 namayesh = 1;
	CALL SUBOPT_0x8
; 0000 00B3                 d3 = nobat1_5 + 1;
	MOVW R30,R12
	ADIW R30,1
	STS  _d3,R30
	STS  _d3+1,R31
; 0000 00B4                 LCD_namayesh_go_to_badje(d3, 3);
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(3)
	LDI  R27,0
	RCALL _LCD_namayesh_go_to_badje
; 0000 00B5                 badje3 = 1;
	CALL SUBOPT_0x5
; 0000 00B6                 nobat1_5 += 1;
; 0000 00B7                 namayesh = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x9
; 0000 00B8             }
; 0000 00B9             break;
_0x2D:
	RJMP _0x13
; 0000 00BA         case 6 : //badje4
_0x2C:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x2E
; 0000 00BB             badje4 = 0;
	CALL SUBOPT_0x14
; 0000 00BC             if (totalcount1_5 > nobat1_5){
	__CPWRR 12,13,10,11
	BRGE _0x2F
; 0000 00BD                 namayesh = 1;
	CALL SUBOPT_0x8
; 0000 00BE                 d4 = nobat1_5 + 1;
	MOVW R30,R12
	ADIW R30,1
	STS  _d4,R30
	STS  _d4+1,R31
; 0000 00BF                 LCD_namayesh_go_to_badje(d4, 4) ;
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(4)
	LDI  R27,0
	RCALL _LCD_namayesh_go_to_badje
; 0000 00C0                 badje4 = 1;
	CALL SUBOPT_0x6
; 0000 00C1                 nobat1_5 += 1;
; 0000 00C2                 namayesh = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x9
; 0000 00C3             }
; 0000 00C4             break;
_0x2F:
	RJMP _0x13
; 0000 00C5         case 5 : //badje5
_0x2E:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x30
; 0000 00C6             badje5 = 0;
	CALL SUBOPT_0x15
; 0000 00C7             if (totalcount1_5 > nobat1_5){
	__CPWRR 12,13,10,11
	BRGE _0x31
; 0000 00C8                 namayesh = 1;
	CALL SUBOPT_0x8
; 0000 00C9                 d5 = nobat1_5 + 1;
	MOVW R30,R12
	ADIW R30,1
	STS  _d5,R30
	STS  _d5+1,R31
; 0000 00CA                 LCD_namayesh_go_to_badje(d5, 5);
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(5)
	LDI  R27,0
	RCALL _LCD_namayesh_go_to_badje
; 0000 00CB                 badje5 = 1;
	CALL SUBOPT_0x7
; 0000 00CC                 nobat1_5 += 1;
; 0000 00CD                 namayesh = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x9
; 0000 00CE             }
; 0000 00CF             break;
_0x31:
	RJMP _0x13
; 0000 00D0         case 4 : //badje6
_0x30:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x32
; 0000 00D1             badje6 = 0;
	CALL SUBOPT_0x16
; 0000 00D2             if (totalcount6 > nobat6){
	CALL SUBOPT_0xB
	LDS  R26,_totalcount6
	LDS  R27,_totalcount6+1
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x33
; 0000 00D3                 namayesh = 1;
	CALL SUBOPT_0x8
; 0000 00D4                 d6 = nobat6 + 1;
	CALL SUBOPT_0xB
	ADIW R30,1
	STS  _d6,R30
	STS  _d6+1,R31
; 0000 00D5                 LCD_namayesh_go_to_badje(d6, 6);
	CALL SUBOPT_0xC
; 0000 00D6                 badje6 = 1;
	CALL SUBOPT_0xA
; 0000 00D7                 nobat6 += 1;
; 0000 00D8                 namayesh = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x9
; 0000 00D9             }
; 0000 00DA             break;
_0x33:
	RJMP _0x13
; 0000 00DB         case 0 : //badje7
_0x32:
	SBIW R30,0
	BRNE _0x13
; 0000 00DC             badje7 = 0;
	CALL SUBOPT_0x17
; 0000 00DD             if (totalcount7 > nobat7){
	CALL SUBOPT_0xF
	LDS  R26,_totalcount7
	LDS  R27,_totalcount7+1
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x35
; 0000 00DE                 namayesh = 1;
	CALL SUBOPT_0x8
; 0000 00DF                 d7 = nobat7 + 1;
	CALL SUBOPT_0xF
	ADIW R30,1
	STS  _d7,R30
	STS  _d7+1,R31
; 0000 00E0                 LCD_namayesh_go_to_badje(d7, 7);
	CALL SUBOPT_0x10
; 0000 00E1                 badje7 = 1;
	CALL SUBOPT_0xE
; 0000 00E2                 nobat7 += 1;
; 0000 00E3                 namayesh = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x9
; 0000 00E4             }
; 0000 00E5             break;
_0x35:
; 0000 00E6 
; 0000 00E7         }
_0x13:
; 0000 00E8       }
; 0000 00E9 
; 0000 00EA         }
_0xA:
; 0000 00EB         else{
	RJMP _0x36
_0x9:
; 0000 00EC             totalcount1_5 = 0, nobat1_5 = 0;
	CALL SUBOPT_0x18
; 0000 00ED             totalcount6 = 0, nobat6 = 0;
; 0000 00EE             totalcount7 = 0, nobat7 = 0;
; 0000 00EF             TotalCount = 0;
; 0000 00F0             badje1 = 0, badje2 = 0, badje3 = 0, badje4 = 0, badje5 = 0, badje6 = 0, badje7 = 0;
	CALL SUBOPT_0x12
	CALL SUBOPT_0x13
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 00F1             namayesh = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x9
; 0000 00F2             //tanzimat saat
; 0000 00F3         }
_0x36:
; 0000 00F4     }
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
;
;//*************************************************************************************************
;void main(void)
; 0000 00F9 {
_main:
; .FSTART _main
; 0000 00FA DDRB = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 00FB PORTB = 0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 00FC DDRC = 0xF0;
	LDI  R30,LOW(240)
	OUT  0x14,R30
; 0000 00FD PORTC = 0x0F;
	LDI  R30,LOW(15)
	OUT  0x15,R30
; 0000 00FE // External Interrupt(s) initialization
; 0000 00FF // INT0: On
; 0000 0100 // INT0 Mode: Falling Edge
; 0000 0101 // INT1: Off
; 0000 0102 // INT2: Off
; 0000 0103 GICR|=(0<<INT1) | (1<<INT0) | (0<<INT2);
	IN   R30,0x3B
	ORI  R30,0x40
	OUT  0x3B,R30
; 0000 0104 MCUCR=(0<<ISC11) | (0<<ISC10) | (1<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(2)
	OUT  0x35,R30
; 0000 0105 MCUCSR=(0<<ISC2);
	LDI  R30,LOW(0)
	OUT  0x34,R30
; 0000 0106 GIFR=(0<<INTF1) | (1<<INTF0) | (0<<INTF2);
	LDI  R30,LOW(64)
	OUT  0x3A,R30
; 0000 0107 ////==============================================timer initiallize
; 0000 0108 // Timer/Counter 1 initialization
; 0000 0109 // Clock source: System Clock
; 0000 010A // Clock value: 31/250 kHz
; 0000 010B // Mode: Normal top=0xFFFF
; 0000 010C // OC1A output: Disconnected
; 0000 010D // OC1B output: Disconnected
; 0000 010E // Noise Canceler: Off
; 0000 010F // Input Capture on Falling Edge
; 0000 0110 // Timer Period: 1 s
; 0000 0111 // Timer1 Overflow Interrupt: On
; 0000 0112 // Input Capture Interrupt: Off
; 0000 0113 // Compare A Match Interrupt: Off
; 0000 0114 // Compare B Match Interrupt: Off
; 0000 0115 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 0116 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (1<<CS12) | (0<<CS11) | (0<<CS10);
	LDI  R30,LOW(4)
	OUT  0x2E,R30
; 0000 0117 TCNT1H=0x85;
	LDI  R30,LOW(133)
	OUT  0x2D,R30
; 0000 0118 TCNT1L=0xEE;
	LDI  R30,LOW(238)
	OUT  0x2C,R30
; 0000 0119 ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0000 011A ICR1L=0x00;
	OUT  0x26,R30
; 0000 011B OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 011C OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 011D OCR1BH=0x00;
	OUT  0x29,R30
; 0000 011E OCR1BL=0x00;
	OUT  0x28,R30
; 0000 011F // Global enable interrupts
; 0000 0120 #asm("sei")
	sei
; 0000 0121 //============================================================
; 0000 0122 totalcount1_5 = 0, nobat1_5 = 0;
	CALL SUBOPT_0x18
; 0000 0123 totalcount6 = 0, nobat6 = 0;
; 0000 0124 totalcount7 = 0, nobat7 = 0;
; 0000 0125 TotalCount = 0;
; 0000 0126 badje1 = 0, badje2 = 0, badje3 = 0, badje4 = 0, badje5 = 0, badje6 = 0, badje7 = 0;
	CALL SUBOPT_0x12
	CALL SUBOPT_0x13
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 0127 namayesh = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x9
; 0000 0128 saat_yekonim = 0;
	LDI  R30,LOW(0)
	STS  _saat_yekonim,R30
	STS  _saat_yekonim+1,R30
; 0000 0129 lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 012A second = 0 ;
	CLR  R4
	CLR  R5
; 0000 012B //======================================================================================
; 0000 012C while (1)
_0x37:
; 0000 012D     {
; 0000 012E      sprintf(lcd_buffer,"Clock: %d:%d:%d",hour,minute,second);
	LDI  R30,LOW(_lcd_buffer)
	LDI  R31,HIGH(_lcd_buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,0
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
; 0000 012F       lcd_gotoxy(0,0);
	CALL SUBOPT_0x1A
; 0000 0130       lcd_puts(lcd_buffer);
	LDI  R26,LOW(_lcd_buffer)
	LDI  R27,HIGH(_lcd_buffer)
	CALL SUBOPT_0x1B
; 0000 0131       delay_ms(1000);
; 0000 0132       lcd_clear();
; 0000 0133 }
	RJMP _0x37
; 0000 0134 }
_0x3A:
	RJMP _0x3A
; .FEND
;//========================================================================================
;void LCD_namayesh_go_to_badje (int a, int b){
; 0000 0136 void LCD_namayesh_go_to_badje (int a, int b){
_LCD_namayesh_go_to_badje:
; .FSTART _LCD_namayesh_go_to_badje
; 0000 0137     lcd_clear();
	ST   -Y,R27
	ST   -Y,R26
;	a -> Y+2
;	b -> Y+0
	CALL _lcd_clear
; 0000 0138     str1[10];
	__GETB1MN _str1,10
; 0000 0139     itoa(a, str1);
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_str1)
	LDI  R27,HIGH(_str1)
	CALL _itoa
; 0000 013A     lcd_gotoxy(0, 0);
	CALL SUBOPT_0x1A
; 0000 013B     lcd_puts(str1);
	LDI  R26,LOW(_str1)
	LDI  R27,HIGH(_str1)
	CALL _lcd_puts
; 0000 013C     lcd_gotoxy(5, 0);
	LDI  R30,LOW(5)
	CALL SUBOPT_0x1C
; 0000 013D     lcd_putsf("go to badje : ");
	__POINTW2FN _0x0,16
	CALL _lcd_putsf
; 0000 013E     itoa(b, str2);
	LD   R30,Y
	LDD  R31,Y+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_str2)
	LDI  R27,HIGH(_str2)
	CALL _itoa
; 0000 013F     lcd_gotoxy(15, 0);
	LDI  R30,LOW(15)
	CALL SUBOPT_0x1C
; 0000 0140     lcd_puts(str2);
	LDI  R26,LOW(_str2)
	LDI  R27,HIGH(_str2)
	CALL SUBOPT_0x1B
; 0000 0141     delay_ms(1000);
; 0000 0142     lcd_clear();
; 0000 0143 }
	ADIW R28,4
	RET
; .FEND
;//==========================================================================================
;void LCD_namayesh_entezar (int a){
; 0000 0145 void LCD_namayesh_entezar (int a){
_LCD_namayesh_entezar:
; .FSTART _LCD_namayesh_entezar
; 0000 0146     lcd_clear();
	ST   -Y,R27
	ST   -Y,R26
;	a -> Y+0
	CALL _lcd_clear
; 0000 0147     str3[17];
	__GETB1MN _str3,17
; 0000 0148     itoa(a, str3);
	LD   R30,Y
	LDD  R31,Y+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_str3)
	LDI  R27,HIGH(_str3)
	CALL _itoa
; 0000 0149     lcd_gotoxy(0, 0);
	CALL SUBOPT_0x1A
; 0000 014A     lcd_puts(str1);
	LDI  R26,LOW(_str1)
	LDI  R27,HIGH(_str1)
	CALL _lcd_puts
; 0000 014B     lcd_gotoxy(4, 0);
	LDI  R30,LOW(4)
	CALL SUBOPT_0x1C
; 0000 014C     lcd_putsf(" nafar joloye shoma hastand");
	__POINTW2FN _0x0,31
	CALL _lcd_putsf
; 0000 014D     delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0000 014E     lcd_clear();
	CALL _lcd_clear
; 0000 014F }
	JMP  _0x20C0003
; .FEND
;//=========================================================================================
;
;
;//=========================================================================================
;char GetKey()
; 0000 0155 {
_GetKey:
; .FSTART _GetKey
; 0000 0156 unsigned char key_code = 0xFF;
; 0000 0157 unsigned char columns;
; 0000 0158 
; 0000 0159 PORTC = 0xFF;
	ST   -Y,R17
	ST   -Y,R16
;	key_code -> R17
;	columns -> R16
	LDI  R17,255
	LDI  R30,LOW(255)
	OUT  0x15,R30
; 0000 015A // first row
; 0000 015B PORTC.4 = 0;
	CBI  0x15,4
; 0000 015C columns = PINC & 0x07;
	CALL SUBOPT_0x1D
; 0000 015D if(columns != 0x07)
	BREQ _0x3D
; 0000 015E   {
; 0000 015F   switch(columns)
	CALL SUBOPT_0x1E
; 0000 0160     {
; 0000 0161     case 0b110 : key_code = 1; break;
	BRNE _0x41
	LDI  R17,LOW(1)
	RJMP _0x40
; 0000 0162     case 0b101 : key_code = 2; break;
_0x41:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x42
	LDI  R17,LOW(2)
	RJMP _0x40
; 0000 0163     case 0b011 : key_code = 3; break;
_0x42:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x40
	LDI  R17,LOW(3)
; 0000 0164     }
_0x40:
; 0000 0165   }
; 0000 0166 PORTC.4 = 1;
_0x3D:
	SBI  0x15,4
; 0000 0167 // second row
; 0000 0168 PORTC.5 = 0;
	CBI  0x15,5
; 0000 0169 columns = PINC & 0x07;
	CALL SUBOPT_0x1D
; 0000 016A if(columns != 0x07)
	BREQ _0x48
; 0000 016B   {
; 0000 016C   switch(columns)
	CALL SUBOPT_0x1E
; 0000 016D     {
; 0000 016E     case 0b110 : key_code = 4; break;
	BRNE _0x4C
	LDI  R17,LOW(4)
	RJMP _0x4B
; 0000 016F     case 0b101 : key_code = 5; break;
_0x4C:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x4D
	LDI  R17,LOW(5)
	RJMP _0x4B
; 0000 0170     case 0b011 : key_code = 6; break;
_0x4D:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x4B
	LDI  R17,LOW(6)
; 0000 0171     }
_0x4B:
; 0000 0172   }
; 0000 0173 PORTC.5 = 1;
_0x48:
	SBI  0x15,5
; 0000 0174 // third row
; 0000 0175 PORTC.6 = 0;
	CBI  0x15,6
; 0000 0176 columns = PINC & 0x07;
	CALL SUBOPT_0x1D
; 0000 0177 if(columns != 0x07)
	BREQ _0x53
; 0000 0178   {
; 0000 0179   switch(columns)
	CALL SUBOPT_0x1E
; 0000 017A     {
; 0000 017B     case 0b110 : key_code = 7; break;
	BRNE _0x57
	LDI  R17,LOW(7)
	RJMP _0x56
; 0000 017C     case 0b101 : key_code = 8; break;
_0x57:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x58
	LDI  R17,LOW(8)
	RJMP _0x56
; 0000 017D     case 0b011 : key_code = 9; break;
_0x58:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x56
	LDI  R17,LOW(9)
; 0000 017E     }
_0x56:
; 0000 017F   }
; 0000 0180 PORTC.6 = 1;
_0x53:
	SBI  0x15,6
; 0000 0181 // fourth row
; 0000 0182 PORTC.7 = 0;
	CBI  0x15,7
; 0000 0183 if(!PINC.1) key_code = 0;
	SBIS 0x13,1
	LDI  R17,LOW(0)
; 0000 0184 PORTC.7 = 1;
	SBI  0x15,7
; 0000 0185 
; 0000 0186 PORTC = 0x0F;
	LDI  R30,LOW(15)
	OUT  0x15,R30
; 0000 0187 return key_code;
	MOV  R30,R17
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 0188 }
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
	ST   -Y,R27
	ST   -Y,R26
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
	CALL SUBOPT_0x1F
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	CALL SUBOPT_0x1F
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
	CALL SUBOPT_0x20
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x21
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	CALL SUBOPT_0x20
	CALL SUBOPT_0x22
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	CALL SUBOPT_0x20
	CALL SUBOPT_0x22
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
	CALL SUBOPT_0x20
	CALL SUBOPT_0x23
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
	CALL SUBOPT_0x20
	CALL SUBOPT_0x23
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
	CALL SUBOPT_0x1F
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
	CALL SUBOPT_0x1F
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
	CALL SUBOPT_0x21
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	CALL SUBOPT_0x1F
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
	CALL SUBOPT_0x21
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
	CALL SUBOPT_0x24
	SBIW R30,0
	BRNE _0x2000072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0004
_0x2000072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x24
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
_0x20C0004:
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
_itoa:
; .FSTART _itoa
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    ld   r30,y+
    ld   r31,y+
    adiw r30,0
    brpl __itoa0
    com  r30
    com  r31
    adiw r30,1
    ldi  r22,'-'
    st   x+,r22
__itoa0:
    clt
    ldi  r24,low(10000)
    ldi  r25,high(10000)
    rcall __itoa1
    ldi  r24,low(1000)
    ldi  r25,high(1000)
    rcall __itoa1
    ldi  r24,100
    clr  r25
    rcall __itoa1
    ldi  r24,10
    rcall __itoa1
    mov  r22,r30
    rcall __itoa5
    clr  r22
    st   x,r22
    ret

__itoa1:
    clr	 r22
__itoa2:
    cp   r30,r24
    cpc  r31,r25
    brlo __itoa3
    inc  r22
    sub  r30,r24
    sbc  r31,r25
    brne __itoa2
__itoa3:
    tst  r22
    brne __itoa4
    brts __itoa5
    ret
__itoa4:
    set
__itoa5:
    subi r22,-0x30
    st   x+,r22
    ret
; .FEND

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
_0x20C0003:
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x25
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x25
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
	RJMP _0x20C0002
; .FEND
_lcd_putsf:
; .FSTART _lcd_putsf
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x206000B:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x206000D
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x206000B
_0x206000D:
_0x20C0002:
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
	CALL SUBOPT_0x26
	CALL SUBOPT_0x26
	CALL SUBOPT_0x26
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
_badje1:
	.BYTE 0x2
_badje2:
	.BYTE 0x2
_badje3:
	.BYTE 0x2
_badje4:
	.BYTE 0x2
_badje5:
	.BYTE 0x2
_badje6:
	.BYTE 0x2
_badje7:
	.BYTE 0x2
_namayesh:
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
_str2:
	.BYTE 0xA
_str3:
	.BYTE 0x11
_reset:
	.BYTE 0x2
_saat_yekonim:
	.BYTE 0x2
_str1:
	.BYTE 0xA
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
	STS  _badje1,R30
	STS  _badje1+1,R31
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _namayesh,R30
	STS  _namayesh+1,R31
	ST   -Y,R13
	ST   -Y,R12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _badje2,R30
	STS  _badje2+1,R31
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _badje3,R30
	STS  _badje3+1,R31
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _badje4,R30
	STS  _badje4+1,R31
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _badje5,R30
	STS  _badje5+1,R31
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _namayesh,R30
	STS  _namayesh+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x9:
	STS  _namayesh,R30
	STS  _namayesh+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _badje6,R30
	STS  _badje6+1,R31
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
	JMP  _LCD_namayesh_go_to_badje

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xD:
	SUB  R30,R26
	SBC  R31,R27
	ST   Y,R30
	STD  Y+1,R31
	LD   R26,Y
	LDD  R27,Y+1
	CALL _LCD_namayesh_entezar
	ADIW R28,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _badje7,R30
	STS  _badje7+1,R31
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
	JMP  _LCD_namayesh_go_to_badje

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(0)
	STS  _badje1,R30
	STS  _badje1+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(0)
	STS  _badje2,R30
	STS  _badje2+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(0)
	STS  _badje3,R30
	STS  _badje3+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	LDI  R30,LOW(0)
	STS  _badje4,R30
	STS  _badje4+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(0)
	STS  _badje5,R30
	STS  _badje5+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x16:
	LDI  R30,LOW(0)
	STS  _badje6,R30
	STS  _badje6+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x17:
	LDI  R30,LOW(0)
	STS  _badje7,R30
	STS  _badje7+1,R30
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1B:
	CALL _lcd_puts
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
	JMP  _lcd_clear

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	IN   R30,0x13
	ANDI R30,LOW(0x7)
	MOV  R16,R30
	CPI  R16,7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1E:
	MOV  R30,R16
	LDI  R31,0
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1F:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x20:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x21:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x22:
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
SUBOPT_0x23:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x26:
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
