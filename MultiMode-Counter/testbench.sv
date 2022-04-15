// TestBench for multimodecounter

module tb_Counter();
  
  logic tb_clk;
  logic tb_rst_n;
  logic tb_WINNER;
  logic tb_LOSER;
  logic tb_GAMEOVER;
  logic [1:0] tb_ctrlBus;
  logic [3:0] tb_count;
  logic [1:0] tb_WHO;
  logic [3:0] tb_initValue;
  logic tb_INIT ; // if set to 1 , use initialValue parallely
  
  parameter HCYCLE = 5 ;
  
  always begin
    #HCYCLE tb_clk = ~tb_clk;
  end
  
 // This initial block is executed once
 // it provides the stimuli for the DUT
	initial begin
      
      tb_clk   = 1'b0;
      tb_INIT = 0;
      tb_initValue = 0;
      
      
      //NORMAL SCENARIO: up mode by 1 
      tb_ctrlBus  = 2'b00;  // count up by 1
      tb_rst_n = 1'b0; // enable reset
      #HCYCLE tb_rst_n = 1'b1; // disable
	  
      
      //NORMAL SCENARIO: count up by 2
      tb_ctrlBus  = 2'b01;  // count up by 1
      tb_rst_n = 1'b0; // enable reset
      #HCYCLE tb_rst_n = 1'b1;
  
      
      //NORMAL SCENARIO: count down by 1
      tb_ctrlBus  = 2'b10;  // count up by 1
      tb_rst_n = 1'b0; // enable reset
      #HCYCLE tb_rst_n = 1'b1;
      
      //NORMAL SCENARIO: count down by 2
  	  tb_ctrlBus  = 2'b11;  // count up by 1
      tb_rst_n = 1'b0; // enable reset
      #HCYCLE tb_rst_n = 1'b1;

      //TEST : INIT VALUE parallely loaded to counter
      #HCYCLE ;
      #HCYCLE ;
      tb_initValue = 10; // Hexadecimal = a
      tb_INIT = 1'b1 ; // initValue must be loaded to counter
      #HCYCLE tb_INIT =0;
      
      #25 tb_INIT =1;
      tb_initValue = 13; // Hexadecimal = d 
      #HCYCLE tb_INIT = 0;
      */

    end
  initial begin
   $dumpfile("dump.vcd");
   $dumpvars;
   #200 $finish; 
  end
  
   // make instance of my module
  MultiModeCounter DUT
  (
      tb_clk,
      tb_rst_n,
      tb_ctrlBus,
      tb_initValue,
      tb_INIT,
      tb_WINNER,
      tb_LOSER,
      tb_GAMEOVER,
      tb_WHO,
      tb_count
  );

endmodule