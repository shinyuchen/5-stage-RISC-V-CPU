module alu_src_mux (
    input      [  1 : 0 ] alu_src1,
    input      [  1 : 0 ] alu_src2,
    input      [  1 : 0 ] rs1_forward,
    input      [  1 : 0 ] rs2_forward,
    input      [ 31 : 0 ] rs1_data,
    input      [ 31 : 0 ] rs2_data,
    input      [ 31 : 0 ] pc,
    input      [ 31 : 0 ] ex_mem_rd_data,
    input      [ 31 : 0 ] mem_wb_rd_data,
    input      [ 31 : 0 ] imm,
    output reg [ 31 : 0 ] alu_rs1,
    output reg [ 31 : 0 ] alu_rs2,
    output     [ 31 : 0 ] rs2_for_mem,
    output     [ 31 : 0 ] rs1_for_branch
);

    assign rs2_for_mem = (rs2_forward == 2'b01) ? ex_mem_rd_data : (rs2_forward == 2'b10) ? mem_wb_rd_data : rs2_data;
    assign rs1_for_branch = (rs1_forward == 2'b01) ? ex_mem_rd_data : (rs1_forward == 2'b10) ? mem_wb_rd_data : rs1_data;

    always @(*) begin
        case(alu_src1)
            2'b00: begin
                alu_rs1 = (rs1_forward == 2'b01) ? ex_mem_rd_data : (rs1_forward == 2'b10) ? mem_wb_rd_data : rs1_data;
            end
            2'b01: begin
                alu_rs1 = pc;
            end
            2'b10: begin
                alu_rs1 = 0;
            end
            default: begin
                alu_rs1 = 0;
            end
        endcase
    end

    always @(*) begin
        case(alu_src2)
            2'b00: begin
                alu_rs2 = (rs2_forward == 2'b01) ? ex_mem_rd_data : (rs2_forward == 2'b10) ? mem_wb_rd_data : rs2_data;
            end
            2'b01: begin
                alu_rs2 = imm;
            end
            2'b10: begin
                alu_rs2 = 4; // = 4 for pc + 4
            end
            default: begin
                alu_rs2 = 0;
            end
        endcase
    end

endmodule