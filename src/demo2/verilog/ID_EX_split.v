module ID_EX_split(clk, rst, en, choose_branch_is, immed_is, update_R7_is, subtract_is, ALU_op_is, invA_is,
                   invB_is, sign_is, ex_BTR_is, ex_SLBI_is, comp_cont_is, comp_is, pass_is, branch_cont_is, 
                   branch_J_is, branch_I_is, createdump_is, write_mem_is, read_mem_is, mem_to_reg_is, reg_w_en_is,
                   ext_out_is, seq_PC_is, data_1_is, data_2_is, choose_branch_os, immed_os, update_R7_os,
                   subtract_os, ALU_op_os, invA_os, invB_os, sign_os, ex_BTR_os, ex_SLBI_os, comp_cont_os,
                   comp_os, pass_os, branch_cont_os, branch_J_os, branch_I_os, createdump_os, write_mem_os, 
                   read_mem_os, mem_to_reg_os, reg_w_en_os, ext_out_os, seq_PC_os, data_1_os, data_2_os);

    input            clk;
    input            rst;
    input            en;

    // ** control signals for execute stage
    input            choose_branch_is;
    input            immed_is;
    input            update_R7_is;
    input            subtract_is;
    input      [2:0] ALU_op_is;
    input            invA_is;
    input            invB_is;
    input            sign_is;
    input            ex_BTR_is;
    input            ex_SLBI_is;
    input      [1:0] comp_cont_is;
    input            comp_is;
    input            pass_is;
    input      [1:0] branch_cont_is;
    input            branch_J_is;
    input            branch_I_is;
    
    output           choose_branch_os;
    output           immed_os;
    output           update_R7_os;
    output           subtract_os;
    output     [2:0] ALU_op_os;
    output           invA_os;
    output           invB_os;
    output           sign_os;
    output           ex_BTR_os;
    output           ex_SLBI_os;
    output     [1:0] comp_cont_os;
    output           comp_os;
    output           pass_os;
    output     [1:0] branch_cont_os;
    output           branch_J_os;
    output           branch_I_os;

    // ** control signals for memory stage
    input            createdump_is;
    input            write_mem_is;
    input            read_mem_is;

    output           createdump_os;
    output           write_mem_os;
    output           read_mem_os;

    // ** control signals for write back stage
    // note: this include the reg_w_en signal that goes back to the execute stage
    input            mem_to_reg_is;
    input            reg_w_en_is;

    output           mem_to_reg_os;
    output           reg_w_en_os;

    // ** data for execute stage
    input     [15:0] ext_out_is;
    input     [15:0] seq_PC_is;
    input     [15:0] data_1_is;
    input     [15:0] data_2_is;

    output    [15:0] ext_out_os;
    output    [15:0] seq_PC_os;
    output    [15:0] data_1_os;
    output    [15:0] data_2_os;

    // registers for the execute data
    register #(16) ext_out_r(.out(ext_out_os), .in(ext_out_is), .wr_en(en), .clk(clk), .rst(rst));
    register #(16) seq_PC_r(.out(seq_PC_os), .in(seq_PC_is), .wr_en(en), .clk(clk), .rst(rst));
    register #(16) data_1_r(.out(data_1_os), .in(data_1_is), .wr_en(en), .clk(clk), .rst(rst));
    register #(16) data_2_r(.out(data_2_os), .in(data_2_is), .wr_en(en), .clk(clk), .rst(rst));

    // registers for the execute control logic
    register #(1) choose_branch_r(.out(choose_branch_os), .in(choose_branch_is), .wr_en(en), .clk(clk), .rst(rst));
    register #(1) immed_r(.out(immed_os), .in(immed_is), .wr_en(en), .clk(clk), .rst(rst));
    register #(1) update_R7_r(.out(update_R7_os), .in(update_R7_is), .wr_en(en), .clk(clk), .rst(rst));
    register #(1) subtract_r(.out(subtract_os), .in(subtract_is), .wr_en(en), .clk(clk), .rst(rst));
    register #(3) ALU_op_r(.out(ALU_op_os), .in(ALU_op_is), .wr_en(en), .clk(clk), .rst(rst));
    register #(1) invA_r(.out(invA_os), .in(invA_is), .wr_en(en), .clk(clk), .rst(rst));
    register #(1) invB_r(.out(invB_os), .in(invB_is), .wr_en(en), .clk(clk), .rst(rst));
    register #(1) sign_r(.out(sign_os), .in(sign_is), .wr_en(en), .clk(clk), .rst(rst));
    register #(1) ex_BTR_r(.out(ex_BTR_os), .in(ex_BTR_is), .wr_en(en), .clk(clk), .rst(rst));
    register #(1) ex_SLBI_r(.out(ex_SLBI_os), .in(ex_SLBI_is), .wr_en(en), .clk(clk), .rst(rst));
    register #(2) comp_cont_r(.out(comp_cont_os), .in(comp_cont_is), .wr_en(en), .clk(clk), .rst(rst));
    register #(1) comp_r(.out(comp_os), .in(comp_is), .wr_en(en), .clk(clk), .rst(rst));
    register #(1) pass_r(.out(pass_os), .in(pass_is), .wr_en(en), .clk(clk), .rst(rst));
    register #(2) branch_cont_r(.out(branch_cont_os), .in(branch_cont_is), .wr_en(en), .clk(clk), .rst(rst));
    register #(1) branch_J_r(.out(branch_J_os), .in(branch_J_is), .wr_en(en), .clk(clk), .rst(rst));
    register #(1) branch_I_r(.out(branch_I_os), .in(branch_I_is), .wr_en(en), .clk(clk), .rst(rst));

    // registers for the memory control logic
    register #(1) createdump_r(.out(createdump_os), .in(createdump_is), .wr_en(en), .clk(clk), .rst(rst));
    register #(1) write_mem_r(.out(write_mem_os), .in(write_mem_is), .wr_en(en), .clk(clk), .rst(rst));
    register #(1) read_mem_r(.out(read_mem_os), .in(read_mem_is), .wr_en(en), .clk(clk), .rst(rst));

    // registers for write back control logic
    register #(1) mem_to_reg_r(.out(mem_to_reg_os), .in(mem_to_reg_is), .wr_en(en), .clk(clk), .rst(rst));
    register #(1) reg_w_en_r(.out(reg_w_en_os), .in(reg_w_en_is), .wr_en(en), .clk(clk), .rst(rst));
endmodule