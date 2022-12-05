

class sdr_driver extends uvm_driver #(sdr_seq_item);

  //--------------------------------------- 
  // Interface
  //--------------------------------------- 
  virtual sdr_if vif;
  `uvm_component_utils(sdr_driver)
    
  //--------------------------------------- 
  // Constructor
  //--------------------------------------- 
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  //--------------------------------------- 
  // build phase
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
     if(!uvm_config_db#(virtual sdr_if)::get(this, "", "vif", vif))
       `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction: build_phase

  //---------------------------------------  
  // run phase
  //---------------------------------------  
  virtual task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);
      write_read_sdrm(req);
      sdrm_reset();
      seq_item_port.item_done();
    end
  endtask : run_phase
  
  //---------------------------------------
  // drive - transaction level to signal level
  // drives the value's from seq_item to interface signals
  //---------------------------------------

  
    virtual task write_read_sdrm(sdr_seq_item req);
      int wait_count = 0;
      if(req.wr_en&&req.rd_en)
        begin
          int i;
  			
          for(i=0; i < req.bl; i++) begin
          @ (posedge vif.sys_clk);
      		vif.wb_stb_i        = 1;
      		vif.wb_cyc_i        = 1;
      		vif.wb_we_i         = 1;
      		vif.wb_sel_i        = 4'b1111;
      		vif.wb_addr_i       = req.addr+i;
        	vif.wb_dat_i = req.wdata; // Drive to DUT
          while(vif.wb_ack_o == 1'b0) begin
            @ (posedge vif.sys_clk);
          	end
           
          vif.wb_cyc_i        = 0; 
           vif.wb_stb_i        = 0;
          
   		end  
           
          for(int j=0; j < req.bl; j++) begin
              @ (posedge vif.sys_clk);
         		vif.wb_stb_i        = 1;
         		vif.wb_cyc_i        = 1;
         		vif.wb_we_i         = 0;
         		vif.wb_sel_i        = 4'b1111;
         		vif.wb_addr_i       = req.addr +j;
            
              while(vif.wb_ack_o == 1'b0) begin
                 @(posedge vif.sys_clk);
                 req.rdata = vif.wb_dat_o;
        	  end
                 @(posedge vif.sys_clk);
                        vif.wb_cyc_i        = 0;
        		vif.wb_stb_i        = 0;
                
			end
      end
      
      
     else  if(req.wr_en&&(req.rd_en==0))  
         
      begin
        int i;
        $display("ENTERED WRONG");
          	$display("Write Address: %x, Burst Size: %d",req.addr,req.bl);
          for(i=0; i < req.bl; i++) begin
          @ (posedge vif.sys_clk);
      		vif.wb_stb_i        = 1;
      		vif.wb_cyc_i        = 1;
      		vif.wb_we_i         = 1;
      		vif.wb_sel_i        = 4'b1111;
      		vif.wb_addr_i       = req.addr+i;
        	vif.wb_dat_i = req.wdata; // Drive to DUT
          while(vif.wb_ack_o == 1'b0) begin
            @ (posedge vif.sys_clk);
          	end
          @(posedge vif.sys_clk);
          	vif.wb_stb_i        = 0;
   		end
   			vif.wb_stb_i        = 0;
   			vif.wb_cyc_i        = 0;
   			vif.wb_we_i         = 'hx;
   			vif.wb_sel_i        = 'hx;
   			vif.wb_addr_i       = 'hx;
   			vif.wb_dat_i        = 'hx;

      end

  
    else if(req.rd_en&&(req.wr_en==0))
      begin
		int j;
        $display("ENTERED WRONG");
        $display("Read Address: %x, Burst Size: %d",req.addr,req.bl);
        
          for(j=0; j < req.bl; j++) begin
              @ (posedge vif.sys_clk);
         		vif.wb_stb_i        = 1;
         		vif.wb_cyc_i        = 1;
         		vif.wb_we_i         = 0;
         		vif.wb_sel_i        = 4'b1111;
         		vif.wb_addr_i       = req.addr +j;
              while(vif.wb_ack_o == 1'b0) begin
                  @ (posedge vif.sys_clk);
        		end
              req.rdata = vif.wb_dat_o;
              
        		vif.wb_stb_i        = 0;       
			end
   			vif.wb_stb_i        = 0;
   			vif.wb_cyc_i        = 0;
  			vif.wb_we_i         = 'hx;
   			vif.wb_addr_i       = 'hx;
  			vif.wb_sel_i        = 'hx;
      end
      
      
  endtask
  
    virtual task sdrm_init();  // Reset method
	vif.wb_addr_i = 0;
   	vif.wb_dat_i  = 0;
   	vif.wb_sel_i  = 4'h0;
   	vif.wb_we_i   = 0;
   	vif.wb_stb_i  = 0;
   	vif.wb_cyc_i  = 0;
    
   	#100;  
  endtask

  virtual task config_reg(sdr_seq_item req);
	vif.cfg_req_depth = req.cfg_req_depth;
	vif.cfg_sdr_en = req.cfg_sdr_en;
        vif.cfg_sdr_mode_reg = req.cfg_sdr_mode_reg;
	vif.cfg_sdr_tras_d = req.cfg_sdr_tras_d ;
	vif.cfg_sdr_trp_d = req.cfg_sdr_trp_d;
	vif.cfg_sdr_trcd_d = req.cfg_sdr_trcd_d;
	vif.cfg_sdr_cas= req.cfg_sdr_cas;
	vif.cfg_sdr_trcar_d= req.cfg_sdr_trcar_d;
	vif.cfg_sdr_twr_d = req.cfg_sdr_twr_d;
	vif.cfg_sdr_rfsh = req.cfg_sdr_rfsh;
	vif.cfg_sdr_rfmax = req.cfg_sdr_rfmax ;
	vif.cfg_colbits = req.cfg_colbits;
        #10;
  endtask
  
   virtual task sdrm_reset();  // Reset method
	#100
	vif.RESETN    = 1'h0;  // Applying reset
  	#100
	vif.RESETN    = 1'h1; ;// Releasing reset
  	#100;
     
   wait(vif.sdr_init_done == 1); 
  endtask
  
endclass : sdr_driver
