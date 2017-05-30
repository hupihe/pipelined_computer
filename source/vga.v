module vga(clk,rst_n,op,data0,data1,data2,data3,data4,data5,data6,vga_r,vga_g,vga_b,clk_vga,hsync,vsync,VGA_BLANK_N,VGA_SYNC_N);

    input clk,rst_n;
    input [1:0] op;
    input [5:0] data0,data1,data2,data3,data4,data5,data6;

    output [9:0] vga_r,vga_g,vga_b;
    output clk_vga,hsync,vsync,VGA_BLANK_N,VGA_SYNC_N;
    reg [9:0] vga_r,vga_g,vga_b;
    reg [10:0] x_cnt,y_cnt,x_tmp,y_tmp;
	reg hsync,vsync;
	reg [5:0] opcode;
	
	wire [7:0] char0[6:0];
	wire [7:0] char1[6:0];
	wire [7:0] char2[6:0];
	wire [7:0] char3[6:0];
	wire [7:0] char4[6:0];
	wire [7:0] char5[6:0];
	wire [7:0] char6[6:0];
	wire [7:0] symbol_eq[6:0];
	wire [7:0] symbol_op[6:0];
	
	
	always @ (*)
	begin
		if (op==2'b00)
			opcode=6'b110100;
		else if (op==2'b01)
			opcode=6'b110101;
		else if (op==2'b10)
			opcode=6'b110111;
		else opcode=6'b111000;
	end
	
	parameter H_SYNC=112;
	parameter H_BACK=248;
	parameter H_ACT=1280;
	parameter H_FRONT=48;
	parameter H_BLANK_FRONT=H_SYNC+H_BACK;
	parameter H_BLANK_BACK=H_SYNC+H_BACK+H_ACT;
	parameter H_TOTAL=H_FRONT+H_SYNC+H_BACK+H_ACT; 

	parameter V_SYNC=3; 
	parameter V_BACK=38; 
	parameter V_ACT=1024;
	parameter V_FRONT=1;
	parameter V_BLANK_FRONT=V_SYNC+V_BACK;
	parameter V_BLANK_BACK=V_SYNC+V_BACK+V_ACT;
	parameter V_TOTAL=V_FRONT+V_SYNC+V_BACK+V_ACT;
	
	pll_105 pll_clk(clk,clk_vga);
			
	assign VGA_SYNC_N=1'b0;
	assign VGA_BLANK_N=~((x_cnt<=H_BLANK_FRONT)||(x_cnt>H_BLANK_BACK)||(y_cnt<=V_BLANK_FRONT)||(y_cnt>V_BLANK_BACK)); 

	always @(posedge clk_vga or negedge rst_n)
		if (!rst_n)
			x_cnt<=10'd0;
		else if (x_cnt==H_TOTAL)
			x_cnt<=0;
		else x_cnt<=x_cnt+10'b1;

	always @(posedge clk_vga or negedge rst_n)
		if (!rst_n)
			y_cnt<=10'd0;
		else if (y_cnt==V_TOTAL)
			y_cnt<=0;
		else if (x_cnt==H_TOTAL)
			y_cnt<=y_cnt+10'b1;

     always @(posedge clk_vga or negedge rst_n)                                 
		if (!rst_n)
			hsync<=1'b1;
		else if(x_cnt==0)      
			hsync<=1'b0;
		else if(x_cnt==H_SYNC)
			hsync<=1'b1;

	always @(posedge clk_vga or negedge rst_n)                                 
		if (!rst_n)
			vsync<=1'b1;
		else if(y_cnt==0)      
			vsync<=1'b0;
		else if(y_cnt==V_SYNC)      
			vsync<=1'b1;              
	
	RAM_set ram0(clk,rst_n,data0,char0[0],char0[1],char0[2],char0[3],char0[4],char0[5],char0[6]);
	RAM_set ram1(clk,rst_n,data1,char1[0],char1[1],char1[2],char1[3],char1[4],char1[5],char1[6]);
	RAM_set ram2(clk,rst_n,data2,char2[0],char2[1],char2[2],char2[3],char2[4],char2[5],char2[6]);
	RAM_set ram3(clk,rst_n,data3,char3[0],char3[1],char3[2],char3[3],char3[4],char3[5],char3[6]);
	RAM_set ram4(clk,rst_n,data4,char4[0],char4[1],char4[2],char4[3],char4[4],char4[5],char4[6]);
	RAM_set ram5(clk,rst_n,data5,char5[0],char5[1],char5[2],char5[3],char5[4],char5[5],char5[6]);
	RAM_set ram6(clk,rst_n,data6,char6[0],char6[1],char6[2],char6[3],char6[4],char6[5],char6[6]);
	
	RAM_set ram7(clk,rst_n,6'b111110,symbol_eq[0],symbol_eq[1],symbol_eq[2],symbol_eq[3],symbol_eq[4],symbol_eq[5],symbol_eq[6]);
	RAM_set ram8(clk,rst_n,opcode,symbol_op[0],symbol_op[1],symbol_op[2],symbol_op[3],symbol_op[4],symbol_op[5],symbol_op[6]);

	always @(posedge clk_vga or negedge rst_n)
	begin
		if (!rst_n)
		begin
			vga_r=10'b0000000000;
			vga_g=10'b0000000000;
			vga_b=10'b0000000000;
			x_tmp=10'b0;
			y_tmp=10'b0;
		end
		else
		begin
			x_tmp=(x_cnt-H_SYNC-H_BACK)>>4;
			y_tmp=(y_cnt-V_SYNC-V_BACK)>>4;
			if (x_cnt>=360&&x_cnt<488&&y_cnt>425&&y_cnt<533)
				if (char0[x_tmp][y_tmp])
				begin
					vga_r=10'b0000000000;
					vga_g=10'b0000000000;
					vga_b=10'b0000000000;
				end
				else
				begin
					vga_r=10'b1111111111;
					vga_g=10'b1111111111;
					vga_b=10'b1111111111;
				end
			else if (x_cnt>=488&&x_cnt<616&&y_cnt>425&&y_cnt<533)
				if (char1[x_tmp][y_tmp])
				begin
					vga_r=10'b0000000000;
					vga_g=10'b0000000000;
					vga_b=10'b0000000000;
				end
				else
				begin
					vga_r=10'b1111111111;
					vga_g=10'b1111111111;
					vga_b=10'b1111111111;
				end
			else if (x_cnt>=616&&x_cnt<744&&y_cnt>425&&y_cnt<533)
				if (symbol_op[x_tmp][y_tmp])
				begin
					vga_r=10'b0000000000;
					vga_g=10'b0000000000;
					vga_b=10'b0000000000;
				end
				else
				begin
					vga_r=10'b1111111111;
					vga_g=10'b1111111111;
					vga_b=10'b1111111111;
				end
			else if (x_cnt>=744&&x_cnt<872&&y_cnt>425&&y_cnt<533)
				if (char2[x_tmp][y_tmp])
				begin
					vga_r=10'b0000000000;
					vga_g=10'b0000000000;
					vga_b=10'b0000000000;
				end
				else
				begin
					vga_r=10'b1111111111;
					vga_g=10'b1111111111;
					vga_b=10'b1111111111;
				end
			else if (x_cnt>=872&&x_cnt<1000&&y_cnt>425&&y_cnt<533)
				if (char3[x_tmp][y_tmp])
				begin
					vga_r=10'b0000000000;
					vga_g=10'b0000000000;
					vga_b=10'b0000000000;
				end
				else
				begin
					vga_r=10'b1111111111;
					vga_g=10'b1111111111;
					vga_b=10'b1111111111;
				end
			else if (x_cnt>=1000&&x_cnt<1128&&y_cnt>425&&y_cnt<533)
				if (symbol_eq[x_tmp][y_tmp])
				begin
					vga_r=10'b0000000000;
					vga_g=10'b0000000000;
					vga_b=10'b0000000000;
				end
				else
				begin
					vga_r=10'b1111111111;
					vga_g=10'b1111111111;
					vga_b=10'b1111111111;
				end
			else if (x_cnt>=1128&&x_cnt<1256&&y_cnt>425&&y_cnt<533)
				if (char4[x_tmp][y_tmp])
				begin
					vga_r=10'b0000000000;
					vga_g=10'b0000000000;
					vga_b=10'b0000000000;
				end
				else
				begin
					vga_r=10'b1111111111;
					vga_g=10'b1111111111;
					vga_b=10'b1111111111;
				end
			else if (x_cnt>=1256&&x_cnt<1384&&y_cnt>425&&y_cnt<533)
				if (char5[x_tmp][y_tmp])
				begin
					vga_r=10'b0000000000;
					vga_g=10'b0000000000;
					vga_b=10'b0000000000;
				end
				else
				begin
					vga_r=10'b1111111111;
					vga_g=10'b1111111111;
					vga_b=10'b1111111111;
				end
			else if (x_cnt>=1384&&x_cnt<1512&&y_cnt>425&&y_cnt<533)
				if (char6[x_tmp][y_tmp])
				begin
					vga_r=10'b0000000000;
					vga_g=10'b0000000000;
					vga_b=10'b0000000000;
				end
				else
				begin
					vga_r=10'b1111111111;
					vga_g=10'b1111111111;
					vga_b=10'b1111111111;
				end
			else
			begin
				vga_r=10'b1111111111;
				vga_g=10'b1111111111;
				vga_b=10'b1111111111;
			end
		end
	end
endmodule
