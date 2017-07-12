////////////////////////////////////////////////////////////////////////////////
//
// Filename:	./main.v
//
// Project:	ZBasic, a generic toplevel implementation using the full ZipCPU
//
// DO NOT EDIT THIS FILE!
// Computer Generated: This file is computer generated by AUTOFPGA. DO NOT EDIT.
// DO NOT EDIT THIS FILE!
//
// CmdLine:	../../../autofpga/trunk/sw/autofpga ../../../autofpga/trunk/sw/autofpga -o . global.txt bkram.txt buserr.txt clock.txt dlyarbiter.txt flash.txt rtclight.txt rtcdate.txt pic.txt pwrcount.txt version.txt busconsole.txt zipmaster.txt sdspi.txt
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
`default_nettype	none
//
//
// Here is a list of defines which may be used, post auto-design
// (not post-build), to turn particular peripherals (and bus masters)
// on and off.  In particular, to turn off support for a particular
// design component, just comment out its respective `define below.
//
// These lines are taken from the respective @ACCESS tags for each of our
// components.  If a component doesn't have an @ACCESS tag, it will not
// be listed here.
//
// First, the independent access fields for any bus masters
`define	WBUBUS_MASTER
`define	INCLUDE_ZIPCPU
// And then for the independent peripherals
`define	SDSPI_ACCESS
`define	FLASH_ACCESS
`define	BUSPIC_ACCESS
`define	BKRAM_ACCESS
`define	RTC_ACCESS
`define	FLASH_ACCESS
`define	BUSCONSOLE_ACCESS
//
//
// The list of those things that have @DEPENDS tags
//
//
// Dependencies are listed within the @DEPENDS tag
// Values prefixed by a !, yet with no spaces between the ! and the
// dependency, are ifndef dependencies.  As an example, an
// an access and depends tag such as:
//
// @ACCESS=  THIS_COMPONENT
// @DEPENDS= MUST_HAVE_A !MUST_NOT_HAVE_B
//
// will turn into:
//
// `ifdef MUST_HAVE_A
// `ifndef MUST_NOT_HAVE_B
// `define THIS_COMPONENT
// `endif // MUST_NOT_HAVE_B
// `endif // MUST_HAVE_A
//
`ifndef	RTC_ACCESS
`define	RTCDATE_ACCESS
`endif
`ifndef	SDSPI_ACCESS
`define	SDSPI_SCOPE
`endif
//
// End of dependency list
//
//
//
//
// Finally, we define our main module itself.  We start with the list of
// I/O ports, or wires, passed into (or out of) the main function.
//
// These fields are copied verbatim from the respective I/O port lists,
// from the fields given by @MAIN.PORTLIST
//
module	main(i_clk, i_reset,
		// The SD-Card wires
		o_sd_sck, o_sd_cmd, o_sd_data, i_sd_cmd, i_sd_data, i_sd_detect,
		// The QSPI Flash
		o_qspi_cs_n, o_qspi_sck, o_qspi_dat, i_qspi_dat, o_qspi_mod,
		// Command and Control port
		i_host_rx_stb, i_host_rx_data,
		o_host_tx_stb, o_host_tx_data, i_host_tx_busy,
		i_cpu_reset);
//
// Any parameter definitions
//
// These are drawn from anything with a MAIN.PARAM definition.
// As they aren't connected to the toplevel at all, it would
// be best to use localparam over parameter, but here we don't
// check
	//
	//
	// Variables/definitions needed by the ZipCPU BUS master
	//
	//
	// A 32-bit address indicating where teh ZipCPU should start running
	// from
	localparam	RESET_ADDRESS = 32'h01000000;
	//
	// The number of valid bits on the bus
	localparam	ZIP_ADDRESS_WIDTH = 23;	// Zip-CPU address width
	//
	// Number of ZipCPU interrupts
	localparam	ZIP_INTS = 16;
	//
	// ZIP_START_HALTED
	//
	// A boolean, indicating whether or not the ZipCPU be halted on startup?
	localparam	ZIP_START_HALTED=1'b1;
//
// The next step is to declare all of the various ports that were just
// listed above.  
//
// The following declarations are taken from the values of the various
// @MAIN.IODECL keys.
//
	input	wire		i_clk;
