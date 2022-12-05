//-------------------------------------------------------------------------
//						sdr_test - www.verificationguide.com 
//-------------------------------------------------------------------------


class sdr_model_base_test extends uvm_test;

  `uvm_component_utils(sdr_model_base_test)
  
  //---------------------------------------
  // env instance 
  //--------------------------------------- 
  sdr_model_env env;


  //---------------------------------------
  // constructor
  //---------------------------------------
  function new(string name = "sdr_model_base_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

  //---------------------------------------
  // build_phase
  //---------------------------------------
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create the env
    env = sdr_model_env::type_id::create("env", this);
    
  endfunction : build_phase
  
  //---------------------------------------
  // end_of_elobaration phase
  //---------------------------------------  
  virtual function void end_of_elaboration();
    //print's the topology
    print();
  endfunction

  //---------------------------------------
  // end_of_elobaration phase
  //---------------------------------------   
 function void report_phase(uvm_phase phase);
   uvm_report_server svr;
   super.report_phase(phase);
   
   svr = uvm_report_server::get_server();
   if(svr.get_severity_count(UVM_FATAL)+svr.get_severity_count(UVM_ERROR)>0) begin 
     `uvm_info(get_type_name(), "************Test failed *************", UVM_NONE)
    
    end
    else begin
      `uvm_info(get_type_name(), "************ Test passed ***********", UVM_NONE)
    end
  endfunction 

endclass : sdr_model_base_test