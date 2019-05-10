module radix4(
  input clk, rst, start, 
  input [7:0]inbus,
  output reg [15:0]outbus,
  output reg stop);
  
  reg [7:0] A_reg, A_next, M_reg, M_next, Q_reg, Q_next;
  reg Q;
  reg [3:0]state_reg, state_next;
  reg [1:0]count;
  reg [15:0] OUTBUS_next;
  
  wire aux;
  assign aux = A_reg[7];
  
  //secvential
  always @(posedge clk, negedge rst)
    begin
      if(!rst)
        begin
          A_reg<=8'd0;
          Q_reg<=8'd0;
          M_reg<=8'd0;
          outbus=16'd0;
          state_reg <= 4'd0;
          stop<=1'd0;
        end
      else
        begin
          A_reg<=A_next;
          Q_reg<=Q_next;
          M_reg<=M_next;
          state_reg <= state_next;
          outbus <= OUTBUS_next;
        end
      end
      
      always@(*)
      begin
        A_next=A_reg;
        Q_next=Q_reg;
        M_next=M_reg;
        state_next = state_reg;
        OUTBUS_next = outbus;
        case(state_reg)
            4'd0 : begin
              Q_next=inbus;
              A_next<=8'd0;
              Q=1'd0;
              count=2'd0;
              state_next=4'd1;
            end
            4'd1 : begin
              M_next=inbus;
              state_next=4'd11;
            end
            4'd11:
          begin
            case({Q_reg[1:0],Q})
              3'd0:
                state_next=4'd6;
              3'd1:
                state_next=4'd2;
              3'd2:
                state_next=4'd2;
              3'd3:
                state_next=4'd4;
              3'd4:
                state_next=4'd5;
              3'd5:
                state_next=4'd3;
              3'd6:
                state_next=4'd3;
              3'd7:
                state_next=4'd6;
            endcase
          end
              4'd2 : begin
                  A_next = A_reg + M_reg;
                  state_next=4'd6;
                end
              4'd3 : begin
                  A_next = A_reg - M_reg;
                  state_next=4'd6;
                 end
              4'd4 : begin
                 A_next = A_reg + {M_reg,1'b1};
                  state_next=4'd6;
               end
               4'd5 : begin
                 A_next = A_reg -  {M_reg,1'b1};
                  state_next=4'd6;
               end           
               4'd6 : begin
                 {A_next[5:0],Q_next,Q} = {A_reg , Q_reg[7:1]};
                 A_next[7]=aux;
                 A_next[6]=aux;
                 if(count==2'd3)
                  state_next=4'd8;
                else
                  state_next=4'd7;
               end
               4'd7: begin
                 count=count+1;
                state_next=4'd11;
                  end     
                4'd8: begin
                  OUTBUS_next[7:0] = Q_next;
                  state_next = 4'd9;
                end
                4'd9: begin
                  OUTBUS_next[15:8] = A_next;
                  state_next = 4'd10;
                end
                4'd10:
                  stop = 1'd1;
              endcase
            end
          endmodule
          
                  
                
                              
  
    

              
          
                  
                
                              
  
    

              
                
                
                

