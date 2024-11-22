module datapath (
	clk,
	reset,
	StallF, 
	StallD, 
	FlushE,
	RegSrcD,
	RegWriteD,
	ImmSrcD,
	ALUSrcD,
	ALUControlD,
	MemtoRegD,
	PCSrcD,
	BranchD,
	MemWriteD,
	FlagWriteD,
	CondD,
	ALUFlags,
	PCF,
	InstrF,
	ALUResultM,
	WriteDataM,
	ReadDataM
); 
	input wire clk;
	input wire reset;
// Hazzard Signals
	input wire StallF;
	input wire StallD;
	input wire FlushE;
// Control Signals
	input wire [1:0] RegSrcD;
	input wire RegWriteD;
	input wire [1:0] ImmSrcD;
	input wire ALUSrcD;
	input wire [1:0] ALUControlD;
	input wire MemtoRegD;
	input wire PCSrcD;
	input wire BranchD;
	input wire MemWriteD;
	input wire FlagWriteD;
	input wire [3:0] CondD;
// Output flags and data
	output wire [3:0] ALUFlags;
	output wire [31:0] PCF;
	input wire [31:0] InstrF;
	output wire [31:0] ALUResultM;
	output wire [31:0] WriteDataM;
	input wire [31:0] ReadDataM;
// Declare internal signals for all pipeline stages
	wire [31:0] PCNext;
	wire [31:0] PCPlus4F;
	
	wire [31:0] InstrD, PCPlus4D;
    wire [31:0] RD1D, RD2D, ExtImmD;
    wire [3:0] RA1D, RA2D, WA3D;
    
	// EX (Execute) stage signals
    wire [31:0] RD1E, RD2E, ExtImmE;
    wire [3:0] WA3E;
    wire RegWriteE, MemtoRegE, MemWriteE, ALUSrcE;
    wire [1:0] ALUControlE;
    wire [31:0] SrcAE, SrcBE, ALUResultE, WriteDataE;
    wire PCSrcE, BranchE, CondE, FlagsE;
    
    // MEM (Memory) stage signals
    wire RegWriteM, MemtoRegM;
    wire [3:0] WA3M;
    
    // WB (Writeback) stage signals
    wire [31:0] ALUResultW, ReadDataW, ResultW;
    wire [3:0] WA3W;
    wire RegWriteW, MemtoRegW;
    wire PCSrcM;
    
    // Forwarding control signals
    wire [1:0] ForwardAE, ForwardBE;
	  
	// Hazard Unit
	
	// TODO
	
	mux2 #(32) pcmux(
		.d0(PCPlus4F),
		.d1(ResultW),
		.s(PCSrcD),
		.y(PCNext)
	);
	flopr #(32) pcreg(
		.clk(clk),
		.reset(reset),
		.d(PCNext),
		.q(PCF)
	);
	adder #(32) pcadd1(
		.a(PCF),
		.b(32'b100),
		.y(PCPlus4F)
	);
	
	if_id_reg if_id(
	    .clk(clk),
	    .reset(reset),
        .en(~StallD),
        .pc_plus_4_in(PCPlus4F),
        .instr_in(InstrF),
        .pc_plus_4_out(PCPlus4D),
        .instr_out(InstrD)
	);
	
	//=============== ID Stage ===============//
    
    // Register file address decode
    assign RA1D = RegSrcD[0] ? 4'b1111 : InstrD[19:16];
    assign RA2D = RegSrcD[1] ? InstrD[15:12] : InstrD[3:0];
    assign WA3D = InstrD[15:12];
	
	mux2 #(4) ra1mux(
		.d0(InstrD[19:16]),
		.d1(4'b1111),
		.s(RegSrcD[0]),
		.y(RA1D)
	);
	
	mux2 #(4) ra2mux(
		.d0(InstrD[3:0]),
		.d1(InstrD[15:12]),
		.s(RegSrcD[1]),
		.y(RA2D)
	);
	
	regfile rf(
		.clk(~clk),
		.we3(RegWriteW),
		.ra1(RA1D),
		.ra2(RA2D),
		.wa3(WA3W),
		.wd3(ResultW),
		.r15(PCPlus4D),
		.rd1(RD1D),
		.rd2(RD2D)
	);
	
	extend ext(
        .Instr(InstrD[23:0]),
        .ImmSrc(ImmSrcD),
        .ExtImm(ExtImmD)
    );
    
    id_ex_reg id_ex(
        .clk(clk),
        .reset(reset),
        .PCSrcD(PCSrcD),
        .RegWriteD(RegWriteD),
        .MemtoRegD(MemtoRegD),
        .MemWriteD(MemWriteD),
        .ALUSrcD(ALUSrcD),
        .ALUControlD(ALUControlD),
        .BranchD(BranchD),
        .FlagWriteD(FlagWriteD),
        .Flags(Flags),
        .CondD(CondD),
        .RD1D(RD1D),
        .RD2D(RD2D),
        .WA3D(WA3D),
        .ExtImmD(ExtImmD),
        .PCSrcE(PCSrcE),
        .RegWriteE(RegWriteE),
        .MemtoRegE(MemtoRegE),
        .MemWriteE(MemWriteE),
        .ALUSrcE(ALUSrcE),
        .ALUControlE(ALUControlE),
        .FlagWriteE(FlagWriteE),
        .FlagsE(FlagsE),
        .BranchE(BranchE),
        .CondE(CondE),
        .RD1E(RD1E),
        .RD2E(RD2E),
        .WA3E(WA3E),
        .ExtImmE(ExtImmE)
    );
    
	mux2 #(32) srcbmux(
        .d0(WriteDataE),
        .d1(ExtImmE),
        .s(ALUSrcE),
        .y(SrcBE)
    );
	
	alu alu(
        .SrcA(SrcAE),
        .SrcB(SrcBE),
        .ALUControl(ALUControlE),
        .ALUResult(ALUResultE),
        .ALUFlags(ALUFlags)
    );
    
    ex_mem_reg ex_mem(
        .clk(clk),
        .reset(reset),
        .PCSrcE(PCSrcE),
        .RegWriteE(RegWriteE),
        .MemtoRegE(MemtoRegE),
        .MemWriteE(MemWriteE),
        .ALUResultE(ALUResultE),
        .WriteDataE(WriteDataE),
        .WA3E(WA3E),
        .PCSrcM(PCSrcM),
        .RegWriteM(RegWriteM),
        .MemtoRegM(MemtoRegM),
        .MemWriteM(MemWriteM),
        .ALUResultM(ALUResultM),
        .WriteDataM(WriteDataM),
        .WA3M(WA3M)
    );
    
    mem_wb_reg mem_wb(
        .clk(clk),
        .reset(reset),
        .PCSrcM(PCSrcM),
        .RegWriteM(RegWriteM),
        .MemtoRegM(MemtoRegM),
        .ReadDataM(ReadDataM),
        .ALUResultM(ALUResultM),
        .WA3M(WA3M),
        .RegWriteW(RegWriteW),
        .MemtoRegW(MemtoRegW),
        .ReadDataW(ReadDataW),
        .ALUResultW(ALUResultW),
        .WA3W(WA3W)
    );
endmodule