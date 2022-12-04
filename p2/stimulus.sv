class stimulus;
  //rand  logic[7:0] burstlength;
  //rand  logic[31:0] address;
  reg [7:0] burstlength;
  reg [31:0] address;
  task random();
    this.burstlength = $urandom_range(8'h4, 8'hF);
  	this.address = $urandom_range(32'h4_0000,32'h0017_0FAC);
  endtask
  //constraint distribution {value dist { 0  := 1 , 1 := 1 }; } 
endclass