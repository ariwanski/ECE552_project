module decode(w_data, instruc, seq_PC, w_reg_cont, se_immed, ze_immed, len_immed, reg_w_en, seq_PC_out, ext_out, data_1, data_2);

    input     [15:0] w_data;
    input     [15:0] instruc;
    input     [15:0] seq_PC;
    input      [1:0] w_reg_cont;
    input            se_immed;
    input            ze_immed;
    input            len_immed;
    input            reg_w_en;

    output    [15:0] seq_PC_out;
    output    [15:0] ext_out;
    output    [15:0] data_1;
    output    [15:0] data_2;

endmodule