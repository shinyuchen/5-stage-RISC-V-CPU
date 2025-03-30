module write_back_mux(
    input             mem_wb_mem_to_reg,
    input  [ 31 : 0 ] mem_wb_mem_data,
    input  [ 31 : 0 ] mem_wb_alu_o,
    output [ 31 : 0 ] wb_data
);

    assign wb_data = (mem_wb_mem_to_reg) ? mem_wb_mem_data : mem_wb_alu_o;

endmodule