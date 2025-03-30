module alu(
    input                 [  4 : 0 ] alu_ctrl,
    input       signed    [ 31 : 0 ] rs1,
    input       signed    [ 31 : 0 ] rs2,
    output  reg                      branch,
    output  reg signed    [ 31 : 0 ] alu_o
);

    // 0000 = AND
    // 0001 = OR
    // 0010 = ADD
    // 0011 = shift left
    // 0100 = set less than
    // 0101 = set less than unsigned
    // 0110 = SUB
    // 0111 = XOR
    // 1000 = logical right shift 
    // 1001 = arithmetic right shift 
    // 1010 = beq
    // 1011 = bne
    // 1100 = blt
    // 1101 = bge
    // 1110 = bltu
    // 1111 = bgeu

    always @(*) begin
        alu_o = 0;
        branch = 0;
        case(alu_ctrl)
            5'b00000: begin
                // AND
                alu_o = rs1 & rs2;
            end
            5'b00001: begin
                // OR
                alu_o = rs1 | rs2;
            end
            5'b00010: begin
                // ADD
                alu_o = rs1 + rs2;
            end
            5'b00011: begin
                // shift left
                alu_o = rs1 << rs2;
            end
            5'b00100: begin
                // set less than
                alu_o = (rs1 < rs2);
            end
            5'b00101: begin
                // set less than unsigned
                alu_o = ({1'b0, rs1} < {1'b0, rs2});
            end
            5'b00110: begin
                // SUB
                alu_o = rs1 - rs2;
            end
            5'b00111: begin
                // XOR
                alu_o = rs1 ^ rs2;
            end
            5'b01000: begin
                // logical right shift 
                alu_o = rs1 >> rs2;
            end
            5'b01001: begin
                // arithmetic right shift 
                alu_o = rs1 >>> rs2;
            end
            5'b01010: begin
                // beq
                branch = (rs1 == rs2);
            end
            5'b01011: begin
                // bne
                branch = (rs1 != rs2);
            end
            5'b01100: begin
                // blt
                branch = (rs1 < rs2);
            end
            5'b01101: begin
                // bge
                branch = (rs1 >= rs2);
            end
            5'b01110: begin
                // bltu
                branch = ({1'b0, rs1} < {1'b0, rs2});
            end
            5'b01111: begin
                // bgeu
                branch = ({1'b0, rs1} >= {1'b0, rs2});
            end
            5'b10000: begin
                // jal, jalr
                branch = 1;
                alu_o = rs1 + rs2;
            end
        endcase
    end


endmodule
