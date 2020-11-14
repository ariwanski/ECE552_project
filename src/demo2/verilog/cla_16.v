module cla_16(A,B,Cin,S,Cout);

input [15:0] A, B; // 16-bit input values to add
input Cin;
output [15:0] S; // output sum
output Cout;

wire G0_3, G4_7, G8_11, G12_15, P0_3, P4_7, P8_11, P12_15; // original generate and propogate wires
wire G8_15, G0_7, P8_15, P0_7; // secondary generate and propogate wires
wire G0_15, P0_15; // final generate and propogate wires
wire c4, c8, c12; // carry wires

cla_4 CLA_0(.A(A[3:0]), .B(B[3:0]), .Cin(Cin), .S(S[3:0]), .Cout(), .G(G0_3), .P(P0_3));
cla_4 CLA_1(.A(A[7:4]), .B(B[7:4]), .Cin(c4), .S(S[7:4]), .Cout(), .G(G4_7), .P(P4_7));
cla_4 CLA_2(.A(A[11:8]), .B(B[11:8]), .Cin(c8), .S(S[11:8]), .Cout(), .G(G8_11), .P(P8_11));
cla_4 CLA_3(.A(A[15:12]), .B(B[15:12]), .Cin(c12), .S(S[15:12]), .Cout(), .G(G12_15), .P(P12_15));

// Compute G's and P's
assign G8_15 = G12_15 | (P12_15 & G8_11);
assign P8_15 = P8_11 & P12_15;

assign G0_7 = G4_7 | (P4_7 & G0_3);
assign P0_7 = P0_3 & P4_7;

assign G0_15 = G8_15 | (P8_15 & G0_7);
assign P0_15 = P0_7 & P8_15;

// Copmute carries
assign c4 = G0_3 | (P0_3 & Cin);
assign c8 = G4_7 | (P4_7 & c4);
assign c12 = G8_11 | (P8_11 & c8);
assign Cout = G12_15 | (P12_15 & c12);

endmodule