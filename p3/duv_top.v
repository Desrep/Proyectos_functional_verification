import uvm_pkg::*;

module duv_top(); 

    parameter P_SYS  = 10;     //    200MHz
	parameter P_SDR  = 20;     //    100MHz
	reg            sdram_clk;
	reg            sys_clk;
	initial sys_clk = 0; // clock generator
	initial sdram_clk = 0; // clock generator
	always #(P_SYS/2) sys_clk = !sys_clk;
	always #(P_SDR/2) sdram_clk = !sdram_clk;
	// Interface
	sdr_if intf(sys_clk,sdram_clk);
	// to fix the sdram interface timing issue
  
  

`ifdef SDR_32BIT
	sdrc_top #(.SDR_DW(32),.SDR_BW(4)) u_dut(
	`elsif SDR_16BIT 
   	sdrc_top #(.SDR_DW(16),.SDR_BW(2)) u_dut(
	`else  // 8 BIT SDRAM
   	sdrc_top #(.SDR_DW(8),.SDR_BW(1)) u_dut(
	`endif
     // System 
	`ifdef SDR_32BIT
          .cfg_sdr_width      (2'b00              ), // 32 BIT SDRAM
	`elsif SDR_16BIT
          .cfg_sdr_width      (2'b01              ), // 16 BIT SDRAM
	`else 
          .cfg_sdr_width      (2'b10              ), // 8 BIT SDRAM
	`endif
          .cfg_colbits        (intf.cfg_colbits), // 8 Bit Column 		Address
/* WISH BONE */
     	  .wb_rst_i           (!intf.RESETN            ),
     	  .wb_clk_i           (intf.sys_clk            ),
     	  .wb_stb_i           (intf.wb_stb_i           ),
          .wb_ack_o           (intf.wb_ack_o           ),
          .wb_addr_i          (intf.wb_addr_i          ),
          .wb_we_i            (intf.wb_we_i            ),
          .wb_dat_i           (intf.wb_dat_i           ),
          .wb_sel_i           (intf.wb_sel_i           ),
          .wb_dat_o           (intf.wb_dat_o           ),
          .wb_cyc_i           (intf.wb_cyc_i           ),
          .wb_cti_i           (intf.wb_cti_i           ), 

/* Interface to SDRAMs */
          .sdram_clk          (intf.sdram_clk          ),
          .sdram_resetn       (intf.RESETN             ),
          .sdr_cs_n           (intf.sdr_cs_n           ),
          .sdr_cke            (intf.sdr_cke            ),
          .sdr_ras_n          (intf.sdr_ras_n          ),
          .sdr_cas_n          (intf.sdr_cas_n          ),
          .sdr_we_n           (intf.sdr_we_n           ),
          .sdr_dqm            (intf.sdr_dqm            ),
          .sdr_ba             (intf.sdr_ba             ),
          .sdr_addr           (intf.sdr_addr           ), 
          .sdr_dq             (intf.Dq                 ),

    /* Parameters */
          .sdr_init_done      (intf.sdr_init_done),
          .cfg_req_depth      (intf.cfg_req_depth),	        //how many req. buffer should hold
          .cfg_sdr_en         (intf.cfg_sdr_en  ),
          .cfg_sdr_mode_reg   (intf.cfg_sdr_mode_reg ),
          .cfg_sdr_tras_d     (intf.cfg_sdr_tras_d ),
          .cfg_sdr_trp_d      (intf.cfg_sdr_trp_d  ),
          .cfg_sdr_trcd_d     (intf.cfg_sdr_trcd_d ),
          .cfg_sdr_cas        (intf.cfg_sdr_cas),
          .cfg_sdr_trcar_d    (intf.cfg_sdr_trcar_d),
          .cfg_sdr_twr_d      (intf.cfg_sdr_twr_d ),
          .cfg_sdr_rfsh       (intf.cfg_sdr_rfsh), // reduced from 12'hC35
          .cfg_sdr_rfmax      (intf.cfg_sdr_rfmax  )
);


`ifdef SDR_32BIT
mt48lc2m32b2 #(.data_bits(32)) u_sdram32 (
          .Dq                 (intf.Dq                 ) , 
          .Addr               (intf.sdr_addr[10:0]     ), 
          .Ba                 (intf.sdr_ba             ), 
           .Clk                (intf.sdram_clk_d        ), 
          .Cke                (intf.sdr_cke            ), 
          .Cs_n               (intf.sdr_cs_n           ), 
          .Ras_n              (intf.sdr_ras_n          ), 
          .Cas_n              (intf.sdr_cas_n          ), 
          .We_n               (intf.sdr_we_n           ), 
          .Dqm                (intf.sdr_dqm            )
     );

`elsif SDR_16BIT

   IS42VM16400K u_sdram16 (
          .dq                 (intf.Dq                 ), 
          .addr               (intf.sdr_addr[11:0]     ), 
          .ba                 (intf.sdr_ba             ), 
          .clk                (intf.sdram_clk_d        ), 
          .cke                (intf.sdr_cke            ), 
          .csb                (intf.sdr_cs_n           ), 
          .rasb               (intf.sdr_ras_n          ), 
          .casb               (intf.sdr_cas_n          ), 
          .web                (intf.sdr_we_n           ), 
          .dqm                (intf.sdr_dqm            )
    );
`else 


mt48lc8m8a2 #(.data_bits(8)) u_sdram8 (
          .Dq                 (intf.Dq                 ) , 
          .Addr               (intf.sdr_addr[11:0]     ), 
          .Ba                 (intf.sdr_ba             ), 
          .Clk                (intf.sdram_clk_d        ), 
          .Cke                (intf.sdr_cke            ), 
          .Cs_n               (intf.sdr_cs_n           ), 
          .Ras_n              (intf.sdr_ras_n          ), 
          .Cas_n              (intf.sdr_cas_n          ), 
          .We_n               (intf.sdr_we_n           ), 
          .Dqm                (intf.sdr_dqm            )
     );
`endif

initial begin
  $dumpfile("dump.vcd"); 
  $dumpvars;

  uvm_config_db#(virtual sdr_if)::set(uvm_root::get(),"*","vif",intf);
end  
      
endmodule
