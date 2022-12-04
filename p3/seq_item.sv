//-------------------------------------------------------------------------
//						mem_seq_item - www.verificationguide.com 
//-------------------------------------------------------------------------

class mem_seq_item extends uvm_sequence_item;
  //---------------------------------------
  //data and control fields
  //---------------------------------------
  rand bit [25:0] addr;
  bit       wr_en;
  bit       rd_en;
  rand bit [31:0] wdata;
  bit [31:0] rdata;
  rand bit [2:0] bl;
  bit[7:0] colum_add_in;
  bit [1:0] bank_add_in;
  bit [11:0] row_add_in;
  bit[11:0] colum_add_out;
  bit [1:0] bank_add_out;
  bit [11:0] row_add_out;
  
  //---------------------------------------
  //Utility and Field macros
  //---------------------------------------
  `uvm_object_utils_begin(mem_seq_item)
    `uvm_field_int(addr,UVM_ALL_ON)
    //`uvm_field_int(wr_en,UVM_ALL_ON)
    //`uvm_field_int(rd_en,UVM_ALL_ON)
    `uvm_field_int(wdata,UVM_ALL_ON)
  `uvm_field_int(bl,UVM_ALL_ON)
  `uvm_object_utils_end
  
  //---------------------------------------
  //Constructor
  //---------------------------------------
  function new(string name = "mem_seq_item");
    super.new(name);
    wr_en = 1;
    rd_en = 1;
  endfunction
  
 
  
endclass