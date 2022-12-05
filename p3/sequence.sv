

//=========================================================================
// write_sequence - "write" one value
//=========================================================================
class write_sequence extends uvm_sequence#(sdr_seq_item);
  
  `uvm_object_utils(write_sequence)
   
  //--------------------------------------- 
  //Constructor
  //---------------------------------------
  function new(string name = "write_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
   
    `uvm_do_with(req,{req.wr_en==1;req.rd_en==0;})
    
  endtask
endclass


//=========================================================================
// read_sequence - "Read" one value
//=========================================================================
class read_sequence extends uvm_sequence#(sdr_seq_item);
  
  `uvm_object_utils(read_sequence)
   
  //--------------------------------------- 
  //Constructor
  //---------------------------------------
  function new(string name = "read_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
   
    `uvm_do_with(req,{req.wr_en==0;req.rd_en==1;})
    
  endtask
endclass


//=========================================================================
// write_read_sequence - "write" followed by "read" 
//=========================================================================
class write_read_sequence extends uvm_sequence#(sdr_seq_item);
   
   
  `uvm_object_utils(write_read_sequence)
  `uvm_declare_p_sequencer(sdr_sequencer)
   
  //--------------------------------------- 
  //Constructor
  //---------------------------------------
  function new(string name = "write_read_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
   `uvm_do_with(req,{req.wr_en==1;req.rd_en==1;})
  endtask
endclass
//=========================================================================
