//Reference https://verificationguide.com/uvm/uvm-testbench-architecture/




class sdr_agent extends uvm_agent;

  
  
  
  sdr_driver    driver;
  sdr_sequencer sequencer;
  sdr_monitor   monitor;
  
  `uvm_component_utils(sdr_agent)
  
  
  
  
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  
  
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    monitor = sdr_monitor::type_id::create("monitor", this);

    
    if(get_is_active() == UVM_ACTIVE) begin
      driver    = sdr_driver::type_id::create("driver", this);
      sequencer = sdr_sequencer::type_id::create("sequencer", this);
    end
  endfunction : build_phase
  
  
  
  
  function void connect_phase(uvm_phase phase);
    if(get_is_active() == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

endclass : sdr_agent