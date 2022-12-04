class monitor;
  scoreboard sb;
  virtual intf_cnt intf;

 
  reg [31:0] ErrCnt; // error count
  reg [31:0]   exp_data;
  int error_count_after;
  int auto_refresh;
  
  
  
  function new(virtual intf_cnt intf,scoreboard sb);
    this.intf = intf;
    this.sb = sb;
    this.ErrCnt = 0;
    this.error_count_after=0;
  endfunction
          
  task check(); // transaction checker 
     int out_dat;
     int exp_dat;
     reg [7:0]  bl;
     reg [31:0] Address;
     int j;
     forever begin
       @(posedge intf.wb_ack_o);// at the end of the transaction 
       if ((intf.wb_we_i == 0)&&(intf.wb_cyc_i == 1)) begin // if active cycle during read
              Address = sb.cafifo.pop_front();
              out_dat = sb.output_data[Address];
              exp_dat = sb.mem_model[Address];// expected data
              if(out_dat != exp_dat) begin
                 this.ErrCnt = this.ErrCnt+1; // error counter as output
                 sb.check_count++;// to make sure it checks
               $display("FAIL>>>READ ERROR: Addr: %x Rxp: %x Exd: %x",Address,out_dat,exp_data);
              end
              else begin
               //$display("PASS>>>READ STATUS: Addr: %x Rxd: %x",Address,out_dat);
                 sb.check_count++;
              end
      end //if
   end //forever
endtask

task address_store(); // this method checks only after the test finishes 
     int out_dat;
     int exp_dat;
     reg [7:0]  bl;
  reg [31:0] row_address_in;
  reg [31:0] row_address_out;
     int j;
     forever begin
      
       if( sb.test_done == 1) begin
         $display("add in %d",sb.row_add_in.size());
         $display("add out %d",sb.row_add_out.size());
         $display("col add out %d",sb.colum_add_out.size());
         $display("col add in %d",sb.colum_add_in.size());
         
         while(sb.row_add_in.size())begin
           $display("FAIL>>>Address decode error: Addr_exp: %x Address_rec: %x",sb.colum_add_out.pop_front(),sb.colum_add_in.pop_front());
           
           row_address_in = sb.row_add_in.pop_front();
           row_address_out = sb.row_add_out.pop_front();
           if(row_address_in[10:0] != row_address_out) begin
              this.ErrCnt = this.ErrCnt+1; // error counter as output
              sb.check_count++;// to make sure it checks
             $display("FAIL>>>Address decode error: Addr_exp: %x Address_rec: %x",row_address_in[10:0],row_address_out);
             $display("at :: time  %0t", $time); 
           end
           else begin
             $display("PASS>>>Address decode : Addr_exp: %x Address_rec: %x",row_address_in[10:0],row_address_out);
             sb.check_count++;// to make sure it checks
           end
         end//while
         sb.test_done = 0;
         
       end // test done if
      
       @(posedge intf.sdram_clk);
       
       //if ((intf.wb_stb_i == 1)&&(intf.wb_cyc_i == 1)) begin // if active cycle
       if((intf.sdr_ras_n == 0)&&(intf.sdr_cas_n==0)&&(intf.sdr_we_n)&&(sb.row_add_out.size())) begin
            auto_refresh = 1; 
           
          end
         
         if((intf.sdr_ras_n == 0)&&(intf.sdr_cas_n)&&(intf.sdr_we_n)&&(!intf.sdr_cs_n)&&(intf.sdr_cke )) begin //active (row)
             
           
           
           `ifdef SDR_32BIT
           if(auto_refresh==1) begin // if there was an auto-refresh don't count it
           
           auto_refresh = 0;
           end
           else begin
           sb.row_add_out.push_back(intf.sdr_addr[10:0]);
           end
          
  
          
           `else 
           if(auto_refresh==1) begin // if there was an auto-refresh don't count it
           
           auto_refresh = 0;
           end
           else begin
           sb.row_add_out.push_back(intf.sdr_addr);
           end 
           `endif 
        
         end // internal if      
        
         if((intf.sdr_ras_n)&&(intf.sdr_cas_n==0)&&(intf.sdr_we_n)&&(!intf.sdr_cs_n)&&(intf.sdr_cke )&&0) begin// read
               
           `ifdef SDR_32BIT
           sb.colum_add_out.push_back(intf.sdr_addr[10:0]);
          
           `else 
           sb.colum_add_out.push_back(intf.sdr_addr);  
           `endif 
        
         end // internal if       
         
         if((intf.sdr_ras_n )&&(intf.sdr_cas_n==0)&&(intf.sdr_we_n==0)&&(!intf.sdr_cs_n)&&(intf.sdr_cke )&&(sb.row_add_out.size())) begin//write
               
           `ifdef SDR_32BIT
              sb.colum_add_out.push_back(intf.sdr_addr[10:0]);
         
           `else 
             sb.colum_add_out.push_back(intf.sdr_addr);  
           `endif 
        
         end // internal if      
         
         
      //end //if  active cycle
   end //forever
endtask   
  
  
  
task address_check(); //  
     int out_dat;
     int exp_dat;
     reg [7:0]  bl;
     reg [31:0] Address;
     int j;
     forever begin
       @(intf.sdr_cas_n or intf.sdr_ras_n or intf.sdr_we_n )
       if ((intf.wb_stb_i == 1)&&(intf.wb_cyc_i == 1)) begin // if active cycle
         if((intf.sdr_ras_n == 0)&&(intf.sdr_cas_n)&&(intf.sdr_we_n)) begin
               Address = sb.row_add_in.pop_front();
           `ifdef SDR_32BIT
           if(Address == intf.sdr_addr[10:0])begin
           `else 
           if(Address == intf.sdr_addr)begin     
           `endif 
                $display("PASS>>>Address decode: Addr_expected: %x Address_rec: %x",Address,intf.sdr_addr[10:0]);
                 sb.check_count++;
              end
              else begin
                 this.ErrCnt = this.ErrCnt+1; // error counter as output
                 sb.check_count++;// to make sure it checks
                $display("FAIL>>>Address decode error: Addr_exp: %x Address_rec: %x",Address,intf.sdr_addr[10:0]);
              end         
         end // internal if      
      end //if
   end //forever
endtask 
  

  
endclass
