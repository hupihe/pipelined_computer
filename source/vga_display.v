module vga_display(
	input clk,
	input rst_n,
	input [1:0] op,
	input [7:0] port0,
	input [7:0] port1,
	input [7:0] port2,
	output [9:0] vga_r,
	output [9:0]  vga_g,
	output [9:0]  vga_b,
	output clk_vga,
	output hsync,
	output vsync,
	output VGA_BLANK_N,
	output VGA_SYNC_N
	);
	wire [3:0] Hundreds[2:0], Tens[2:0], Ones[2:0];
	BCD bcd1(port0, Hundreds[0], Tens[0], Ones[0]);
	BCD bcd2(port1, Hundreds[1], Tens[1], Ones[1]);
	BCD bcd3(port2, Hundreds[2], Tens[2], Ones[2]);
	
	vga screen(clk,rst_n,op,{2'b0,Tens[0]},{2'b0,Ones[0]},{2'b0,Tens[1]},{2'b0,Ones[1]},{2'b0,Hundreds[2]},{2'b0,Tens[2]},{2'b0,Ones[2]},vga_r,vga_g,vga_b,clk_vga,hsync,vsync,VGA_BLANK_N,VGA_SYNC_N);
endmodule 