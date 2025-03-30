module top #(
    parameter IM_DEPTH = 'd10, 
    parameter DM_DEPTH = 'd10
) (
    input             clk,
    input             rst_n,
    input             wr_im,
    input   [31:0]    top_inst_i,
    input             start,
    output            finish,
    output  [31:0]    executed_inst
);

    // IF stage

    wire        branch;
    wire        hazard;
    wire [31:0] if_branch_target_pc;
    wire [31:0] if_pc;
    wire [31:0] if_inst;
    wire [31:0] if_id_pc, if_id_inst;

    pc pc_inst (
        .clk              ( clk                 ) ,
        .rst_n            ( rst_n               ) ,
        .start            ( start               ) ,
        .wr_im            ( wr_im               ) ,
        .branch           ( branch              ) ,
        .hazard           ( hazard              ) ,
        .branch_target_pc ( if_branch_target_pc ) ,
        .pc               ( if_pc               ) 
    );

    instruction_memory #(.DEPTH(IM_DEPTH)) instruction_memory_inst (
        .clk      (   clk            ), 
        .rst_n    (   rst_n          ),
        .wr       (   wr_im          ),
        .addr     (   if_pc          ),
        .i_inst   (   top_inst_i     ),
        .o_inst   (   if_inst        )
    );

    if_id_reg if_id_reg_inst(
        .clk        ( clk        ),
        .rst_n      ( rst_n      ),
        .flush      ( branch     ),
        .hazard     ( hazard     ),
        .if_pc      ( if_pc      ),
        .if_inst    ( if_inst    ),
        .if_id_pc   ( if_id_pc   ),
        .if_id_inst ( if_id_inst ),
        .o_finish   ( finish     )
    );

    // ID stage

    wire                   id_load_use_hazard;
    wire                   id_reg_write;
    wire        [ 12 : 0 ] id_ctrl;
    wire        [ 31 : 0 ] id_rd_data, id_rs1_data, id_rs2_data;
    wire signed [ 31 : 0 ] id_imm;
    wire        [  4 : 0 ] id_rd_idx;
    
    assign hazard = id_load_use_hazard;
    assign branch = ex_branch & id_ex_ctrl[4];

    reg [ 31 : 0 ] id_ex_pc;
    reg [ 12 : 0 ] id_ex_ctrl;
    reg [ 31 : 0 ] id_ex_imm;
    reg [  6 : 0 ] id_ex_opcode;
    reg [  4 : 0 ] id_ex_rs1_idx;
    reg [  4 : 0 ] id_ex_rs2_idx;
    reg [  4 : 0 ] id_ex_rd_idx;
    reg [ 31 : 0 ] id_ex_rs1_data;
    reg [ 31 : 0 ] id_ex_rs2_data;
    reg [  6 : 0 ] id_ex_funct7;
    reg [  2 : 0 ] id_ex_funct3;
    reg [ 31 : 0 ] id_ex_inst;

    assign executed_inst = id_ex_inst;

    // ctrl = {alu_src1, alu_src2, mem_to_reg, reg_write, mem_read, mem_write, branch, branch_base, alu_op};



    control control_inst (
        .clk       ( clk                ) ,
        .rst_n     ( rst_n              ) ,
        .flush     ( branch             ) ,
        .opcode    ( if_id_inst[6:0]    ) ,
        .ctrl      ( id_ctrl            ) 
    );

    register_file reg_file_inst (
        .clk       ( clk                 ) ,
        .rst_n     ( rst_n               ) ,
        .rs1_idx   ( if_id_inst[19:15]   ) ,
        .rs2_idx   ( if_id_inst[24:20]   ) ,
        .rd_idx    ( id_rd_idx           ) ,
        .reg_write ( id_reg_write        ) ,
        .rd_data   ( id_rd_data          ) ,
        .rs1_data  ( id_rs1_data         ) ,
        .rs2_data  ( id_rs2_data         )
    );

    load_use_hazard load_use_hazard_inst (
        .id_ex_rd_idx    ( id_ex_rd_idx        ),
        .if_id_rs1_idx   ( if_id_inst[19:15]   ),
        .if_id_rs2_idx   ( if_id_inst[24:20]   ),
        .if_id_opcode    ( if_id_inst[ 6:0 ]   ),
        .id_ex_mem_read  ( id_ex_ctrl[8]       ),
        .load_use_hazard ( id_load_use_hazard  )
    );

    imm_extend imm_extend_inst (
        .inst   ( if_id_inst ),
        .imm    ( id_imm     )
    );

    id_ex_reg id_ex_reg_inst (
        .clk            (   clk                  ) , 
        .rst_n          (   rst_n                ) ,
        .hazard         (   hazard               ) ,
        .branch         (   branch               ) ,
        .if_id_pc       (   if_id_pc             ) ,
        .if_id_funct7   (   if_id_inst[ 31 : 25 ]) ,
        .if_id_funct3   (   if_id_inst[ 14 : 12 ]) ,
        .if_id_inst     (   if_id_inst           ) , // for test
        .id_ctrl        (   id_ctrl              ) ,
        .id_imm         (   id_imm               ) ,
        .id_rs1_idx     (   if_id_inst[ 19 : 15 ]) ,
        .id_rs2_idx     (   if_id_inst[ 24 : 20 ]) ,
        .id_rd_idx      (   if_id_inst[ 11 : 7  ]) ,
        .id_rs1_data    (   id_rs1_data          ) ,
        .id_rs2_data    (   id_rs2_data          ) ,
        .id_ex_pc       (   id_ex_pc             ) ,
        .id_ex_ctrl     (   id_ex_ctrl           ) ,
        .id_ex_imm      (   id_ex_imm            ) ,
        .id_ex_rs1_idx  (   id_ex_rs1_idx        ) ,
        .id_ex_rs2_idx  (   id_ex_rs2_idx        ) ,
        .id_ex_rd_idx   (   id_ex_rd_idx         ) ,
        .id_ex_rs1_data (   id_ex_rs1_data       ) ,
        .id_ex_rs2_data (   id_ex_rs2_data       ) ,
        .id_ex_funct7   (   id_ex_funct7         ) ,
        .id_ex_funct3   (   id_ex_funct3         ) ,
        .id_ex_inst     (   id_ex_inst           )  // for test
    );


    // EX stage

    wire [  4 : 0 ] ex_alu_ctrl;
    wire [ 31 : 0 ] ex_alu_rs1, ex_alu_rs2, ex_rs2_for_mem;
    wire [ 31 : 0 ] ex_alu_o;
    wire [  1 : 0 ] ex_rs1_forward, ex_rs2_forward;
    wire [ 31 : 0 ] ex_branch_target_pc;
    wire            ex_branch;

    reg              ex_mem_reg_write;
    reg              ex_mem_mem_read;
    reg              ex_mem_mem_write;
    reg              ex_mem_mem_to_reg;
    reg  [  4 : 0 ]  ex_mem_rd_idx;
    reg  [ 31 : 0 ]  ex_mem_alu_o;
    reg  [ 31 : 0 ]  ex_mem_rs2_for_mem;
    reg  [ 31 : 0 ]  ex_rs1_for_branch;

    assign if_branch_target_pc = ex_branch_target_pc;

    alu_control alu_control_inst (
        .alu_op   ( id_ex_ctrl[2:0] )   ,
        .funct7   ( id_ex_funct7    )   ,
        .funct3   ( id_ex_funct3    )   ,
        .alu_ctrl ( ex_alu_ctrl     )
    );

    alu alu_inst(
        .alu_ctrl ( ex_alu_ctrl     )   ,
        .rs1      ( ex_alu_rs1      )   ,
        .rs2      ( ex_alu_rs2      )   ,
        .branch   ( ex_branch       )   ,
        .alu_o    ( ex_alu_o        )   
    );

    forward forward_inst(
        .id_ex_rs1_idx    ( id_ex_rs1_idx    )  ,
        .id_ex_rs2_idx    ( id_ex_rs2_idx    )  ,
        .ex_mem_rd_idx    ( ex_mem_rd_idx    )  ,
        .mem_wb_rd_idx    ( mem_wb_rd_idx    )  ,
        .ex_mem_reg_write ( ex_mem_reg_write )  ,
        .mem_wb_reg_write ( mem_wb_reg_write )  ,
        .rs1_forward      ( ex_rs1_forward   )  ,
        .rs2_forward      ( ex_rs2_forward   )  
    );

    alu_src_mux alu_src_mux_inst(
        .alu_src1       ( id_ex_ctrl[ 12 : 11 ] ) ,
        .alu_src2       ( id_ex_ctrl[ 10 : 9  ] ) ,
        .rs1_forward    ( ex_rs1_forward        ) ,
        .rs2_forward    ( ex_rs2_forward        ) ,
        .rs1_data       ( id_ex_rs1_data        ) ,
        .rs2_data       ( id_ex_rs2_data        ) ,
        .pc             ( id_ex_pc              ) ,
        .ex_mem_rd_data ( ex_mem_alu_o          ) ,
        .mem_wb_rd_data ( wb_data               ) ,
        .imm            ( id_ex_imm             ) ,
        .alu_rs1        ( ex_alu_rs1            ) ,
        .alu_rs2        ( ex_alu_rs2            ) ,
        .rs2_for_mem    ( ex_rs2_for_mem        ) ,
        .rs1_for_branch ( ex_rs1_for_branch     ) 
    );

    branch_target branch_target_inst (
        .branch_base      ( id_ex_ctrl[3]       )   ,
        .pc               ( id_ex_pc            )   ,
        .rs1              ( ex_rs1_for_branch   )   ,
        .imm              ( id_ex_imm           )   ,
        .branch_target_pc ( ex_branch_target_pc )   
    );

    ex_mem_reg ex_mem_reg_inst (
        .clk                ( clk                ) , 
        .rst_n              ( rst_n              ) ,
        .id_ex_reg_write    ( id_ex_ctrl[7]      ) ,
        .id_ex_mem_read     ( id_ex_ctrl[6]      ) ,
        .id_ex_mem_write    ( id_ex_ctrl[5]      ) ,
        .id_ex_mem_to_reg   ( id_ex_ctrl[8]     ) ,
        .id_ex_rd_idx       ( id_ex_rd_idx       ) ,
        .ex_alu_o           ( ex_alu_o           ) ,
        .ex_rs2_for_mem     ( ex_rs2_for_mem     ) ,
        .ex_mem_reg_write   ( ex_mem_reg_write   ) ,
        .ex_mem_mem_read    ( ex_mem_mem_read    ) ,
        .ex_mem_mem_write   ( ex_mem_mem_write   ) ,
        .ex_mem_mem_to_reg  ( ex_mem_mem_to_reg  ) ,
        .ex_mem_rd_idx      ( ex_mem_rd_idx      ) ,
        .ex_mem_alu_o       ( ex_mem_alu_o       ) ,
        .ex_mem_rs2_for_mem ( ex_mem_rs2_for_mem ) 
    );

    // MEM stage

    wire [ 31 : 0 ] mem_data;

    reg             mem_wb_reg_write;
    reg             mem_wb_mem_to_reg;
    reg  [ 31 : 0 ] mem_wb_mem_data;
    reg  [ 31 : 0 ] mem_wb_alu_o;
    reg  [  4 : 0 ] mem_wb_rd_idx;

    data_memory #(.DEPTH(DM_DEPTH)) data_memory_inst (
        .clk       ( clk                )  ,
        .rst_n     ( rst_n              )  ,
        .mem_read  ( ex_mem_mem_read    )  ,
        .mem_write ( ex_mem_mem_write   )  ,
        .addr      ( ex_mem_alu_o       )  ,
        .i_data    ( ex_mem_rs2_for_mem )  ,
        .o_data    ( mem_data           )  
    );

    mem_wb_reg mem_wb_reg_inst (
        .clk               ( clk                 ) ,
        .rst_n             ( rst_n               ) ,
        .ex_mem_reg_write  ( ex_mem_reg_write    ) ,
        .ex_mem_mem_to_reg ( ex_mem_mem_to_reg   ) ,
        .mem_data          ( mem_data            ) ,
        .ex_mem_alu_o      ( ex_mem_alu_o        ) ,
        .ex_mem_rd_idx     ( ex_mem_rd_idx       ) ,
        .mem_wb_mem_to_reg ( mem_wb_mem_to_reg   ) ,
        .mem_wb_reg_write  ( mem_wb_reg_write    ) ,
        .mem_wb_mem_data   ( mem_wb_mem_data     ) ,
        .mem_wb_alu_o      ( mem_wb_alu_o        ) ,
        .mem_wb_rd_idx     ( mem_wb_rd_idx       )  
    );

    // WB stage

    wire [ 31 : 0 ] wb_data;

    write_back_mux write_back_mux_inst (
        .mem_wb_mem_to_reg ( mem_wb_mem_to_reg )  ,
        .mem_wb_mem_data   ( mem_wb_mem_data   )  ,   
        .mem_wb_alu_o      ( mem_wb_alu_o      )  ,
        .wb_data           ( wb_data           )  
    );

    assign id_rd_data = wb_data;
    assign id_reg_write = mem_wb_reg_write;
    assign id_rd_idx = mem_wb_rd_idx;


endmodule