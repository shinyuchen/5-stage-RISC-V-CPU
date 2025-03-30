module pc (
    input                    clk,
    input                    rst_n,
    input                    start,
    input                    wr_im,
    input                    branch,
    input                    hazard,
    input      [ 31 : 0 ]    branch_target_pc,
    output reg [ 31 : 0 ]    pc
);

    localparam S_IDLE = 2'b00, S_WR = 2'b01, S_EXE = 2'b10;

    reg [1:0] state, state_nxt;

    reg [31:0] pc_nxt;

    always @(*) begin
        case(state)
            S_IDLE: begin
                state_nxt = (wr_im) ? S_WR : S_IDLE;
                pc_nxt = (wr_im) ? pc + 4 : pc;
            end
            S_WR: begin
                state_nxt = (start) ? S_EXE : S_WR;
                pc_nxt = (start) ? 'd0 : pc + 4;
            end
            S_EXE: begin
                state_nxt = S_EXE;
                pc_nxt = (hazard) ? pc : (branch) ? (branch_target_pc) : pc + 4;
            end
            default: begin
                state_nxt = S_IDLE;
                pc_nxt = pc;
            end
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            pc      <= 'd0;
            state   <= S_IDLE;
        end
        else begin
            state   <= state_nxt;
            pc      <= pc_nxt;
        end
    end

endmodule