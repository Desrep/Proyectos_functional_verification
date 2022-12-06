`uvm_analysis_imp_decl(_export_decode)
`uvm_analysis_imp_decl(_export_data)
`uvm_analysis_imp_decl(_export_decode_col)
class sdr_scoreboard extends uvm_scoreboard;

  //---------------------------------------
  // Virtual Interface
  //---------------------------------------
  virtual sdr_if vif;
  
  //---------------------------------------
  // declaring pkt_qu to store the pkt's recived from monitor
  //---------------------------------------
  sdr_seq_item pkt_qu[$];
   sdr_seq_item pkt_decode[$];
  sdr_seq_item pkt_col[$];
  functional_coverage funcov;

  int data_check;
  int row_check;
  int bank_check;
  int col_check;

  int ulim_col;
  int ulim_bank;
  int llim_bank;
  int ulim_row;
  int llim_row;
  int llim_col = 0;

  //---------------------------------------
  // sc_mem 
  //---------------------------------------
  bit [31:0] sc_mem [int];
  bit [11:0] col_decode_buff[int];
  bit [11:0] col_expected_buff[int];
  bit [11:0] bank_decode_buff[int];
  bit [11:0] bank_expected_buff[int];
  bit [11:0] row_expected_buff[int];
  bit [11:0] row_decode_buff[int];

  //---------------------------------------
  //port to recive packets from monitor
  //---------------------------------------
  uvm_analysis_imp_export_data#(sdr_seq_item, sdr_scoreboard) item_collected_export_data;
  uvm_analysis_imp_export_decode#(sdr_seq_item, sdr_scoreboard) item_collected_export_decode;
  uvm_analysis_imp_export_decode_col#(sdr_seq_item, sdr_scoreboard) item_collected_export_decode_col;
  `uvm_component_utils(sdr_scoreboard)

  //---------------------------------------
  // new - constructor
  //---------------------------------------
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  //---------------------------------------
  // build_phase - create port and initialize local memory
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
      if(!uvm_config_db#(virtual sdr_if)::get(this, "", "vif", vif))
       `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
      item_collected_export_data = new("item_collected_export", this);
    item_collected_export_decode = new("item_collected_export_decode", this);
    item_collected_export_decode_col = new("item_collected_export_decode_col", this);
    funcov = new(vif);
    //foreach(sc_mem[i]) sc_mem[i] = 32'hFFFFFFFF;
  endfunction: build_phase
  
  //---------------------------------------
  // write task - recives the pkt from monitor and pushes into queue
  //---------------------------------------
  virtual function void write_export_data(sdr_seq_item pkt);
    //pkt.print();
    pkt_qu.push_back(pkt);
  endfunction : write_export_data

  
    virtual function void write_export_decode(sdr_seq_item pkt);
    //pkt.print();
    pkt_decode.push_back(pkt);
    if(pkt.row_add_out == ((pkt.addr>>llim_row)&&(~((-1)<<(ulim_row-llim_row+1))))) begin
      row_decode_buff[pkt.addr] = pkt.row_add_out;
      row_expected_buff[pkt.addr] =((pkt.addr>>llim_row)&&(~((-1)<<(ulim_row-llim_row+1)))) ;
    end
  

  endfunction : write_export_decode
  
  
  
  virtual function void write_export_decode_col(sdr_seq_item pkt);
    //pkt.print();
    pkt_col.push_back(pkt);
    if(pkt.colum_add_out == ((pkt.addr>>llim_col)&&(~((-1)<<(ulim_col-llim_col+1))))) begin
    col_decode_buff[pkt.addr] = pkt.colum_add_out;
      col_expected_buff[pkt.addr] =((pkt.addr>>llim_col)&&(~((-1)<<(ulim_col-llim_col+1))));
    end

    if(pkt.bank_add_out == ((pkt.addr>>llim_bank)&&(~((-1)<<(ulim_bank-llim_bank+1)))))begin
      bank_decode_buff[pkt.addr] = pkt.bank_add_out;
      bank_expected_buff[pkt.addr] = ((pkt.addr>>llim_bank)&&(~((-1)<<(ulim_bank-llim_bank+1))));
    end
    
  endfunction : write_export_decode_col
  //---------------------------------------
  // run_phase - compare's the read data with the expected data(stored in local memory)
  // local memory will be updated on the write operation.
  //---------------------------------------
  virtual task run_phase(uvm_phase phase);
    sdr_seq_item sdr_pkt;
    sdr_seq_item sdr_pkt_decode;
    sdr_seq_item sdr_pkt_col;

    int read_count = 0;
    int precharge_count = 0;
    
   
     forever begin
      if( vif.cfg_colbits == 0) begin
      ulim_col = 7;
      ulim_bank = 9;
      llim_bank = 8;
      ulim_row = 21;
      llim_row = 10;
      end  
      if( vif.cfg_colbits == 1) begin
      ulim_col = 8;
      ulim_bank = 10;
      llim_bank = 9;
      ulim_row = 22;
      llim_row = 11;
      end

      if( vif.cfg_colbits == 2) begin
      ulim_col = 9;
      ulim_bank = 11;
      llim_bank = 10;
      ulim_row = 23;
      llim_row = 12;
      end
      
      if( vif.cfg_colbits == 3) begin
      ulim_col = 10;
      ulim_bank = 12;
      llim_bank = 11;
      ulim_row = 24;
      llim_row = 13;
      end


      wait((pkt_qu.size() > 0));
      sdr_pkt = pkt_qu.pop_front();
      sdr_pkt_col = pkt_col.pop_front();
      
     
      if (vif.wb_we_i==0)  begin
        
        
        if(read_count != 0) begin
        
          if(col_expected_buff[sdr_pkt.addr]== col_decode_buff[sdr_pkt.addr]) begin 
           // `uvm_info(get_type_name(),$sformatf("**********:: Col match :: ***********"),UVM_LOW)
      //  `uvm_info(get_type_name(),$sformatf("Addr: %0h",sdr_pkt.addr),UVM_LOW)
       //   `uvm_info(get_type_name(),$sformatf("Expected Col Addr: %0h Actual Col Addr: %0h",sdr_pkt.colum_add_in,sdr_pkt.colum_add_out),UVM_LOW)
              col_check++;
        end
        if(col_expected_buff[sdr_pkt.addr]!= col_decode_buff[sdr_pkt.addr]) begin 
           
          `uvm_error(get_type_name(),"*******:: Col mismatch :: *******")
        `uvm_info(get_type_name(),$sformatf("Addr: %0h",sdr_pkt.addr),UVM_LOW)
         `uvm_info(get_type_name(),$sformatf("Expected Col Addr: %0h Actual Col Addr: %0h",sdr_pkt.colum_add_in,col_decode_buff[sdr_pkt.addr]),UVM_LOW)
          
       end
        
        end 
        
        if(read_count == 0) begin
        
          if(col_expected_buff[sdr_pkt.addr]== col_decode_buff[sdr_pkt.addr]) begin 
            //   `uvm_info(get_type_name(),$sformatf("*******:: Col match :: *******"),UVM_LOW)
     //   `uvm_info(get_type_name(),$sformatf("Addr: %0h",sdr_pkt.addr),UVM_LOW)
     //     `uvm_info(get_type_name(),$sformatf("Expected Col Addr: %0h Actual Col Addr: %0h",sdr_pkt_col.colum_add_in,sdr_pkt_col.colum_add_out),UVM_LOW)
            col_check++;
        end
          if(col_expected_buff[sdr_pkt.addr] != col_decode_buff[sdr_pkt.addr]) begin 
           
            `uvm_error(get_type_name(),"****** :: Col mismatch :: ********")
        `uvm_info(get_type_name(),$sformatf("Addr: %0h",sdr_pkt.addr),UVM_LOW)
         `uvm_info(get_type_name(),$sformatf("Expected Col Addr: %0h Actual Col Addr: %0h",sdr_pkt_col.colum_add_in,col_decode_buff[sdr_pkt.addr]),UVM_LOW)
   
       end
          read_count ++;
        end
        
        
        
        
        if(bank_expected_buff[sdr_pkt.addr] == bank_decode_buff[sdr_pkt.addr]) begin 
           //   `uvm_info(get_type_name(),$sformatf("***** :: Bank match :: ******"),UVM_LOW)
      //  `uvm_info(get_type_name(),$sformatf("Addr: %0h",sdr_pkt.addr),UVM_LOW)
     //     `uvm_info(get_type_name(),$sformatf("Expected bank Addr: %0h Actual bank Addr: %0h",sdr_pkt.bank_add_in,sdr_pkt.bank_add_out),UVM_LOW)
           bank_check++;
        end
        if(bank_expected_buff[sdr_pkt.addr] != bank_decode_buff[sdr_pkt.addr]) begin 
           
          `uvm_error(get_type_name(),"-******* :: Bank mismatch :: ******")
         `uvm_info(get_type_name(),$sformatf("Addr: %0h",sdr_pkt.addr),UVM_LOW)
         `uvm_info(get_type_name(),$sformatf("Expected bank Addr: %0h Actual bank Addr: %0h",bank_expected_buff[sdr_pkt.addr],bank_decode_buff[sdr_pkt.addr]),UVM_LOW)
          
       end
         //if((pkt_decode.size()>0))
        // begin
	if(row_decode_buff.exists(sdr_pkt.addr)) begin
         sdr_pkt_decode = pkt_decode.pop_front();
        if((row_expected_buff[sdr_pkt.addr] == row_decode_buff[sdr_pkt.addr])) begin 
        //  `uvm_info(get_type_name(),$sformatf("------ :: Row match :: ------"),UVM_LOW)
        //`uvm_info(get_type_name(),$sformatf("Addr: %0h",sdr_pkt.addr),UVM_LOW)
        //  `uvm_info(get_type_name(),$sformatf("Expected row Addr: %0h Actual row Addr: %0h",row_expected_buff[sdr_pkt.addr],row_decode_buff[sdr_pkt.addr]),UVM_LOW)
            row_check++;
        end
        if((row_expected_buff[sdr_pkt.addr] != row_decode_buff[sdr_pkt.addr])) begin 
           
          `uvm_error(get_type_name(),"******* :: Row mismatch :: *******")
         `uvm_info(get_type_name(),$sformatf("Addr: %0h",sdr_pkt.addr),UVM_LOW)
          `uvm_info(get_type_name(),$sformatf("Expected row Addr: %0h Actual row Addr: %0h",row_expected_buff[sdr_pkt.addr] , row_decode_buff[sdr_pkt.addr]),UVM_LOW)
   
       end
      end


     end    

      if(vif.wb_we_i) begin
        sc_mem[sdr_pkt.addr] = sdr_pkt.wdata;
        // `uvm_info(get_type_name(),$sformatf(" ***** :: Data write      :: ******"),UVM_LOW)
       // `uvm_info(get_type_name(),$sformatf("Addr: %0h",sdr_pkt.addr),UVM_LOW)
       // `uvm_info(get_type_name(),$sformatf("Data: %0h",sdr_pkt.wdata),UVM_LOW)
       // `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)   
        read_count = 0;
        
      end
      else if((vif.wb_we_i == 0)) begin
        if(sc_mem[sdr_pkt.addr] == vif.wb_dat_o) begin
         //  `uvm_info(get_type_name(),$sformatf("******* :: Read data match :: ******"),UVM_LOW)
         // `uvm_info(get_type_name(),$sformatf("Addr: %0h",sdr_pkt.addr),UVM_LOW)
          //`uvm_info(get_type_name(),$sformatf("Expected Data: %0h Actual Data: %0h",sc_mem[sdr_pkt.addr],vif.wb_dat_o),UVM_LOW)
         // `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
             data_check++;
          //$display("Checks data %0d row %0d col %0d bank %0d",data_check, row_check, col_check,bank_check);
        end
        else begin
          `uvm_error(get_type_name(),"*******:: Read data mismatch :: ********")
          `uvm_info(get_type_name(),$sformatf("Addr: %0h",sdr_pkt.addr),UVM_LOW)
          `uvm_info(get_type_name(),$sformatf("Expected Data: %0h Actual Data: %0h",sc_mem[sdr_pkt.addr],sdr_pkt.rdata),UVM_LOW)
          `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
          precharge_count = 0;
        end
      end
    end
    
      
   
      
    
  endtask : run_phase
endclass : sdr_scoreboard
