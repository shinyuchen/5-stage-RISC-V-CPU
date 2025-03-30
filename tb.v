`timescale 10ps/10ps

module tb;

reg          clk;
reg          rst_n;
reg          wr_im;
reg          start;
reg  [31:0]  inst_i;
wire         finish;
wire [31:0]  executed_inst;

integer fd, inst;
integer fd2;

top #(
    .IM_DEPTH('d10), 
    .DM_DEPTH('d10)
) top_inst (
    .clk            ( clk           ) ,
    .rst_n          ( rst_n         ) ,         
    .wr_im          ( wr_im         ) ,
    .top_inst_i     ( inst_i        ) ,
    .start          ( start         ) ,
    .finish         ( finish        ) ,
    .executed_inst  ( executed_inst )
);

initial begin
    clk = 0;
    forever begin
        #5;
            clk = ~clk;
    end
end

initial begin
    $dumpfile("five-stage-risc-v-cpu.vcd");
    $dumpvars(0, tb);
end

initial begin
    rst_n  = 1;
    wr_im  = 0;
    start  = 0;
    inst_i = 0;
    inst   = $fopen("./testing/inst_bin.txt", "r");
    fd2    = $fopen("./testing/exe_inst.txt", "w");

    @(posedge clk)  
        rst_n = 0;

    @(posedge clk)
        rst_n = 1;
        // fd = $fscanf(inst, "%b\n", inst_i); 

    while (!$feof(inst)) begin
        @(posedge clk)
            wr_im = 1;
        // read file and feed instructions
            fd = $fscanf(inst, "%b\n", inst_i); 
            // $display("inst = %b\n", inst_i);
    end
    
    @(posedge clk)
        wr_im = 0;
        start = 1;

    while(!finish) begin
        @(posedge clk)
            if(executed_inst)
                $fdisplayb(fd2, executed_inst);
    end

end

initial begin
    wait(finish);
    @(posedge clk)
    // check if all the registers and memories have correct values
        $finish;
end

initial begin
    #20000;
        $display("Exceed time\n");
        $finish;
end



endmodule