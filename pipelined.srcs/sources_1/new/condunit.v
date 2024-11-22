module condunit (
	clk,
	reset,
	CondE,
	FlagsE,
	ALUFlags,
	FlagWriteE,
	RegW,
	MemW,
	PCSrc,
	RegWrite,
	MemWrite
);
	input wire clk;
	input wire reset;
	input wire [3:0] CondE;
	input wire [3:0] ALUFlags;
	input wire [3:0] FlagsE;
	input wire [1:0] FlagWriteE;
	input wire PCSrc;
	input wire RegW;
	input wire MemW;
	output wire RegWrite;
	output wire MemWrite;
	output wire CondExE;
	output wire [3:0] Flags
	wire [1:0] FlagWrite;
	wire [3:0] Flags;

	flopenr #(2) flagreg1(
		.clk(clk),
		.reset(reset),
		.en(FlagWriteE[1]),
		.d(ALUFlags[3:2]),
		.q(Flags[3:2])
	);
	flopenr #(2) flagreg0(
		.clk(clk),
		.reset(reset),
		.en(FlagWriteE[0]),
		.d(ALUFlags[1:0]),
		.q(Flags[1:0])
	);
	condcheck cc(
		.Cond(CondE),
		.Flags(Flags),
		.CondExE(CondEx)
	);

	assign FlagWrite = FlagWriteE & {2 {CondExE}};

endmodule