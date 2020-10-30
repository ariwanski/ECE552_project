module execute(ext_out, seq_PC, data_1, data_2, choose_branch, immed, update_R7, subtract, ALU_op[2:0], invA, invB, sign, ex_BTR, ex_SLBI, comp_cont, comp, pass, branch_cont, branch_J, data_2_out, ALU_out, branch, branch_PC);

    input     [15:0] ext_out;
    input     [15:0] seq_PC;
    input     [15:0] data_1;
    input     [15:0] data_2;
    input            choose_branch;
    input            immed;
    input            update_R7;
    input            subtract;
    input      [2:0] ALU_op;
    input            invA;
    input            invB;
    input            sign;
    input            ex_BTR;
    input            ex_SLBI;
    input      [1:0] comp_cont;
    input            comp;
    input            pass;
    input      [1:0] branch_cont;
    input            branch_J;

    output    [15:0] data_2_out;
    output    [15:0] ALU_out;
    output           branch;
    output    [15:0] branch_PC;

endmodule