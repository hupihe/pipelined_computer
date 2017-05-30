module pipemwreg (mwreg,mm2reg,mmo,malu,mrn,clk,clrn,
	wwreg,wm2reg,wmo,walu,wrn);
	input [31:0] mmo,malu;
	input [4:0]  mrn;
	input        mwreg,mm2reg;
	input        clk,clrn;
	output [31:0] wmo,walu;
	output [4:0]  wrn;
	output        wwreg,wm2reg;
	
	reg [31:0] wmo,walu;
	reg [4:0]  wrn;
	reg        wwreg,wm2reg;
	
	always @ (negedge clrn or posedge clk)
		if (clrn == 0)
		begin
			wmo    <= 32'b0;
			walu   <= 32'b0;
			wrn    <= 4'b0;
			wwreg  <= 1'b0;
			wm2reg <= 1'b0;
		end
		else
		begin
			wmo    <= mmo;
			walu   <= malu;
			wrn    <= mrn;
			wwreg  <= mwreg;
			wm2reg <= mm2reg;
		end
endmodule
