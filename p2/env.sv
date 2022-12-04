class environment;
  driver drvr;
  scoreboard sb;
  monitor mntr;
  functional_coverage funcov;
  virtual intf_cnt intf;
           
  function new(virtual intf_cnt intf);
    $display("Creating environment");
    this.intf = intf;
    sb = new();
    drvr = new(intf,sb);
    mntr = new(intf,sb);
    funcov = new(intf);
    fork 
      mntr.check();
      //mntr.address_store();
    join_none
  endfunction
           
endclass