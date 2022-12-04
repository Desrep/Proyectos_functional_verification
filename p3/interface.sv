//-------------------------------------------------------------------------
//						mem_interface - www.verificationguide.com
//-------------------------------------------------------------------------
import uvm_pkg::*;
interface mem_if(input logic clk, sdram_clk);
  
  
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
    wire #(2.0) sdram_clk_d   = sdram_clk;
    wire sys_clk = clk;
  
  //---------------------------------------
  //declaring the signals
  //---------------------------------------
  logic wr_en;
  logic rd_en;
  //---------------------------------------
  //driver clocking block
  //---------------------------------------
  clocking driver_cb @(posedge clk);
    default input #1 output #1;
    output wb_addr_i;
    output wr_en;
    output rd_en;
    output wb_dat_i;
    output wb_stb_i;
    output wb_cyc_i;
    input  wb_dat_o; 
    output wb_we_i;
  endclocking
  
  //---------------------------------------
  //monitor clocking block
  //---------------------------------------
  clocking monitor_cb @(posedge clk);
    default input #1 output #1;
    input wb_addr_i;
    input wr_en;
    input rd_en;
    input wb_dat_i;
    input wb_stb_i;
    input wb_cyc_i;
    input  wb_dat_o; 
    input wb_we_i;
  endclocking
  reg reset = RESETN;
  //---------------------------------------
  //driver modport
  //---------------------------------------
  modport DRIVER  (clocking driver_cb,input clk,reset);
  
  //---------------------------------------
  //monitor modport  
  //---------------------------------------
  modport MONITOR (clocking monitor_cb,input clk,reset);
  
endinterface
    
    
    
