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

    wire      [15:0] input_B;
    wire      [15:0] input_A;
    wire      [15:0] internal_alu_out;
    wire       [2:0] internal_alu_op;

    wire      [15:0] SLBI_out;
    wire      [15:0] BTR_out;

    wire             seq_cond; // condition that must be met for seq
    wire             slt_cond; // condition that must be met for slt
    wire             sle_cond; // condition that must be met for sle

    // localparams for comp_cont values
    localparam CC_SEQ = 2'b00;
    localparam CC_SLT = 2'b01;
    localparam CC_SLE = 2'b10;
    localparam CC_SCO = 2'b11;

    // 16bit wide output values
    localparam ONE_16 = 16'h0001;
    localparam ZERO_16 = 16'h0000;

    // 2-to-1 mux on B input of internal ALU
    assign input_B = (ex_SLBI) ? (16'h0008) : (B);
    
    // 2-to-1 mux on Op input of internal ALU
    assign internal_alu_op = (ex_SLBI) ? (3'b001) : (Op);

    // instantiate internal alu 
    alu_internal alu(.A(A),
                     .B(input_B),
                     .Cin(Cin),
                     .Op(internal_alu_op),
                     .invA(invA),
                     .invB(invB),
                     .sign(sign),
                     .Out(internal_alu_out),
                     .Ofl(Ofl),
                     .Z(zero),
                     .Cout(Cout),
                     .neg(negative));

    assign seq_cond = zero && ~Ofl;
    assign slt_cond = (A[15] == B[15]) ? (negative) : ( // same MSB - safe to use subtraction
                      (A[15] == 1'b1) ? (1'b1) : (1'b0)); // one with MSB = 1 is smaller
    assign sle_cond = (A[15] == B[15]) ? (negative || zero) : ( // same MSB - safe to use subtraction
                      (A[15] == 1'b1) ? (1'b1) : (1'b0));

    // 4-to-1 mux for comp_out signal
    assign comp_out = ((comp_cont == CC_SEQ) && seq_cond) ? (ONE_16) : ( // SEQ
                      ((comp_cont == CC_SLT) && slt_cond) ? (ONE_16) : ( //SLT
                      ((comp_cont == CC_SLE) && sle_cond) ? (ONE_16) : ( // SLE
                      ((comp_cont == CC_SCO) && Cout) ? (ONE_16) : (ZERO_16)))); //SCO

    // datapath for executing SLBI
    assign SLBI_out = internal_alu_out | B;

    // datapath for executing BTR
    assign BTR_out[0] = A[15];
    assign BTR_out[1] = A[14];
    assign BTR_out[2] = A[13];
    assign BTR_out[3] = A[12];
    assign BTR_out[4] = A[11];
    assign BTR_out[5] = A[10];
    assign BTR_out[6] = A[9];
    assign BTR_out[7] = A[8];
    assign BTR_out[8] = A[7];
    assign BTR_out[9] = A[6];
    assign BTR_out[10] = A[5];
    assign BTR_out[11] = A[4];
    assign BTR_out[12] = A[3];
    assign BTR_out[13] = A[2];
    assign BTR_out[14] = A[1];
    assign BTR_out[15] = A[0];

    // 5-to-1 mux of final output
    assign ALU_out = (ex_BTR) ? (BTR_out) : (
                     (ex_SLBI) ? (SLBI_out) : (
                     (comp) ? (comp_out) : (
                     (pass) ? (B) : (internal_alu_out)))); // default -- take output from internal alu

endmodule