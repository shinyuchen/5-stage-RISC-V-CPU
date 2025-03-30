module branch_target (
    input                    branch_base,
    input         [ 31 : 0 ] pc,
    input         [ 31 : 0 ] rs1,
    input  signed [ 31 : 0 ] imm,
    output        [ 31 : 0 ] branch_target_pc
);

    assign branch_target_pc = (branch_base == 0) ? pc + imm : rs1 + imm;

endmodule