module memory(data_2, ALU_out, createdump, write_mem, read_mem, ALU_out_out, mem_out, clk, rst);

    input     [15:0] data_2;
    input     [15:0] ALU_out;
    input            createdump;
    input            write_mem;
    input            read_mem;

    output    [15:0] ALU_out_out;
    output    [15:0] mem_out;

    // inputs to memory2c
    wire             enable;
    wire             wr;

    // create enable and wr from read_mem and write_mem
    assign enable = (read_mem == 1'b0 && write_mem == 1'b0) ? (1'b0) : (1'b1);
    assign wr = (read_mem == 1'b1) ? (1'b0) : (
                (write_mem == 1'b1) ? (1'b1) : (1'b0));

    // instantite data memory
    memory2c data_mem(.data_out(mem_out),
                      .data_in(data_2),
                      .addr(ALU_out),
                      .enable(enable), 
                      .wr(wr),
                      .createdump(createdump),
                      .clk(clk),
                      .rst(rst));

    // pass through ALU_out
    assign ALU_out_out = ALU_out;

endmodule