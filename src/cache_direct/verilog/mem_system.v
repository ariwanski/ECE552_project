/* $Author: karu $ */
/* $LastChangedDate: 2009-04-24 09:28:13 -0500 (Fri, 24 Apr 2009) $ */
/* $Rev: 77 $ */

module mem_system(/*AUTOARG*/
   // Outputs
   DataOut, Done, Stall, CacheHit, err,
   // Inputs
   Addr, DataIn, Rd, Wr, createdump, clk, rst
   );
   
   input      [15:0] Addr;
   input      [15:0] DataIn;
   input             Rd;
   input             Wr;
   input             createdump;
   input             clk;
   input             rst;
   
   output reg [15:0] DataOut;
   output reg        Done;
   output reg        Stall;
   output reg        CacheHit;
   output            err;

   // specifying FSM IO (that isn't an input or output to mem_system module)
   // state machine inputs
   wire             hit;
   wire             dirty;
   wire             valid;

   // state machine outputs
   reg              enable_cache;
   reg              wr_mem;
   reg              rd_mem;
   reg        [4:0] tag_in;
   reg        [7:0] index;
   reg        [2:0] offset;
   reg       [15:0] data_in_cache;
   reg       [15:0] data_in_mem;
   reg              valid_in;
   reg              comp;
   reg              write_cache;
   reg       [15:0] addr_mem;

   // additional cache wires
   wire       [4:0] tag_out;
   wire      [15:0] data_out_cache;
   wire             cache_err;

   // additional mem wires
   wire      [15:0] data_out_mem;
   wire             stall;
   wire       [3:0] busy;
   wire             mem_err;

   // wires for holding state and nxt_state
   wire       [5:0] state;
   reg        [5:0] nxt_state;
   wire       [5:0] nxt_state_reg;

   // STATE LOCAL PARAMETERS
   localparam IDLE           = 6'h00; // idle state
   localparam RD_BEGIN       = 6'h01; // read begin
   localparam RD_CHECK       = 6'h02; // read check
   localparam RD_EVICT_IW0   = 6'h03; // read evict issue word 0
   localparam RD_EVICT_IW1   = 6'h04; // read evict issue word 0
   localparam RD_EVICT_IW2   = 6'h05; // read evict issue word 0
   localparam RD_EVICT_IW3   = 6'h06; // read evict issue word 0
   localparam RD_EVICT_WAIT0 = 6'h07; // read evict wait 0
   localparam RD_EVICT_WAIT1 = 6'h08; // read evict wait 1
   localparam RD_EVICT_WAIT2 = 6'h09; // read evict wait 2
   localparam RD_EVICT_DONE  = 6'h0A; // read evict done
   localparam RD_LOAD_IW0    = 6'h0B; // read load issue word 0
   localparam RD_LOAD_IW1    = 6'h0C; // read load issue word 1
   localparam RD_LOAD_IW2    = 6'h0D; // read load issue word 2
   localparam RD_LOAD_IW3    = 6'h0E; // read load issue word 3
   localparam RD_LOAD_WAIT0  = 6'h0F; // read load wait 0
   localparam RD_LOAD_DONE   = 6'h10; // read load done
   localparam WR_BEGIN       = 6'h11; // write begin
   localparam WR_CHECK       = 6'h12; // write check
   localparam WR_EVICT_IW0   = 6'h13; // write evict issue word 0
   localparam WR_EVICT_IW1   = 6'h14; // write evict issue word 0
   localparam WR_EVICT_IW2   = 6'h15; // write evict issue word 0
   localparam WR_EVICT_IW3   = 6'h16; // write evict issue word 0
   localparam WR_EVICT_WAIT0 = 6'h17; // write evict wait 0
   localparam WR_EVICT_WAIT1 = 6'h18; // write evict wait 1
   localparam WR_EVICT_WAIT2 = 6'h19; // write evict wait 2
   localparam WR_EVICT_DONE  = 6'h1A; // write evict done
   localparam WR_LOAD_IW0    = 6'h1B; // write load issue word 0
   localparam WR_LOAD_IW1    = 6'h1C; // write load issue word 1
   localparam WR_LOAD_IW2    = 6'h1D; // write load issue word 2
   localparam WR_LOAD_IW3    = 6'h1E; // write load issue word 3
   localparam WR_LOAD_WAIT0  = 6'h1F; // write load wait 0
   localparam WR_LOAD_DONE   = 6'h20; // write load done
   localparam WR_CACHE       = 6'h21; // write cache
   localparam RD_CACHE       = 6'h22; // read cache

   // OFFSET LOCALPARAMS
   localparam OFFSET_W0      = 3'b000;
   localparam OFFSET_W1      = 3'b010;
   localparam OFFSET_W2      = 3'b100;
   localparam OFFSET_W3      = 3'b110;

   // create state register
   register #(6) state_reg(.out(state), .in(nxt_state), .wr_en(1'b1), .clk(clk), .rst(rst));

   /* data_mem = 1, inst_mem = 0 *
    * needed for cache parameter */
   parameter memtype = 0;
   cache #(0 + memtype) c0(// Outputs
                          .tag_out              (tag_out),
                          .data_out             (data_out_cache),
                          .hit                  (hit),
                          .dirty                (dirty),
                          .valid                (valid),
                          .err                  (cache_err),
                          // Inputs
                          .enable               (enable_cache),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),
                          .tag_in               (tag_in),
                          .index                (index),
                          .offset               (offset),
                          .data_in              (data_in_cache),
                          .comp                 (comp),
                          .write                (write_cache),
                          .valid_in             (valid_in));

   four_bank_mem mem(// Outputs
                     .data_out          (data_out_mem),
                     .stall             (stall),
                     .busy              (busy),
                     .err               (mem_err),
                     // Inputs
                     .clk               (clk),
                     .rst               (rst),
                     .createdump        (createdump),
                     .addr              (addr_mem),
                     .data_in           (data_in_mem),
                     .wr                (wr_mem),
                     .rd                (rd_mem));

   // create any purely datapath assignments
   
   // finite state machine logic
   always @(*)begin
      Done = 1'b0;
      Stall = 1'b1;
      CacheHit = 1'b0;
      DataOut = data_out_cache;
      tag_in = Addr[15:11];
      index = Addr[10:3];
      offset = Addr[2:0];
      data_in_cache = data_out_mem;
      valid_in = 1'b1;
      comp = 1'b0;
      write_cache = 1'b0;
      addr_mem = 16'h0000;
      data_in_mem = data_out_cache;
      rd_mem = 1'b0;
      wr_mem = 1'b0;
      enable_cache = 1'b0;
      nxt_state = 6'h00; // default state is IDLE
      case(state)
         IDLE:begin
            Stall = 1'b0;
            nxt_state = (Rd) ? (RD_BEGIN) : ((Wr) ? (WR_BEGIN) : (IDLE));
         end
         RD_BEGIN:begin
            Done = hit & valid;
            CacheHit = hit & valid;
            comp = 1'b1;
            enable_cache = 1'b1;
            nxt_state = (hit & valid) ? (IDLE) : (RD_CHECK);
         end
         RD_CHECK:begin
            comp = 1'b1;
            enable_cache = 1'b1;
            nxt_state = (dirty) ? (RD_EVICT_IW0): (RD_LOAD_IW0);
         end
         RD_EVICT_IW0:begin
            tag_in = tag_out;
            offset = OFFSET_W0;
            enable_cache = 1'b1;
            addr_mem = {tag_out, Addr[10:3], OFFSET_W0};
            wr_mem = 1'b1;
            nxt_state = RD_EVICT_IW1;
         end
         RD_EVICT_IW1:begin
            tag_in = tag_out;
            offset = OFFSET_W1;
            enable_cache = 1'b1;
            addr_mem = {tag_out, Addr[10:3], OFFSET_W1};
            wr_mem = 1'b1;
            nxt_state = RD_EVICT_IW2;
         end
         RD_EVICT_IW2:begin
            tag_in = tag_out;
            offset = OFFSET_W2;
            enable_cache = 1'b1;
            addr_mem = {tag_out, Addr[10:3], OFFSET_W2};
            wr_mem = 1'b1;
            nxt_state = RD_EVICT_IW3;
         end
         RD_EVICT_IW3:begin
            tag_in = tag_out;
            offset = OFFSET_W3;
            enable_cache = 1'b1;
            addr_mem = {tag_out, Addr[10:3], OFFSET_W3};
            wr_mem = 1'b1;
            nxt_state = RD_EVICT_WAIT0;
         end
         RD_EVICT_WAIT0:begin
            nxt_state = RD_EVICT_WAIT1;
         end
         RD_EVICT_WAIT1:begin
            nxt_state = RD_EVICT_WAIT2;
         end
         RD_EVICT_WAIT2:begin
            nxt_state = RD_EVICT_DONE;
         end
         RD_EVICT_DONE:begin
            nxt_state = RD_LOAD_IW0;
         end
         RD_LOAD_IW0:begin
            addr_mem = {Addr[15:3], OFFSET_W0};
            rd_mem = 1'b1;
            nxt_state = RD_LOAD_IW1;
         end
         RD_LOAD_IW1:begin
            addr_mem = {Addr[15:3], OFFSET_W1};
            rd_mem = 1'b1;
            nxt_state = RD_LOAD_IW2;   
         end
         RD_LOAD_IW2:begin
            offset = OFFSET_W0;
            enable_cache = 1'b1;
            write_cache = 1'b1;
            addr_mem = {Addr[15:3], OFFSET_W2};
            rd_mem = 1'b1;
            nxt_state = RD_LOAD_IW3;
         end
         RD_LOAD_IW3:begin
            offset = OFFSET_W1;
            enable_cache = 1'b1;
            write_cache = 1'b1;
            addr_mem = {Addr[15:3], OFFSET_W3};
            rd_mem = 1'b1;
            nxt_state = RD_LOAD_WAIT0;
         end
         RD_LOAD_WAIT0:begin
            offset = OFFSET_W2;
            enable_cache = 1'b1;
            write_cache = 1'b1;
            nxt_state = RD_LOAD_DONE;
         end
         RD_LOAD_DONE:begin
            offset = OFFSET_W3;
            enable_cache = 1'b1;
            write_cache = 1'b1;
            nxt_state = RD_CACHE;
         end
         RD_CACHE:begin
            Done = 1'b1;
            //Stall = 1'b0;
            comp = 1'b1;
            enable_cache = 1'b1;
            nxt_state = IDLE;
         end
         WR_BEGIN:begin
            Done = hit & valid;
            CacheHit = hit & valid;
            data_in_cache = DataIn;
            comp = 1'b1;
            enable_cache = 1'b1;
            write_cache= 1'b1;
            nxt_state = (hit & valid) ? (IDLE) : (WR_CHECK);
         end
         WR_CHECK:begin
            comp = 1'b1;
            enable_cache = 1'b1;
            nxt_state = (dirty) ? (WR_EVICT_IW0) : (WR_LOAD_IW0);
         end
         WR_EVICT_IW0:begin
            tag_in = tag_out;
            offset = OFFSET_W0;
            enable_cache = 1'b1;
            addr_mem = {tag_out, Addr[10:3], OFFSET_W0};
            wr_mem = 1'b1;
            nxt_state = WR_EVICT_IW1;
         end
         WR_EVICT_IW1:begin
            tag_in = tag_out;
            offset = OFFSET_W1;
            enable_cache = 1'b1;
            addr_mem = {tag_out, Addr[10:3], OFFSET_W1};
            wr_mem = 1'b1;
            nxt_state = WR_EVICT_IW2;
         end
         WR_EVICT_IW2:begin
            tag_in = tag_out;
            offset = OFFSET_W2;
            enable_cache = 1'b1;
            addr_mem = {tag_out, Addr[10:3], OFFSET_W2};
            wr_mem = 1'b1;
            nxt_state = WR_EVICT_IW3;
         end
         WR_EVICT_IW3:begin
            tag_in = tag_out;
            offset = OFFSET_W3;
            enable_cache = 1'b1;
            addr_mem = {tag_out, Addr[10:3], OFFSET_W3};
            wr_mem = 1'b1;
            nxt_state = WR_EVICT_WAIT0;
         end
         WR_EVICT_WAIT0:begin
            nxt_state = WR_EVICT_WAIT1;
         end
         WR_EVICT_WAIT1:begin
            nxt_state = WR_EVICT_WAIT2;
         end
         WR_EVICT_WAIT2:begin
            nxt_state = WR_EVICT_DONE;
         end
         WR_EVICT_DONE:begin
            nxt_state = WR_LOAD_IW0;
         end
         WR_LOAD_IW0:begin
            addr_mem = {Addr[15:3],OFFSET_W0};
            rd_mem = 1'b1;
            nxt_state = WR_LOAD_IW1;
         end
         WR_LOAD_IW1:begin
            addr_mem = {Addr[15:3],OFFSET_W1};
            rd_mem = 1'b1;
            nxt_state = WR_LOAD_IW2;
         end
         WR_LOAD_IW2:begin
            addr_mem = {Addr[15:3],OFFSET_W2};
            rd_mem = 1'b1;
            offset = OFFSET_W0;
            enable_cache = 1'b1;
            write_cache = 1'b1;
            nxt_state = WR_LOAD_IW3;
         end
         WR_LOAD_IW3:begin
            addr_mem = {Addr[15:3],OFFSET_W3};
            rd_mem = 1'b1;
            offset = OFFSET_W1;
            enable_cache = 1'b1;
            write_cache = 1'b1;
            nxt_state = WR_LOAD_WAIT0;
         end
         WR_LOAD_WAIT0:begin
            offset = OFFSET_W2;
            enable_cache = 1'b1;
            write_cache = 1'b1;
            nxt_state = WR_LOAD_DONE;
         end
         WR_LOAD_DONE:begin
            offset = OFFSET_W3;
            enable_cache = 1'b1;
            write_cache = 1'b1;
            nxt_state = WR_CACHE;
         end
         default:begin // (WR_CACHE)
            Done = 1'b1;
            //Stall = 1'b0;
            data_in_cache = DataIn;
            comp = 1'b1;
            enable_cache = 1'b1;
            write_cache = 1'b1;
            nxt_state = IDLE;
         end
      endcase
   end
   

   
endmodule // mem_system

// DUMMY LINE FOR REV CONTROL :9:
