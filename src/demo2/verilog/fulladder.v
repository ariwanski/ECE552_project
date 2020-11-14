module fulladder(A ,B,Cin, S, Cout);

input A, B, Cin;
output S, Cout;

wire A_XOR_B, A_XOR_B_NAND_C, A_XOR_B_AND_C, A_NAND_B, A_AND_B, NOT_Out; 

xor2 XOR_1(.in1(A), .in2(B), .out(A_XOR_B));

xor2 XOR_2(.in1(A_XOR_B), .in2(Cin), .out(S));

nand2 NAND_1(.in1(A_XOR_B), .in2(Cin), .out(A_XOR_B_NAND_C));
not1 NOT_1(.in1(A_XOR_B_NAND_C), .out(A_XOR_B_AND_C));

nand2 NAND_2(.in1(A), .in2(B), .out(A_NAND_B));
not1 NOT_2(.in1(A_NAND_B), .out(A_AND_B));

nor2 NOR_1(.in1(A_AND_B), .in2(A_XOR_B_AND_C), .out(NOT_Out));

not1 NOT_3(.in1(NOT_Out), .out(Cout));

endmodule


