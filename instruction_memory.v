module instruction_memory #(parameter DEPTH = 'd10) (
    input                       clk, 
    input                       rst_n,
    input                       wr,
    input  [        31 : 0 ]    addr,
    input  [        31 : 0 ]    i_inst,
    output [        31 : 0 ]    o_inst
);

mem #(.DEPTH(DEPTH)) mem_inst (
    .clk    (   clk         ),
    .rst_n  (   rst_n       ),
    .wr     (   wr          ),
    .addr   (   addr >> 'd2 ),
    .i_data (   i_inst      ),
    .o_data (   o_inst      )
);

endmodule