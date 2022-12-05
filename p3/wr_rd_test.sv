import uvm_pkg::*;
class sdr_wr_rd_test extends sdr_model_base_test;

  `uvm_component_utils(sdr_wr_rd_test)
   parameter cases=500;
  
  //---------------------------------------
  // sequence instance 
  //--------------------------------------- 
  write_read_sequence seq[cases];
  virtual sdr_if vif;
  //---------------------------------------
  // constructor
  //---------------------------------------
  function new(string name = "sdr_wr_rd_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

  //---------------------------------------
  // build_phase
  //---------------------------------------
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    foreach (seq[i]) begin
      seq[i]= write_read_sequence::type_id::create($sformatf("seq%0d",i));
    end
   
   
  endfunction : build_phase
  
  //---------------------------------------
  // run_phase - starting the test
  //---------------------------------------
  task run_phase(uvm_phase phase);
    
    
    phase.raise_objection(this);
    //env.sdr_agnt.sequencer.set_arbitration(UVM_SEQ_ARB_FIFO);
    env.sdr_agnt.driver.sdrm_init();
    env.sdr_agnt.driver.sdrm_reset();
   
    foreach(seq[i])
      begin
        fork
          int j = i;
          seq[j].start(env.sdr_agnt.sequencer);
        join
      end
    
    
    
    
    phase.drop_objection(this);
   
    //set a drain-time for the environment if desired
    //phase.phase_done.set_drain_time(this, 50);
  endtask : run_phase
  
endclass : sdr_wr_rd_test
