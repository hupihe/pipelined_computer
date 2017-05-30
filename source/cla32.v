module cla32 (pc,x1,e,p4);
   input [31:0] pc, x1;
   input        e;
   output [31:0] p4;
   assign p4 = (~e ? pc + x1 : 32'b0);
endmodule
