/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
module rf (
           // Outputs
           read1data, read2data, err,
           // Inputs
           clk, rst, read1regsel, read2regsel, writeregsel, writedata, write
           );
  parameter DATA_WIDTH = 16;

   input clk, rst;
   input [2:0] read1regsel;
   input [2:0] read2regsel;
   input [2:0] writeregsel;
   input [DATA_WIDTH-1:0] writedata;
   input        write;

   output [DATA_WIDTH-1:0] read1data;
   output [DATA_WIDTH-1:0] read2data;
   output        err;

   // output busses
   wire [DATA_WIDTH-1:0] r0_out;
   wire [DATA_WIDTH-1:0] r1_out;
   wire [DATA_WIDTH-1:0] r2_out;
   wire [DATA_WIDTH-1:0] r3_out;
   wire [DATA_WIDTH-1:0] r4_out;
   wire [DATA_WIDTH-1:0] r5_out;
   wire [DATA_WIDTH-1:0] r6_out;
   wire [DATA_WIDTH-1:0] r7_out;

   // input busses
   wire [DATA_WIDTH-1:0] r0_in;
   wire [DATA_WIDTH-1:0] r1_in;
   wire [DATA_WIDTH-1:0] r2_in;
   wire [DATA_WIDTH-1:0] r3_in;
   wire [DATA_WIDTH-1:0] r4_in;
   wire [DATA_WIDTH-1:0] r5_in;
   wire [DATA_WIDTH-1:0] r6_in;
   wire [DATA_WIDTH-1:0] r7_in;

   // write enables
   wire r0_we;
   wire r1_we;
   wire r2_we;
   wire r3_we;
   wire r4_we;
   wire r5_we;
   wire r6_we;
   wire r7_we;

   assign err = 1'b0;

   // instantiate 8 registers
   register #(DATA_WIDTH) r0(.out(r0_out), .in(r0_in), .wr_en(r0_we), .clk(clk), .rst(rst));
   register #(DATA_WIDTH) r1(.out(r1_out), .in(r1_in), .wr_en(r1_we), .clk(clk), .rst(rst));
   register #(DATA_WIDTH) r2(.out(r2_out), .in(r2_in), .wr_en(r2_we), .clk(clk), .rst(rst));
   register #(DATA_WIDTH) r3(.out(r3_out), .in(r3_in), .wr_en(r3_we), .clk(clk), .rst(rst));
   register #(DATA_WIDTH) r4(.out(r4_out), .in(r4_in), .wr_en(r4_we), .clk(clk), .rst(rst));
   register #(DATA_WIDTH) r5(.out(r5_out), .in(r5_in), .wr_en(r5_we), .clk(clk), .rst(rst));
   register #(DATA_WIDTH) r6(.out(r6_out), .in(r6_in), .wr_en(r6_we), .clk(clk), .rst(rst));
   register #(DATA_WIDTH) r7(.out(r7_out), .in(r7_in), .wr_en(r7_we), .clk(clk), .rst(rst));

   //localparams for reg addresses
   localparam reg_0_addr = 3'b000;
   localparam reg_1_addr = 3'b001;
   localparam reg_2_addr = 3'b010;
   localparam reg_3_addr = 3'b011;
   localparam reg_4_addr = 3'b100;
   localparam reg_5_addr = 3'b101;
   localparam reg_6_addr = 3'b110;
   localparam reg_7_addr = 3'b111;

  // selection of output for read1data
   assign read1data = (read1regsel == reg_0_addr) ? r0_out : (
                      (read1regsel == reg_1_addr) ? r1_out : (
                      (read1regsel == reg_2_addr) ? r2_out : (
                      (read1regsel == reg_3_addr) ? r3_out : ( 
                      (read1regsel == reg_4_addr) ? r4_out : (
                      (read1regsel == reg_5_addr) ? r5_out : (
                      (read1regsel == reg_6_addr) ? r6_out : (  
                      (read1regsel == reg_7_addr) ? r7_out : ( 16'h0000 ))))))));

  // selection of output for read2data
   assign read2data = (read2regsel == reg_0_addr) ? r0_out : (
                      (read2regsel == reg_1_addr) ? r1_out : (
                      (read2regsel == reg_2_addr) ? r2_out : (
                      (read2regsel == reg_3_addr) ? r3_out : ( 
                      (read2regsel == reg_4_addr) ? r4_out : (
                      (read2regsel == reg_5_addr) ? r5_out : (
                      (read2regsel == reg_6_addr) ? r6_out : (  
                      (read2regsel == reg_7_addr) ? r7_out : ( 16'h0000 ))))))));

    assign r0_in = (writeregsel == reg_0_addr) ? writedata : 16'h0000;
    assign r0_we = (writeregsel == reg_0_addr) ? write : 0;

    assign r1_in = (writeregsel == reg_1_addr) ? writedata : 16'h0000;
    assign r1_we = (writeregsel == reg_1_addr) ? write : 0;

    assign r2_in = (writeregsel == reg_2_addr) ? writedata : 16'h0000;
    assign r2_we = (writeregsel == reg_2_addr) ? write : 0;

    assign r3_in = (writeregsel == reg_3_addr) ? writedata : 16'h0000;
    assign r3_we = (writeregsel == reg_3_addr) ? write : 0;

    assign r4_in = (writeregsel == reg_4_addr) ? writedata : 16'h0000;
    assign r4_we = (writeregsel == reg_4_addr) ? write : 0;

    assign r5_in = (writeregsel == reg_5_addr) ? writedata : 16'h0000;
    assign r5_we = (writeregsel == reg_5_addr) ? write : 0;

    assign r6_in = (writeregsel == reg_6_addr) ? writedata : 16'h0000;
    assign r6_we = (writeregsel == reg_6_addr) ? write : 0;

    assign r7_in = (writeregsel == reg_7_addr) ? writedata : 16'h0000;
    assign r7_we = (writeregsel == reg_7_addr) ? write : 0;
   

endmodule
// DUMMY LINE FOR REV CONTROL :1:
