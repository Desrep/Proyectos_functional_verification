class sdr_monitor_decode_column extends uvm_monitor;

  
  
  
  virtual sdr_if vif;
   int ulim_col;
  int ulim_bank;
  int llim_bank;
  
  
  
  uvm_analysis_port #(sdr_seq_item) item_collected_port;
  
  
  
  
  
  sdr_seq_item trans_collected;

  `uvm_component_utils(sdr_monitor_decode_column)

  
  
  
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected = new();
    item_collected_port = new("item_collected_port", this);
  endfunction : new

  
  
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual sdr_if)::get(this, "", "vif", vif))
       `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction: build_phase
  
  
  
  
  
  virtual task run_phase(uvm_phase phase);
    
    forever begin
      @(posedge (((vif.sdr_ras_n)&&(!vif.sdr_cas_n)&&(!vif.sdr_we_n))))
      @(posedge vif.sdram_clk_d )  
      if(vif.sdr_cke)
      begin 
        
        
      trans_collected.addr = vif.wb_addr_i;
        
    
      trans_collected.colum_add_out =  vif.sdr_addr [11:0];
        trans_collected.bank_add_out =  vif.sdr_ba [1:0];   
      
	  item_collected_port.write(trans_collected);
      end
      end 
  endtask : run_phase

endclass : sdr_monitor_decode_column
