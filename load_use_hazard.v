module load_use_hazard (
    input   [ 4 : 0 ] id_ex_rd_idx,
    input   [ 4 : 0 ] if_id_rs1_idx,
    input   [ 4 : 0 ] if_id_rs2_idx,
    input   [ 6 : 0 ] if_id_opcode,
    input             id_ex_mem_read,
    output            load_use_hazard
);
    wire   has_rs1 = (if_id_opcode != 7'b0110111) & (if_id_opcode != 7'b0010111) & (if_id_opcode != 7'b1101111) & (if_id_opcode != 7'b1110011);
    assign load_use_hazard = has_rs1 & id_ex_mem_read & ((id_ex_rd_idx == if_id_rs1_idx) || (id_ex_rd_idx == if_id_rs2_idx)) & (id_ex_rd_idx != 'd0);

endmodule
