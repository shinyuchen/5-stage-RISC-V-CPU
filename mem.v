module mem #(parameter DEPTH = 'd10) (
    input                       clk,
    input                       rst_n,
    input                       wr,
    input   [        31 : 0 ]   addr,
    input   [        31 : 0 ]   i_data,
    output  [        31 : 0 ]   o_data
);
    integer i;

    reg [31:0] data     [0 : (1 << DEPTH) - 1];
    reg [31:0] data_nxt [0 : (1 << DEPTH) - 1];

    assign o_data = data[addr];

    always @(*) begin
        for(i = 0; i < (1 << DEPTH); i = i + 1) begin
            data_nxt[i] = data[i];
        end
        data_nxt[addr] = (wr) ? i_data : data_nxt[addr];
    end

    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            for(i = 0; i < (1 << DEPTH); i = i + 1) 
                data[i] <= 0;
        end
        else begin
            for(i = 0; i < (1 << DEPTH); i = i + 1) 
                data[i] <= data_nxt[i];
        end
    end

endmodule