// verilator lint_off UNUSED
	input	wire		i_reset;
	// verilator lint_on UNUSED
	// SD-Card declarations
	output	wire		o_sd_sck, o_sd_cmd;
	output	wire	[3:0]	o_sd_data;
	// verilator lint_off UNUSED
	input	wire		i_sd_cmd;
	input	wire	[3:0]	i_sd_data;
	input	wire		i_sd_detect;
	// verilator lint_on  UNUSED
	// The QSPI flash
	output	wire		o_qspi_cs_n, o_qspi_sck;
	output	wire	[3:0]	o_qspi_dat;
	input	wire	[3:0]	i_qspi_dat;
	output	wire	[1:0]	o_qspi_mod;
	input	wire		i_host_rx_stb;
	input	wire	[7:0]	i_host_rx_data;
	output	wire		o_host_tx_stb;
	output	wire	[7:0]	o_host_tx_data;
	input	wire		i_host_tx_busy;
	input	wire		i_cpu_reset;
	// Make Verilator happy ... defining bus wires for lots of components
	// often ends up with unused wires lying around.  We'll turn off
	// Verilator's lint warning here that checks for unused wires.
	// verilator lint_off UNUSED



	//
	// Declaring interrupt lines
	//
	// These declarations come from the various components values
	// given under the @INT.<interrupt name>.WIRE key.
	//
	wire	sdcard_int;	// sdcard.INT.SDCARD.WIRE
	wire	w_bus_int;	// buspic.INT.BUS.WIRE
	wire	rtc_int;	// rtc.INT.RTC.WIRE
	wire	flash_interrupt;	// flash.INT.FLASH.WIRE
	wire	scope_sdcard_int;	// scope_sdcard.INT.SDSCOPE.WIRE
	wire	zip_cpu_int;	// zip.INT.ZIP.WIRE
	wire	uarttxf_int;	// uart.INT.UARTTXF.WIRE
	wire	uartrxf_int;	// uart.INT.UARTRXF.WIRE
	wire	uarttx_int;	// uart.INT.UARTTX.WIRE
	wire	uartrx_int;	// uart.INT.UARTRX.WIRE


	//
	// Component declarations
	//
	// These declarations come from the @MAIN.DEFNS keys found in the
	// various components comprising the design.
	//
// Looking for string: MAIN.DEFNS
	wire[31:0]	sdspi_debug;
	// Bus arbiter's internal lines
	wire		dwbi_cyc, dwbi_stb, dwbi_we,
			dwbi_ack, dwbi_stall, dwbi_err;
	wire	[(23-1):0]	dwbi_addr;
	wire	[31:0]	dwbi_odata, dwbi_idata;
	wire	[3:0]	dwbi_sel;
	// Definitions in support of the GPS driven RTC
	wire	rtc_ppd;
	reg	r_rtc_ack;
	wire	scope_sdcard_trigger,
		scope_sdcard_ce;
	// Definitions for the WB-UART converter.  We really only need one
	// (more) non-bus wire--one to use to select if we are interacting
	// with the ZipCPU or not.
	wire	[0:0]	wbubus_dbg;
`ifndef	INCLUDE_ZIPCPU
	//
	// The bus-console depends upon the zip_dbg wires.  If there is no
	// ZipCPU defining them, we'll need to define them here anyway.
	//
	wire		zip_dbg_ack, zip_dbg_stall;
	wire	[31:0]	zip_dbg_data;
`endif
	// ZipSystem/ZipCPU connection definitions
	// All we define here is a set of scope wires
	wire	[31:0]	zip_debug;
	wire		zip_trigger;
	wire	[15:0] zip_int_vector;
