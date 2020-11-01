module alu(A, B, Cin, Op, invA, invB, sign, ex_BTR, ex_SLBI, comp_cont, comp, pass, ALU_out, Ofl);

    input     [15:0] A;
    input     [15:0] B;
    input            Cin;
    input      [2:0] Op;
    input            invA;
    input            invB;
    input            sign;
    input            ex_BTR;
    input            ex_SLBI;
    input      [1:0] comp_cont;
    input            comp;
    input            pass;

    output    [15:0] ALU_out;
    output           Ofl;

    wire             negative; // output of internal ALU is negative
    wire             zero; // output of internal ALU is zero
    wire             Cout; // output of internal ALU has a carry out
    wire      [15:0] comp_out;

    // localparams for comp_cont values
    localparam CC_ZERO = 2'b00;
    localparam CC_NEG = 2'b01;
    localparam CC_NEG_ZERO = 2'b10;
    localparam CC_COUT = 2'b11;

    // 16bit wide output values
    localparam ONE_16 = 16'h0001;
    localparam ZERO_16 = 16'h0000;

    // 4-to-1 mux for comp_out signal
    assign comp_out = ((comp_cont == CC_ZERO) && zero) ? (ONE_16) : (
                      ((comp_cont == CC_NEG) && negative) ? (ONE_16) : (
                      ((comp_cont == CC_NEG_ZERO) && (negative || zero)) ? (ONE_16) : (
                      ((comp_cont == CC_COUT) && Cout) ? (ONE_16) : (ZERO_16))));

    // datapath for executing SLBI
    

    // datapath for executing BTR

endmodule