module mem_wb_reg(
    input                  clk,
    input                  rst_n,
    input                  ex_mem_reg_write,
    input                  ex_mem_mem_to_reg,
    input       [ 31 : 0 ] mem_data,
    input       [ 31 : 0 ] ex_mem_alu_o,
    input       [  4 : 0 ] ex_mem_rd_idx,
    output reg             mem_wb_mem_to_reg,
    output reg             mem_wb_reg_write,
    output reg  [ 31 : 0 ] mem_wb_mem_data,
    output reg  [ 31 : 0 ] mem_wb_alu_o,
    output reg  [  4 : 0 ] mem_wb_rd_idx
);

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            mem_wb_mem_data    <= 'd0;  
            mem_wb_alu_o       <= 'd0;  
            mem_wb_rd_idx      <= 'd0;  
            mem_wb_reg_write   <= 'd0;
            mem_wb_mem_to_reg  <= 'd0;
        end  
        else begin  
            mem_wb_mem_data    <= mem_data;  
            mem_wb_alu_o       <= ex_mem_alu_o;  
            mem_wb_rd_idx      <= ex_mem_rd_idx;  
            mem_wb_reg_write   <= ex_mem_reg_write;
            mem_wb_mem_to_reg  <= ex_mem_mem_to_reg;
        end
    end

endmodule