module id_ex_pipeline_reg (
    input clk,
    input reset,
    input RegWrite,
    input ALUSrc,
    input [1:0] ALUControl,
    input [31:0] Instr,
    output reg RegWrite_out,
    output reg ALUSrc_out,
    output reg [1:0] ALUControl_out,
    output reg [31:0] Instr_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            RegWrite_out <= 0;
            ALUSrc_out <= 0;
            ALUControl_out <= 0;
            Instr_out <= 0;
        end else begin
            RegWrite_out <= RegWrite;
            ALUSrc_out <= ALUSrc;
            ALUControl_out <= ALUControl;
            Instr_out <= Instr;
        end
    end
endmodule
