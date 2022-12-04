program write_read_random(intf_cnt intf);
  environment env = new(intf);
initial begin //{
  reg [31:0] StartAddr;
  int delay1;
  int delay2;
  env.drvr.init();
  $display(" Init done ");
  $display("Applying reset");
  env.drvr.reset();

  $display("---------------------------------------------------");
  $display(" Case: 6 Random 2 write and 2 read random");
  $display("---------------------------------------------------");
  for(int k=0; k < 10; k++) begin
    delay1 = $urandom_range(150,50);
    delay2 = $urandom_range(130,50);
    env.drvr.burst_write_rand(); // random write 
    #delay1;
    env.drvr.burst_write_rand();  
    #delay2;
    env.drvr.burst_read();  
    #delay1;
    env.drvr.burst_read();  
    #delay1;
  end
  
  
  env.drvr.reset();
  #1000


  
        $display("###############################");
  if(env.mntr.ErrCnt == 0) begin
        $display("STATUS: SDRAM Write/Read TEST PASSED");
        $display("Check count is %d",env.sb.check_count);
        $display("Check count decode is %d",env.sb.check_count_decode);// did it check?
  end
    else begin
        $display("ERROR:  SDRAM Write/Read TEST FAILED");
        $display("###############################");
      $display("Check count is %d",env.sb.check_count);// did it check?
      $display("Check count decode is %d",env.sb.check_count_decode);// did it check?
    end
        $finish;// end program
end
endprogram
