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

endmodule