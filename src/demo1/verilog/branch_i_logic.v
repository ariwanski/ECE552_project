module branch_i_logic(Rs, Rs_zero, Rs_n_zero, Rs_lt_zero, Rs_gte_zero);

    input     [15:0] Rs;

    output           Rs_zero;
    output           Rs_n_zero;
    output           Rs_lt_zero;
    output           Rs_gte_zero;

    assign Rs_zero = (Rs == 0) ? (1) : (0);
    assign Rs_n_zero = (Rs !== 0) ? (1) : (0);
    assign Rs_lt_zero = (Rs[15] == 1'b1) ? (1) : (0);
    assign Rs_gte_zero = (Rs[15] == 0 ) ? (1) : (0);

endmodule