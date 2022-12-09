


import uvm_pkg::*;
interface sdr_if(input logic clk, sdram_clk);
  
  
  	`timescale 1ns/1ps
	
	reg            RESETN;
	parameter      dw              = 32;  
	parameter      tw              =  8;   
	parameter      bl              =  5;   
	
	reg             wb_stb_i           ;
	wire            wb_ack_o           ;
	reg  [25:0]     wb_addr_i          ;
	reg             wb_we_i            ; 
	reg  [dw-1:0]   wb_dat_i           ;
	reg  [dw/8-1:0] wb_sel_i           ; 
    wire [dw-1:0]   wb_dat_o           ;
	reg             wb_cyc_i           ;
    reg  [2:0]      wb_cti_i           ;
	
	`ifdef SDR_32BIT
   	wire [31:0]     Dq                 ; 
   	wire [3:0]      sdr_dqm            ; 
	`elsif SDR_16BIT 
   	wire [15:0]     Dq                 ; 
   	wire [1:0]      sdr_dqm            ; 
	`else 
    wire [7:0]      Dq                 ; 
   	wire [0:0]      sdr_dqm            ; 
	`endif
	wire [1:0]      sdr_ba             ; 
	wire [12:0]     sdr_addr           ; 
	wire            sdr_init_done      ; 
	wire            sdr_cke			   ;
	wire            sdr_cs_n  		   ;
	wire            sdr_ras_n		   ;
	wire            sdr_cas_n 		   ;
	wire            sdr_we_n 		   ;  
    wire #(2.0) sdram_clk_d   = sdram_clk;
    wire sys_clk = clk;
        
          logic  [1:0]  cfg_req_depth; 
          logic       cfg_sdr_en;
         logic [12:0] cfg_sdr_mode_reg;
         logic [3:0]  cfg_sdr_tras_d;
         logic  [3:0]  cfg_sdr_trp_d;
         logic  [3:0]  cfg_sdr_trcd_d;
         logic [2:0]  cfg_sdr_cas;
         logic [3:0]  cfg_sdr_trcar_d;
         logic [3:0]  cfg_sdr_twr_d;
        logic [11:0] cfg_sdr_rfsh;
        logic  [2:0] cfg_sdr_rfmax;
        logic [1:0] cfg_colbits;


        
  
  
  
  logic wr_en;
  logic rd_en;
  
  
  
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
  
  
  
  modport DRIVER  (clocking driver_cb,input clk,reset);
  
  
  
  
  modport MONITOR (clocking monitor_cb,input clk,reset);
  
endinterface
    
    
    
