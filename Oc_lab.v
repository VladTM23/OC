`define INITIALIZE 3'b001//initialization

`define LOAD_Q 3'b010//get Q from INBUS

`define LOAD_M 3'b011//get M from INBUS

`define RUN 3'b100//start running

`define STORE_A 3'b101//set A on OUTBUS

`define STORE_Q 3'b110//set Q on OUTBUS

`define SUBSTRACT 3'b111//substract;

module restore(
           inbus, //input bus
           outbus,//output bus
           enable//control
           );
   
   //-----Output Ports-----
   output reg [7:0] outbus;
   
   //-----Input Ports------
   input [7:0] 	    inbus;
   input [2:0] 	    enable;
   
   //-----Registers--------   
   reg [7:0] 	    A_reg;
   reg [8:0] 	    M_reg;
   reg [7:0] 	    Q_reg;
   reg 		    S;
   reg [3:0] 	    count;
   
  
   //sensitive to enable and count signals
   always @(enable,count) begin
      case(enable)//just a switch to change states
    `INITIALIZE:
      begin
         A_reg<=8'b0;//initialize A_Reg with 0
         S<=1'b0;
         count<=4'b0;
      end
    `LOAD_Q:
      Q_reg<=inbus;//load Q from inbus
    `LOAD_M:
      M_reg<={1'b0,inbus};//load M from inbus
      
    `SUBSTRACT:
    begin
    {S,A_reg,Q_reg[7:1]}={A_reg,Q_reg};
    $display("%b",{S,A_reg});
    $display("%b",Q_reg);
    {S,A_reg}={S,A_reg}-M_reg;
    $display("%b",{S,A_reg});
    
    
     end
     
    `RUN:
      if(count<8) 
        begin
          case(S)
          1'b0:  
            begin
              Q_reg[0]<=1'b1;
              {S,A_reg,Q_reg[7:1]}<={A_reg,Q_reg};
              {S,A_reg}<={S,A_reg}-M_reg;
            end
           default:
            begin
            Q_reg[0]<=1'b0;
            {S,A_reg}<={S,A_reg}+M_reg;
            {S,A_reg,Q_reg[7:1]}<={A_reg,Q_reg};
            {S,A_reg}<={S,A_reg}-M_reg; 
          end
          endcase
          count<=count+1'b1;
          $display("%b",count);
        end
    `STORE_A:
      outbus<=A_reg;
    `STORE_Q:
      outbus<=Q_reg;
      endcase // case (enable)
      
   end // always @ (enable)
   
endmodule //restore