`timescale 1ns/1ns

module Automatic_Garage_Door_Controller_TB ();

reg        Activate_TB ;
reg        Up_Max_TB ;
reg        DN_Max_TB ;
reg        rst_TB ;
reg        clk_TB ;
wire       UP_M_TB ;
wire       DN_M_TB ;

////////////////////////////////////////////////////////
////////////////// Clock Generator  ////////////////////
////////////////////////////////////////////////////////
parameter   clk_period = 20 ;
always #(clk_period/2)  clk_TB = ~clk_TB ;
  

////////////////////////////////////////////////////////
////////////////// initial block /////////////////////// 
////////////////////////////////////////////////////////
initial 
 begin
   
 // Save Waveform
   $dumpfile("Automatic_Garage_Door_Controller.vcd") ;       
   $dumpvars; 

 // initialization
   initialize();

 // Reset
   reset();
   
 // Input Sequence
   User_and_Sensors(1'b0,1'b0,1'b1);    // input_1 for Activate
                                        // input_2 for Up_Max
                                        // input_3 for DN_Max
                                        

 $display("**** TEST CASE 1 ****");
 $display("checks IDLE state of the Door");
 // check Garage Door
   Door(1'b0,1'b0);      // input_1 for UP_M
                         // input_2 for DN_M 

 $display("**** TEST CASE 2 ****");
 $display("Open the Door to max");
 User_and_Sensors(1'b1,1'b0,1'b1);
 Door(1'b1,1'b0);
 
 $display("**** TEST CASE 3 ****");
 $display("Back to IDLE");
 User_and_Sensors(1'b0,1'b1,1'b0);
 Door(1'b0,1'b0);
 
 $display("**** TEST CASE 4 ****");
 $display("Close the Door to max");
 User_and_Sensors(1'b1,1'b1,1'b0);
 Door(1'b0,1'b1);
 
 $display("**** TEST CASE 5 ****");
 $display("Back to IDLE");
 User_and_Sensors(1'b0,1'b0,1'b1);
 Door(1'b0,1'b0);
  
  
  #100
  
  $stop ;
 
 end  


////////////////////////////////////////////////////////
/////////////////////// TASKS //////////////////////////
////////////////////////////////////////////////////////

/////////////// Signals Initialization //////////////////
task initialize;
 begin
  Activate_TB = 1'b0 ;
  Up_Max_TB = 1'b0 ;
  DN_Max_TB = 1'b0 ;
  clk_TB = 1'b0 ; 
 end
endtask

///////////////////////// RESET /////////////////////////
task reset;
 begin
 rst_TB =  1'b1;
 #(clk_period/2)
 rst_TB  = 1'b0;
 #(clk_period/2)
 rst_TB  = 1'b1;
 end
endtask  

//////////////////// User_and_Sensors ///////////////////
task User_and_Sensors(
  input     reg     user,
  input     reg     up,
  input     reg     down
);
  
begin
  #clk_period
  Activate_TB = user ;
  Up_Max_TB = up ;
  DN_Max_TB = down ;
 end
endtask    

///////////////////////// Door /////////////////////////
task Door(
  input     reg     open,
  input     reg     closed
);
  
begin
  #clk_period
  if(UP_M_TB != open  && DN_M_TB != closed)
    $display("Failed");
  else
    $display("Success");
 end
endtask      

////////////////////////////////////////////////////////
/////////////////// DUT Instantation ///////////////////
////////////////////////////////////////////////////////
Automatic_Garage_Door_Controller DUT (
.clk(clk_TB),
.rst(rst_TB),
.Activate(Activate_TB),
.Up_Max(Up_Max_TB),
.DN_Max(DN_Max_TB),
.UP_M(UP_M_TB),
.DN_M(DN_M_TB)
);


endmodule  