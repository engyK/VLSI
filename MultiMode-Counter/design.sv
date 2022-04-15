// Declaring the module
module MultiModeCounter(clk,rst_n,
                        ctrlBus,initValue,INIT,
                        WINNER,LOSER,
                        GAMEOVER,WHO,
                        count);
  
  // Declare module parameters  
  
  input logic [1:0] ctrlBus; // mode of operation
  input logic [3:0]initValue ; //initial value to startCount
  input logic INIT ; // one bit control signal
  input logic clk;
  input logic rst_n ;  // active high (if rst_A == 1 , reset = ON)
  
  output logic WINNER;
  output logic LOSER ;
  output logic [1 : 0] WHO;
  output logic GAMEOVER;
  
  output logic [3 : 0] count;
  
  //internal wires
  logic winnerCount = 0;
  logic loserCount = 0 ;
  logic [3:0] value = -1;
  
  // -------------------------------------------
  // initial state for OUTPUTs
  initial begin
    WINNER = 0 ;
    LOSER  = 0 ;
    GAMEOVER = 0;
    WHO = 2'b00;
    count = 0 ;
  end
  // -------------------------------------------
  // Combinational Part

  always @(posedge clk or INIT)
  begin
    if (INIT ==1) begin
      count = initValue;
    end
    
	
	// case block to check bus mode
    case (ctrlBus)
      2'b00 : count = count + 1 ; // count UP by 1's
      2'b01 : count = count + 2 ; // count UP by 2's
      2'b10 : count = count - 1 ; // count DOWN by 1's
      2'b11 : count = count - 2 ; // count DOWN by 2's
      default : count = count + 1;
    endcase
  end
  
  // -------------------------------------------
  // Sequential Part
  // Always Prodcedural block to implement logic
  
  always @ (posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
      //Clear every thing and start from initial state
      count = 0; winnerCount = 0 ; loserCount = 0;
      WINNER = 0; LOSER = 0 ; WHO = 0 ; GAMEOVER = 0; 
    end // if statement
    else begin
      // Signals cleared in the next cycle (after one cycle)
       if (WINNER) begin
         WINNER = 1'b0 ;
         $display("Winner CLEARED after 1 cycle = %0d", WINNER);
       end // if

       if (GAMEOVER) begin
         GAMEOVER = 1'b0;
         WHO = 2'b00 ;
       end // if


      // ---- DOWN COUNT MODE ----
      if ((ctrlBus == 2'b10 || ctrlBus == 2'b11 )) begin // COUNT DOWN mode
        if (count == 4'b0000) begin 
          LOSER = 1'b1; // set LOSER = 1 (high);

          if (LOSER) begin
            loserCount = loserCount + 1 ;
            $display( "INCREMENT loserCount = %0d ", loserCount);

            if (loserCount == 15) begin
              WHO = 2'b01;
              GAMEOVER = 1;
            end // if statement

          end // internal if
        end // if
      end // outer if


      // ---- UP COUNT MODE ----
      else if (ctrlBus == 2'b10 || ctrlBus == 2'b11 ) begin //COUNT UP mode
        if (count == 4'b1111) begin 
          WINNER = 1'b1; // set WINNER = 1 (high);

          if (WINNER) begin
            winnerCount = winnerCount + 1 ;
            $display( "INCREMENT winnerCount = %0d ", winnerCount);

            if (winnerCount == 15) begin
              WHO = 2'b10;
              GAMEOVER = 1;
            end // if statement

          end // internal if
         end // if
      end // else if
    end // end of else
  end // always block
  
endmodule //MultiModeCounter



// ------------------------------------
// testbench 
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