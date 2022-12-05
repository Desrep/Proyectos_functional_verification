//-------------------------------------------------------------------------
//						sdr_sequencer - www.verificationguide.com
//-------------------------------------------------------------------------

class sdr_sequencer extends uvm_sequencer#(sdr_seq_item);

  `uvm_component_utils(sdr_sequencer) 

  //---------------------------------------
  //constructor
  //---------------------------------------
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
endclass