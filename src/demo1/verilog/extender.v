module extender(in_11_bit, in_8_bit, in_5_bit, ext_type, length_in, ext_out);

    input     [10:0] in_11_bit;
    input      [7:0] in_8_bit;
    input      [4:0] in_5_bit;
    input            ext_type; // if ext_type = 1 -> se otherwise ze
    input      [1:0] length_in;

    output    [15:0] ext_out;

    localparam LEN_5 = 2'b00;
    localparam LEN_8 = 2'b01;
    localparam LEN_11 = 2'b10;

    assign ext_out = (ext_type == 1'b1) ? ( // sign extend 
                         (length_in == LEN_5) ? ({{11{in_5_bit[4]}},in_5_bit}) : (
                         (length_in == LEN_8) ? ({{8{in_8_bit[7]}},in_8_bit}) : (
                         ({{5{in_11_bit[10]}},in_11_bit}))) // length_in == LEN_11
                   : ( // zero extend
                         (length_in == LEN_5) ? ({{11{1'b0}},in_5_bit}) : (
                         (length_in == LEN_8) ? ({{8{1'b0}},in_8_bit}) : (
                         ({{5{1'b0}},in_11_bit})))) // length_in == LEN_11
                   );

endmodule