`include "builddate.v"
	reg	[23-1:0]	r_buserr_addr;
	// Console definitions
	wire	w_console_rx_stb, w_console_tx_stb, w_console_busy;
	wire	[6:0]	w_console_rx_data, w_console_tx_data;
	reg	[31:0]	r_pwrcount_data;


	//
	// Declaring interrupt vector wires
	//
	// These declarations come from the various components having
	// PIC and PIC.MAX keys.
	//
	wire	[14:0]	bus_int_vector;
	wire	[14:0]	sys_int_vector;
	wire	[14:0]	alt_int_vector;
//
//
// Define bus wires
//
//
	// Bus wb
	// Wishbone master wire definitions for bus: wb
	wire		wb_cyc, wb_stb, wb_we, wb_stall, wb_err;
	wire		wb_none_sel, wb_many_ack;
	wire	[22:0]	wb_addr;
	wire	[31:0]	wb_data, wb_idata;
	wire	[3:0]	wb_sel;
	reg		wb_ack;

	// Wishbone slave definitions for bus wb(SIO), slave buserr
	wire		buserr_sel, buserr_ack, buserr_stall;
	wire	[31:0]	buserr_data;

	// Wishbone slave definitions for bus wb(SIO), slave buspic
	wire		buspic_sel, buspic_ack, buspic_stall;
	wire	[31:0]	buspic_data;

	// Wishbone slave definitions for bus wb(SIO), slave date
	wire		date_sel, date_ack, date_stall;
	wire	[31:0]	date_data;

	// Wishbone slave definitions for bus wb(SIO), slave pwrcount
	wire		pwrcount_sel, pwrcount_ack, pwrcount_stall;
	wire	[31:0]	pwrcount_data;

	// Wishbone slave definitions for bus wb(SIO), slave version
	wire		version_sel, version_ack, version_stall;
	wire	[31:0]	version_data;

	// Wishbone slave definitions for bus wb, slave scope_sdcard
	wire		scope_sdcard_sel, scope_sdcard_ack, scope_sdcard_stall;
	wire	[31:0]	scope_sdcard_data;

	// Wishbone slave definitions for bus wb, slave flctl
	wire		flctl_sel, flctl_ack, flctl_stall;
	wire	[31:0]	flctl_data;

	// Wishbone slave definitions for bus wb, slave sdcard
	wire		sdcard_sel, sdcard_ack, sdcard_stall;
	wire	[31:0]	sdcard_data;

	// Wishbone slave definitions for bus wb, slave uart
	wire		uart_sel, uart_ack, uart_stall;
	wire	[31:0]	uart_data;

	// Wishbone slave definitions for bus wb, slave rtc
	wire		rtc_sel, rtc_ack, rtc_stall;
	wire	[31:0]	rtc_data;

	// Wishbone slave definitions for bus wb, slave wb_sio
	wire		wb_sio_sel, wb_sio_ack, wb_sio_stall;
	wire	[31:0]	wb_sio_data;

	// Wishbone slave definitions for bus wb, slave bkram
	wire		bkram_sel, bkram_ack, bkram_stall;
	wire	[31:0]	bkram_data;

	// Wishbone slave definitions for bus wb, slave flash
	wire		flash_sel, flash_ack, flash_stall;
	wire	[31:0]	flash_data;

	// Bus wbu
	// Wishbone master wire definitions for bus: wbu
	wire		wbu_cyc, wbu_stb, wbu_we, wbu_stall, wbu_err;
	wire		wbu_none_sel, wbu_many_ack;
	wire	[23:0]	wbu_addr;
	wire	[31:0]	wbu_data, wbu_idata;
	wire	[3:0]	wbu_sel;
	reg		wbu_ack;

	// Wishbone slave definitions for bus wbu, slave wbu_dwb
	wire		wbu_dwb_sel, wbu_dwb_ack, wbu_dwb_stall, wbu_dwb_err;
	wire	[31:0]	wbu_dwb_data;

	// Wishbone slave definitions for bus wbu, slave zip_dbg
	wire		zip_dbg_sel, zip_dbg_ack, zip_dbg_stall;
	wire	[31:0]	zip_dbg_data;

	// Bus zip
	// Wishbone master wire definitions for bus: zip
	wire		zip_cyc, zip_stb, zip_we, zip_stall, zip_err;
	wire		zip_none_sel, zip_many_ack;
	wire	[22:0]	zip_addr;
	wire	[31:0]	zip_data, zip_idata;
	wire	[3:0]	zip_sel;
	reg		zip_ack;

	// Wishbone slave definitions for bus zip, slave zip_dwb
	wire		zip_dwb_sel, zip_dwb_ack, zip_dwb_stall, zip_dwb_err;
	wire	[31:0]	zip_dwb_data;


	//
	// Peripheral address decoding
	//
	//
	//
	//
	// Select lines for bus: wb
	//
	// Address width: 23
	//
	//
	
	assign	      buserr_sel = ((wb_sio_sel)&&(wb_addr[ 2: 0] ==  3'h0));
	assign	      buspic_sel = ((wb_sio_sel)&&(wb_addr[ 2: 0] ==  3'h1));
	assign	        date_sel = ((wb_sio_sel)&&(wb_addr[ 2: 0] ==  3'h2));
	assign	    pwrcount_sel = ((wb_sio_sel)&&(wb_addr[ 2: 0] ==  3'h3));
	assign	     version_sel = ((wb_sio_sel)&&(wb_addr[ 2: 0] ==  3'h4));
	assign	scope_sdcard_sel = ((wb_addr[22:19] &  4'hf) ==  4'h1);
	assign	       flctl_sel = ((wb_addr[22:19] &  4'hf) ==  4'h2);
	assign	      sdcard_sel = ((wb_addr[22:19] &  4'hf) ==  4'h3);
	assign	        uart_sel = ((wb_addr[22:19] &  4'hf) ==  4'h4);
	assign	         rtc_sel = ((wb_addr[22:19] &  4'hf) ==  4'h5);
	assign	      wb_sio_sel = ((wb_addr[22:19] &  4'hf) ==  4'h6);
//x2	Was a master bus as well
	assign	       bkram_sel = ((wb_addr[22:19] &  4'hf) ==  4'h7);
	assign	       flash_sel = ((wb_addr[22:19] &  4'h8) ==  4'h8);
	//

	//
	//
	//
	// Select lines for bus: wbu
	//
	// Address width: 24
	//
	//
	
	assign	     wbu_dwb_sel = ((wbu_addr[23:23] &  1'h1) ==  1'h0);
	assign	     zip_dbg_sel = ((wbu_addr[23:23] &  1'h1) ==  1'h1);
	//

	//
	//
	//
	// Select lines for bus: zip
	//
	// Address width: 23
	//
	//
	
	assign	     zip_dwb_sel = (zip_cyc); // Only one peripheral on this bus
	//

	//
	// BUS-LOGIC for wb
	//
	assign	wb_none_sel = (wb_stb)&&({
				scope_sdcard_sel,
				flctl_sel,
				sdcard_sel,
				uart_sel,
				rtc_sel,
				wb_sio_sel,
				bkram_sel,
				flash_sel} == 0);

	//
	// many_ack
	//
	// It is also a violation of the bus protocol to produce multiply
	// acks at once and on the same clock.  In that case, the bus
	// can't decide which result to return.  Worse, if someone is waiting
	// for a return value, that value will never come since another ack
	// masked it.
	//
	// The other error that isn't tested for here, no would I necessarily
	// know how to test for it, is when peripherals return values out of
	// order.  Instead, I propose keeping that from happening by
	// guaranteeing, in software, that two peripherals are not accessed
	// immediately one after the other.
	//
	always @(posedge i_clk)
		case({		scope_sdcard_ack,
				flctl_ack,
				sdcard_ack,
				uart_ack,
				rtc_ack,
				wb_sio_ack,
				bkram_ack,
				flash_ack})
			8'b00000000: wb_many_ack <= 1'b0;
			8'b10000000: wb_many_ack <= 1'b0;
			8'b01000000: wb_many_ack <= 1'b0;
			8'b00100000: wb_many_ack <= 1'b0;
			8'b00010000: wb_many_ack <= 1'b0;
			8'b00001000: wb_many_ack <= 1'b0;
			8'b00000100: wb_many_ack <= 1'b0;
			8'b00000010: wb_many_ack <= 1'b0;
			8'b00000001: wb_many_ack <= 1'b0;
			default: wb_many_ack <= (wb_cyc);
		endcase

	assign	wb_sio_stall = 1'b0;
	initial r_wb_sio_ack = 1'b0;
	always	@(posedge i_clk)
		r_wb_sio_ack <= (wb_stb)&&(wb_sio_sel);
	assign	wb_sio_ack = r_wb_sio_ack;
	reg	r_wb_sio_ack;
	always	@(posedge i_clk)
		// mask        = 00000007
		// lgdw        = 2
		// unused_lsbs = 0
		casez( wb_addr[2:0] )
			3'h0: wb_sio_data <= buserr_data;
			3'h1: wb_sio_data <= buspic_data;
			3'h2: wb_sio_data <= date_data;
			3'h3: wb_sio_data <= pwrcount_data;
			default: wb_sio_data <= version_data;
		endcase

	//
	// Finally, determine what the response is from the wb bus
	// bus
	//
	//
	//
	// wb_ack
	//
	// The returning wishbone ack is equal to the OR of every component that
	// might possibly produce an acknowledgement, gated by the CYC line.
	//
	// To return an ack here, a component must have a @SLAVE.TYPE tag.
	// Acks from any @SLAVE.TYPE of SINGLE and DOUBLE components have been
	// collected together (above) into wb_sio_ack and wb_dio_ack
	// respectively, which will appear ahead of any other device acks.
	//
	always @(posedge i_clk)
		wb_ack <= (wb_cyc)&&(|{ scope_sdcard_ack,
				flctl_ack,
				sdcard_ack,
				uart_ack,
				rtc_ack,
				wb_sio_ack,
				bkram_ack,
				flash_ack });
	//
	// wb_idata
	//
	// This is the data returned on the bus.  Here, we select between a
	// series of bus sources to select what data to return.  The basic
	// logic is simply this: the data we return is the data for which the
	// ACK line is high.
	//
	// The last item on the list is chosen by default if no other ACK's are
	// true.  Although we might choose to return zeros in that case, by
	// returning something we can skimp a touch on the logic.
	//
	// Any peripheral component with a @SLAVE.TYPE value will be listed
	// here.
	//
	always @(posedge i_clk)
	begin
		casez({		scope_sdcard_ack,
				flctl_ack,
				sdcard_ack,
				uart_ack,
				rtc_ack,
				wb_sio_ack,
				bkram_ack	})
			7'b1??????: wb_idata <= scope_sdcard_data;
			7'b01?????: wb_idata <= flctl_data;
			7'b001????: wb_idata <= sdcard_data;
			7'b0001???: wb_idata <= uart_data;
			7'b00001??: wb_idata <= rtc_data;
			7'b000001?: wb_idata <= wb_sio_data;
			7'b0000001: wb_idata <= bkram_data;
			default: wb_idata <= flash_data;
		endcase
	end
	assign	wb_stall =	((scope_sdcard_sel)&&(scope_sdcard_stall))
				||((flctl_sel)&&(flctl_stall))
				||((sdcard_sel)&&(sdcard_stall))
				||((uart_sel)&&(uart_stall))
				||((rtc_sel)&&(rtc_stall))
				||((wb_sio_sel)&&(wb_sio_stall))
				||((bkram_sel)&&(bkram_stall))
				||((flash_sel)&&(flash_stall));

	assign wb_err = ((wb_stb)&&(wb_none_sel))||(wb_many_ack);
	//
	// BUS-LOGIC for wbu
	//
	assign	wbu_none_sel = (wbu_stb)&&({
				wbu_dwb_sel,
				zip_dbg_sel} == 0);

	//
	// many_ack
	//
	// It is also a violation of the bus protocol to produce multiply
	// acks at once and on the same clock.  In that case, the bus
	// can't decide which result to return.  Worse, if someone is waiting
	// for a return value, that value will never come since another ack
	// masked it.
	//
	// The other error that isn't tested for here, no would I necessarily
	// know how to test for it, is when peripherals return values out of
	// order.  Instead, I propose keeping that from happening by
	// guaranteeing, in software, that two peripherals are not accessed
	// immediately one after the other.
	//
	always @(posedge i_clk)
		case({		wbu_dwb_ack,
				zip_dbg_ack})
			2'b00: wbu_many_ack <= 1'b0;
			2'b10: wbu_many_ack <= 1'b0;
			2'b01: wbu_many_ack <= 1'b0;
			default: wbu_many_ack <= (wbu_cyc);
		endcase

	//
	// Finally, determine what the response is from the wbu bus
	// bus
	//
	//
	//
	// wbu_ack
	//
	// The returning wishbone ack is equal to the OR of every component that
	// might possibly produce an acknowledgement, gated by the CYC line.
	//
	// To return an ack here, a component must have a @SLAVE.TYPE tag.
	// Acks from any @SLAVE.TYPE of SINGLE and DOUBLE components have been
	// collected together (above) into wbu_sio_ack and wbu_dio_ack
	// respectively, which will appear ahead of any other device acks.
	//
	always @(posedge i_clk)
		wbu_ack <= (wbu_cyc)&&(|{ wbu_dwb_ack,
				zip_dbg_ack });
	//
	// wbu_idata
	//
	// This is the data returned on the bus.  Here, we select between a
	// series of bus sources to select what data to return.  The basic
	// logic is simply this: the data we return is the data for which the
	// ACK line is high.
	//
	// The last item on the list is chosen by default if no other ACK's are
	// true.  Although we might choose to return zeros in that case, by
	// returning something we can skimp a touch on the logic.
	//
	// Any peripheral component with a @SLAVE.TYPE value will be listed
	// here.
	//
	always @(posedge i_clk)
		if (wbu_dwb_ack)
			wbu_idata <= wbu_dwb_data;
		else
			wbu_idata <= zip_dbg_data;
	assign	wbu_stall =	((wbu_dwb_sel)&&(wbu_dwb_stall))
				||((zip_dbg_sel)&&(zip_dbg_stall));

	assign wbu_err = ((wbu_stb)&&(wbu_none_sel))||(wbu_many_ack)||((wbu_dwb_err));
	//
	// BUS-LOGIC for zip
	//
	assign	zip_none_sel = 1'b0;
	always @(*)
		zip_many_ack = 1'b0;
	assign	zip_err = zip_dwb_err;
	assign	zip_stall = zip_dwb_stall;
	always @(*)
		zip_ack = zip_dwb_ack;
	always @(*)
		zip_idata = zip_dwb_data;
	//
	// Declare the interrupt busses
	//
	// Interrupt busses are defined by anything with a @PIC tag.
	// The @PIC.BUS tag defines the name of the wire bus below,
	// while the @PIC.MAX tag determines the size of the bus width.
	//
	// For your peripheral to be assigned to this bus, it must have an
	// @INT.NAME.WIRE= tag to define the wire name of the interrupt line,
	// and an @INT.NAME.PIC= tag matching the @PIC.BUS tag of the bus
	// your interrupt will be assigned to.  If an @INT.NAME.ID tag also
	// exists, then your interrupt will be assigned to the position given
	// by the ID# in that tag.
	//
	assign	bus_int_vector = {
		1'b0,
		1'b0,
		1'b0,
		1'b0,
		1'b0,
		1'b0,
		1'b0,
		1'b0,
		1'b0,
		1'b0,
		1'b0,
		1'b0,
		1'b0,
		flash_interrupt,
		sdcard_int
	};
	assign	sys_int_vector = {
		1'b0,
		1'b0,
		1'b0,
		1'b0,
		1'b0,
		uartrxf_int,
		uarttxf_int,
		sdcard_int,
		w_bus_int,
		1'b0,
		1'b0,
		1'b0,
		1'b0,
		1'b0,
		1'b0
	};
	assign	alt_int_vector = {
		1'b0,
		1'b0,
		1'b0,
		1'b0,
		uartrx_int,
		uarttx_int,
		rtc_int,
		1'b0,
		1'b0,
		1'b0,
		1'b0,
		1'b0,
		1'b0,
		1'b0,
		1'b0
	};


	//
	//
	// Now we turn to defining all of the parts and pieces of what
	// each of the various peripherals does, and what logic it needs.
	//
	// This information comes from the @MAIN.INSERT and @MAIN.ALT tags.
	// If an @ACCESS tag is available, an ifdef is created to handle
	// having the access and not.  If the @ACCESS tag is `defined above
	// then the @MAIN.INSERT code is executed.  If not, the @MAIN.ALT
	// code is exeucted, together with any other cleanup settings that
	// might need to take place--such as returning zeros to the bus,
	// or making sure all of the various interrupt wires are set to
	// zero if the component is not included.
	//
