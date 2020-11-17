module IF_ID_split(clk, rst, en, instruc_is, seq_PC_is, instruc_os, seq_PC_os, branch_haz, branch);

    input            clk;
    input            rst;
    input            en;

    // data for the decode
    input     [15:0] instruc_is;
    input     [15:0] seq_PC_is;

    output    [15:0] instruc_os;
    output    [15:0] seq_PC_os;

    input            branch_haz;
    input            branch;

    wire      [15:0] in_instruc_r;
    wire      [15:0] in_seq_PC_r;

    assign in_instruc_r = (branch_haz || branch) ? (16'b0001100000000000) : (instruc_is);
    assign in_seq_PC_r = (branch_haz || branch) ? (16'b0000000000000000) : (seq_PC_is);

    // registers for the decode data
    register #(16) instruc_r(.out(instruc_os), .in(in_instruc_r), .wr_en(en), .clk(clk), .rst(rst));
    register #(16) seq_PC_r(.out(seq_PC_os), .in(in_seq_PC_r), .wr_en(en), .clk(clk), .rst(rst));

endmodule