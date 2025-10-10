`timescale 1ns/1ps
module mem_shuffle #(

  parameter int N_TILES = 16
)(

  input  logic                 clk,
  input  logic                 rst,
  input  logic                 start,
  input  logic [15:0]          rnd,
  output logic                 busy,
  output logic                 done,
  output logic [4*N_TILES-1:0] tiles_id_flat
);

 
  localparam int N_PAIRS = N_TILES/2;
  typedef enum logic [1:0] {S_IDLE, S_INIT, S_SHUF, S_DONE} st_t;
  st_t s;
  logic [3:0] a [0:N_TILES-1];
  logic [4:0] i;
  logic [3:0] j, tmp;

 
  integer k;
  always_comb begin
    busy = (s == S_INIT) || (s == S_SHUF);
    done = (s == S_DONE);
    for (k = 0; k < N_TILES; k++) begin
      tiles_id_flat[4*k +: 4] = a[k];
    end
  end


  always_comb begin
    if (i == 0) j = 4'd0;
    else        j = rnd % (i + 5'd1);
  end

  // FSM y swaps
  integer t;
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      s <= S_IDLE;
      i <= 5'd0;
      for (t = 0; t < N_TILES; t++) a[t] <= (t % N_PAIRS);
    end else begin
      unique case (s)
        S_IDLE: begin
          if (start) begin
            for (t = 0; t < N_TILES; t++) a[t] <= (t % N_PAIRS);
            i <= N_TILES - 1;
            s <= S_INIT;
          end
        end
        S_INIT: begin
          s <= S_SHUF;
        end
        S_SHUF: begin
          tmp   = a[j];
          a[j] <= a[i];
          a[i] <= tmp;
          if (i != 0) begin
            i <= i - 5'd1;
            s <= S_SHUF;
          end else begin
            s <= S_DONE;
          end
        end
        S_DONE: begin
          s <= S_IDLE;
        end
      endcase
    end
  end
endmodule
