//Reference https://verificationguide.com/uvm/uvm-testbench-architecture/






class sdr_model_env extends uvm_env;
  
  
  
  
  sdr_agent      sdr_agnt; 
  sdr_agent_passive sdr_agntp; 
  sdr_agent_passive_col sdr_agntpc;
  sdr_scoreboard sdr_scb;
  `uvm_component_utils(sdr_model_env)
  
  
  
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  
  
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    sdr_agnt = sdr_agent::type_id::create("sdr_agnt", this);
    sdr_agntp = sdr_agent_passive::type_id::create("sdr_agntp", this);
    sdr_agntpc = sdr_agent_passive_col::type_id::create("sdr_agntpc", this);
    sdr_scb  = sdr_scoreboard::type_id::create("sdr_scb", this);
    
    uvm_config_db#(uvm_active_passive_enum)::set(this, "sdr_agntp", "is_active", UVM_PASSIVE);
    uvm_config_db#(uvm_active_passive_enum)::set(this, "sdr_agntpc", "is_active", UVM_PASSIVE);
  endfunction : build_phase
  
  
  
  
  function void connect_phase(uvm_phase phase);
    sdr_agnt.monitor.item_collected_port.connect(sdr_scb.item_collected_export_data);
    sdr_agntp.monitor.item_collected_port.connect(sdr_scb.item_collected_export_decode);
    sdr_agntpc.monitor.item_collected_port.connect(sdr_scb.item_collected_export_decode_col);
  endfunction : connect_phase

endclass : sdr_model_env
