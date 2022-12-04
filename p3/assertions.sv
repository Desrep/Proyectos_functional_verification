`define DUV_PATH duv_top.intf
`define DRAM_PATH duv_top.u_dut

module bus_protocol_assertions();


always_comb begin
    if(`DUV_PATH.wb_ack_o == 1) begin
      rule_335: assert ((`DUV_PATH.wb_stb_i == 1) && (`DUV_PATH.wb_cyc_i ==1)) else $error("Reset rule 3.35 violated"); // rule 3.35
    end
  end

  property rule_320pt1;
//    disable iff (!`DUV_PATH.RESETN)
    @(posedge `DUV_PATH.sys_clk) $rose(!`DUV_PATH.RESETN)|=> (`DUV_PATH.wb_stb_i == 0) && (`DUV_PATH.wb_cyc_i == 0); // rule 3.20 pt1
  endproperty

 property rule_320pt2;
   disable iff (!`DUV_PATH.RESETN)
   @(posedge `DUV_PATH.sys_clk) $fell(!`DUV_PATH.RESETN)|=> (`DUV_PATH.wb_stb_i == 0) && (`DUV_PATH.wb_cyc_i == 0); // rule 3.20 pt2
  endproperty

 property rule_325pt1;
   disable iff (!`DUV_PATH.RESETN)
   @(posedge `DUV_PATH.sys_clk) $rose(`DUV_PATH.wb_stb_i) |-> (`DUV_PATH.wb_cyc_i==1); // rule 3.25 pt1
 endproperty

 property rule_325pt2;
    disable iff (!`DUV_PATH.RESETN||!`DUV_PATH.sdr_init_done||(`DUV_PATH.sdr_init_done===1'bx))
    @(posedge `DUV_PATH.sys_clk) $fell(`DUV_PATH.wb_stb_i) |-> ($past(`DUV_PATH.wb_cyc_i,1) == 1); // rule 3.25 pt2
 endproperty

 property rule_360pt1;
   disable iff (!`DUV_PATH.RESETN||!`DUV_PATH.sdr_init_done||(`DUV_PATH.sdr_init_done===1'bx))
   @(posedge `DUV_PATH.sys_clk) (`DUV_PATH.wb_we_i==1) |-> (`DUV_PATH.wb_stb_i == 1); // rule 3.60 pt1
 endproperty

 property rule_375pt1;
   disable iff (!`DUV_PATH.RESETN)
   @(posedge `DUV_PATH.sys_clk) (`DUV_PATH.wb_we_i==1) |-> (`DUV_PATH.wb_stb_i == 1); // rule 3.75 pt1
 endproperty



  property dram_out_enable; //clk enabled when cs selected
   disable iff (!`DUV_PATH.RESETN)
    @(posedge `DUV_PATH.sdram_clk_d ) (`DUV_PATH.sdr_cs_n == 0 ) |-> (`DUV_PATH.sdr_cke == 1);
 endproperty

 property dram_data_valid; //data enabled when cs selected
   disable iff (!`DUV_PATH.RESETN)
     @(posedge `DUV_PATH.sdram_clk_d ) (`DUV_PATH.sdr_cs_n == 0 )&& (`DUV_PATH.sdr_cke == 1) |-> (`DRAM_PATH.cfg_sdr_en == 1 ) ;
 endproperty


 property dram_cmd_valid_read; //read is valid
   disable iff (!`DUV_PATH.RESETN)
   @(posedge `DUV_PATH.sdram_clk_d ) (`DUV_PATH.sdr_ras_n) && (`DUV_PATH.sdr_cas_n==0) && (`DUV_PATH.sdr_we_n) |-> (`DUV_PATH.sdr_cke) && (`DUV_PATH.sdr_cs_n == 0 )  ;
 endproperty


property dram_cmd_valid_write; //write is valid
   disable iff (!`DUV_PATH.RESETN)
  @(posedge `DUV_PATH.sdram_clk_d ) (`DUV_PATH.sdr_ras_n) && (`DUV_PATH.sdr_cas_n==0) && (`DUV_PATH.sdr_we_n==0) |-> (`DUV_PATH.sdr_cke) && (`DUV_PATH.sdr_cs_n == 0 )  ;
 endproperty


property dram_cmd_valid_active; //active is valid
   disable iff (!`DUV_PATH.RESETN)
  @(posedge `DUV_PATH.sdram_clk_d ) (`DUV_PATH.sdr_ras_n==0) && (`DUV_PATH.sdr_cas_n) && (`DUV_PATH.sdr_we_n) |-> (`DUV_PATH.sdr_cke) && (`DUV_PATH.sdr_cs_n == 0 )  ;
endproperty

  after_reset0: assert property (rule_320pt1) else $error("Reset rule 3.20 violated");
  after_reset1: assert property (rule_320pt2) else $error("Reset rule 3.20 violated");
  valid_cicle0: assert property (rule_325pt1) else $error("Reset rule 3.25 violated");
  valid_cicle1: assert property (rule_325pt2) else $error("Reset rule 3.25 violated");
  //valid_write0: assert property (rule_360pt1) else $error("Reset rule 3.60 violated");
  cs_valid: assert property (dram_out_enable) else $error("CS dram signal invalid");
  data_valid: assert property (dram_data_valid) else $error("Data enable dram signal invalid");
  read_valid: assert property (dram_cmd_valid_read) else $error("read command DRAM invalid");
  write_valid: assert property (dram_cmd_valid_write) else $error("write command DRAM invalid");
  active_valid: assert property (dram_cmd_valid_active) else $error("Active command DRAM invalid");

endmodule
