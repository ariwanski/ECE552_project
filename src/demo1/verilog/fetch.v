module fetch(en_PC, branch, branch_PC, instruc, seq_PC, clk, rst);

    input            en_PC;
    input            branch;
    input     [15:0] branch_PC;
    input            clk;
    input            rst;

    output    [15:0] instruc;
    output    [15:0] seq_PC;

    wire      [15:0] PC_in;
    wire      [15:0] PC_out;

    localparam WIDTH = 16;

    // instantiate the instruction memory
    memory2c instr_mem(.data_out(instruc),
                       .data_in(),
                       .addr(PC_out),
                       .enable(1'b1), // set up to always read
                       .wr(1'b0), // set up to always read
                       .createdump(),
                       .clk(clk),
                       .rst(rst));

    // 2-to-1 mux for input to PC reg
    assign PC_in = (branch == 1'b1) ? (branch_PC) : (seq_PC);

    // instantiate PC register
    register #(WIDTH) PC_reg(.out(PC_out), 
                             .in(PC_in), 
                             .wr_en(en_PC), 
                             .clk(clk), 
                             .rst(rst));

    // instantite 16bit CLA adder for seq_PC
    cla_16 adder(.A(PC_out),
                 .B(16'h0002),
                 .S(seq_PC), 
                 .Cin(),
                 .Cout());

endmodule