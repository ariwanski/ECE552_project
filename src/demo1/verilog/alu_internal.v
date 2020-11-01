module alu_internal (A, B, Cin, Op, invA, invB, sign, Out, Ofl, Z, Cout, neg);
   
   input [15:0] A;
   input [15:0] B;
   input Cin;
   input [2:0] Op;
   input invA;
   input invB;
   input sign;
   output [15:0] Out;
   output Ofl;
   output Z;
   output Cout; // carry out from addition
   output neg;

   wire [15:0] out_A, out_B; // versions of A and B to be used in datapath
   wire [15:0] out_bs; // output of barrel shifter
   wire [15:0] out_add; // output of adder
   wire [15:0] out_or; // output of logical or operation
   wire [15:0] out_xor; // output of logical xor operation
   wire [15:0] out_and; // output of logical and operation
   wire [15:0] out_logadd; // output of logical and add 4:1 mux
   wire overflow_det; // overflow detection signal

   // simplifies the code for the logic and add 4:1 mux
   localparam ADD = 2'b00;
   localparam OR = 2'b01;
   localparam XOR = 2'b10;
   localparam AND = 2'b11;

   // inversion logic for inputs A and B
   assign out_A = invA ? ~A : A;
   assign out_B = invB ? ~B : B;

   // barrel shifter logic
   shifter barrel_shift (.In(out_A), .Cnt(out_B[3:0]), .Op(Op[1:0]), .Out(out_bs));

   // carry look ahead adder logic
   cla_16 adder (.A(out_A), .B(out_B), .Cin(Cin), .S(out_add), .Cout(Cout));

   // OR operation logic
   assign out_or = out_A | out_B;

   // XOR operation logic
   assign out_xor = out_A ^ out_B;

   // AND operation logic
   assign out_and = out_A & out_B;

   // logical and add 4:1 mux -- uses lower two bits of op code
   assign out_logadd = Op[1:0] == ADD ? (out_add) :
                      (Op[1:0] == OR ? (out_or) :
                      (Op[1:0] == XOR ? (out_xor) : 
                      (out_and))); // Op[1:0] == AND

   // 2:1 for final Out bus
   assign Out = Op[2] ? out_logadd : out_bs ;
   
   // create the zero output signal -- high when Out is zero
   assign Z = (Out == 16'h0000) ? 1'b1 : 1'b0; 

   // create neg output signal -- high when output is negative
   assign neg = ((Out[15] == 1'b1) && sign == 1'b1) ? (1'b1) : (1'b0);

   assign overflow_det = sign ? ((out_add[15] & ~out_A[15] & ~out_B[15]) | (~out_add[15] & out_A[15] & out_B[15])) : (Cout);
   assign Ofl = overflow_det & (Op == 3'b100);

endmodule
