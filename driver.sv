class driver;
    stimulus sti;
 	scoreboard sb;
  	virtual intf_cnt intf;  
  
	function new(virtual intf_cnt intf,scoreboard sb);
    	this.intf = intf;
    	this.sb = sb;
	endfunction
  
   //Initialization task
  	task init();
		intf.wb_addr_i = 0;
   		intf.wb_dat_i  = 0;
   		intf.wb_sel_i  = 4'h0;
   		intf.wb_we_i   = 0;
   		intf.wb_stb_i  = 0;
   		intf.wb_cyc_i  = 0;
   		intf.RESETN    = 1'h0;
   		#100;  
    endtask
   //Rest task
	task reset();  
		#100
		intf.RESETN    = 1'h0;  // Applying reset
  		#1000
		intf.RESETN    = 1'h1; ;// Releasing reset
  		#1000;
    	wait(intf.sdr_init_done == 1); 
  	endtask
  
    //Write random task 
task burst_write_rand();
		int i;
		reg [31:0] Address;
		reg [7:0]  bl;
		begin
          Address = $random & 32'h0FFFFFFF;// generate random address (antes 22 bits)
          bl = ($random & 8'h07)+1;  // burst lenght
  		sb.afifo.push_back(Address);
  		sb.bfifo.push_back(bl);
  		sb.mfifo.push_back(bl);
  //@ (negedge intf.sys_clk);
 // $display("Write Address: %x, Burst Size: %d",Address[31:2],bl);
          
   		for(i=0; i < bl; i++) begin
     		@ (posedge intf.sys_clk);
      		intf.wb_stb_i        = 1;
      		intf.wb_cyc_i        = 1;
      		intf.wb_we_i         = 1;
      		intf.wb_sel_i        = 4'b1111;
      		intf.wb_addr_i       = Address[31:2]+i;
      		intf.wb_dat_i        = $random & 32'hFFFFFFFF;
     		sb.mem_model[Address[31:2]+i] = intf.wb_dat_i; //store input in model
          if (i == 0) begin
            sb.address_decode(Address[31:2]);// store row and other address
          end
          else begin
            sb.address_decode_col_bank(Address[31:2]+i); // store bank and col address
          end
     		sb.cafifo.push_back(intf.wb_addr_i); // store address for checker

           while(intf.wb_ack_o == 1'b0) begin
          	@ (posedge intf.sys_clk);
          end
     		@(posedge intf.sys_clk);
          intf.wb_stb_i        = 0;
          intf.wb_we_i         = 0;
          intf.wb_sel_i        = 4'b0;
     //$display("Status: Burst-No: %d  Write Address: %x  WriteData: %x ",i,Address[31:2]+i,intf.wb_dat_i);
   		end
   			intf.wb_stb_i        = 0;
   			intf.wb_cyc_i        = 0;
   			intf.wb_we_i         = 'hx;
   			intf.wb_sel_i        = 'hx;
   			intf.wb_addr_i       = 'hx;
   			intf.wb_dat_i        = 'hx;
		end
	endtask
  
    //Write task
	task burst_write;
		reg [31:0] Address;
		reg [7:0]  bl;
		int i;
		begin
            sti = new();
          	sti.random(); // Generate stimulus
            bl = sti.burstlength; // Drive to DUT
            Address = sti.address; // Drive to DUT
  			sb.afifo.push_back(Address);
  			sb.bfifo.push_back(bl);
  			sb.mfifo.push_back(bl);
   			$display("Write Address: %x, Burst Size: %d",Address,bl);
   			for(i=0; i < bl; i++) begin
     			@ (posedge intf.sys_clk);
      			intf.wb_stb_i        = 1;
      			intf.wb_cyc_i        = 1;
      			intf.wb_we_i         = 1;
      			intf.wb_sel_i        = 4'b1111;
      			intf.wb_addr_i       = Address[31:2]+i;
      			intf.wb_dat_i        = $random & 32'hFFFFFFFF;
     			sb.mem_model[Address[31:2]+i] = intf.wb_dat_i; // store input in model
     			sb.cafifo.push_back(intf.wb_addr_i); //store address for the checker
        		while(intf.wb_ack_o == 1'b0) begin
          			@ (posedge intf.sys_clk);
        		end
     			@(posedge intf.sys_clk);
        	   intf.wb_stb_i        = 0;
               intf.wb_we_i         = 0;
               intf.wb_sel_i        = 4'b0;
     			$display("Status: Burst-No: %d  Write Address: %x  WriteData: %x ",i,intf.wb_addr_i,intf.wb_dat_i);
   			end
   			intf.wb_stb_i        = 0;
   			intf.wb_cyc_i        = 0;
   			intf.wb_we_i         = 'hx;
   			intf.wb_sel_i        = 'hx;
   			intf.wb_addr_i       = 'hx;
   			intf.wb_dat_i        = 'hx;
		end
	endtask
	//	read task
	task burst_read;
		reg [31:0] Address;
		reg [7:0]  bl;
		int j;
		begin
  			Address = sb.afifo.pop_front(); // get information from the write stage 
   			bl      = sb.bfifo.pop_front(); 
            
      		for(j=0; j < bl; j++) begin
         		@ (posedge intf.sys_clk);
         		intf.wb_stb_i        = 1;
         		intf.wb_cyc_i        = 1;
         		intf.wb_we_i         = 0;
         		intf.wb_sel_i        = 4'b1111;
         		intf.wb_addr_i       = Address[31:2]+j;
        		while(intf.wb_ack_o == 1'b0) begin
                   @ (posedge intf.sys_clk);
        		end
        		sb.output_data[Address[31:2]+j]=(intf.wb_dat_o); // store output for checker
        //$display("Status: Burst-No: %d  Read Address: %x  read data: %x ",j,Address[31:2]+j,sb.output_data[Address[31:2]+j]);
        		@(posedge intf.sys_clk);
        		intf.wb_stb_i        = 0;  
                intf.wb_sel_i        = 4'b0;
			end
   			intf.wb_stb_i        = 0;
   			intf.wb_cyc_i        = 0;
  			intf.wb_we_i         = 'hx;
   			intf.wb_addr_i       = 'hx;
  			intf.wb_sel_i        = 'hx;
		end
	endtask 
  
endclass
