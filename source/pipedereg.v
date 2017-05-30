module pipedereg (dwreg,dm2reg,dwmem,daluc,daluimm,da,db,dimm,drn,dshift,
	djal,dpc4,clk,clrn,ewreg,em2reg,ewmem,ealuc,ealuimm,
	ea,eb,eimm,ern,eshift,ejal,epc4);
	input [31:0] da,db,dimm,dpc4;
	input [4:0] drn;
	input [3:0] daluc;
	input       dwreg,dm2reg,dwmem,daluimm,dshift,djal;
	input       clk,clrn;
	output [31:0] ea,eb,eimm,epc4;
	output [4:0]  ern;
	output [3:0] ealuc;
	output       ewreg,em2reg,ewmem,ealuimm,eshift,ejal;
	
	reg [31:0] ea,eb,eimm,epc4;
	reg [4:0]  ern;
	reg [3:0]  ealuc;
	reg        ewreg,em2reg,ewmem,ealuimm,eshift,ejal;
	
	always @ (negedge clrn or posedge clk)
		if (clrn == 0)
		begin
			ea      <= 32'b0;
			eb      <= 32'b0;
			eimm    <= 32'b0;
			epc4    <= 32'b0;
			ern     <= 5'b0;
			ealuc   <= 4'b0;
			ewreg   <= 1'b0;
			em2reg  <= 1'b0;
			ewmem   <= 1'b0;
			ealuimm <= 1'b0;
			eshift  <= 1'b0;
			ejal    <= 1'b0;
		end
		else
		begin
			ea      <= da;
			eb      <= db;
			eimm    <= dimm;
			epc4    <= dpc4;
			ern     <= drn;
			ealuc   <= daluc;
			ewreg   <= dwreg;
			em2reg  <= dm2reg;
			ewmem   <= dwmem;
			ealuimm <= daluimm;
			eshift  <= dshift;
			ejal    <= djal;
		end
endmodule
