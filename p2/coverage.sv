class functional_coverage;

  virtual intf_cnt intf;
  int temp_value;
  
  covergroup cov0 @(intf.sys_clk); //active signals
    Feature_stv: coverpoint intf.wb_stb_i;
    Feature_cyc: coverpoint intf.wb_cyc_i;
    Feature_we: coverpoint intf.wb_we_i;
    Feature_ack: coverpoint intf.wb_ack_o; 
    Feature_data: coverpoint intf.wb_dat_i    
{option.auto_bin_max=8;}
    Feature_resetn: coverpoint intf.RESETN; 
  endgroup
  
  covergroup cov1 @(posedge intf.sys_clk); // reset transitions
    reset_transitneg: coverpoint intf.RESETN {bins seq = (1=>0);}
    reset_transitpos: coverpoint intf.RESETN {bins seq = (0=>1);}
  endgroup

  covergroup cov2 @(posedge intf.sys_clk); // address range access
    address_access: coverpoint intf.wb_addr_i {
      bins lower_address = {[0:11184810]};
      bins mid_address = {[11184811:2*11184810]} ;
      bins higher_address = {[2*11184810+1:$]};
      }
  endgroup
  
  covergroup cov3 @(posedge intf.sys_clk); // WB transitions for 1 bit signals
   cyc_transitions: coverpoint intf.wb_cyc_i {
     bins neg = (1=>0);
     bins pos = (0=>1);
   }
   stb_transitions: coverpoint intf.wb_stb_i {
     bins neg = (1=>0);
     bins pos = (0 =>1);
   }
   
 we_transitions: coverpoint intf.wb_we_i {
     bins neg = (1=>0);
     bins pos = (0=>1);
   }
 
 ack_transitions: coverpoint intf.wb_ack_o {
     bins neg = (1=>0);
     bins pos = (0=>1);
   }
    
    
 sel_transitions: coverpoint intf.wb_sel_i {
     bins neg = (15=>0);
     bins pos = (0=>15);
   }  
   
endgroup
  
  covergroup cov4 @(posedge intf.sys_clk); // data range access
    data_access: coverpoint intf.wb_dat_i {
      bins lower_dat = {[0:715827882]};
      bins mid_dat = {[715827883:2*715827882]} ;
      bins higher_dat = {[2*715827882+1:$]};
      }
  endgroup
  
  covergroup cov5 @(posedge intf.sys_clk); // bank  access
    sdr_bank_access: coverpoint intf.sdr_ba   {
      bins bank_access = {0,1,2,3};
      }
     endgroup
  
  
  covergroup cov6 @(posedge intf.sys_clk); // Sdr transitions for 1 bit signals
   cs_transitions: coverpoint intf.sdr_cs_n {
     bins neg = (1=>0);
     bins pos = (0=>1);
   }
   cke_transitions: coverpoint intf.sdr_cke {
     bins neg = (1=>0);
     bins pos = (0 =>1);
   }
   
 ras_transitions: coverpoint intf.sdr_ras_n{
     bins neg = (1=>0);
     bins pos = (0=>1);
   }
 
 cas_transitions: coverpoint intf.sdr_cas_n {
     bins neg = (1=>0);
     bins pos = (0=>1);
   }
    
    
 we_transitions: coverpoint intf.sdr_we_n {
     bins neg = (1=>0);
     bins pos = (0=>1);
   }  
  
  
  init_transitions: coverpoint intf.sdr_init_done {
     bins neg = (1=>0);
     bins pos = (0=>1);
   } 
  
   
endgroup

  covergroup cov7 @(posedge intf.sys_clk); // sdr address range access
    sdr_addr_access: coverpoint intf.sdr_addr {
      bins lower_add = {[0:682]};
      bins mid_add = {[683:2*682]} ;
      bins higher_add = {[682*2+1:$]};
      }
  endgroup
  
  
covergroup cov8 @(posedge intf.sys_clk); // WB transitions for 1 bit signals
   cyc_transitions: coverpoint intf.wb_cyc_i {
     bins neg = (1 => 0 =>  1);
     bins pos = (0 => 1 =>  0);
   }
   stb_transitions: coverpoint intf.wb_stb_i {
     bins neg = (1 =>0 =>  1);
     bins pos = (0 => 1 =>  0);
   }
   
 we_transitions: coverpoint intf.wb_we_i {
   bins neg = (1 =>0 =>  1);
   bins pos = (0 => 1 =>  0);
   }
 
 ack_transitions: coverpoint intf.wb_ack_o {
   bins neg = (1 => 0 =>  1);
   bins pos = (0 => 1 =>  0);
   }
    
    
 sel_transitions: coverpoint intf.wb_sel_i {
   bins neg = (15 => 0 =>  15);
   bins pos = (0 => 15 => 0);
   }   
endgroup

  covergroup cov9 @(posedge intf.sdram_clk_d); // check if all operations are used
    sdr_commands: coverpoint {intf.sdr_ras_n,intf.sdr_cas_n,intf.sdr_we_n }{
      bins nop = {3'b111};
      bins active = {3'b011};
      bins read = {3'b101};
      bins write = {3'b100};
      bins burst_terminate = {3'b110};
      bins recharge = {3'b010};
      bins autorefresh = {3'b001};
      bins load_mode_register = {3'b000};
    }
    
  endgroup
  
   covergroup cov10 @(posedge intf.sdram_clk_d); // check if all operations are used
    sdr_dq: coverpoint {intf.Dq}{
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
    endgroup
  
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
  
  covergroup cov11 @(posedge intf.sdram_clk_d); // range for dq mask
  sdr_dqm: coverpoint intf.sdr_dqm ;
  endgroup
  
  covergroup cov12 @(posedge intf.sdram_clk_d); // range for cti
  sdr_dqm: coverpoint intf.wb_cti_i;
  endgroup 
  
  covergroup cov13 @(posedge intf.sdram_clk_d); // range for sel
  sdr_dqm: coverpoint intf.wb_sel_i;
  endgroup  
  
 
  function new(virtual intf_cnt intf);
    this.intf =intf;
    cov0 =new();
    cov1 =new();
    cov2 =new();
    cov3 = new();
    cov4 = new();
    cov5 = new();
    cov6 = new();
    cov7 = new();
    cov8 = new();
    cov9 = new();
    cov10 = new();
    cov11 = new();
    cov12 = new();
    cov13 = new();
  endfunction


endclass