module dff_en(q, d, en, clk, rst);
    input d;
    input en;
    input clk;
    input rst;
    output q;

    wire real_d;

    dff flop(.q(q), .d(real_d), .clk(clk), .rst(rst));

    assign real_d = en ? d : q;

endmodule