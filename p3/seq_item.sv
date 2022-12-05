//-------------------------------------------------------------------------
//						sdr_seq_item - www.verificationguide.com 
//-------------------------------------------------------------------------

class sdr_seq_item extends uvm_sequence_item;
  //---------------------------------------
  //data and control fields
  //---------------------------------------
  rand bit [25:0] addr;
  rand bit       wr_en;
  rand bit       rd_en;
  rand bit [31:0] wdata;
  bit [31:0] rdata;
  rand bit [2:0] bl;
  bit[7:0] colum_add_in;
  bit [1:0] bank_add_in;
  bit [11:0] row_add_in;
  bit[11:0] colum_add_out;
  bit [1:0] bank_add_out;
  bit [11:0] row_add_out;
  rand bit [1:0]  cfg_req_depth;
  rand bit        cfg_sdr_en; 
  rand bit [12:0] cfg_sdr_mode_reg;  
  rand bit [3:0]  cfg_sdr_tras_d; 
  rand bit [3:0]  cfg_sdr_trp_d;      
  rand bit [3:0]  cfg_sdr_trcd_d;    
  rand bit [2:0]  cfg_sdr_cas;    
  rand bit [3:0]  cfg_sdr_trcar_d; 
  rand bit [3:0]  cfg_sdr_twr_d;  
  rand bit [11:0] cfg_sdr_rfsh;
  rand bit [2:0] cfg_sdr_rfmax;
 
  //---------------------------------------
  //Utility and Field macros
  //---------------------------------------
  `uvm_object_utils_begin(sdr_seq_item)
    `uvm_field_int(addr,UVM_ALL_ON)
    `uvm_field_int(wr_en,UVM_ALL_ON)
    `uvm_field_int(rd_en,UVM_ALL_ON)
    `uvm_field_int(wdata,UVM_ALL_ON)
    `uvm_field_int(cfg_req_depth,UVM_ALL_ON)
     `uvm_field_int(cfg_sdr_en,UVM_ALL_ON)
     `uvm_field_int(cfg_sdr_mode_reg,UVM_ALL_ON)
     `uvm_field_int(cfg_sdr_tras_d,UVM_ALL_ON)
     `uvm_field_int(cfg_sdr_trp_d,UVM_ALL_ON)
     `uvm_field_int(cfg_sdr_trcd_d,UVM_ALL_ON)
     `uvm_field_int(cfg_sdr_cas,UVM_ALL_ON)
     `uvm_field_int(cfg_sdr_trcar_d,UVM_ALL_ON)
     `uvm_field_int(cfg_sdr_twr_d,UVM_ALL_ON)
     `uvm_field_int(cfg_sdr_rfsh,UVM_ALL_ON)
     `uvm_field_int(cfg_sdr_rfmax,UVM_ALL_ON)
  `uvm_object_utils_end
  
  //---------------------------------------
  //Constructor
  //---------------------------------------
  function new(string name = "sdr_seq_item");
    super.new(name);
  endfunction

  
  constraint c1 {  cfg_req_depth == 3; }
 constraint c2 {  cfg_sdr_mode_reg != 0; }
 constraint c3 {  cfg_sdr_tras_d >= 2 ; }
 constraint c4 {  cfg_sdr_trp_d  >= 2 ; }
 constraint c5 {  cfg_sdr_trcd_d >= 2 ; }
 constraint c6 {  cfg_sdr_cas == cfg_sdr_mode_reg[5:4]; }
 constraint c7 {  cfg_sdr_trcar_d > 5;}
 constraint c8 {  cfg_sdr_twr_d >=  1;}
 constraint c9 {  cfg_sdr_rfsh >= 12'h100; cfg_sdr_rfsh < 12'hC35 ;}
 constraint c10 {  cfg_sdr_rfmax == 6;}
 constraint c11 {  cfg_sdr_mode_reg[2:0] inside {[0:3]}; cfg_sdr_mode_reg[6:4] inside {2,3}; cfg_sdr_mode_reg[12:10]==0;cfg_sdr_mode_reg[8:7] == 0;}
 constraint c12 { cfg_sdr_en == 1;}

  
  /*
constraint c1 {  cfg_req_depth == 3; }
 constraint c2 {  cfg_sdr_mode_reg != 0; }
 constraint c3 {  cfg_sdr_tras_d == 4 ; }
 constraint c4 {  cfg_sdr_trp_d  == 2 ; }
 constraint c5 {  cfg_sdr_trcd_d == 2 ; }
 constraint c6 {  cfg_sdr_cas == 2; }
 constraint c7 {  cfg_sdr_trcar_d == 7;}
 constraint c8 {  cfg_sdr_twr_d ==  1;}
 constraint c9 {  cfg_sdr_rfsh == 12'h100;}
 constraint c10 {  cfg_sdr_rfmax == 6;}
 constraint c11 {  cfg_sdr_mode_reg == 12'h033; }
 constraint c12 { cfg_sdr_en == 1;}


constraint c1 {  cfg_req_depth > 2; }
 constraint c2 {  cfg_sdr_mode_reg != 0; }
 constraint c3 {  cfg_sdr_tras_d >2 ; }
 constraint c4 {  cfg_sdr_trp_d >1 ; }
 constraint c5 {  cfg_sdr_trcd_d >1 ; }
 constraint c6 {  cfg_sdr_cas > 2; }
 constraint c7 {  cfg_sdr_trcar_d > 6;}
 constraint c8 {  cfg_sdr_twr_d > 0;}
 constraint c9 {  cfg_sdr_rfsh >= 12'h100; cfg_sdr_rfsh < 12'hC35;}
 constraint c10 {  cfg_sdr_rfmax != 0;}
 constraint c11 {  cfg_sdr_mode_reg inside {[12'h000:12'h033]}; }
 constraint c12 { cfg_sdr_en inside {0,1};}





*/
  
endclass
