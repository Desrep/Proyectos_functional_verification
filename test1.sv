program write_read_deterministic(intf_cnt intf);
  environment env = new(intf);
  
  initial 
    begin 
  	env.drvr.init();
  	env.drvr.reset();
    env.drvr.burst_write();
  	env.drvr.burst_read();
    env.drvr.burst_write();
  	env.drvr.burst_read();
    env.drvr.burst_write();
  	env.drvr.burst_read();
    env.drvr.burst_write();
  	env.drvr.burst_read();
    $display("###############################");
  	if(env.mntr.ErrCnt == 0) begin
        $display("STATUS: SDRAM Write/Read TEST PASSED");
    	$display("Check count is %d",env.sb.check_count);// did it check?
    end
  	else  begin
        $display("ERROR:  SDRAM Write/Read TEST FAILED");
        $display("###############################");
        $display("Check count is %d",env.sb.check_count);
  	end
        $finish;// end program
    

	end
endprogram