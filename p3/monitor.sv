//Reference https://verificationguide.com/uvm/uvm-testbench-architecture/



class sdr_monitor extends uvm_monitor;

  
  
  
  virtual sdr_if vif;

  
  
  
  uvm_analysis_port #(sdr_seq_item) item_collected_port;
  
  
  
  
  
  sdr_seq_item trans_collected;

  `uvm_component_utils(sdr_monitor)

  
  
  
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
       
     
       
      
	  item_collected_port.write(trans_collected);
       
      end 
  endtask : run_phase

endclass : sdr_monitor
