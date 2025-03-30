module id_ex_reg (
    input                 clk, 
    input                 rst_n,
    input                 branch,
    input                 hazard,
    input      [ 31 : 0 ] if_id_pc,
    input      [  6 : 0 ] if_id_funct7,
    input      [  2 : 0 ] if_id_funct3,
    input      [ 31 : 0 ] if_id_inst, // for test
    input      [ 12 : 0 ] id_ctrl,
    input      [ 31 : 0 ] id_imm,
    input      [  4 : 0 ] id_rs1_idx,
    input      [  4 : 0 ] id_rs2_idx,
    input      [  4 : 0 ] id_rd_idx,
    input      [ 31 : 0 ] id_rs1_data,
    input      [ 31 : 0 ] id_rs2_data,
    output reg [ 31 : 0 ] id_ex_pc,
    output reg [ 12 : 0 ] id_ex_ctrl,
    output reg [ 31 : 0 ] id_ex_imm,
    output reg [  4 : 0 ] id_ex_rs1_idx,
    output reg [  4 : 0 ] id_ex_rs2_idx,
    output reg [  4 : 0 ] id_ex_rd_idx,
    output reg [ 31 : 0 ] id_ex_rs1_data,
    output reg [ 31 : 0 ] id_ex_rs2_data,
    output reg [  6 : 0 ] id_ex_funct7,
    output reg [  2 : 0 ] id_ex_funct3,
    output reg [ 31 : 0 ] id_ex_inst  // for test
);


    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            id_ex_pc       <= 'd0;  
            id_ex_ctrl     <= 'd0;  
            id_ex_imm      <= 'd0;  
            id_ex_rs1_idx  <= 'd0;  
            id_ex_rs2_idx  <= 'd0;  
            id_ex_rd_idx   <= 'd0;  
            id_ex_rs1_data <= 'd0;
            id_ex_rs2_data <= 'd0;
            id_ex_funct7   <= 'd0;
            id_ex_funct3   <= 'd0;
            id_ex_inst     <= 'd0;
        end
        else begin
            id_ex_pc       <= if_id_pc;  
            id_ex_ctrl     <= (branch | hazard) ? 0 : id_ctrl;  
            id_ex_imm      <= id_imm;  
            id_ex_rs1_idx  <= id_rs1_idx;  
            id_ex_rs2_idx  <= id_rs2_idx;  
            id_ex_rd_idx   <= id_rd_idx;  
            id_ex_rs1_data <= id_rs1_data;
            id_ex_rs2_data <= id_rs2_data;
            id_ex_funct7   <= if_id_funct7;
            id_ex_funct3   <= if_id_funct3;
            id_ex_inst     <= (branch | hazard) ? 0 : if_id_inst;
        end
    end
 
endmodule