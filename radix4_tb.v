module radix4_tb;
  reg clk;
  reg rst;
  reg start;
  reg [7:0]inbus;
  wire [15:0]outbus;
  wire stop;
  
  radix4 r(
  .clk(clk),
  .rst(rst),
  .start(start),
  .inbus(inbus),
  .stop(stop),
  .outbus(outbus) );
  
  always
    begin
      #40
      clk=~clk;
    end
    
  initial
    begin
      
      clk=1'd0;
      rst=1'd1;
      #10 rst=1'd0;
      #40 rst=1'd1;
      start=1'd0;
      inbus=8'd0;
      #30
      inbus=8'd3;
      start=~start;
      #50
      inbus=-8'd23;
      #200
      inbus=8'd0;
    end
  endmodule
  
  
  
  
  


