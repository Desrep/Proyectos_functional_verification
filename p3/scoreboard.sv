//Reference https://verificationguide.com/uvm/uvm-testbench-architecture/

`uvm_analysis_imp_decl(_export_decode)
`uvm_analysis_imp_decl(_export_data)
`uvm_analysis_imp_decl(_export_decode_col)
class sdr_scoreboard extends uvm_scoreboard;

  
  
  
  virtual sdr_if vif;
  
  
  
  
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

  
  
  
  bit [31:0] sc_mem [int];
  bit [11:0] col_decode_buff[int];
  bit [11:0] col_expected_buff[int];
  bit [11:0] bank_decode_buff[int];
  bit [11:0] bank_expected_buff[int];
  bit [11:0] row_expected_buff[int];
  bit [11:0] row_decode_buff[int];

  
  
  
  uvm_analysis_imp_export_data#(sdr_seq_item, sdr_scoreboard) item_collected_export_data;
  uvm_analysis_imp_export_decode#(sdr_seq_item, sdr_scoreboard) item_collected_export_decode;
  uvm_analysis_imp_export_decode_col#(sdr_seq_item, sdr_scoreboard) item_collected_export_decode_col;
  `uvm_component_utils(sdr_scoreboard)

  
  
  
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  
  
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
      if(!uvm_config_db#(virtual sdr_if)::get(this, "", "vif", vif))
       `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
      item_collected_export_data = new("item_collected_export", this);
    item_collected_export_decode = new("item_collected_export_decode", this);
    item_collected_export_decode_col = new("item_collected_export_decode_col", this);
    funcov = new(vif);
    
  endfunction: build_phase
  
  
  
  
  virtual function void write_export_data(sdr_seq_item pkt);
    
    pkt_qu.push_back(pkt);
  endfunction : write_export_data

  `ifdef SDR_32BIT


    virtual function void write_export_decode(sdr_seq_item pkt);
    
    pkt_decode.push_back(pkt);
    if(pkt.row_add_out == ((pkt.addr>>(llim_row))&(~((-1)<<(ulim_row-llim_row+1))))) begin
      row_decode_buff[pkt.addr] = pkt.row_add_out;
      row_expected_buff[pkt.addr] =((pkt.addr>>(llim_row))&(~((-1)<<(ulim_row-llim_row + 1)))) ;
    end
    endfunction : write_export_decode


        virtual function void write_export_decode_col(sdr_seq_item pkt);
     bit [11:0] temp = ((pkt.addr>>(llim_col))&(~((-1)<<(ulim_col-llim_col+1))));
     bit [11:0] temp2 = ((pkt.addr>>llim_bank)&(~((-1)<<(ulim_bank-llim_bank+1))));
    pkt_col.push_back(pkt);

    if(pkt.colum_add_out == temp) begin
    col_decode_buff[pkt.addr] = pkt.colum_add_out;
      col_expected_buff[pkt.addr] =temp;
    end

    if(pkt.bank_add_out == temp2)begin
      bank_decode_buff[pkt.addr] = pkt.bank_add_out;
      bank_expected_buff[pkt.addr] = temp2;
    end

  endfunction : write_export_decode_col



 `elsif SDR_16BIT

      virtual function void write_export_decode(sdr_seq_item pkt);
    
    pkt_decode.push_back(pkt);
    if(pkt.row_add_out == ((pkt.addr>>(llim_row-1))&(~((-1)<<(ulim_row-llim_row+1))))) begin
      row_decode_buff[pkt.addr] = pkt.row_add_out;
      row_expected_buff[pkt.addr] =((pkt.addr>>(llim_row-1))&(~((-1)<<(ulim_row-llim_row + 1)))) ;
    end
    endfunction : write_export_decode

    virtual function void write_export_decode_col(sdr_seq_item pkt);
     bit [11:0] temp = {((pkt.addr>>(llim_col))&(~((-1)<<(ulim_col-llim_col)))),1'b0};
     bit [11:0] temp2 = ((pkt.addr>>(llim_bank-1))&(~((-1)<<(ulim_bank-llim_bank+1))));
    pkt_col.push_back(pkt);

    if(pkt.colum_add_out == temp) begin
    col_decode_buff[pkt.addr] = pkt.colum_add_out;
      col_expected_buff[pkt.addr] =temp;
    end

    if(pkt.bank_add_out == temp2)begin
      bank_decode_buff[pkt.addr] = pkt.bank_add_out;
      bank_expected_buff[pkt.addr] = temp2;
    end

  endfunction : write_export_decode_col


  `else

      virtual function void write_export_decode(sdr_seq_item pkt);
    
    pkt_decode.push_back(pkt);
    if(pkt.row_add_out == ((pkt.addr>>(llim_row-2))&(~((-1)<<(ulim_row-llim_row+1))))) begin
      row_decode_buff[pkt.addr] = pkt.row_add_out;
      row_expected_buff[pkt.addr] =((pkt.addr>>(llim_row-2))&(~((-1)<<(ulim_row-llim_row + 1)))) ;
    end
    endfunction : write_export_decode
     


     virtual function void write_export_decode_col(sdr_seq_item pkt);
     bit [11:0] temp = {((pkt.addr>>(llim_col))&(~((-1)<<(ulim_col-llim_col-1)))),2'b0};
     bit [11:0] temp2 =   ((pkt.addr>>(llim_bank-2))&(~((-1)<<(ulim_bank-llim_bank+1))));
    pkt_col.push_back(pkt);
    if(pkt.colum_add_out == temp) begin
    col_decode_buff[pkt.addr] = pkt.colum_add_out;
      col_expected_buff[pkt.addr] =temp;
    end

    if(pkt.bank_add_out == temp2)begin
      bank_decode_buff[pkt.addr] = pkt.bank_add_out;
      bank_expected_buff[pkt.addr] = temp2;
    end

  endfunction : write_export_decode_col


  `endif 
  
  
  
  
  
  virtual task run_phase(uvm_phase phase);
    sdr_seq_item sdr_pkt;
    sdr_seq_item sdr_pkt_decode;
    sdr_seq_item sdr_pkt_col;

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
      
     
      if (vif.wb_we_i==0&&col_decode_buff.exists(sdr_pkt.addr))  begin
        
        
          if(col_expected_buff[sdr_pkt.addr]== col_decode_buff[sdr_pkt.addr]) begin 
            
     
     
            col_check++;
        end
          if(col_expected_buff[sdr_pkt.addr] != col_decode_buff[sdr_pkt.addr]) begin 
           
            `uvm_error(get_type_name(),"****** :: Col mismatch :: ********")
        `uvm_info(get_type_name(),$sformatf("Addr: %0h",sdr_pkt.addr),UVM_LOW)
         `uvm_info(get_type_name(),$sformatf("Expected Col Addr: %0h Actual Col Addr: %0h",col_expected_buff[sdr_pkt.addr],col_decode_buff[sdr_pkt.addr]),UVM_LOW)
   
       end
        
        
        if(bank_expected_buff[sdr_pkt.addr] == bank_decode_buff[sdr_pkt.addr]) begin 
           
      
     
           bank_check++;
        end
        if(bank_expected_buff[sdr_pkt.addr] != bank_decode_buff[sdr_pkt.addr]) begin 
           
          `uvm_error(get_type_name(),"-******* :: Bank mismatch :: ******")
         `uvm_info(get_type_name(),$sformatf("Addr: %0h",sdr_pkt.addr),UVM_LOW)
         `uvm_info(get_type_name(),$sformatf("Expected bank Addr: %0h Actual bank Addr: %0h",bank_expected_buff[sdr_pkt.addr],bank_decode_buff[sdr_pkt.addr]),UVM_LOW)
          
       end
	if(row_decode_buff.exists(sdr_pkt.addr)) begin
         sdr_pkt_decode = pkt_decode.pop_front();
        if((row_expected_buff[sdr_pkt.addr] == row_decode_buff[sdr_pkt.addr])) begin 
        
        
        
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
        
       
       
       
        
      end
      else if((vif.wb_we_i == 0)) begin
        if(sc_mem[sdr_pkt.addr] == vif.wb_dat_o) begin
         
         
          
         
             data_check++;
          
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

   virtual function void check_phase (uvm_phase phase);
    if (data_check > 0) begin
      
    end
    else begin
      `uvm_warning("Data Warn", $sformatf("SDRAM not checked. SDRAM didn't check write and read data"));
    end
    if (row_check > 0) begin
      
    end
    else begin
      `uvm_warning("Row Warn", $sformatf(" SDRAM didn't check row decode"));
    end
    if (bank_check > 0) begin
     
    end
    else begin
      `uvm_warning("Data Warn", $sformatf("SDRAM didn't check bank decode"));
    end
    if (col_check > 0) begin
     
    end
    else begin
      `uvm_warning("Data Warn", $sformatf("SDRAM didn't check col decode"));
    end
	endfunction
  
endclass : sdr_scoreboard
