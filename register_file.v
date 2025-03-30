module register_file(
    input              clk,
    input              rst_n,
    input   [  4 : 0 ] rs1_idx,
    input   [  4 : 0 ] rs2_idx,
    input   [  4 : 0 ] rd_idx,
    input              reg_write,
    input   [ 31 : 0 ] rd_data,
    output  [ 31 : 0 ] rs1_data,
    output  [ 31 : 0 ] rs2_data
);
    
    integer i;

    assign rs1_data = ((rd_idx == rs1_idx) && (rd_idx != 'd0)) ? rd_data : registers[rs1_idx];
    assign rs2_data = ((rd_idx == rs2_idx) && (rd_idx != 'd0)) ? rd_data : registers[rs2_idx];

    reg [31:0] registers [0:31];

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            for(i = 0; i < 32; i = i + 1) begin
                registers[i] <= 0;
            end
        end
        else begin
            if(reg_write && rd_idx != 'd0) begin
                registers[rd_idx] <= rd_data;
            end
        end
    end

endmodule