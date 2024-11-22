module controlunit (
	Op,
	Funct,
	Rd,
	FlagW,
	PCSrcD,
	RegWriteD,
	MemWriteD,
	MemtoRegD,
	ALUSrcD,
	BranchD,
	FlagWriteD,
	ImmSrcD,
	RegSrcD,
	ALUControlD
);
	input wire [1:0] Op;	
	input wire [5:0] Funct;
	input wire [3:0] Rd;
	output reg [1:0] FlagWriteD;
	output wire PCSrcD;
	output wire RegWriteD;
	output wire MemWriteD;
	output wire MemtoRegD;
	output wire ALUSrcD;
	output wire BranchD;
	output wire [1:0] ImmSrcD;
	output wire [1:0] RegSrcD;
	output reg [1:0] ALUControlD;
	reg [9:0] controls;
	wire Branch;
	wire ALUOp;
	always @(*)
		casex (Op)
			2'b00:
				if (Funct[5])
					controls = 10'b0000101001;
				else
					controls = 10'b0000001001;
			2'b01:
				if (Funct[0])
					controls = 10'b0001111000;
				else
					controls = 10'b1001110100;
			2'b10: controls = 10'b0110100010;
			default: controls = 10'bxxxxxxxxxx;
		endcase
	assign {RegSrcD, ImmSrcD, ALUSrcD, MemtoRegD, RegWriteD, MemWriteD, BranchD, ALUOp} = controls;
	always @(*)
		if (ALUOp) begin
			case (Funct[4:1])
				4'b0100: ALUControlD = 2'b00;
				4'b0010: ALUControlD = 2'b01;
				4'b0000: ALUControlD = 2'b10;
				4'b1100: ALUControlD = 2'b11;
				default: ALUControlD = 2'bxx;
			endcase
			FlagWriteD[1] = Funct[0];
			FlagWriteD[0] = Funct[0] & ((ALUControlD == 2'b00) | (ALUControlD == 2'b01));
		end
		else begin
			ALUControlD = 2'b00;
			FlagWriteD = 2'b00;
		end
	assign PCSrcD = ((Rd == 4'b1111) & RegWriteD) | BranchD;
endmodule