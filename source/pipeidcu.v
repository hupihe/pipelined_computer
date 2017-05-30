module pipeidcu (mwreg,mrn,ern,ewreg,em2reg,mm2reg,rsrtequ,func,
	            op,rs,rt,wreg,m2reg,wmem,aluc,regrt,aluimm,
	            fwda,fwdb,nostall,sext,pcsource,shift,jal);
	input       mwreg,ewreg,em2reg,mm2reg,rsrtequ;
	input [4:0] mrn,ern,rs,rt;
	input [5:0] func,op;
	output       wreg,m2reg,wmem,regrt,aluimm,sext,shift,jal;
	output [3:0] aluc;
	output [1:0] pcsource,fwda,fwdb;
	output       nostall;
	
	reg [1:0] fwda,fwdb;
	wire r_type = ~|op;
	wire i_add =  r_type &  func[5] & ~func[4] & ~func[3] & ~func[2] & ~func[1] & ~func[0];
	wire i_mul =  r_type &  func[5] & ~func[4] &  func[3] &  func[2] & ~func[1] & ~func[0];
	wire i_div =  r_type &  func[5] & ~func[4] &  func[3] & ~func[2] & ~func[1] &  func[0];
	wire i_sub =  r_type &  func[5] & ~func[4] & ~func[3] & ~func[2] &  func[1] & ~func[0];
	wire i_and =  r_type &  func[5] & ~func[4] & ~func[3] &  func[2] & ~func[1] & ~func[0];
	wire i_or  =  r_type &  func[5] & ~func[4] & ~func[3] &  func[2] & ~func[1] &  func[0];
	wire i_xor =  r_type &  func[5] & ~func[4] & ~func[3] &  func[2] &  func[1] & ~func[0];
	wire i_sll =  r_type & ~func[5] & ~func[4] & ~func[3] & ~func[2] & ~func[1] & ~func[0];
	wire i_srl =  r_type & ~func[5] & ~func[4] & ~func[3] & ~func[2] &  func[1] & ~func[0];
	wire i_sra =  r_type & ~func[5] & ~func[4] & ~func[3] & ~func[2] &  func[1] &  func[0];
	wire i_jr  =  r_type & ~func[5] & ~func[4] &  func[3] & ~func[2] & ~func[1] & ~func[0];
	
	wire i_addi = ~op[5] & ~op[4] &  op[3] & ~op[2] & ~op[1] & ~op[0];
	wire i_andi = ~op[5] & ~op[4] &  op[3] &  op[2] & ~op[1] & ~op[0];
	wire i_ori  = ~op[5] & ~op[4] &  op[3] &  op[2] & ~op[1] &  op[0];
	wire i_xori = ~op[5] & ~op[4] &  op[3] &  op[2] &  op[1] & ~op[0];
	wire i_lw   =  op[5] & ~op[4] & ~op[3] & ~op[2] &  op[1] &  op[0];
	wire i_sw   =  op[5] & ~op[4] &  op[3] & ~op[2] &  op[1] &  op[0];
	wire i_beq  = ~op[5] & ~op[4] & ~op[3] &  op[2] & ~op[1] & ~op[0];
	wire i_bne  = ~op[5] & ~op[4] & ~op[3] &  op[2] & ~op[1] &  op[0];
	wire i_lui  = ~op[5] & ~op[4] &  op[3] &  op[2] &  op[1] &  op[0];
	wire i_j    = ~op[5] & ~op[4] & ~op[3] & ~op[2] &  op[1] & ~op[0];
	wire i_jal  = ~op[5] & ~op[4] & ~op[3] & ~op[2] &  op[1] &  op[0];

	wire i_rs = i_add  | i_sub | i_mul  | i_div | i_and | i_or  | i_xor | i_jr | i_addi |
				i_addi | i_ori | i_xori | i_lw  | i_sw  | i_beq | i_bne;
	wire i_rt = i_add  | i_sub | i_mul  | i_div | i_and | i_or  | i_xor | i_sll | i_srl |
				i_sra | i_sw  | i_beq | i_bne;
				
	assign nostall = ~(ewreg & em2reg & (ern != 0) & (i_rs & (ern == rs) | i_rt & (ern == rt)));
	
	assign pcsource[1] = i_jr | i_j | i_jal;
	assign pcsource[0] = ( i_beq & rsrtequ ) | (i_bne & ~rsrtequ) | i_j | i_jal ;
	
    assign wreg = (i_add | i_mul | i_div | i_sub  | i_and  | i_or  | i_xor  |
				   i_sll | i_srl | i_sra | i_addi | i_andi | i_ori | i_xori |
				   i_lw  | i_lui | i_jal) & nostall;
	
	assign aluc[3] = i_sra  | i_mul  | i_div;
	assign aluc[2] = i_sub  | i_or   | i_srl | i_sra  | i_ori | i_beq  | i_bne  | i_lui;
	assign aluc[1] = i_mul  | i_xor  | i_sll | i_srl  | i_sra | i_xori | i_lui;
	assign aluc[0] = i_mul  | i_and  | i_or  | i_sll  | i_srl | i_sra  | i_andi | i_ori;
	
	
	assign aluimm  = i_addi | i_andi | i_ori | i_xori | i_lw  | i_sw   | i_lui;
	assign regrt   = i_addi | i_andi | i_ori | i_xori | i_lw  | i_lui;
	assign sext    = i_addi | i_lw   | i_sw  | i_beq  | i_bne;
	assign shift   = i_sll  | i_srl  | i_sra;
	assign wmem    = i_sw & nostall;
	assign m2reg   = i_lw;
	assign jal     = i_jal;
	
	always @ (*)
	begin
		fwda = 2'b00;
		if (ewreg & (ern != 0) & (ern == rs) & ~em2reg)
			fwda = 2'b01;
		else if (mwreg & (mrn != 0) & (mrn == rs) & ~mm2reg)
			fwda = 2'b10;
		else if (mwreg & (mrn != 0) & (mrn == rs) & mm2reg)
			fwda = 2'b11;
	end
	
	always @ (*)
	begin
		fwdb = 2'b00;
		if (ewreg & (ern != 0) & (ern == rt) & ~em2reg)
			fwdb = 2'b01;
		else if (mwreg & (mrn != 0) & (mrn == rt) & ~mm2reg)
			fwdb = 2'b10;
		else if (mwreg & (mrn != 0) & (mrn == rt) & mm2reg)
			fwdb = 2'b11;
	end
endmodule
