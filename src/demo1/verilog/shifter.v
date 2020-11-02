module shifter (In, Cnt, Op, Out);
   
   input [15:0] In;
   input [3:0]  Cnt;
   input [1:0]  Op;
   output [15:0] Out;

   wire [15:0] mod_layer_1, mod_layer_2, mod_layer_4, mod_layer_8;
   wire [15:0] res_layer_1, res_layer_2, res_layer_4, res_layer_8;

   localparam ROT_LEFT = 2'b00;
   localparam SHFT_LEFT = 2'b01;
   localparam ROT_RIGHT = 2'b10;
   localparam SHFT_RIGHT_LOG = 2'b11;

   // Layer 1 of Multiplexers
   assign mod_layer_1 = Op == ROT_LEFT ? ({In[14:0],In[15]}) :
                        (Op == SHFT_LEFT ? ({In[14:0], 1'b0}) :
                        (Op == ROT_RIGHT ? ({In[0],In[15:1]}) : 
                        ({1'b0,In[15:1]}))); // Op == SHFT_RIGHT_LOG 

   assign res_layer_1 = Cnt[0] ? mod_layer_1 : In;

   // Layer 2 of Multiplexers
   assign mod_layer_2 = Op == ROT_LEFT ? ({res_layer_1[13:0], res_layer_1[15:14]}) :
                     (Op == SHFT_LEFT ? ({res_layer_1[13:0], 2'b00}) :
                     (Op == ROT_RIGHT ? ({res_layer_1[1:0],res_layer_1[15:2]}) : 
                     ({2'b00,res_layer_1[15:2]}))); // Op == SHFT_RIGHT_LOG 

   assign res_layer_2 = Cnt[1] ? mod_layer_2 : res_layer_1;

   // Layer 4 of Multiplexers
   assign mod_layer_4 = Op == ROT_LEFT ? ({res_layer_2[11:0],res_layer_2[15:12]}) :
                     (Op == SHFT_LEFT ? ({res_layer_2[11:0], 4'b0000}) :
                     (Op == ROT_RIGHT ? ({res_layer_2[3:0],res_layer_2[15:4]}) : 
                     ({4'b0000,res_layer_2[15:4]}))); // Op == SHFT_RIGHT_LOG 

   assign res_layer_4 = Cnt[2] ? mod_layer_4 : res_layer_2;

   // Layer 8 of Multiplexers
   assign mod_layer_8 = Op == ROT_LEFT ? ({res_layer_4[7:0],res_layer_4[15:8]}) :
                     (Op == SHFT_LEFT ? ({res_layer_4[7:0], 8'b00000000}) :
                     (Op == ROT_RIGHT ? ({res_layer_4[7:0],res_layer_4[15:8]}) : 
                     ({8'b00000000,res_layer_4[15:8]}))); // Op == SHFT_RIGHT_LOG 

   assign res_layer_8 = Cnt[3] ? mod_layer_8 : res_layer_4;

   assign Out = res_layer_8;

endmodule

