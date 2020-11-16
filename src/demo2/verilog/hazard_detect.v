module hazard_detect(w_reg_ex, reg_w_en_ex, w_reg_mem, reg_w_en_mem, read_reg_1, read_reg_2, branch_I, branch_J, data_haz_s1, data_haz_s2, branch_haz);
    
    input      [2:0] w_reg_ex;
    input      [2:0] w_reg_mem;
    input            reg_w_en_ex;
    input            reg_w_en_mem;
    input      [2:0] read_reg_1;
    input      [2:0] read_reg_2;
    input            branch_I;
    input            branch_J;

    output           data_haz_s1;
    output           data_haz_s2;
    output           branch_haz;

    assign data_haz_s1 = ((w_reg_mem == read_reg_2) && reg_w_en_mem) || ((w_reg_mem == read_reg_1) && reg_w_en_mem);
    assign data_haz_s2 = ((w_reg_ex == read_reg_2) && reg_w_en_ex) || ((w_reg_ex == read_reg_1) && reg_w_en_ex);
    assign branch_haz = branch_I || branch_J;

endmodule