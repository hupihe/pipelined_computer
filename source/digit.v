module digit(
	input [7:0] data0,
	input [7:0] data1,
	input [7:0] data2,
	output [55:0] seven
	);
	
	wire [3:0] Hundreds[2:0], Tens[2:0], Ones[2:0];
	
	BCD bcd0(data0, Hundreds[0], Tens[0], Ones[0]);
	BCD bcd1(data1, Hundreds[1], Tens[1], Ones[1]);
	BCD bcd2(data2, Hundreds[2], Tens[2], Ones[2]);
	
	seven_segments seven00(Tens[0], seven[55:49]);
	seven_segments seven01(Ones[0], seven[48:42]);
	
	seven_segments seven10(Tens[1], seven[41:35]);
	seven_segments seven11(Ones[1], seven[34:28]);
	
	assign seven[27:21] = 7'b1111111;
	
	seven_segments seven20(Ones[2], seven[6:0]);
	seven_segments seven21(Tens[2], seven[13:7]);
	seven_segments seven22(Hundreds[2], seven[20:14]);
endmodule 