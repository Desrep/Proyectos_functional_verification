//Reference https://verificationguide.com/uvm/uvm-testbench-architecture/

import uvm_pkg::*;

module top_hvl();

initial begin  
  run_test("sdr_wr_rd_test");
end
  
endmodule
