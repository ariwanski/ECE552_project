module control(instruc, en_PC, w_reg_cont, ext_type, len_immed, reg_w_en, choose_branch, immed, update_R7, subtract, ALU_op, invA, invB, sign, ex_BTR, ex_SLBI, comp_cont, comp, pass, branch_cont, branch_J, createdump, write_mem, read_mem, mem_to_reg);

    input     [15:0] instruc;

    output           en_PC;
    output     [1:0] w_reg_cont;
    output           ext_type;
    output     [1:0] len_immed;
    output           reg_w_en;
    output           choose_branch; 
    output           immed;
    output           update_R7;
    output           subtract;
    output     [2:0] ALU_op;
    output           invA;
    output           invB;
    output           sign;
    output           ex_BTR;
    output           ex_SLBI;
    output     [1:0] comp_cont;
    output           comp;
    output           pass;
    output     [1:0] branch_cont;
    output           branch_J;
    output           createdump;
    output           write_mem;
    output           read_mem;
    output           mem_to_reg;

    wire op_code = instruc[15:11]; // get the op_code from instruc
    wire func_code = instruc[1:0]; // get the func_code from instruc -- used for a few instructions

    always@(*)begin
        // assign default outputs
        en_PC = 1'b1;
        reg_w_en = 1'b1;
        w_reg_cont = 2'b00;
        ext_type = 1'b0;
        len_immed = 2'b-0;
        choose_branch = 1'b0;
        immed = 1'b0;
        update_R7 = 1'b0;
        subtract = 1'b0;
        ALU_op = 3'b000;
        invA = 1'b0;
        invB = 1'b0;
        sign = 1'b0;
        ex_BTR = 1'b0;
        ex_SLBI = 1'b0;
        comp_cont = 2'b00;
        comp = 1'b0;
        branch_cont = 2'b00;
        branch_J = 1'b0;
        createdump = 1'b0;
        write_mem = 1'b0;
        read_mem = 1'b0;
        mem_to_reg = 1'b0;

        casex(op_code)
            5'b0000:begin
                en_PC = 1'b0;
                createdump = 1'b1;
                reg_w_en = 1'b0;
            end
            5'b00001:begin
                reg_w_en = 1'b0;
            end
            5'b01000:begin
                ext_type = 1'b1;
                immed = 1'b1;
                ALU_op = 3'b100;
                sign = 1'b1;
            end
            5'b01001:begin
                ext_type = 1'b1;
                immed = 1'b1;
                subtract = 1'b1;
                ALU_op = 1'b100;
                invA = 1'b1;
                sign = 1'b1;
            end
            5'b01010:begin
                immed = 1'b1;
                ALU_op = 3'b110;
            end
            5'b01011:begin
                immed = 1'b1;
                ALU_op = 1'b111;
                invB = 1'b1;
            end
            5'b10100:begin
                immed = 1'b1;
                ALU_op = 3'b000;
            end
            5'b10101:begin
                immed = 1'b1;
                ALU_op = 3'b001;
            end
            5'b10110:begin
                immed = 1'b1;
                ALU_op = 3'b010;
            end
            5'b10111:begin
                immed = 1'b1;
                ALU_op = 3'b011;
            end
            5'b10000:begin
                ext_type = 1'b1;
                immed = 1'b1;
                ALU_op = 3'b100;
                reg_w_en = 1'b0;
                write_mem = 1'b1;
                sign = 1'b1;
            end
            5'b10001:begin
                ext_type = 1'b1;
                immed = 1'b1;
                ALU_op = 3'b100;
                sign = 1'b1;
                read_mem = 1'b1;
                mem_to_reg = 1'b1;
            end
            5'b10011:begin
                ext_type = 1'b1;
                immed = 1'b1;
                ALU_op = 3'b100;
                sign = 1'b1;
                write_mem = 1'b1;
                w_reg_cont = 2'b10;
            end
            5'b11001:begin
                w_reg_cont = 2'b01;
                ex_BTR = 1'b1;
            end
            5'b11011:begin // includes 4 instructions
                w_reg_cont = 2'b01;
                case(func_code)
                    2'b00:begin // ADD
                        ALU_op = 3'b100;
                    end
                    2'b01:begin // SUB
                        ALU_op = 3'b100;
                        subtract = 1'b1;
                        invA = 1'b1;
                        sign = 1'b1;
                    end
                    2'b10:begin // XOR
                        ALU_op = 3'b110;
                    end
                    2'b11:begin // ANDN
                        ALU_op = 3'b111;
                        invB = 1'b1;
                    end
                endcase
            end
            5'b11010:begin // includes 4 instructions
                w_reg_cont = 2'b01;
                ALU_op = {1'b0, func_code};
            end
            5'b11100:begin
                w_reg_cont = 2'b01;
                ALU_op = 3'b100;
                subtract = 1;
                invB = 1'b1;
                sign = 1'b1;
                comp = 1'b1;
                comp_cont = 2'b00;
            end
            5'b11101:begin
                w_reg_cont = 2'b01;
                ALU_op = 3'b100;
                subtract = 1;
                invB = 1'b1;
                sign = 1'b1;
                comp = 1'b1;
                comp_cont = 2'b01;
            end
            5'b11110:begin
                w_reg_cont = 2'b01;
                ALU_op = 3'b100;
                subtract = 1;
                invB = 1'b1;
                sign = 1'b1;
                comp = 1'b1;
                comp_cont = 2'b10;
            end
            5'b11111:begin
                w_reg_cont = 2'b01;
                ALU_op = 3'b100;
                comp = 1'b1;
                comp_cont = 2'b11;
            end
            5'b01100:begin
                reg_w_en = 1'b0;
                ext_type = 1'b1;
                len_immed = 2'b01;
                branch_cont = 2'b00;
            end
            5'b01101:begin
                reg_w_en = 1'b0;
                ext_type = 1'b1;
                len_immed = 2'b01;
                branch_cont = 2'b01;
            end
            5'b01110:begin
                reg_w_en = 1'b0;
                ext_type = 1'b1;
                len_immed = 2'b01;
                branch_cont = 2'b10;
            end
            5'b01111:begin
                reg_w_en = 1'b0;
                ext_type = 1'b1;
                len_immed = 2'b01;
                branch_cont = 2'b11;
            end
            5'b11000:begin
                w_reg_cont = 2'b10;
                ext_type = 1'b1;
                immed = 1'b1;
                len_immed = 2'b01;
                pass = 1'b1;
            end
            5'b10010:begin
                w_reg_cont = 2'b10;
                immed = 1'b1;
                len_immed = 2'b01;
                ex_SLBI = 1'b1;
            end
            5'b00100:begin
                reg_w_en = 1'b0;
                ext_type = 1'b1;
                len_immed = 2'b10;
                branch_J = 1'b1;
            end
            5'b00101:begin
                reg_w_en = 1'b0;
                ext_type = 1'b1;
                len_immed = 2'b01;
                choose_branch = 1'b1;
                branch_J = 1'b1;
            end
            5'b00110:begin
                ext_type = 1'b1;
                len_immed = 2'b10;
                w_reg_cont = 2'b11;
                branch_J = 1'b1;
                update_R7 = 1'b1;
                pass = 1'b1;
            end
            5'b00111:begin
                ext_type = 1'b1;
                len_immed = 2'b01;
                w_reg_cont = 2'b11;
                branch_J = 1'b1;
                choose_branch = 1'b1;
                update_R7 = 1'b1;
                pass = 1'b1;
            end
        endcase
    end


endmodule