`ifdef	SDSPI_ACCESS
	// SPI mapping
	wire	w_sd_cs_n, w_sd_mosi, w_sd_miso;

	sdspi	sdcardi(i_clk,
		wb_cyc,
			(wb_stb)&&(sdcard_sel),
			wb_we,
			wb_addr[1:0],
			wb_data,
			sdcard_ack, sdcard_stall, sdcard_data,
		w_sd_cs_n, o_sd_sck, w_sd_mosi, w_sd_miso,
		sdcard_int, 1'b1, sdspi_debug);

	assign	w_sd_miso = i_sd_data[0];
	assign	o_sd_data = { w_sd_cs_n, 3'b111 };
	assign	o_sd_cmd  = w_sd_mosi;
`else	// SDSPI_ACCESS
	assign	o_sd_sck   = 1'b1;
	assign	o_sd_cmd   = 1'b1;
	assign	o_sd_data  = 4'hf;
	reg	r_sdcard_ack;
	initial	r_sdcard_ack = 1'b0;
	always @(posedge i_clk)	r_sdcard_ack <= (wb_stb)&&(sdcard_sel);
	assign	sdcard_ack   = r_sdcard_ack;
	assign	sdcard_stall = 0;
	assign	sdcard_data  = 0;
	assign	sdcard_int = 1'b0;	// sdcard.INT.SDCARD.WIRE
`endif	// SDSPI_ACCESS

`ifdef	FLASH_ACCESS
	// The Flash control interface result comes back together with the
	// flash interface itself.  Hence, we always return zero here.
	assign	flctl_ack   = 1'b0;
	assign	flctl_stall = 1'b0;
	assign	flctl_data  = 0;
`else	// FLASH_ACCESS
	reg	r_flctl_ack;
	initial	r_flctl_ack = 1'b0;
	always @(posedge i_clk)	r_flctl_ack <= (wb_stb)&&(flctl_sel);
	assign	flctl_ack   = r_flctl_ack;
	assign	flctl_stall = 0;
	assign	flctl_data  = 0;
`endif	// FLASH_ACCESS

`ifdef	BUSPIC_ACCESS
	//
	// The BUS Interrupt controller
	//
	icontrol #(15)	buspici(i_clk, 1'b0, (wb_stb)&&(buspic_sel),
			wb_data, buspic_data, bus_int_vector, w_bus_int);
`else	// BUSPIC_ACCESS
	reg	r_buspic_ack;
	initial	r_buspic_ack = 1'b0;
	always @(posedge i_clk)	r_buspic_ack <= (wb_stb)&&(buspic_sel);
	assign	buspic_ack   = r_buspic_ack;
	assign	buspic_stall = 0;
	assign	buspic_data  = 0;
	assign	w_bus_int = 1'b0;	// buspic.INT.BUS.WIRE
