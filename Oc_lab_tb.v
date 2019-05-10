module restore_tb;
   

   wire [7:0] outbus_tb;
   reg [7:0]  inbus_tb;
   reg [7:0]  rest;
   reg [7:0]  result;
   reg [2:0]  enable_tb;
   
  restore divide(
		    .inbus(inbus_tb),
		    .outbus(outbus_tb),
		    .enable(enable_tb)
		    );

   initial begin

      

      enable_tb<=3'b001;//initialize
      #1 inbus_tb<=8'b00011001;//set M on inbus
      #1 enable_tb<=3'b011;//load M
      #1 inbus_tb<=8'b01111111;//set Q on inbus
      #1 enable_tb<=3'b010;//load Q
      #2 enable_tb<=3'b111;//
      #5 enable_tb<=3'b100;//run algorithm
      #10 enable_tb<=3'b101;//a on outbus;
      #15 rest<=outbus_tb;
      #20 enable_tb<=3'b110;//q on outbus;
      #25 result<=outbus_tb;


      
      

      
   end

endmodule // booth_tb