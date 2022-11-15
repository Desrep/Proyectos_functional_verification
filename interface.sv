
interface intf_cnt(input sys_clk,input sdram_clk);
	`timescale 1ns/1ps
	// General
	reg            RESETN;
	parameter      dw              = 32;  // data width
	parameter      tw              =  8;   // tag id width
	parameter      bl              =  5;   // burst_lenght_width 
	// Wish Bone Interface  
	reg             wb_stb_i           ;
	wire            wb_ack_o           ;
	reg  [25:0]     wb_addr_i          ;
	reg             wb_we_i            ; // 1 - Write, 0 - Read
	reg  [dw-1:0]   wb_dat_i           ;
	reg  [dw/8-1:0] wb_sel_i           ; // Byte enable
    wire [dw-1:0]   wb_dat_o           ;
	reg             wb_cyc_i           ;
    reg  [2:0]      wb_cti_i           ;
	// SDRAM I/F 
	`ifdef SDR_32BIT
   	wire [31:0]     Dq                 ; // SDRAM Read/Write Data Bus
   	wire [3:0]      sdr_dqm            ; // SDRAM DATA Mask
	`elsif SDR_16BIT 
   	wire [15:0]     Dq                 ; // SDRAM Read/Write Data Bus
   	wire [1:0]      sdr_dqm            ; // SDRAM DATA Mask
	`else 
    wire [7:0]      Dq                 ; // SDRAM Read/Write Data Bus
   	wire [0:0]      sdr_dqm            ; // SDRAM DATA Mask
	`endif
	wire [1:0]      sdr_ba             ; // SDRAM Bank Select
	wire [12:0]     sdr_addr           ; // SDRAM ADRESS
	wire            sdr_init_done      ; // SDRAM Init Done 	
	wire            sdr_cke			   ;
	wire            sdr_cs_n  		   ;
	wire            sdr_ras_n		   ;
	wire            sdr_cas_n 		   ;
	wire            sdr_we_n 		   ;  
    wire #(2.0) sdram_clk_d   = sdram_clk;// fixes timing issue for DRAM
endinterface
