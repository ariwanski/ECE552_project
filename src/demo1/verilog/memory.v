module memory(data_2, ALU_out, createdump, write_mem, read_mem, ALU_out_out, mem_out);

    input     [15:0] data_2;
    input     [15:0] ALU_out;
    input            createdump;
    input            write_mem;
    input            read_mem;

    output    [15:0] ALU_out_out;
    output    [15:0] mem_out;

endmodule