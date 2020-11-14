/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
module proc (/*AUTOARG*/
   // Outputs
   err, 
   // Inputs
   clk, rst
   );

   input clk;
   input rst;

   output err;

   // None of the above lines can be modified

   // OR all the err ouputs for every sub-module and assign it as this
   // err output
   
   // As desribed in the homeworks, use the err signal to trap corner
   // cases that you think are illegal in your statemachines
   
   
   /* your code here */

   // wires needed for control
   wire      [15:0] instruc;

   wire             en_PC;
   wire       [1:0] w_reg_cont;
   wire             ext_type;
   wire       [1:0] len_immed;
   wire             reg_w_en;
   wire             choose_branch; 
   wire             immed;
   wire             update_R7;
   wire             subtract;
   wire       [2:0] ALU_op;
   wire             invA;
   wire             invB;
   wire             sign;
   wire             ex_BTR;
   wire             ex_SLBI;
   wire       [1:0] comp_cont;
   wire             comp;
   wire             pass;
   wire       [1:0] branch_cont;
   wire             branch_J;
   wire             branch_I;
   wire             createdump;
   wire             write_mem;
   wire             read_mem;
   wire             mem_to_reg;

   // wires needed for fetch
   wire      [15:0] branch_PC;
   wire             branch;

   wire      [15:0] seq_PC_1; // seq_PC from fetch to decode

   // wires needed for decode
   wire      [15:0] w_data;

   wire      [15:0] seq_PC_2; // seq_PC from decode to execute
   wire      [15:0] ext_out;
   wire      [15:0] data_1;
   wire      [15:0] data_2_1; // data_2 from decode to execute

   // wires needed for execute
   wire      [15:0] data_2_2; // data_2 from execute to memory
   wire      [15:0] ALU_out_1; // ALU_out from execute to memory

   // wires needed for memory
   wire      [15:0] ALU_out_2; // ALU_out from memory to write back
   wire      [15:0] mem_out;

   // instantiate control 
   control control(.instruc(instruc),
                   .en_PC(en_PC),
                   .w_reg_cont(w_reg_cont),
                   .ext_type(ext_type),
                   .len_immed(len_immed),
                   .reg_w_en(reg_w_en),
                   .choose_branch(choose_branch),
                   .immed(immed),
                   .update_R7(update_R7),
                   .subtract(subtract),
                   .ALU_op(ALU_op),
                   .invA(invA),
                   .invB(invB),
                   .sign(sign),
                   .ex_BTR(ex_BTR),
                   .ex_SLBI(ex_SLBI),
                   .comp_cont(comp_cont),
                   .comp(comp),
                   .pass(pass),
                   .branch_cont(branch_cont),
                   .branch_J(branch_J),
                   .branch_I(branch_I),
                   .createdump(createdump),
                   .write_mem(write_mem),
                   .read_mem(read_mem),
                   .mem_to_reg(mem_to_reg));


   // instantiate fetch
   fetch fetch(.en_PC(en_PC),
               .branch(branch),
               .branch_PC(branch_PC),
               .instruc(instruc),
               .seq_PC(seq_PC_1),
               .clk(clk),
               .rst(rst));

   // instantiate decode
   decode decode(.w_data(w_data),
                 .instruc(instruc),
                 .seq_PC(seq_PC_1),
                 .w_reg_cont(w_reg_cont),
                 .ext_type(ext_type),
                 .len_immed(len_immed),
                 .reg_w_en(reg_w_en),
                 .seq_PC_out(seq_PC_2),
                 .ext_out(ext_out),
                 .data_1(data_1),
                 .data_2(data_2_1),
                 .clk(clk),
                 .rst(rst));

   // instantiate execute
   execute execute(.ext_out(ext_out),
                   .seq_PC(seq_PC_2),
                   .data_1(data_1),
                   .data_2(data_2_1),
                   .choose_branch(choose_branch),
                   .immed(immed),
                   .update_R7(update_R7),
                   .subtract(subtract),
                   .ALU_op(ALU_op),
                   .invA(invA),
                   .invB(invB),
                   .sign(sign),
                   .ex_BTR(ex_BTR),
                   .ex_SLBI(ex_SLBI),
                   .comp_cont(comp_cont),
                   .comp(comp),
                   .pass(pass),
                   .branch_cont(branch_cont),
                   .branch_J(branch_J),
                   .branch_I(branch_I),
                   .data_2_out(data_2_2),
                   .ALU_out(ALU_out_1),
                   .branch(branch),
                   .branch_PC(branch_PC));

   // instantiate memory
   memory memory(.data_2(data_2_2),
                 .ALU_out(ALU_out_1),
                 .createdump(createdump),
                 .write_mem(write_mem),
                 .read_mem(read_mem),
                 .ALU_out_out(ALU_out_2),
                 .mem_out(mem_out),
                 .clk(clk),
                 .rst(rst));

   // instantiate write back
   write_back write_back(.ALU_out(ALU_out_2),
                         .mem_out(mem_out),
                         .mem_to_reg(mem_to_reg),
                         .w_data(w_data));

   
endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:
