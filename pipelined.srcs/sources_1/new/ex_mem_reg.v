module ex_mem_reg (
    input wire clk, reset,
    // Control signals
    input wire PCSrcE, RegWriteE, MemtoRegE, MemWriteE,
    // Data signals
    input wire [31:0] ALUResultE,
    input wire [31:0] WriteDataE,
    input wire [3:0] WA3E,
    // Outputs
    output reg PCSrcM, RegWriteM, MemtoRegM, MemWriteM,
    output reg [31:0] ALUResultM,
    output reg [31:0] WriteDataM,
    output reg [3:0] WA3M
);
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            PCSrcM <= 0;
            RegWriteM <= 0;
            MemtoRegM <= 0;
            MemWriteM <= 0;
            ALUResultM <= 32'b0;
            WriteDataM <= 32'b0;
            WA3M <= 4'b0;
        end
        else begin
            PCSrcM <= PCSrcE;
            RegWriteM <= RegWriteE;
            MemtoRegM <= MemtoRegE;
            MemWriteM <= MemWriteE;
            ALUResultM <= ALUResultE;
            WriteDataM <= WriteDataE;
            WA3M <= WA3E;
        end
    end
endmodule