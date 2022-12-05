class sdr_monitor_decode_column extends uvm_monitor;

  //---------------------------------------
  //Interface
  //---------------------------------------
  virtual sdr_if vif;
   int ulim_col;
  int ulim_bank;
  int llim_bank;
  //---------------------------------------
  // analysis port, to send the transaction to scoreboard
  //---------------------------------------
  uvm_analysis_port #(sdr_seq_item) item_collected_port;
  
  //---------------------------------------
  // The following property holds the transaction information currently
  // begin captured (by the collect_address_phase and data_phase methods).
  //---------------------------------------
  sdr_seq_item trans_collected;

  `uvm_component_utils(sdr_monitor_decode_column)

  //---------------------------------------
  // new - constructor
  //---------------------------------------
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected = new();
    item_collected_port = new("item_collected_port", this);
  endfunction : new

  //---------------------------------------
  // build_phase - getting the interface handle
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual sdr_if)::get(this, "", "vif", vif))
       `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction: build_phase
  
  //---------------------------------------
  // run_phase - convert the signal level activity to transaction level.
  // i.e, sample the values on interface signal ans assigns to transaction class fields
  //---------------------------------------
  virtual task run_phase(uvm_phase phase);
    
    forever begin
	    
      @(posedge (((vif.sdr_ras_n)&&(!vif.sdr_cas_n)&&(!vif.sdr_we_n))||((vif.sdr_ras_n)&&(!vif.sdr_cas_n)&&(vif.sdr_we_n))));
      //@(posedge vif.sdram_clk_d )  
      begin 
        
        
      trans_collected.addr = vif.wb_addr_i;
        
    
      trans_collected.colum_add_out =  vif.sdr_addr [11:0];
        trans_collected.bank_add_out =  vif.sdr_ba [1:0];   
      
      
	  item_collected_port.write(trans_collected);
      end
      end 
  endtask : run_phase

endclass : sdr_monitor_decode_column
