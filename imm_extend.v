module imm_extend(
    input             [ 31 : 0 ] inst,
    output reg signed [ 31 : 0 ] imm
);

    always @(*) begin
        case(inst[6:0]) // opcode
            7'b0110111: // LUI
                imm = {inst[31:12], {12{1'b0}}};
            7'b0010111: // AUIPC
                imm = {inst[31:12], {12{1'b0}}};
            7'b1101111: // JAL
                imm = {{11{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0}; // instruction.txt is in pc + 4, but in cpu, converts to pc + 1
            7'b1100111: // JALR
                imm = {{20{inst[31]}}, inst[31:20]};
            7'b1100011: begin // BRANCH
                imm = {{19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};
                // $display("imm = %d\n", imm);
            end
            7'b0000011: // LOAD 
                imm = {{20{1'b0}}, inst[31:20]};
            7'b0100011: // STORE
                imm = {{20{1'b0}}, inst[31:25], inst[11:7]};
            7'b0010011: // other I-type (excluding jalr) // be aware of SRAI, the shift amount != inst[31:20]
                imm = ({inst[31:25], inst[14:12]} == 'b0100000101) ? {{{27{1'b0}}, inst[24:20]}} : {{20{inst[31]}}, inst[31:20]};
            7'b0110011: // R-type
                imm = 32'b0;
            7'b0001111: // FENCE
                imm = 32'b0;
            7'b1110011: // EXCEPTION
                imm = 32'b0;
            default:
                imm = 32'b0;
        endcase
    end

endmodule