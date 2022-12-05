class sr_coverage extends uvm_subscriber #(sdr_seq_item);

  //----------------------------------------------------------------------------
  virtual sdr_if vif;
  `uvm_component_utils(sr_coverage)
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  function new(string name="sr_coverage",uvm_component parent);
    super.new(name,parent);
    dut_cov0=new();
    dut_cov1 =new();
    dut_cov2 =new();
    dut_cov4 = new();
    dut_cov5 = new();
    dut_cov7 = new();
    dut_cov8 = new();
    dut_cov9 = new();
    dut_cov10 = new();
    dut_cov11 = new();
    dut_cov12 = new();
    dut_cov13 = new();
  endfunction
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  sdr_seq_item req;
  real cov0;
  real  cov1;
  real  cov2;
  real  cov4;
  real  cov5;
  real  cov7;
  real  cov8;
  real  cov9;
  real  cov10;
  real  cov11;
  real  cov12;
  real  cov13;
  //----------------------------------------------------------------------------
  
  //----------------------------------------------------------------------------
  
  covergroup dut_cov0 @(vif.sys_clk); //active signals
    Feature_stv: coverpoint vif.wb_stb_i;
    Feature_cyc: coverpoint vif.wb_cyc_i;
    Feature_we: coverpoint vif.wb_we_i;
    Feature_ack: coverpoint vif.wb_ack_o; 
    Feature_data: coverpoint vif.wb_dat_i    
{option.auto_bin_max=8;}
    Feature_resetn: coverpoint vif.RESETN; 
  endgroup:dut_cov0;
  
  covergroup dut_cov1 @(posedge vif.sys_clk); // reset transitions
    reset_transitneg: coverpoint vif.RESETN {bins seq = (1=>0);}
    reset_transitpos: coverpoint vif.RESETN {bins seq = (0=>1);}
  endgroup:dut_cov1;

  covergroup dut_cov2 @(posedge vif.sys_clk); // address range access
    address_access: coverpoint vif.wb_addr_i {
      bins lower_address = {[0:11184810]};
      bins mid_address = {[11184811:2*11184810]} ;
      bins higher_address = {[2*11184810+1:$]};
      }
  endgroup:dut_cov2;
  
   
  
  covergroup dut_cov4 @(posedge vif.sys_clk); // data range access
    data_access: coverpoint vif.wb_dat_i {
      bins lower_dat = {[0:715827882]};
      bins mid_dat = {[715827883:2*715827882]} ;
      bins higher_dat = {[2*715827882+1:$]};
      }
  endgroup:dut_cov4;
  
  covergroup dut_cov5 @(posedge vif.sys_clk); // bank  access
    sdr_bank_access: coverpoint vif.sdr_ba   {
      bins bank_access = {0,1,2,3};
      }
     endgroup:dut_cov5;
  
  covergroup dut_cov7 @(posedge vif.sys_clk); // sdr address range access
    sdr_addr_access: coverpoint vif.sdr_addr {
      bins lower_add = {[0:682]};
      bins mid_add = {[683:2*682]} ;
      bins higher_add = {[682*2+1:$]};
      }
  endgroup:dut_cov7;
  
  
covergroup dut_cov8 @(posedge vif.sys_clk); // WB transitions for 1 bit signals
   cyc_transitions: coverpoint vif.wb_cyc_i {
     bins neg = (1 => 0 =>  1);
     bins pos = (0 => 1 =>  0);
   }
   stb_transitions: coverpoint vif.wb_stb_i {
     bins neg = (1 =>0 =>  1);
     bins pos = (0 => 1 =>  0);
   }
   
 we_transitions: coverpoint vif.wb_we_i {
   bins neg = (1 =>0 =>  1);
   bins pos = (0 => 1 =>  0);
   }
 
 ack_transitions: coverpoint vif.wb_ack_o {
   bins neg = (1 => 0 =>  1);
   bins pos = (0 => 1 =>  0);
   }
    
    
 sel_transitions: coverpoint vif.wb_sel_i {
   bins neg = (15 => 0 =>  15);
   bins pos = (0 => 15 => 0);
   }   
endgroup:dut_cov8;

  covergroup dut_cov9 @(posedge vif.sdram_clk_d); // check if all operations are used
    sdr_commands: coverpoint {vif.sdr_ras_n,vif.sdr_cas_n,vif.sdr_we_n }{
      bins nop = {3'b111};
      bins active = {3'b011};
      bins read = {3'b101};
      bins write = {3'b100};
      bins burst_terminate = {3'b110};
      bins recharge = {3'b010};
      bins autorefresh = {3'b001};
      bins load_mode_register = {3'b000};
    }
    
  endgroup:dut_cov9;
  
   covergroup dut_cov10 @(posedge vif.sdram_clk_d); // check if all operations are used
    sdr_dq: coverpoint {vif.Dq}{
   	`ifdef SDR_32BIT
      // SDRAM Read/Write Data Bus
      bins lower_add = {[0:715827882]};
      bins mid_add = {[715827882:2*715827882]} ;
      bins higher_add = {[715827882*2+1:$]};
	`elsif SDR_16BIT 
      // SDRAM Read/Write Data Bus
      bins lower_add = {[0:21845]};
      bins mid_add = {[21845:2*21845]} ;
      bins higher_add = {[21845*2+1:$]};
	`else 
     // SDRAM Read/Write Data Bus
      bins lower_add = {[0:85]};
      bins mid_add = {[85:2*85]} ;
      bins higher_add = {[85*2+1:$]};
	`endif
    }
    endgroup:dut_cov10;
  
  /*
   
  covergroup cov11 @(posedge intf.sdram_clk_d); // check if all operations are used
    sdr_dqm: coverpoint {intf.sdr_dqm }{
   	`ifdef SDR_32BIT
      bins dqm  = {0:8}; //  SDRAM DATA Mask//
	`elsif SDR_16BIT 
      bins dqm  = {0:1}; //  SDRAM DATA Mask
	`else 
      bins dqm = {0:0}; //  SDRAM DATA Mask
     `endif
    }
    endgroup
  
*/  
  
  covergroup dut_cov11 @(posedge vif.sdram_clk_d); // range for dq mask
  sdr_dqm: coverpoint vif.sdr_dqm ;
  endgroup:dut_cov11;
  
  covergroup dut_cov12 @(posedge vif.sdram_clk_d); // range for cti
  sdr_dqm: coverpoint vif.wb_cti_i;
  endgroup:dut_cov12;
  
  covergroup dut_cov13 @(posedge vif.sdram_clk_d); // range for sel
  sdr_dqm: coverpoint vif.wb_sel_i;
  endgroup:dut_cov13; 
  
  

  //----------------------------------------------------------------------------

  //---------------------  write method ----------------------------------------
  function void write(sdr_seq_item t);
    req=t;
    //dut_cov.sample();
  endfunction
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    cov0=dut_cov0.get_coverage();
    cov1=dut_cov1.get_coverage();
    cov2=dut_cov2.get_coverage();
    cov4=dut_cov4.get_coverage();
    cov5=dut_cov5.get_coverage();
    cov7=dut_cov7.get_coverage();
    cov8=dut_cov8.get_coverage();
    cov9=dut_cov9.get_coverage();
    cov10=dut_cov10.get_coverage();
    cov11=dut_cov11.get_coverage();
    cov12=dut_cov12.get_coverage();
    cov13=dut_cov13.get_coverage();
    
  endfunction
  //----------------------------------------------------------------------------


  //----------------------------------------------------------------------------
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name(),$sformatf("Coverage is %f",cov0),UVM_MEDIUM)
  endfunction
  //----------------------------------------------------------------------------
  
endclass:sr_coverage
