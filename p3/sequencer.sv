//Reference https://verificationguide.com/uvm/uvm-testbench-architecture/




class sdr_sequencer extends uvm_sequencer#(sdr_seq_item);

  `uvm_component_utils(sdr_sequencer) 

  
  
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
endclass