module mem_wb_reg (
    input wire clk, reset,
    // Control signals
    input wire PCSrcM, RegWriteM, MemtoRegM,
    // Data signals
    input wire [31:0] ReadDataM,
    input wire [31:0] ALUResultM,
    input wire [3:0] WA3M,
    // Outputs
    output reg PCSrcW, RegWriteW, MemtoRegW,
    output reg [31:0] ReadDataW,
    output reg [31:0] ALUResultW,
    output reg [3:0] WA3W
);
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            PCSrcW <= 0;
            RegWriteW <= 0;
            MemtoRegW <= 0;
            ReadDataW <= 32'b0;
            ALUResultW <= 32'b0;
            WA3W <= 4'b0;
        end
        else begin
            PCSrcW <= PCSrcM;
            RegWriteW <= RegWriteM;
            MemtoRegW <= MemtoRegM;
            ReadDataW <= ReadDataM;
            ALUResultW <= ALUResultM;
            WA3W <= WA3M;
        end
    end
endmodule