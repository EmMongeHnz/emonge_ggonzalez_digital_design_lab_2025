`timescale 1ns/1ps
module auto_reveal #(
  parameter int unsigned DELAY_SECS = 2
)(
  input  logic clk,
  input  logic rst,

  input  logic time_expired,  
  input  logic tick_1hz,      

  output logic rng_req_auto,      
  output logic cap_first_auto,    
  output logic reveal_tick,       

  
  output logic auto_busy
);

  typedef enum logic [1:0] { AR_IDLE, AR_PULSE, AR_WAIT, AR_REVEAL } ar_state_t;
  ar_state_t st, st_n;

  logic te_d;
  wire  te_edge = time_expired & ~te_d;

  logic [7:0] sec_cnt;


  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      st      <= AR_IDLE;
      te_d    <= 1'b0;
      sec_cnt <= '0;
    end else begin
      st   <= st_n;
      te_d <= time_expired;

      if (st == AR_WAIT) begin
        if (tick_1hz) sec_cnt <= sec_cnt + 8'd1;
      end else begin
        sec_cnt <= '0;
      end
    end
  end

  
  always_comb begin
    rng_req_auto   = 1'b0;
    cap_first_auto = 1'b0;
    reveal_tick    = 1'b0;
    auto_busy      = 1'b0;
    st_n           = st;

    unique case (st)
      AR_IDLE: begin
        if (te_edge) st_n = AR_PULSE;
      end

      AR_PULSE: begin
        auto_busy      = 1'b1;
        rng_req_auto   = 1'b1;
        cap_first_auto = 1'b1;          
        st_n = (DELAY_SECS == 0) ? AR_REVEAL : AR_WAIT;
      end

      AR_WAIT: begin
        auto_busy = 1'b1;                
        if (tick_1hz && (sec_cnt == (DELAY_SECS-1))) st_n = AR_REVEAL;
      end

      AR_REVEAL: begin
        auto_busy   = 1'b1;              
        reveal_tick = 1'b1;              
        st_n        = AR_IDLE;
      end
    endcase
  end
endmodule
