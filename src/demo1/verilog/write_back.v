module write_back(ALU_out, mem_out, mem_to_reg, w_data);

    input     [15:0] ALU_out;
    input     [15:0] mem_out;
    input            mem_to_reg;

    output    [15:0] w_data;

endmodule