`endif	// BUSPIC_ACCESS

`ifdef	INCLUDE_ZIPCPU
	//
	//
	// And an arbiter to decide who gets access to the bus
	//
	//
	// Clock speed = 100000000
	wbpriarbiter #(32,23)	bus_arbiter(i_clk,
		// The Zip CPU bus master --- gets the priority slot
		zip_cyc, (zip_stb)&&(zip_dwb_sel), zip_we, zip_addr, zip_data, zip_sel,
			zip_dwb_ack, zip_dwb_stall, zip_dwb_err,
		// The UART interface master
		(wbu_cyc)&&(wbu_dwb_sel), (wbu_stb)&&(wbu_dwb_sel), wbu_we,
			wbu_addr[(23-1):0], wbu_data, wbu_sel,
			wbu_dwb_ack, wbu_dwb_stall, wbu_dwb_err,
		// Common bus returns
		dwbi_cyc, dwbi_stb, dwbi_we, dwbi_addr, dwbi_odata, dwbi_sel,
			dwbi_ack, dwbi_stall, dwbi_err);

	// And because the ZipCPU and the Arbiter can create an unacceptable
	// delay, we often fail timing.  So, we add in a delay cycle
`else
	// If no ZipCPU, no delay arbiter is needed
	assign	dwbi_cyc   = wbu_cyc;
	assign	dwbi_stb   = wbu_stb;
	assign	dwbi_we    = wbu_we;
	assign	dwbi_addr  = wbu_addr;
	assign	dwbi_odata = wbu_data;
	assign	dwbi_sel   = wbu_sel;
	assign	wbu_dwb_ack   = dwbi_ack;
	assign	wbu_dwb_stall = dwbi_stall;
	assign	wbu_dwb_err   = dwbi_err;
	assign wbu_dwb_data   = dwbi_idata;
`endif	// INCLUDE_ZIPCPU

`ifdef	WBUBUS_MASTER
`ifdef	INCLUDE_ZIPCPU
`define	BUS_DELAY_NEEDED
`endif
`endif
`ifdef	BUS_DELAY_NEEDED
	busdelay #(23)	dwbi_delay(i_clk,
		dwbi_cyc, dwbi_stb, dwbi_we, dwbi_addr, dwbi_odata, dwbi_sel,
			dwbi_ack, dwbi_stall, dwbi_idata, dwbi_err,
		wb_cyc, wb_stb, wb_we, wb_addr, wb_data, wb_sel,
			wb_ack, wb_stall, wb_idata, wb_err);
