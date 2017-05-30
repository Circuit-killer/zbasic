////////////////////////////////////////////////////////////////////////////////
//
// Filename:	./regdefs.h
//
// Project:	ZBasic, a generic toplevel implementation using the full ZipCPU
//
// DO NOT EDIT THIS FILE!
// Computer Generated: This file is computer generated by AUTOFPGA. DO NOT EDIT.
// DO NOT EDIT THIS FILE!
//
// CmdLine:	../../../autofpga/trunk/sw/autofpga ../../../autofpga/trunk/sw/autofpga -o . global.txt bkram.txt buserr.txt clock.txt dlyarbiter.txt flash.txt rtclight.txt rtcdate.txt pic.txt pwrcount.txt rtclight.txt version.txt busconsole.txt zipmaster.txt sdspi.txt
//
// Creator:	Dan Gisselquist, Ph.D.
//		Gisselquist Technology, LLC
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2017, Gisselquist Technology, LLC
//
// This program is free software (firmware): you can redistribute it and/or
// modify it under the terms of  the GNU General Public License as published
// by the Free Software Foundation, either version 3 of the License, or (at
// your option) any later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTIBILITY or
// FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
// for more details.
//
// You should have received a copy of the GNU General Public License along
// with this program.  (It's in the $(ROOT)/doc directory.  Run make with no
// target there if the PDF file isn't present.)  If not, see
// <http://www.gnu.org/licenses/> for a copy.
//
// License:	GPL, v3, as defined and found on www.gnu.org,
//		http://www.gnu.org/licenses/gpl.html
//
//
////////////////////////////////////////////////////////////////////////////////
//
//
#ifndef	REGDEFS_H
#define	REGDEFS_H


//
// The @REGDEFS.H.INCLUDE tag
//
// @REGDEFS.H.INCLUDE for masters
// @REGDEFS.H.INCLUDE for peripherals
// And finally any master REGDEFS.H.INCLUDE tags
// End of definitions from REGDEFS.H.INCLUDE


//
// Register address definitions, from @REGS.#d
//
#define	R_BUSERR        	0x00000400	// 00000400, wbregs names: BUSERR
#define	R_PIC           	0x00000404	// 00000404, wbregs names: PIC
#define	R_DATE          	0x00000408	// 00000408, wbregs names: RTCDATE, DATE
#define	PWCOUNT         	0x0000040c	// 0000040c, wbregs names: PWRCOUNT
#define	R_VERSION       	0x00000410	// 00000410, wbregs names: VERSION


// SD-SPI addresses
#define	R_SDSPI_CTRL    	0x00000440	// 00000440, wbregs names: SDCARD
#define	R_SDSPI_DATA    	0x00000444	// 00000440, wbregs names: SDDATA
#define	R_SDSPI_FIFOA   	0x00000448	// 00000440, wbregs names: SDFIFOA, SDFIF0, SDFIFA
#define	R_SDSPI_FIFOB   	0x0000044c	// 00000440, wbregs names: SDFIFOB, SDFIF1, SDFIFB
// RTC clock registers
#define	R_CLOCK         	0x00000460	// 00000460, wbregs names: CLOCK, TIMER
#define	R_TIMER         	0x00000464	// 00000460, wbregs names: TIMER
#define	R_STOPWATCH     	0x00000468	// 00000460, wbregs names: STOPWATCH
#define	R_CKALARM       	0x0000046c	// 00000460, wbregs names: ALARM, CKALARM


// SDSPI Debugging scope
#define	R_SDSPI_SCOPC   	0x00000480	// 00000480, wbregs names: SDSCOPC, SDSCOPE
#define	R_SDSPI_SCOPD   	0x00000484	// 00000480, wbregs names: SDSCOPD
// FLASH erase/program configuration registers
#define	R_QSPI_EREG     	0x00000490	// 00000490, wbregs names: QSPIE
#define	R_QSPI_CREG     	0x00000494	// 00000490, wbregs names: QSPIC
#define	R_QSPI_SREG     	0x00000498	// 00000490, wbregs names: QSPIS
#define	R_QSPI_IDREG    	0x0000049c	// 00000490, wbregs names: QSPII
// CONSOLE registers
#define	R_CONSOLE_FIFO  	0x000004a4	// 000004a0, wbregs names: UFIFO
#define	R_CONSOLE_UARTRX	0x000004a8	// 000004a0, wbregs names: RX
#define	R_CONSOLE_UARTTX	0x000004ac	// 000004a0, wbregs names: TX
#define	BKRAM           	0x00100000	// 00100000, wbregs names: RAM
#define	FLASHMEM        	0x01000000	// 01000000, wbregs names: FLASH


//
// The @REGDEFS.H.DEFNS tag
//
// @REGDEFS.H.DEFNS for masters
#define	CLKFREQHZ	100000000
#define	R_ZIPCTRL	0x80000000
#define	R_ZIPDATA	0x80000004
#define	RESET_ADDRESS	0x01000000
// @REGDEFS.H.DEFNS for peripherals
#define	BKMEMBASE	1048576
#define	BKMEMLEN	0x00100000
#define	FLASHBASE	16777216
#define	FLASHLEN	0x01000000
#define	FLASHLGLEN	24
// @REGDEFS.H.DEFNS at the top level
// End of definitions from REGDEFS.H.DEFNS
//
// The @REGDEFS.H.INSERT tag
//
// @REGDEFS.H.INSERT for masters

#define	CPU_GO		0x0000
#define	CPU_RESET	0x0040
#define	CPU_INT		0x0080
#define	CPU_STEP	0x0100
#define	CPU_STALL	0x0200
#define	CPU_HALT	0x0400
#define	CPU_CLRCACHE	0x0800
#define	CPU_sR0		0x0000
#define	CPU_sSP		0x000d
#define	CPU_sCC		0x000e
#define	CPU_sPC		0x000f
#define	CPU_uR0		0x0010
#define	CPU_uSP		0x001d
#define	CPU_uCC		0x001e
#define	CPU_uPC		0x001f


// @REGDEFS.H.INSERT for peripherals
// Flash control constants
#define	ERASEFLAG	0x80000000
#define	DISABLEWP	0x10000000
#define	ENABLEWP	0x00000000

#define	SZPAGEB		256
#define	PGLENB		256
#define	SZPAGEW		64
#define	PGLENW		64
#define	NPAGES		256
#define	SECTORSZB	(NPAGES * SZPAGEB)	// In bytes, not words!!
#define	SECTORSZW	(NPAGES * SZPAGEW)	// In words
#define	NSECTORS	64
#define	SECTOROF(A)	((A) & (-1<<16))
#define	SUBSECTOROF(A)	((A) & (-1<<12))
#define	PAGEOF(A)	((A) & (-1<<8))


#define	R_ICONTROL	R_PIC
#define	ISPIF_EN	0x80010001
#define	ISPIF_DIS	0x00010001
#define	ISPIF_CLR	0x00000001
// @REGDEFS.H.INSERT from the top level
typedef	struct {
	unsigned	m_addr;
	const char	*m_name;
} REGNAME;

extern	const	REGNAME	*bregs;
extern	const	int	NREGS;
// #define	NREGS	(sizeof(bregs)/sizeof(bregs[0]))

extern	unsigned	addrdecode(const char *v);
extern	const	char *addrname(const unsigned v);
// End of definitions from REGDEFS.H.INSERT


#endif	// REGDEFS_H
