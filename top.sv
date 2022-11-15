`timescale 1ns/1ps
module top();
	parameter P_SYS  = 10;     //    200MHz
	parameter P_SDR  = 20;     //    100MHz
	reg            sdram_clk;
	reg            sys_clk;
	initial sys_clk = 0; // clock generator
	initial sdram_clk = 0; // clock generator
	always #(P_SYS/2) sys_clk = !sys_clk;
	always #(P_SDR/2) sdram_clk = !sdram_clk;
	// Interface
	intf_cnt intf(sys_clk,sdram_clk);
	// to fix the sdram interface timing issue
	//wire #(2.0) sdram_clk_d   = sdram_clk;
   duv_top tb_dut();



  initial begin
    $dumpfile("verilog.vcd");
    $dumpvars(0);
    
  end
 
  // Test Case
     //write_read_deterministic test1(intf);
     write_read_random test2(intf);

endmodule
