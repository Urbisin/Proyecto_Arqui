module if_id_reg (
    input wire clk, reset,
    input wire [31:0] instr_in,
    output reg [31:0] instr_out
);
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            instr_out <= 32'b0;
        end
        else begin
            instr_out <= instr_in;
        end
    end
endmodule