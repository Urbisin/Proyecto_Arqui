module forwarding_unit (
    input [3:0] EX_Rs,
    input [3:0] EX_Rt,
    input [3:0] MEM_Rd,
    input [3:0] WB_Rd,
    input MEM_RegWrite,
    input WB_RegWrite,
    output reg [1:0] ForwardA,
    output reg [1:0] ForwardB
);
    always @(*) begin
        // Forwarding para ALU Source A
        if (MEM_RegWrite && (MEM_Rd != 4'b0) && (MEM_Rd == EX_Rs))
            ForwardA = 2'b10; // Desde MEM
        else if (WB_RegWrite && (WB_Rd != 4'b0) && (WB_Rd == EX_Rs))
            ForwardA = 2'b01; // Desde WB
        else
            ForwardA = 2'b00; // Sin forwarding

        // Forwarding para ALU Source B
        if (MEM_RegWrite && (MEM_Rd != 4'b0) && (MEM_Rd == EX_Rt))
            ForwardB = 2'b10; // Desde MEM
        else if (WB_RegWrite && (WB_Rd != 4'b0) && (WB_Rd == EX_Rt))
            ForwardB = 2'b01; // Desde WB
        else
            ForwardB = 2'b00; // Sin forwarding
    end
endmodule
