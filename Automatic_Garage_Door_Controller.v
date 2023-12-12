/////////////////////////////////////
///////////// Moore FSM ///////////// 
/////////////////////////////////////

module Automatic_Garage_Door_Controller (
  input   wire      clk,
  input   wire      rst,
  input   wire      Activate,
  input   wire      Up_Max,
  input   wire      DN_Max,
  output  reg       UP_M,
  output  reg       DN_M
  );
  
localparam  [1:0]   IDLE = 2'b00,     // Bits order: UP_M - DN_M
                    Mv_Up = 2'b10,
                    Mv_Dn = 2'b01 ;

reg     [1:0]       current_state,
                    next_state ;

// state transition
always @(posedge clk or negedge rst)
  begin
    if(!rst)
      begin
        current_state <= IDLE ;
      end
    else
      begin
        current_state <= next_state ;
      end
  end

// next state logic
always @(*)
  begin
    case(current_state)
      IDLE  : begin
                if(Activate && DN_Max)
                  next_state = Mv_Up ;
                else if(Activate && Up_Max)
                  next_state = Mv_Dn ;
                else
                  next_state = IDLE ;
              end
              
      Mv_Up : begin
                if(Up_Max)
                  next_state = IDLE ;
                else
                  next_state = Mv_Up ;
              end
              
      Mv_Dn : begin
                if(DN_Max)
                  next_state = IDLE ;
                else
                  next_state = Mv_Dn ;
              end
    endcase
  end

// output logic
always @(*)
  begin
    case(current_state)
      IDLE  : begin
                UP_M = 1'b0 ;
                DN_M = 1'b0 ;
              end
              
      Mv_Up : begin
                UP_M = 1'b1 ;
                DN_M = 1'b0 ;
              end
              
      Mv_Dn : begin
                UP_M = 1'b0 ;
                DN_M = 1'b1 ;
              end
    endcase
  end

endmodule