module hazard_detect(w_reg_ex, reg_w_en_ex, w_reg_mem, reg_w_en_mem, read_reg_1, read_reg_2, branch_I, branch_J, stall);
    
    input      [2:0] w_reg_ex;
    input      [2:0] w_reg_mem;
    input            reg_w_en_ex;
    input            reg_w_en_mem;
    input      [2:0] read_reg_1;
    input      [2:0] read_reg_2;
    input            branch_I;
    input            branch_J;

    output           stall;

    wire             data_hazard; // data hazard detected
    wire             data_hazard_rr1; // data hazard due to the read register 1 address
    wire             data_hazard_rr2; // data hazard due to the read register 2 address

    wire             branch_hazard; // branch hazard detected

    assign data_hazard_rr1 = ((w_reg_ex == read_reg_1) && reg_w_en_ex) || ((w_reg_mem == read_reg_1) && reg_w_en_mem);
    assign data_hazard_rr2 = ((w_reg_ex == read_reg_2) && reg_w_en_ex) || ((w_reg_mem == read_reg_2) && reg_w_en_mem);
    assign data_hazard = data_hazard_rr1 || data_hazard_rr2;

    assign branch_hazard = branch_I || branch_J;

    assign stall = data_hazard && branch_hazard;
endmodule