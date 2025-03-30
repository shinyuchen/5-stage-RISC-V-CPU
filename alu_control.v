module alu_control(
    input      [ 2 : 0 ] alu_op,
    input      [ 6 : 0 ] funct7,
    input      [ 2 : 0 ] funct3,
    output reg [ 4 : 0 ] alu_ctrl
);

    // 16 operations in total
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
        case(alu_op)
            3'b000: begin
                alu_ctrl = 5'b00010; // add for store, load, ...
            end
            3'b001: begin // branch
                case(funct3)
                    3'b000: 
                        alu_ctrl = 5'b01010; // beq
                    3'b001:
                        alu_ctrl = 5'b01011; // bne
                    3'b100:
                        alu_ctrl = 5'b01100; // blt
                    3'b101:
                        alu_ctrl = 5'b01101; // bge
                    3'b110:
                        alu_ctrl = 5'b01110; // bltu
                    3'b111:
                        alu_ctrl = 5'b01111; // bgeu
                    default:
                        alu_ctrl = 5'b00000;
                endcase
            end
            3'b010: begin // R-type
                case({funct7, funct3})
                    10'b0000000000:
                        alu_ctrl = 5'b00010; // add
                    10'b0100000000:
                        alu_ctrl = 5'b00110; // sub
                    10'b0000000001:
                        alu_ctrl = 5'b00011; // shift left
                    10'b0000000010:
                        alu_ctrl = 5'b00100; // set less than
                    10'b0000000011:
                        alu_ctrl = 5'b00101; // set less than unsigned
                    10'b0000000100:
                        alu_ctrl = 5'b00111; // xor
                    10'b0000000101:
                        alu_ctrl = 5'b01000; // logical right shift
                    10'b0100000101:
                        alu_ctrl = 5'b01001; // arithmetic right shift
                    10'b0000000110:
                        alu_ctrl = 5'b00001; // or
                    10'b0000000111:
                        alu_ctrl = 5'b00000; // and
                    default:
                        alu_ctrl = 5'b00000;
                endcase
            end
            3'b100: begin // I-type
                case(funct3)
                    3'b000: 
                        alu_ctrl = 5'b00010; // add
                    3'b010:
                        alu_ctrl = 5'b00100; // set less than
                    3'b011:
                        alu_ctrl = 5'b00101; // set less than unsigned
                    3'b100:
                        alu_ctrl = 5'b00111; // xor
                    3'b110:
                        alu_ctrl = 5'b00001; // or
                    3'b111:
                        alu_ctrl = 5'b00000; // and
                    3'b001:
                        alu_ctrl = 5'b00011; // shift left
                    3'b101:
                        alu_ctrl = (funct7 == 7'b0000000) ? 5'b01000 : 5'b01001; // right shift
                    default:
                        alu_ctrl = 5'b00000;
                endcase
            end
            3'b101: begin
                // exception, fence 
                // TODO
                alu_ctrl = 5'b00000;
            end
            3'b110: begin
                // jal, jalr
                alu_ctrl = 5'b10000;
            end
            default: 
                alu_ctrl = 5'b00000;
        endcase
    end

endmodule
