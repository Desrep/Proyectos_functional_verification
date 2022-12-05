class sdr_agent_passive extends uvm_agent;

  //---------------------------------------
  // component instances
  //---------------------------------------
  sdr_driver    driver;
  sdr_sequencer sequencer;
  sdr_monitor_decode   monitor;
  
  `uvm_component_utils(sdr_agent_passive)
  
  //---------------------------------------
  // constructor
  //---------------------------------------
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  //---------------------------------------
  // build_phase
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    monitor = sdr_monitor_decode::type_id::create("monitor", this);

    //creating driver and sequencer only for ACTIVE agent
    if(get_is_active() == UVM_ACTIVE) begin
      driver    = sdr_driver::type_id::create("driver", this);
      sequencer = sdr_sequencer::type_id::create("sequencer", this);
    end
  endfunction : build_phase
  
  //---------------------------------------  
  // connect_phase - connecting the driver and sequencer port
  //---------------------------------------
  function void connect_phase(uvm_phase phase);
    if(get_is_active() == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

endclass : sdr_agent_passive