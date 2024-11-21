module id_ex_reg (
    input wire clk, reset,
    // Control signals
    input wire PCSrcD, RegWriteD, MemtoRegD, MemWriteD, ALUSrcD, BranchD, FlagWriteD, Flags,
    input wire [1:0] ALUControlD,
    input wire [3:0] CondD,
    // Data signals
    input wire [31:0] RD1D, RD2D,
    input wire [3:0] WA3D,
    input wire [31:0] ExtImmD,
    // Outputs
    output reg PCSrcE, RegWriteE, MemtoRegE, MemWriteE, ALUSrcE, BranchE, FlagWriteE, FlagsE,
    output reg [1:0] ALUControlE,
    output reg [3:0] CondE,
    output reg [31:0] RD1E, RD2E,
    output reg [3:0] WA3E,
    output reg [31:0] ExtImmE
);
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            // Control signals
            PCSrcE <= 0;
            RegWriteE <= 0;
            MemtoRegE <= 0;
            MemWriteE <= 0;
            ALUSrcE <= 0;
            BranchE <= 0;
            FlagWriteE <= 0;
            FlagsE <= 0;
            ALUControlE <= 2'b00;
            CondE <= 4'b0000;
            // Data signals
            RD1E <= 32'b0;
            RD2E <= 32'b0;
            WA3E <= 4'b0;
            ExtImmE <= 32'b0;
        end
        else begin
            // Control signals
            PCSrcE <= PCSrcD;
            RegWriteE <= RegWriteD;
            MemtoRegE <= MemtoRegD;
            MemWriteE <= MemWriteD;
            ALUSrcE <= ALUSrcD;
            BranchE <= BranchD;
            FlagWriteE <= FlagWriteD;
            FlagsE <= Flags;
            ALUControlE <= ALUControlD;
            CondE <= CondD;
            // Data signals
            RD1E <= RD1D;
            RD2E <= RD2D;
            WA3E <= WA3D;
            ExtImmE <= ExtImmD;
        end
    end
endmodule