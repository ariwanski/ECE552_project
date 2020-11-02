module execute(ext_out, seq_PC, data_1, data_2, choose_branch, immed, update_R7, subtract, ALU_op, invA, invB, sign, ex_BTR, ex_SLBI, comp_cont, comp, pass, branch_cont, branch_J, data_2_out, ALU_out, branch, branch_PC);

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

    wire             branch_I;
    wire      [15:0] branch_add;

    wire      [15:0] data_B;
    wire      [15:0] other_B;

    wire             rs_zero;
    wire             rs_n_zero;
    wire             rs_lt_zero;
    wire             rs_gte_zero;

    wire             Ofl; // overflow detection

    // 2-to-1 mux for branch_add
    assign branch_add = (choose_branch == 1'b1) ? (data_1) : (seq_PC);

    // instantiate 16bit CLA adder for calc branch_PC
    cla_16 adder(.A(ext_out),
                 .B(branch_add),
                 .S(branch_PC), 
                 .Cin(),
                 .Cout());

    // instantiate branch logic
    branch_i_logic branch_i(.Rs(data_1), 
                            .Rs_zero(rs_zero),
                            .Rs_n_zero(rs_n_zero),
                            .Rs_lt_zero(rs_lt_zero),
                            .Rs_gte_zero(rs_gte_zero));

    // 4-to-1 mux on outputs of branch i logic
    assign branch_I = (branch_cont == 2'b00) ? (rs_zero) : (
                      (branch_cont == 2'b01) ? (rs_n_zero) : (
                      (branch_cont == 2'b10) ? (rs_lt_zero) : (
                       rs_gte_zero))); // branch_cont == 2'b11
    
    assign branch = branch_I || branch_J;

    // create two levels of 2-to-1 muxes for data_B
    assign other_B = (immed == 1'b1) ? (ext_out) : (data_2);
    assign data_B = (update_R7 == 1'b1) ? (seq_PC) : (other_B);

    // instantiate alu
    alu alu(.A(data_1),
            .B(data_B),
            .Cin(subtract),
            .Op(ALU_op),
            .invA(invA),
            .invB(invB),
            .sign(sign),
            .ex_BTR(ex_BTR),
            .ex_SLBI(ex_SLBI),
            .comp_cont(comp_cont),
            .comp(comp),
            .pass(pass),
            .ALU_out(ALU_out),
            .Ofl(Ofl));

    // pass through data_2
    assign data_2_out = data_2;

endmodule