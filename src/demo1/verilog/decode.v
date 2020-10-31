module decode(w_data, instruc, seq_PC, w_reg_cont, ext_type, len_immed, reg_w_en, seq_PC_out, ext_out, data_1, data_2);

    input     [15:0] w_data;
    input     [15:0] instruc;
    input     [15:0] seq_PC;
    input      [1:0] w_reg_cont;
    input            ext_type;
    input      [1:0] len_immed;
    input            reg_w_en;

    output    [15:0] seq_PC_out;
    output    [15:0] ext_out;
    output    [15:0] data_1;
    output    [15:0] data_2;

    wire       [2:0] w_reg; // register address to write to

    // instantiate extender block
    extender extend(.in_11_bit(instruc[10:0]),
                    .in_8_bit(instruc[7:0]),
                    .in_5_bit(instruc[4:0]),
                    .length_in(len_immed),
                    .ext_type(ext_type),
                    .ext_out(ext_out));

    // instantiate register file

    // 4-to-1 mux on Write Register
    assign w_reg = (w_reg_cont == 2'b00) ? (instruc[7:5]) : (
                   (w_reg_cont == 2'b01) ? (instruc[4:2]) : (
                   (w_reg_cont == 2'b10) ? (instruc[10:8]) :(
                    3'b111))); // w_reg_cont == 2'b11

endmodule