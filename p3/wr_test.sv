import uvm_pkg::*;
class sdr_wr_rd_test extends sdr_model_base_test;

  `uvm_component_utils(sdr_wr_rd_test)
   parameter cases=100;
   parameter conf_number  = 20;
  
  
  
  write_read_sequence seq[cases];
  sdr_seq_item conf_reg[conf_number];
  virtual sdr_if vif;
  
  
  
  function new(string name = "sdr_wr_rd_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

  
  
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    foreach (seq[i]) begin
      seq[i]= write_read_sequence::type_id::create($sformatf("seq%0d",i));
    end
      foreach (conf_reg[j]) begin
      conf_reg[j] = sdr_seq_item::type_id::create($sformatf("conf%0d",j)); 
      end
  endfunction : build_phase
  
  
  
  
  task run_phase(uvm_phase phase);
    
    
    phase.raise_objection(this);
    
    foreach(conf_reg[j])
     begin
    
    randomize(conf_reg);
    env.sdr_agnt.driver.config_reg(conf_reg[j]);
    env.sdr_agnt.driver.sdrm_init();
    env.sdr_agnt.driver.sdrm_reset();
   
    foreach(seq[i])
      begin
        fork
          int j = i;
          seq[j].start(env.sdr_agnt.sequencer);
        join
      end
    end
    
    
    
    phase.drop_objection(this);
   
    
    
  endtask : run_phase
  
endclass : sdr_wr_rd_test
