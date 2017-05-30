module pipeemreg (ewreg,em2reg,ewmem,ealu,eb,ern,clk,clrn,
	mwreg,mm2reg,mwmem,malu,mb,mrn);
	input [31:0] ealu,eb;
	input [4:0]  ern;
	input        ewreg,em2reg,ewmem;
	input		 clk,clrn;
	output [31:0] malu,mb;
	output [4:0]  mrn;
	output        mwreg,mm2reg,mwmem;
	
	reg [31:0]    malu,mb;
	reg [4:0]     mrn;
	reg			  mwreg,mm2reg,mwmem;
	
	always @ (negedge clrn or posedge clk)
		if (clrn == 0)
		begin
			malu   <= 32'b0;
			mb     <= 32'b0;
			mrn    <= 5'b0;
			mwreg   <= 1'b0;
			mm2reg <= 1'b0;
			mwmem  <= 1'b0;
		end
		else
		begin
			malu   <= ealu;
			mb     <= eb;
			mrn    <= ern;
			mwreg   <= ewreg;
			mm2reg <= em2reg;
			mwmem  <= ewmem;
		end
endmodule
	