`else
	// If one of the two, the ZipCPU or the WBUBUS, isn't here, then we
	// don't need the bus delay, and we can go directly from the bus driver
	// to the bus itself
	//
	assign	wb_cyc    = dwbi_cyc;
	assign	wb_stb    = dwbi_stb;
	assign	wb_we     = dwbi_we;
	assign	wb_addr   = dwbi_addr;
	assign	wb_data   = dwbi_odata;
	assign	wb_sel    = dwbi_sel;
	assign	dwbi_ack   = wb_ack;
	assign	dwbi_stall = wb_stall;
	assign	dwbi_err   = wb_err;
	assign	dwbi_idata = wb_idata;
`endif
	assign	wbu_dwb_data = dwbi_idata;
`ifdef	INCLUDE_ZIPCPU
	assign	zip_dwb_data = dwbi_idata;
`endif
`ifdef	BKRAM_ACCESS
	memdev #(.LGMEMSZ(20), .EXTRACLOCK(1))
		bkrami(i_clk,
			(wb_cyc), (wb_stb)&&(bkram_sel), wb_we,
				wb_addr[(20-3):0], wb_data, wb_sel,
				bkram_ack, bkram_stall, bkram_data);
`else	// BKRAM_ACCESS
	reg	r_bkram_ack;
	initial	r_bkram_ack = 1'b0;
	always @(posedge i_clk)	r_bkram_ack <= (wb_stb)&&(bkram_sel);
	assign	bkram_ack   = r_bkram_ack;
	assign	bkram_stall = 0;
	assign	bkram_data  = 0;
`endif	// BKRAM_ACCESS

`ifdef	RTC_ACCESS
	rtclight	#(32'h002af31d) thertc(i_clk,
		wb_cyc, (wb_stb)&&(rtc_sel), wb_we,
			wb_addr[2:0], wb_data,
		rtc_data, rtc_int, rtc_ppd);
	assign	rtc_stall = 1'b0;
	initial	r_rtc_ack = 1'b0;
	always @(posedge i_clk)
		r_rtc_ack <= (wb_stb)&&(rtc_sel);
	assign	rtc_ack = r_rtc_ack;
`else	// RTC_ACCESS
	reg	r_rtc_ack;
	initial	r_rtc_ack = 1'b0;
	always @(posedge i_clk)	r_rtc_ack <= (wb_stb)&&(rtc_sel);
	assign	rtc_ack   = r_rtc_ack;
	assign	rtc_stall = 0;
	assign	rtc_data  = 0;
	assign	rtc_int = 1'b0;	// rtc.INT.RTC.WIRE
`endif	// RTC_ACCESS

`ifdef	FLASH_ACCESS
	wbqspiflash #(24)
		flashmem(i_clk,
			(wb_cyc), (wb_stb)&&(flash_sel), (wb_stb)&&(flctl_sel),wb_we,
			wb_addr[(24-3):0], wb_data,
			flash_ack, flash_stall, flash_data,
			o_qspi_sck, o_qspi_cs_n, o_qspi_mod, o_qspi_dat, i_qspi_dat,
			flash_interrupt);
`else	// FLASH_ACCESS
	assign	o_qspi_sck  = 1'b1;
	assign	o_qspi_cs_n = 1'b1;
	assign	o_qspi_mod  = 2'b01;
	assign	o_qspi_dat  = 4'b1111;
	reg	r_flash_ack;
	initial	r_flash_ack = 1'b0;
	always @(posedge i_clk)	r_flash_ack <= (wb_stb)&&(flash_sel);
	assign	flash_ack   = r_flash_ack;
	assign	flash_stall = 0;
	assign	flash_data  = 0;
	assign	flash_interrupt = 1'b0;	// flash.INT.FLASH.WIRE
`endif	// FLASH_ACCESS

`ifdef	SDSPI_SCOPE
	assign	scope_sdcard_trigger = (wb_stb)
				&&(sdcard_sel)&&(wb_we);
	assign	scope_sdcard_ce = 1'b1;
	wbscope #(5'h9) sdspiscope(i_clk, scope_sdcard_ce,
			scope_sdcard_trigger,
			sdspi_debug,
			i_clk, wb_cyc,
			(wb_stb)&&(scope_sdcard_sel),
			wb_we,
			wb_addr[0],
			wb_data,
			scope_sdcard_ack,
			scope_sdcard_stall,
			scope_sdcard_data,
			scope_sdcard_int);

`else	// SDSPI_SCOPE
	reg	r_scope_sdcard_ack;
	initial	r_scope_sdcard_ack = 1'b0;
	always @(posedge i_clk)	r_scope_sdcard_ack <= (wb_stb)&&(scope_sdcard_sel);
	assign	scope_sdcard_ack   = r_scope_sdcard_ack;
	assign	scope_sdcard_stall = 0;
	assign	scope_sdcard_data  = 0;
	assign	scope_sdcard_int = 1'b0;	// scope_sdcard.INT.SDSCOPE.WIRE
`endif	// SDSPI_SCOPE

