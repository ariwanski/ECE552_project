module fetch(en_PC, branch, branch_PC, instruc, seq_PC);

    input            en_PC;
    input            branch;
    input     [15:0] branch_PC;

    output    [15:0] instruc;
    output    [15:0] seq_PC;

endmodule