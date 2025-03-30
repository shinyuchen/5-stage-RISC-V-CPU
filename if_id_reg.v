module if_id_reg(
    input             clk,
    input             rst_n,
    input             flush,
    input             hazard,
    input      [31:0] if_pc,
    input      [31:0] if_inst,
    output reg [31:0] if_id_pc,
    output reg [31:0] if_id_inst,
    output            o_finish
);

    reg [3:0] finish;

    assign o_finish = finish[3];

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n)
            finish <= 'd0;
        else begin
            if(flush)
                finish <= 'd0;
            else begin
                finish[0]   <= (if_id_inst == 32'hffffffff) | finish[0];
                finish[3:1] <= {finish[2:0]};
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            if_id_pc   <= 'd0;
            if_id_inst <= 'd0;
        end
        else begin
            if_id_pc   <= (flush) ? 0 : (hazard) ? if_id_pc : if_pc;
            if_id_inst <= (flush) ? 0 : (hazard) ? if_id_inst : if_inst;
        end
    end

endmodule
