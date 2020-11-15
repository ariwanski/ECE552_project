module IF_ID_split(clk, rst, en, instruc_is, seq_PC_is, instruc_os, seq_PC_os);

    input            clk;
    input            rst;
    input            en;

    // data for the decode
    input     [15:0] instruc_is;
    input     [15:0] seq_PC_is;

    output    [15:0] instruc_os;
    output    [15:0] seq_PC_os;

    // registers for the decode data
    register #(16) instruc_r(.out(instruc_os), .in(instruc_is), .wr_en(en), .clk(clk), .rst(rst));
    register #(16) seq_PC_r(.out(seq_PC_os), .in(seq_PC_is), .wr_en(en), .clk(clk), .rst(rst));
    
endmodule