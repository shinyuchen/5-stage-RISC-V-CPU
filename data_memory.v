module data_memory #(parameter DEPTH = 'd10) (
    input                 clk,
    input                 rst_n,
    input                 mem_read,
    input                 mem_write,
    input      [ 31 : 0 ] addr,
    input      [ 31 : 0 ] i_data,
    output     [ 31 : 0 ] o_data
);

    mem #(.DEPTH(DEPTH)) data_memory_inst (
        .clk    ( clk         ) ,
        .rst_n  ( rst_n       ) ,
        .wr     ( mem_write   ) ,
        .addr   ( addr >> 'd2 ) ,
        .i_data ( i_data      ) ,
        .o_data ( o_data      )
    );

endmodule