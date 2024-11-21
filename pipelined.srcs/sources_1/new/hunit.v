module hazard_detection_unit (
    input [3:0] ID_Rs,
    input [3:0] ID_Rt,
    input [3:0] EX_Rd,
    input EX_MemRead,
    output reg Stall
);
    always @(*) begin
        if (EX_MemRead && ((EX_Rd == ID_Rs) || (EX_Rd == ID_Rt)))
            Stall = 1'b1;
        else
            Stall = 1'b0;
    end
endmodule
