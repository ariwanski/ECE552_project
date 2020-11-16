/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
module rf_bypass (
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

   // intermediate read registers
   wire [DATA_WIDTH-1:0] i_read1data;
   wire [DATA_WIDTH-1:0] i_read2data;

   // instantiate the register file 
   rf #(DATA_WIDTH) reg_file(.clk(clk),
                             .rst(rst),
                             .read1regsel(read1regsel),
                             .read2regsel(read2regsel), 
                             .writeregsel(writeregsel), 
                             .writedata(writedata), 
                             .write(write), 
                             .read1data(i_read1data), 
                             .read2data(i_read2data), 
                             .err(err));

   assign read1data = ((read1regsel == writeregsel) && write) ? writedata : i_read1data;
   assign read2data = ((read2regsel == writeregsel) && write) ? writedata : i_read2data;
endmodule
// DUMMY LINE FOR REV CONTROL :1:
