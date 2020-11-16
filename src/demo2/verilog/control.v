module control(instruc, en_PC, w_reg_cont, ext_type, len_immed, reg_w_en, choose_branch, immed, update_R7, subtract, ALU_op, invA, invB, sign, ex_BTR, ex_SLBI, comp_cont, comp, pass, branch_cont, branch_J, branch_I, createdump, write_mem, read_mem, mem_to_reg);

    input     [15:0] instruc;

    output reg           en_PC;
    output reg     [1:0] w_reg_cont;
    output reg           ext_type;
    output reg     [1:0] len_immed;
    output reg           reg_w_en;
    output reg           choose_branch; 
    output reg           immed;
    output reg           update_R7;
    output reg           subtract;
    output reg     [2:0] ALU_op;
    output reg           invA;
    output reg           invB;
    output reg           sign;
    output reg           ex_BTR;
    output reg           ex_SLBI;
    output reg     [1:0] comp_cont;
    output reg           comp;
    output reg           pass;
    output reg     [1:0] branch_cont;
    output reg           branch_J;
    output reg           branch_I;
    output reg           createdump;
    output reg           write_mem;
    output reg           read_mem;
    output reg           mem_to_reg;

    reg halt=1'b0;

    wire [4:0]op_code = instruc[15:11]; // get the op_code from instruc
    wire [1:0]func_code = instruc[1:0]; // get the func_code from instruc -- used for a few instructions

    always@(*)begin
        // assign default outputs
        en_PC = 1'b1;
        reg_w_en = 1'b1;
        w_reg_cont = 2'b00;
        ext_type = 1'b0;
        len_immed = 2'b00;
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
        branch_I = 1'b0;
        createdump = 1'b0;
        write_mem = 1'b0;
        read_mem = 1'b0;
        mem_to_reg = 1'b0;
        pass = 1'b0;

        case(op_code)
            5'b00000:begin
                en_PC = 1'b0;
                createdump = 1'b1;
                reg_w_en = 1'b0;
                halt= 1'b1;
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
                ALU_op = 3'b100;
                invA = 1'b1;
                sign = 1'b1;
            end
            5'b01010:begin
                immed = 1'b1;
                ALU_op = 3'b110;
            end
            5'b01011:begin
                immed = 1'b1;
                ALU_op = 3'b111;
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
                subtract = 1'b1;
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
            5'b01100:begin //BEQZ
                reg_w_en = 1'b0;
                ext_type = 1'b1;
                len_immed = 2'b01;
                branch_cont = 2'b00;
                branch_I = 1'b1;
            end
            5'b01101:begin //BNEZ
                reg_w_en = 1'b0;
                ext_type = 1'b1;
                len_immed = 2'b01;
                branch_cont = 2'b01;
                branch_I = 1'b1;
            end
            5'b01110:begin // BLTZ
                reg_w_en = 1'b0;
                ext_type = 1'b1;
                len_immed = 2'b01;
                branch_cont = 2'b10;
                branch_I = 1'b1;
            end
            5'b01111:begin // BGEZ
                reg_w_en = 1'b0;
                ext_type = 1'b1;
                len_immed = 2'b01;
                branch_cont = 2'b11;
                branch_I = 1'b1;
            end
            5'b11000:begin // LBI instruction
                w_reg_cont = 2'b10;
                ext_type = 1'b1;
                immed = 1'b1;
                len_immed = 2'b01;
                pass = 1'b1;
                en_PC = 1'b1;
            end
            5'b10010:begin
                w_reg_cont = 2'b10;
                immed = 1'b1;
                len_immed = 2'b01;
                ex_SLBI = 1'b1;
            end
            5'b00100:begin // J displacement
                reg_w_en = 1'b0;
                ext_type = 1'b1;
                len_immed = 2'b10;
                branch_J = 1'b1;
            end
            5'b00101:begin // JR
                reg_w_en = 1'b0;
                ext_type = 1'b1;
                len_immed = 2'b01;
                choose_branch = 1'b1;
                branch_J = 1'b1;
            end
            5'b00110:begin //JAL
                ext_type = 1'b1;
                len_immed = 2'b10;
                w_reg_cont = 2'b11;
                branch_J = 1'b1;
                update_R7 = 1'b1;
                pass = 1'b1;
            end
            5'b00111:begin // JALR
                ext_type = 1'b1;
                len_immed = 2'b01;
                w_reg_cont = 2'b11;
                branch_J = 1'b1;
                choose_branch = 1'b1;
                update_R7 = 1'b1;
                pass = 1'b1;
            end
            5'b00011:begin // NOP
                en_PC = 1'b0; // disable the PC so don't get new instruction
                reg_w_en = 1'b0;
            end
        endcase
    end


endmodule