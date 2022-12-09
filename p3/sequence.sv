//Reference https://verificationguide.com/uvm/uvm-testbench-architecture/





class write_sequence extends uvm_sequence#(sdr_seq_item);
  
  `uvm_object_utils(write_sequence)
   
  
  
  
  function new(string name = "write_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
   
    `uvm_do_with(req,{req.wr_en==1;req.rd_en==0;})
    
  endtask
endclass





class read_sequence extends uvm_sequence#(sdr_seq_item);
  
  `uvm_object_utils(read_sequence)
   
  
  
  
  function new(string name = "read_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
   
    `uvm_do_with(req,{req.wr_en==0;req.rd_en==1;})
    
  endtask



endclass







class write_read_sequence extends uvm_sequence#(sdr_seq_item);
   
   
  `uvm_object_utils(write_read_sequence)
  `uvm_declare_p_sequencer(sdr_sequencer)
   
  
  
  
  function new(string name = "write_read_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
   `uvm_do_with(req,{req.wr_en==1;req.rd_en==1;})
  endtask
endclass