`ifdef	WBUBUS_MASTER
`ifdef	INCLUDE_ZIPCPU
`else
	assign	zip_dbg_ack   = 1'b0;
	assign	zip_dbg_stall = 1'b0;
	assign	zip_dbg_data  = 0;
`endif
`ifndef	BUSPIC_ACCESS
	wire	w_bus_int;
	assign	w_bus_int = 1'b0;
`endif
	wire	[31:0]	wbu_tmp_addr;
	wbuconsole genbus(i_clk, i_host_rx_stb, i_host_rx_data,
			wbu_cyc, wbu_stb, wbu_we, wbu_tmp_addr, wbu_data,
			wbu_ack, wbu_stall, wbu_err, wbu_idata,
			w_bus_int,
			o_host_tx_stb, o_host_tx_data, i_host_tx_busy,
			//
			w_console_tx_stb, w_console_tx_data, w_console_busy,
			w_console_rx_stb, w_console_rx_data,
			//
			wbubus_dbg[0]);
	assign	wbu_sel = 4'hf;
	assign	wbu_addr = wbu_tmp_addr[(24-1):0];
`else	// WBUBUS_MASTER
`endif	// WBUBUS_MASTER

`ifdef	INCLUDE_ZIPCPU
	//
	//
	// The ZipCPU/ZipSystem BUS master
	//
	//
	assign	zip_int_vector = { alt_int_vector[14:8], sys_int_vector[14:6] };
	zipsystem #(RESET_ADDRESS,ZIP_ADDRESS_WIDTH,10,ZIP_START_HALTED,ZIP_INTS)
		swic(i_clk, i_cpu_reset,
			// Zippys wishbone interface
			zip_cyc, zip_stb, zip_we, zip_addr, zip_data, zip_sel,
					zip_ack, zip_stall, zip_idata, zip_err,
			zip_int_vector, zip_cpu_int,
			// Debug wishbone interface
			(wbu_cyc), ((wbu_stb)&&(zip_dbg_sel)),wbu_we,
			wbu_addr[0],
			wbu_data, zip_dbg_ack, zip_dbg_stall, zip_dbg_data,
			zip_debug);
	assign	zip_trigger = zip_debug[0];
`else	// INCLUDE_ZIPCPU
	assign	zip_cpu_int = 1'b0;	// zip.INT.ZIP.WIRE
`endif	// INCLUDE_ZIPCPU

`ifdef	RTCDATE_ACCESS
	//
	// The Calendar DATE
	//
	rtcdate	thedate(i_clk, rtc_ppd,
		(wb_stb)&&(date_sel), wb_we, wb_data,
			date_ack, date_stall, date_data);
`else	// RTCDATE_ACCESS
	reg	r_date_ack;
	initial	r_date_ack = 1'b0;
	always @(posedge i_clk)	r_date_ack <= (wb_stb)&&(date_sel);
	assign	date_ack   = r_date_ack;
	assign	date_stall = 0;
	assign	date_data  = 0;
`endif	// RTCDATE_ACCESS

	assign	version_data = `DATESTAMP;
	assign	version_ack = 1'b0;
	assign	version_stall = 1'b0;
	always @(posedge i_clk)
		if (wb_err)
			r_buserr_addr <= wb_addr;
	assign	buserr_data = { {(32-2-23){1'b0}},
			r_buserr_addr, 2'b00 };
`ifdef	BUSCONSOLE_ACCESS
	wbconsole console(i_clk, 1'b0,
 			wb_cyc, (wb_stb)&&(uart_sel), wb_we,
				wb_addr[1:0], wb_data,
 			uart_ack, uart_stall, uart_data,
			w_console_tx_stb, w_console_tx_data, w_console_busy,
			w_console_rx_stb, w_console_rx_data,
			uartrx_int, uarttx_int, uartrxf_int, uarttxf_int);
`else	// BUSCONSOLE_ACCESS
	reg	r_uart_ack;
	initial	r_uart_ack = 1'b0;
	always @(posedge i_clk)	r_uart_ack <= (wb_stb)&&(uart_sel);
	assign	uart_ack   = r_uart_ack;
	assign	uart_stall = 0;
	assign	uart_data  = 0;
	assign	uarttxf_int = 1'b0;	// uart.INT.UARTTXF.WIRE
	assign	uartrxf_int = 1'b0;	// uart.INT.UARTRXF.WIRE
	assign	uarttx_int = 1'b0;	// uart.INT.UARTTX.WIRE
	assign	uartrx_int = 1'b0;	// uart.INT.UARTRX.WIRE
`endif	// BUSCONSOLE_ACCESS

	initial	r_pwrcount_data = 32'h0;
	always @(posedge i_clk)
	if (r_pwrcount_data[31])
		r_pwrcount_data[30:0] <= r_pwrcount_data[30:0] + 1'b1;
	else
		r_pwrcount_data[31:0] <= r_pwrcount_data[31:0] + 1'b1;
	assign	pwrcount_data = r_pwrcount_data;


endmodule // main.v
