//-------------------------------------------------------------------------
//						mem_env - www.verificationguide.com
//-------------------------------------------------------------------------



class mem_model_env extends uvm_env;
  
  //---------------------------------------
  // agent and scoreboard instance
  //---------------------------------------
  mem_agent      mem_agnt; //datos
  mem_agent_passive mem_agntp; //fila
  mem_agent_passive_col mem_agntpc;//columna
  mem_scoreboard mem_scb;
  
  
  `uvm_component_utils(mem_model_env)
  
  //--------------------------------------- 
  // constructor
  //---------------------------------------
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  //---------------------------------------
  // build_phase - crate the components
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    mem_agnt = mem_agent::type_id::create("mem_agnt", this);
    mem_agntp = mem_agent_passive::type_id::create("mem_agntp", this);
    mem_agntpc = mem_agent_passive_col::type_id::create("mem_agntpc", this);
    mem_scb  = mem_scoreboard::type_id::create("mem_scb", this);
    
    uvm_config_db#(uvm_active_passive_enum)::set(this, "mem_agntp", "is_active", UVM_PASSIVE);
    uvm_config_db#(uvm_active_passive_enum)::set(this, "mem_agntpc", "is_active", UVM_PASSIVE);
    
  endfunction : build_phase
  
  //---------------------------------------
  // connect_phase - connecting monitor and scoreboard port
  //---------------------------------------
  function void connect_phase(uvm_phase phase);
    mem_agnt.monitor.item_collected_port.connect(mem_scb.item_collected_export_data);
    mem_agntp.monitor.item_collected_port.connect(mem_scb.item_collected_export_decode);
    mem_agntpc.monitor.item_collected_port.connect(mem_scb.item_collected_export_decode_col);
  endfunction : connect_phase

endclass : mem_model_env