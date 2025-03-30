module forward(
    input   [ 4 : 0 ] id_ex_rs1_idx,
    input   [ 4 : 0 ] id_ex_rs2_idx,
    input   [ 4 : 0 ] ex_mem_rd_idx,
    input   [ 4 : 0 ] mem_wb_rd_idx,
    input             ex_mem_reg_write,
    input             mem_wb_reg_write,
    output  [ 1 : 0 ] rs1_forward,
    output  [ 1 : 0 ] rs2_forward
);

    assign rs1_forward = ((id_ex_rs1_idx == ex_mem_rd_idx) & (ex_mem_reg_write)) ? 2'b01 :
                         ((id_ex_rs1_idx == mem_wb_rd_idx) & (mem_wb_reg_write)) ? 2'b10 : 2'b00;
                         
    assign rs2_forward = ((id_ex_rs2_idx == ex_mem_rd_idx) & (ex_mem_reg_write)) ? 2'b01 :
                         ((id_ex_rs2_idx == mem_wb_rd_idx) & (mem_wb_reg_write)) ? 2'b10 : 2'b00;

endmodule