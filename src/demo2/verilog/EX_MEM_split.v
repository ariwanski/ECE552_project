module EX_MEM_split(clk, rst, en, createdump_is, write_mem_is, read_mem_is, mem_to_reg_is,reg_w_en_is, w_reg_is, data_2_is,
                    ALU_out_is, createdump_os, write_mem_os, read_mem_os, mem_to_reg_os,reg_w_en_os,w_reg_os, data_2_os, ALU_out_os);

    input            clk;
    input            rst;
    input            en;

    // ** control signals for memory stage
    input            createdump_is;
    input            write_mem_is;
    input            read_mem_is;

    output           createdump_os;
    output           write_mem_os;
    output           read_mem_os;

    // ** control signals for write back stage
    // note: this include the reg_w_en and w_reg signals that goes back to the decode stage
    input            mem_to_reg_is;
    input            reg_w_en_is;
    input      [2:0] w_reg_is;

    output           mem_to_reg_os;
    output           reg_w_en_os;
    output     [2:0] w_reg_os;

    // ** data for memory stage
    input     [15:0] data_2_is;
    input     [15:0] ALU_out_is;

    output    [15:0] data_2_os;
    output    [15:0] ALU_out_os;

    // registers for the memory data
    register #(16) data_2_r(.out(data_2_os), .in(data_2_is), .wr_en(en), .clk(clk), .rst(rst));
    register #(16) ALU_out_r(.out(ALU_out_os), .in(ALU_out_is), .wr_en(en), .clk(clk), .rst(rst));

    // registers for the memory control logic
    register #(1) createdump_r(.out(createdump_os), .in(createdump_is), .wr_en(en), .clk(clk), .rst(rst));
    register #(1) write_mem_r(.out(write_mem_os), .in(write_mem_is), .wr_en(en), .clk(clk), .rst(rst));
    register #(1) read_mem_r(.out(read_mem_os), .in(read_mem_is), .wr_en(en), .clk(clk), .rst(rst));

    // registers for write back control logic
    register #(1) mem_to_reg_r(.out(mem_to_reg_os), .in(mem_to_reg_is), .wr_en(en), .clk(clk), .rst(rst));
    register #(1) reg_w_en_r(.out(reg_w_en_os), .in(reg_w_en_is), .wr_en(en), .clk(clk), .rst(rst));
    register #(3) w_reg_r(.out(w_reg_os), .in(w_reg_is), .wr_en(en), .clk(clk), .rst(rst));
endmodule