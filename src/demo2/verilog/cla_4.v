module cla_4(A, B, Cin, Cout, S, G, P);

input [3:0] A, B; // 4-bit input values to add
input Cin;
output [3:0] S; // output sum
output Cout, G, P;

wire g0, g1, g2, g3, p0, p1, p2, p3; // generate and propogate wires
wire c1, c2, c3; // carry wires

fulladder FA_0(.A(A[0]), .B(B[0]), .Cin(Cin), .S(S[0]), .Cout());
fulladder FA_1(.A(A[1]), .B(B[1]), .Cin(c1), .S(S[1]), .Cout());
fulladder FA_2(.A(A[2]), .B(B[2]), .Cin(c2), .S(S[2]), .Cout());
fulladder FA_3(.A(A[3]), .B(B[3]), .Cin(c3), .S(S[3]), .Cout());

assign g0 = A[0] & B[0];
assign p0 = A[0] | B[0];

assign c1 = g0 | (p0 & Cin);
assign g1 = A[1] & B[1];
assign p1 = A[1] | B[1];

assign c2 = g1 | (p1 & c1);
assign g2 = A[2] & B[2];
assign p2 = A[2] | B[2];

assign c3 = g2 | (p2 & c2);
assign g3 = A[3] & B[3];
assign p3 = A[3] | B[3];

assign Cout = g3 | (p3 & c3);

assign G = g3 | (p3 & g2) | (p3 & p2 & g1) | (p3 & p2 & p1 & g0);
assign P = p3 & p2 & p1 & p0;

endmodule