class scoreboard;
  //--------------------
// data/address/burst length FIFO
//--------------------
  
int cfg_colbits = 2'b00;
 
int afifo[$]; // address  fifo
int cafifo[$]; // checker address fifo
int bfifo[$]; // Burst Length fifo
int mfifo[$]; // Burst Length fifo for monitor
int mem_model[int]; // assosiative array model
int output_data[int]; // output data fifo
  
int test_done;

reg[31:0] bank_add_in[$];
reg[31:0] colum_add_in[$];
reg[31:0] row_add_in[$];

reg[31:0] bank_add_out[$];
reg[31:0] colum_add_out[$];
reg[31:0] row_add_out[$];  
  
 
 int check_count;
int check_count_decode;
  
task address_decode(reg[31:0] inp_address);
  if(this.cfg_colbits == 2'b00)begin
    this.colum_add_in.push_back({4'h0,inp_address[7:0]});
    this.bank_add_in.push_back(inp_address[9:8]);
    this.row_add_in.push_back(inp_address[21:10]);
  end    
endtask
  
task address_decode_col_bank(reg[31:0] inp_address);
  if(this.cfg_colbits == 2'b00)begin
    this.colum_add_in.push_back({4'h0,inp_address[7:0]});
    this.bank_add_in.push_back(inp_address[9:8]);
  end    
endtask
  
  
  
  function new();
    this.check_count = 0;
    this.check_count_decode = 0;
    this.test_done = 0;
  endfunction
  
endclass