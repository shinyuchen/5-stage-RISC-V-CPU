module control(
    input                    clk,
    input                    rst_n,
    input                    flush,
    input      [  6 : 0 ]    opcode,
    output     [ 12 : 0 ]    ctrl
);

    reg       mem_to_reg, reg_write, mem_read, mem_write, branch;
    reg       branch_base; // 0 = pc, 1 = rs1
    reg [1:0] alu_src1; // 00 for register file, 01 for pc, 10 for 0
    reg [1:0] alu_src2; // 00 for register file, 01 for imm, 10 for 4
    reg [2:0] alu_op;   // 2 bits are not sufficient for all op categories (lui, branch, I-type, R-type, and LD/SD)

    assign ctrl = {alu_src1, alu_src2, mem_to_reg, reg_write, mem_read, mem_write, branch, branch_base, alu_op};

    always @(*) begin
        case(opcode)
            7'b0110111: begin // LUI -> rd = imm
                alu_src1    = 2'b10;
                alu_src2    = 2'b01;
                mem_to_reg  = 1'b0;
                reg_write   = 1'b1;
                mem_read    = 1'b0;
                mem_write   = 1'b0;
                branch      = 1'b0;
                branch_base = 1'b0;
                alu_op      = 3'b000; // 0 + imm
            end
            7'b0010111: begin // AUIPC -> rd = pc + imm
                alu_src1    = 2'b01;
                alu_src2    = 2'b01;
                mem_to_reg  = 1'b0;
                reg_write   = 1'b1;
                mem_read    = 1'b0;
                mem_write   = 1'b0;
                branch      = 1'b0;
                branch_base = 1'b0;
                alu_op      = 3'b000; // add
            end
            7'b1101111: begin // JAL -> rd = pc + 4, pc = pc + imm
                alu_src1    = 2'b01;
                alu_src2    = 2'b10;
                mem_to_reg  = 1'b0;
                reg_write   = 1'b1;
                mem_read    = 1'b0;
                mem_write   = 1'b0;
                branch      = 1'b1;
                branch_base = 1'b0;
                alu_op      = 3'b110; // add
            end
            7'b1100111: begin // JALR -> rd = pc + 4, pc = rs1 + imm
                alu_src1    = 2'b01;
                alu_src2    = 2'b10;
                mem_to_reg  = 1'b0;
                reg_write   = 1'b1;
                mem_read    = 1'b0;
                mem_write   = 1'b0;
                branch      = 1'b1;
                branch_base = 1'b1;
                alu_op      = 3'b110; // add
            end
            7'b1100011: begin // BRANCH
                alu_src1    = 2'b00;
                alu_src2    = 2'b00;
                mem_to_reg  = 1'b0;
                reg_write   = 1'b0;
                mem_read    = 1'b0;
                mem_write   = 1'b0;
                branch      = 1'b1;
                branch_base = 1'b0;
                alu_op      = 3'b001;
            end
            7'b0000011: begin // LOAD 
                alu_src1    = 2'b00;
                alu_src2    = 2'b01;
                mem_to_reg  = 1'b1;
                reg_write   = 1'b1;
                mem_read    = 1'b1;
                mem_write   = 1'b0;
                branch      = 1'b0;
                branch_base = 1'b0;
                alu_op      = 3'b000; // add
            end
            7'b0100011: begin // STORE
                alu_src1    = 2'b00;
                alu_src2    = 2'b01;
                mem_to_reg  = 1'b0;
                reg_write   = 1'b0;
                mem_read    = 1'b0;
                mem_write   = 1'b1;
                branch      = 1'b0;
                branch_base = 1'b0;
                alu_op      = 3'b000; // add
            end
            7'b0010011: begin // I-type // be aware of SRAI, the shift amount != inst[31:20]
                alu_src1    = 2'b00;
                alu_src2    = 2'b01;
                mem_to_reg  = 1'b0;
                reg_write   = 1'b1;
                mem_read    = 1'b0;
                mem_write   = 1'b0;
                branch      = 1'b0;
                branch_base = 1'b0;
                alu_op      = 3'b100;
            end
            7'b0110011: begin // R-type
                alu_src1    = 2'b00;
                alu_src2    = 2'b00;
                mem_to_reg  = 1'b0;
                reg_write   = 1'b1;
                mem_read    = 1'b0;
                mem_write   = 1'b0;
                branch      = 1'b0;
                branch_base = 1'b0;
                alu_op      = 3'b010;
            end
            7'b0001111: begin // FENCE
            // TODO
                alu_src1    = 2'b00;
                alu_src2    = 2'b00;
                mem_to_reg  = 1'b0;
                reg_write   = 1'b0;
                mem_read    = 1'b0;
                mem_write   = 1'b0;
                branch      = 1'b0;
                branch_base = 1'b0;
                alu_op      = 3'b101;
            end
            7'b1110011: begin // EXCEPTION
            // TODO
                alu_src1    = 2'b00;
                alu_src2    = 2'b00;
                mem_to_reg  = 1'b0;
                reg_write   = 1'b0;
                mem_read    = 1'b0;
                mem_write   = 1'b0;
                branch      = 1'b0;
                branch_base = 1'b0;
                alu_op      = 3'b101;
            end
            default: begin
                alu_src1    = 2'b00;
                alu_src2    = 2'b00;
                mem_to_reg  = 1'b0;
                reg_write   = 1'b0;
                mem_read    = 1'b0;
                mem_write   = 1'b0;
                branch      = 1'b0;
                branch_base = 1'b0;
                alu_op      = 3'b101;
            end
        endcase
        if (flush) begin
            alu_src1    = 2'b00;
            alu_src2    = 2'b00;
            mem_to_reg  = 1'b0;
            reg_write   = 1'b0;
            mem_read    = 1'b0;
            mem_write   = 1'b0;
            branch      = 1'b0;
            branch_base = 1'b0;
            alu_op      = 3'b101;
        end
    end


endmodule