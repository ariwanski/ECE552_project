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
   wire      [15:0] instruc_fd_is;
   wire      [15:0] instruc_fd_os;

   // signals used in the fetch stage
   wire             en_PC;

   // control signals used right away in the decode stage
   wire       [1:0] w_reg_cont;
   wire             ext_type;
   wire       [1:0] len_immed;

   // control signals used by the execute stage
   wire             choose_branch_de_is; 
   wire             immed_de_is;
   wire             update_R7_de_is;
   wire             subtract_de_is;
   wire       [2:0] ALU_op_de_is;
   wire             invA_de_is;
   wire             invB_de_is;
   wire             sign_de_is;
   wire             ex_BTR_de_is;
   wire             ex_SLBI_de_is;
   wire       [1:0] comp_cont_de_is;
   wire             comp_de_is;
   wire             pass_de_is;
   wire       [1:0] branch_cont_de_is;
   wire             branch_J_de_is;
   wire             branch_I_de_is;

   wire             choose_branch_de_os; 
   wire             immed_de_os;
   wire             update_R7_de_os;
   wire             subtract_de_os;
   wire       [2:0] ALU_op_de_os;
   wire             invA_de_os;
   wire             invB_de_os;
   wire             sign_de_os;
   wire             ex_BTR_de_os;
   wire             ex_SLBI_de_os;
   wire       [1:0] comp_cont_de_os;
   wire             comp_de_os;
   wire             pass_de_os;
   wire       [1:0] branch_cont_de_os;
   wire             branch_J_de_os;
   wire             branch_I_de_os;

   // control signals used by the memory stage
   wire             createdump_de_is;
   wire             write_mem_de_is;
   wire             read_mem_de_is;

   wire             createdump_de_os;
   wire             write_mem_de_os;
   wire             read_mem_de_os;

   wire             createdump_em_os;
   wire             write_mem_em_os;
   wire             read_mem_em_os;

   // control signals used by the write back stage
   wire             mem_to_reg_de_is;
   wire             mem_to_reg_de_os;

   wire             mem_to_reg_em_os;

   wire             mem_to_reg_mw_os;

   // control signals used in decode after write back
   wire             reg_w_en_de_is;
   wire       [2:0] w_reg_de_is;

   wire             reg_w_en_de_os;
   wire       [2:0] w_reg_de_os;

   wire             reg_w_en_em_os;
   wire       [2:0] w_reg_em_os;

   wire             reg_w_en_mw_os;
   wire       [2:0] w_reg_mw_os;

   // wires needed for fetch
   wire      [15:0] branch_PC;
   wire             branch;

   wire      [15:0] seq_PC_1_fd_is; // seq_PC from fetch to decode
   wire      [15:0] seq_PC_1_fd_os; // seq_PC from fetch to decode

   // wires needed for decode
   wire      [15:0] seq_PC_2_de_is; // seq_PC from decode to execute
   wire      [15:0] seq_PC_2_de_os; // seq_PC from decode to execute
   wire      [15:0] ext_out_de_is;
   wire      [15:0] ext_out_de_os;
   wire      [15:0] data_1_de_is;
   wire      [15:0] data_1_de_os;
   wire      [15:0] data_2_1_de_is; // data_2 from decode to execute
   wire      [15:0] data_2_1_de_os; // data_2 from decode to execute

   // wires needed for execute
   wire      [15:0] data_2_2_em_is; // data_2 from execute to memory
   wire      [15:0] data_2_2_em_os; // data_2 from execute to memory
   wire      [15:0] ALU_out_1_em_is; // ALU_out from execute to memory
   wire      [15:0] ALU_out_1_em_os; // ALU_out from execute to memory

   // wires needed for memory
   wire      [15:0] ALU_out_2_mw_is; // ALU_out from memory to write back
   wire      [15:0] ALU_out_2_mw_os; // ALU_out from memory to write back
   wire      [15:0] mem_out_mw_is;
   wire      [15:0] mem_out_mw_os;

   // wires needed for write back
   wire      [15:0] w_data;

   // enable signals for pipeline registers
   wire             en_IF_ID;
   wire             en_ID_EX;
   wire             en_EX_MEM;
   wire             en_MEM_WB;

   // wires for hazard detection and stalling
   wire             stall;

   // assign the pipeline register enable signals to 1 for now
   assign en_IF_ID = 1'b1;
   assign en_ID_EX = 1'b1;
   assign en_EX_MEM = 1'b1;
   assign en_MEM_WB = 1'b1;

   // instantiate fetch
   fetch fetch(.en_PC(en_PC),
               .branch(branch),
               .branch_PC(branch_PC),
               .instruc(instruc_fd_is),
               .seq_PC(seq_PC_1_fd_is),
               .clk(clk),
               .rst(rst));

   // instantiate the pipeline registers between fetch and decode (control is in decode)
   IF_ID_split IF_ID_split(.clk(clk),
                           .rst(rst),
                           .en(en_IF_ID),
                           .instruc_is(instruc_fd_is),
                           .seq_PC_is(seq_PC_1_fd_is),
                           .instruc_os(instruc_fd_os),
                           .seq_PC_os(seq_PC_1_fd_os)); 

   // instantiate hazard dectection logic
   hazard_detect hazard_detect(.w_reg_ex(w_reg_de_os),
                               .w_reg_mem(w_reg_em_os),
                               .reg_w_en_ex(reg_w_en_de_os),
                               .reg_w_en_mem(reg_w_en_em_os),
                               .read_reg_1(instruc_fd_os[10:8]),
                               .read_reg_2(instruc_fd_os[7:5]),
                               .branch_I(branch_I_de_is),
                               .branch_J(branch_J_de_is),
                               .stall(stall));        

   // instantiate control 
   control control(.instruc(instruc_fd_os),
                   .en_PC(en_PC), // used in fetch
                   .w_reg_cont(w_reg_cont), // used right away in decode
                   .ext_type(ext_type), // used right away in decode
                   .len_immed(len_immed), // used right away in decode
                   .reg_w_en(reg_w_en_de_is),
                   .choose_branch(choose_branch_de_is),
                   .immed(immed_de_is),
                   .update_R7(update_R7_de_is),
                   .subtract(subtract_de_is),
                   .ALU_op(ALU_op_de_is),
                   .invA(invA_de_is),
                   .invB(invB_de_is),
                   .sign(sign_de_is),
                   .ex_BTR(ex_BTR_de_is),
                   .ex_SLBI(ex_SLBI_de_is),
                   .comp_cont(comp_cont_de_is),
                   .comp(comp_de_is),
                   .pass(pass_de_is),
                   .branch_cont(branch_cont_de_is),
                   .branch_J(branch_J_de_is),
                   .branch_I(branch_I_de_is),
                   .createdump(createdump_de_is),
                   .write_mem(write_mem_de_is),
                   .read_mem(read_mem_de_is),
                   .mem_to_reg(mem_to_reg_de_is));

   // instantiate decode
   decode decode(.w_data(w_data), // input from the write back stage
                 .instruc(instruc_fd_os),
                 .seq_PC(seq_PC_1_fd_os),
                 .w_reg_cont(w_reg_cont), // from the control unit -- used right away
                 .ext_type(ext_type), // from the control unit -- used right away
                 .len_immed(len_immed), // from the control unit -- used right away
                 .reg_w_en(reg_w_en_mw_os), // input from the write back split register
                 .w_reg_use(w_reg_mw_os), // input from the write back split register
                 .seq_PC_out(seq_PC_2_de_is),
                 .ext_out(ext_out_de_is),
                 .data_1(data_1_de_is),
                 .data_2(data_2_1_de_is),
                 .w_reg_pipe(w_reg_de_is), // register write address to be pipelined
                 .clk(clk),
                 .rst(rst));

   // instantiate the pipeline registers between decode and execute
   ID_EX_split ID_EX_split(.clk(clk),
                           .rst(rst),
                           .en(en_ID_EX),
                           .choose_branch_is(choose_branch_de_is),
                           .immed_is(immed_de_is),
                           .update_R7_is(update_R7_de_is),
                           .subtract_is(subtract_de_is),
                           .ALU_op_is(ALU_op_de_is),
                           .invA_is(invA_de_is),
                           .invB_is(invB_de_is),
                           .sign_is(sign_de_is),
                           .ex_BTR_is(ex_BTR_de_is),
                           .ex_SLBI_is(ex_SLBI_de_is),
                           .comp_cont_is(comp_cont_de_is),
                           .comp_is(comp_de_is),
                           .pass_is(pass_de_is),
                           .branch_cont_is(branch_cont_de_is),
                           .branch_J_is(branch_J_de_is),
                           .branch_I_is(branch_I_de_is),
                           .createdump_is(createdump_de_is),
                           .write_mem_is(write_mem_de_is),
                           .read_mem_is(read_mem_de_is),
                           .mem_to_reg_is(mem_to_reg_de_is),
                           .reg_w_en_is(reg_w_en_de_is),
                           .w_reg_is(w_reg_de_is),
                           .ext_out_is(ext_out_de_is),
                           .seq_PC_is(seq_PC_2_de_is),
                           .data_1_is(data_1_de_is),
                           .data_2_is(data_2_1_de_is),
                           .choose_branch_os(choose_branch_de_os),
                           .immed_os(immed_de_os),
                           .update_R7_os(update_R7_de_os),
                           .subtract_os(subtract_de_os),
                           .ALU_op_os(ALU_op_de_os),
                           .invA_os(invA_de_os),
                           .invB_os(invB_de_os),
                           .sign_os(sign_de_os),
                           .ex_BTR_os(ex_BTR_de_os),
                           .ex_SLBI_os(ex_SLBI_de_os),
                           .comp_cont_os(comp_cont_de_os),
                           .comp_os(comp_de_os),
                           .pass_os(pass_de_os),
                           .branch_cont_os(branch_cont_de_os),
                           .branch_J_os(branch_J_de_os),
                           .branch_I_os(branch_I_de_os),
                           .createdump_os(createdump_de_os),
                           .write_mem_os(write_mem_de_os),
                           .read_mem_os(read_mem_de_os),
                           .mem_to_reg_os(mem_to_reg_de_os),
                           .reg_w_en_os(reg_w_en_de_os),
                           .w_reg_os(w_reg_de_os),
                           .ext_out_os(ext_out_de_os),
                           .seq_PC_os(seq_PC_2_de_os),
                           .data_1_os(data_1_de_os),
                           .data_2_os(data_2_1_de_os));

   // instantiate execute
   execute execute(.ext_out(ext_out_de_os),
                   .seq_PC(seq_PC_2_de_os),
                   .data_1(data_1_de_os),
                   .data_2(data_2_1_de_os),
                   .choose_branch(choose_branch_de_os),
                   .immed(immed_de_os),
                   .update_R7(update_R7_de_os),
                   .subtract(subtract_de_os),
                   .ALU_op(ALU_op_de_os),
                   .invA(invA_de_os),
                   .invB(invB_de_os),
                   .sign(sign_de_os),
                   .ex_BTR(ex_BTR_de_os),
                   .ex_SLBI(ex_SLBI_de_os),
                   .comp_cont(comp_cont_de_os),
                   .comp(comp_de_os),
                   .pass(pass_de_os),
                   .branch_cont(branch_cont_de_os),
                   .branch_J(branch_J_de_os),
                   .branch_I(branch_I_de_os),
                   .data_2_out(data_2_2_em_is),
                   .ALU_out(ALU_out_1_em_is),
                   .branch(branch), // feeds into fetch
                   .branch_PC(branch_PC)); // feeds into fetch

   // instantiate the pipeline registers between execute and memory
   EX_MEM_split EX_MEM_split(.clk(clk),
                             .rst(rst),
                             .en(en_EX_MEM),
                             .createdump_is(createdump_de_os),
                             .write_mem_is(write_mem_de_os),
                             .read_mem_is(read_mem_de_os),
                             .mem_to_reg_is(mem_to_reg_de_os),
                             .reg_w_en_is(reg_w_en_de_os),
                             .w_reg_is(w_reg_de_os),
                             .data_2_is(data_2_2_em_is),
                             .ALU_out_is(ALU_out_1_em_is),
                             .createdump_os(createdump_em_os),
                             .write_mem_os(write_mem_em_os),
                             .read_mem_os(read_mem_em_os),
                             .mem_to_reg_os(mem_to_reg_em_os),
                             .reg_w_en_os(reg_w_en_em_os),
                             .w_reg_os(w_reg_em_os),
                             .data_2_os(data_2_2_em_os),
                             .ALU_out_os(ALU_out_1_em_os));

   // instantiate memory
   memory memory(.data_2(data_2_2_em_os),
                 .ALU_out(ALU_out_1_em_os),
                 .createdump(createdump_em_os),
                 .write_mem(write_mem_em_os),
                 .read_mem(read_mem_em_os),
                 .ALU_out_out(ALU_out_2_mw_is),
                 .mem_out(mem_out_mw_is),
                 .clk(clk),
                 .rst(rst));

   // instantiate the pipeline registers between memory and write back
   MEM_WB_split MEM_WB_split(.clk(clk),
                             .rst(rst),
                             .en(en_MEM_WB),
                             .mem_to_reg_is(mem_to_reg_em_os),
                             .reg_w_en_is(reg_w_en_em_os),
                             .w_reg_is(w_reg_em_os),
                             .ALU_out_is(ALU_out_2_mw_is),
                             .mem_out_is(mem_out_mw_is),
                             .mem_to_reg_os(mem_to_reg_mw_os),
                             .reg_w_en_os(reg_w_en_mw_os), // fed into decode stage
                             .w_reg_os(w_reg_mw_os), // fed into decode stage
                             .ALU_out_os(ALU_out_2_mw_os),
                             .mem_out_os(mem_out_mw_os));

   // instantiate write back
   write_back write_back(.ALU_out(ALU_out_2_mw_os),
                         .mem_out(mem_out_mw_os),
                         .mem_to_reg(mem_to_reg_mw_os),
                         .w_data(w_data)); // fed into decode

   
endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:
