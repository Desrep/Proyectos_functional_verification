class functional_coverage;
  //----------------------------------------------------------------------------
  virtual sdr_if vif;
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  function new(virtual sdr_if vif); 
    this.vif = vif;
    dut_cov0=new();
    dut_cov1 =new();
    dut_cov2 =new();
    dut_cov4 = new();
    dut_cov5 = new();
    dut_cov9 = new();
    dut_cov10 = new();
    dut_cov11 = new();
    dut_cov12 = new();
    dut_cov13 = new();
    dut_cov14 = new();
  endfunction
  //----------------------------------------------------------------------------

  
  covergroup dut_cov0 @(posedge vif.sys_clk); //active signals
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
  
  covergroup dut_cov5 @(posedge vif.sys_clk); // bank  access, sdr_addr access
    sdr_bank_access: coverpoint vif.sdr_ba   {
      bins bank_access = {0,1,2,3};
   
      }
      sdr_addr_access: coverpoint vif.sdr_addr ;
      all_accesses: cross sdr_addr_access,sdr_bank_access;
     endgroup:dut_cov5;
  
  
  

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
  
  covergroup dut_cov14 @(posedge vif.sdram_clk_d); // configuration bins
  sdr_col_bits: coverpoint vif.cfg_colbits;
  sdr_req_depth: coverpoint vif.cfg_req_depth;
  sdr_sdr_tras_d: coverpoint vif.cfg_sdr_tras_d;
  sdr_trp_d: coverpoint vif.cfg_sdr_trp_d;
  sdr_trcd_d: coverpoint vif.cfg_sdr_trcd_d;
  sdr_cas: coverpoint vif.cfg_sdr_cas;
  sdr_trcar: coverpoint  vif.cfg_sdr_trcar_d;
  sdr_twr_d: coverpoint vif.cfg_sdr_twr_d;
  sdr_rfsh: coverpoint vif.cfg_sdr_rfsh;
  sdr_rfmax: coverpoint vif.cfg_sdr_rfmax;
  endgroup:dut_cov14;



  
  endclass:functional_coverage
