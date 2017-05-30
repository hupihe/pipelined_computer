module pipeid (mwreg,mrn,ern,ewreg,em2reg,mm2reg,dpc4,inst,
	wrn,wdi,ealu,malu,mmo,wwreg,clk,clrn,
	bpc,jpc,pcsource,nostall,wreg,m2reg,wmem,aluc,
	aluimm,a,b,imm,rn,shift,jal);
	input [31:0] dpc4,inst,wdi,ealu,malu,mmo;
	input [4:0]  ern,mrn,wrn;
	input        mwreg,ewreg,em2reg,mm2reg,wwreg;
	input        clk,clrn;
	output [31:0] bpc,jpc,a,b,imm;
	output [4:0]  rn;
	output [3:0]  aluc;
	output [1:0]  pcsource;
	output        nostall,wreg,m2reg,wmem,aluimm,shift,jal;

	wire sext,regrt;
	wire [1:0]  fwda,fwdb;
	wire [31:0] qa,qb;
	
	wire [5:0] func = inst[5:0];
	wire [5:0] op   = inst[31:26];
	wire [4:0] rs   = inst[25:21];
	wire [4:0] rt   = inst[20:16];
	wire [4:0] rd   = inst[15:11];
	assign jpc  = {dpc4[31:28],inst[25:0],2'b00};
	wire rsrtequ = ~|(a^b);
	wire e    = sext & inst[15];
	wire [15:0] ext16 = {16{e}};
	assign imm  = {ext16,inst[15:0]};
	wire [31:0] br_offset = {imm[29:0],2'b00};
	
	pipeidcu cu (mwreg,mrn,ern,ewreg,em2reg,mm2reg,rsrtequ,func,
	            op,rs,rt,wreg,m2reg,wmem,aluc,regrt,aluimm,
	            fwda,fwdb,nostall,sext,pcsource,shift,jal);
	regfile rf (rs,rt,wdi,wrn,wwreg,~clk,clrn,qa,qb);
	mux2x5 des_reg_no (rd,rt,regrt,rn);
	mux4x32 alu_a (qa,ealu,malu,mmo,fwda,a);
	mux4x32 alu_b (qb,ealu,malu,mmo,fwdb,b);
	cla32 br_addr (dpc4,br_offset,1'b0,bpc);
endmodule
	
	
	