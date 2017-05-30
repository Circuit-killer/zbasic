////////////////////////////////////////////////////////////////////////////////
//
// Filename:	bootloader.h
//
// Project:	Zip CPU -- a small, lightweight, RISC CPU soft core
//
// Purpose:	
//
//
// Creator:	Dan Gisselquist, Ph.D.
//		Gisselquist Technology, LLC
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2015-2016, Gisselquist Technology, LLC
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
// License:	GPL, v3, as defined and found on www.gnu.org,
//		http://www.gnu.org/licenses/gpl.html
//
//
////////////////////////////////////////////////////////////////////////////////
//
//
#ifndef	BOOTLOADER_H
#define	BOOTLOADER_H

extern	int	_top_of_heap[1], _top_of_stack[1];
extern	int	_boot_address[1];

#ifdef	_BOARD_HAS_BKRAM
#ifdef	_BOARD_HAS_SDRAM
extern	int	_kernel_image_start[1], _kernel_image_end[1],
#define	_BOARD_HAS_KERNEL_SPACE
#endif
#endif


#ifndef	_BOARD_HAS_KERNEL_SPACE
#ifndef	_ram

#ifdef	_BOARD_HAS_BKRAM
#define	_ram	_bkram
#elif	defined(_BOARD_HAS_SDRAM)
#define	_ram	_sdram
#endif

#endif	// _ram
#endif	// _BOARD_HAS_KERNEL_SPACE


extern	int	_ram_image_start[1], _ram_image_end[1],
		_bss_image_end[1];

#endif