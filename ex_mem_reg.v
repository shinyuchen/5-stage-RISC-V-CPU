module ex_mem_reg (
    input                   clk, 
    input                   rst_n,
    input                   id_ex_reg_write,
    input                   id_ex_mem_read,
    input                   id_ex_mem_write,
    input                   id_ex_mem_to_reg,
    input       [  4 : 0 ]  id_ex_rd_idx,
    input       [ 31 : 0 ]  ex_alu_o,
    input       [ 31 : 0 ]  ex_rs2_for_mem,
    output reg              ex_mem_reg_write,
    output reg              ex_mem_mem_read,
    output reg              ex_mem_mem_write,
    output reg              ex_mem_mem_to_reg,
    output reg  [  4 : 0 ]  ex_mem_rd_idx,
    output reg  [ 31 : 0 ]  ex_mem_alu_o,
    output reg  [ 31 : 0 ]  ex_mem_rs2_for_mem
);

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            ex_mem_reg_write   <= 'd0;     
            ex_mem_mem_read    <= 'd0; 
            ex_mem_mem_write   <= 'd0;     
            ex_mem_rd_idx      <= 'd0; 
            ex_mem_alu_o       <= 'd0; 
            ex_mem_rs2_for_mem <= 'd0; 
            ex_mem_mem_to_reg  <= 'd0;
        end
        else begin
            ex_mem_reg_write   <= id_ex_reg_write;    
            ex_mem_mem_read    <= id_ex_mem_read;
            ex_mem_mem_write   <= id_ex_mem_write;    
            ex_mem_rd_idx      <= id_ex_rd_idx;
            ex_mem_alu_o       <= ex_alu_o;
            ex_mem_rs2_for_mem <= ex_rs2_for_mem;
            ex_mem_mem_to_reg  <= id_ex_mem_to_reg;
        end
    end

endmodule