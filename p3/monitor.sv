

class mem_monitor extends uvm_monitor;

  //---------------------------------------
  //Interface
  //---------------------------------------
  virtual mem_if vif;

  //---------------------------------------
  // analysis port, to send the transaction to scoreboard
  //---------------------------------------
  uvm_analysis_port #(mem_seq_item) item_collected_port;
  
  //---------------------------------------
  // The following property holds the transaction information currently
  // begin captured (by the collect_address_phase and data_phase methods).
  //---------------------------------------
  mem_seq_item trans_collected;

  `uvm_component_utils(mem_monitor)

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
    if(!uvm_config_db#(virtual mem_if)::get(this, "", "vif", vif))
       `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction: build_phase
  
  //---------------------------------------
  // run_phase - convert the signal level activity to transaction level.
  // i.e, sample the values on interface signal ans assigns to transaction class fields
  //---------------------------------------
  virtual task run_phase(uvm_phase phase);
    
    forever begin
      @(posedge vif.wb_ack_o);
        
     

     
      
      if(vif.wb_we_i&&vif.wb_stb_i) begin
       
        trans_collected.wr_en = vif.wb_we_i;
        trans_collected.wdata = vif.wb_dat_i;
       
        @(posedge vif.MONITOR.clk);
      end
      
      if((vif.wb_we_i == 0)&&(vif.wb_stb_i==0)) begin
        
        trans_collected.rd_en = ~vif.wb_we_i;
        
        
        trans_collected.rdata = vif.wb_dat_o;
        
      end
      
        trans_collected.addr = vif.wb_addr_i;
        trans_collected.colum_add_in =  vif.wb_addr_i [7:0];
        trans_collected.bank_add_in  = vif.wb_addr_i[9:8];
       
     
        trans_collected.colum_add_out =  vif.sdr_addr [11:0];
      

       
      trans_collected.bank_add_out =  vif.sdr_ba [1:0];
      
	  item_collected_port.write(trans_collected);
       
      end 
  endtask : run_phase

endclass : mem_monitor
