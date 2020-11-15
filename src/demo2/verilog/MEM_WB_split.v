module MEM_WB_split(clk, rst, en, mem_to_reg_is,reg_w_en_is,w_reg_is, ALU_out_is, mem_out_is, mem_to_reg_os,reg_w_en_os,w_reg_os, ALU_out_os, mem_out_os);

    input            clk;
    input            rst;
    input            en;

    // ** control signals for write back stage
    // note: this include the reg_w_en and w_reg signals that goes back to the decode stage
    input            mem_to_reg_is;
    input            reg_w_en_is;
    input      [2:0] w_reg_is;

    output           mem_to_reg_os;
    output           reg_w_en_os;
    output     [2:0] w_reg_os;

    // ** data for write back stage
    input     [15:0] ALU_out_is;
    input     [15:0] mem_out_is;

    output    [15:0] ALU_out_os;
    output    [15:0] mem_out_os;

    // registers for the write back data
    register #(16) ALU_out_r(.out(ALU_out_os), .in(ALU_out_is), .wr_en(en), .clk(clk), .rst(rst));
    register #(16) mem_out_r(.out(mem_out_os), .in(mem_out_is), .wr_en(en), .clk(clk), .rst(rst));

    // registers for write back control logic
    register #(1) mem_to_reg_r(.out(mem_to_reg_os), .in(mem_to_reg_is), .wr_en(en), .clk(clk), .rst(rst));
    register #(1) reg_w_en_r(.out(reg_w_en_os), .in(reg_w_en_is), .wr_en(en), .clk(clk), .rst(rst));
    register #(3) w_reg_r(.out(w_reg_os), .in(w_reg_is), .wr_en(en), .clk(clk), .rst(rst));

endmodule