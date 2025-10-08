`timescale 1ns/1ps
module mem_board #(
  parameter int N_TILES = 16
)(
  input  logic       clk, rst,
  input  logic       sel_pulse,
  input  logic [3:0] idx_sw,
  input  logic [3:0] rnd,
  input  logic       rng_req,

  input  logic       capture_first,
  input  logic       capture_second,
  input  logic       eval_now,
  input  logic       lock_pair,
  input  logic       flip_back,

  input  logic                       load_ids,
  input  logic [4*N_TILES-1:0]       tiles_id_flat_in,

  output logic       es_par,
  output logic [7:0] pairs_left,
  output logic [2*N_TILES-1:0] tiles_st_flat
);
  localparam int N_PAIRS = N_TILES/2;
  localparam logic [1:0] ST_CLOSED = 2'b00;
  localparam logic [1:0] ST_OPEN   = 2'b01;
  localparam logic [1:0] ST_REM    = 2'b10;

  logic [1:0] tile_st [0:N_TILES-1];
  logic [3:0] tile_id [0:N_TILES-1];

  logic [3:0] first_idx, second_idx;
  logic       have_first, have_second;

  logic [3:0] prefer_idx, pick_idx;
  always_comb begin
    prefer_idx = rng_req ? rnd : idx_sw;
    pick_idx   = prefer_idx;
    if (tile_st[pick_idx] != ST_CLOSED) begin
      int kk;
      pick_idx = 4'd0;
      for (kk = 0; kk < N_TILES; kk++) begin
        if (tile_st[kk] == ST_CLOSED) pick_idx = kk[3:0];
      end
    end
  end

  wire same_pair = (first_idx != second_idx) &&
                   (tile_id[first_idx] == tile_id[second_idx]);
  assign es_par = have_first && have_second && same_pair;

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      int ii;
      for (ii = 0; ii < N_TILES; ii++) begin
        tile_st[ii] <= ST_CLOSED;
        tile_id[ii] <= (ii % N_PAIRS); // valor por defecto hasta que llegue load_ids
      end
      first_idx   <= 4'd0;
      second_idx  <= 4'd0;
      have_first  <= 1'b0;
      have_second <= 1'b0;
      pairs_left  <= N_PAIRS[7:0];

    end else begin
      if (load_ids) begin
        int jj;
        for (jj = 0; jj < N_TILES; jj++) begin
          tile_id[jj] <= tiles_id_flat_in[4*jj +: 4];
          tile_st[jj] <= ST_CLOSED;
        end
        have_first  <= 1'b0;
        have_second <= 1'b0;
        pairs_left  <= N_PAIRS[7:0];
      end

      if (capture_first) begin
        first_idx  <= pick_idx;
        have_first <= 1'b1;
        if (tile_st[pick_idx] == ST_CLOSED) tile_st[pick_idx] <= ST_OPEN;
      end
      if (capture_second) begin
        second_idx  <= pick_idx;
        have_second <= 1'b1;
        if (tile_st[pick_idx] == ST_CLOSED) tile_st[pick_idx] <= ST_OPEN;
      end

      if (lock_pair && have_first && have_second) begin
        if (tile_st[first_idx]  == ST_OPEN) tile_st[first_idx]  <= ST_REM;
        if (tile_st[second_idx] == ST_OPEN) tile_st[second_idx] <= ST_REM;
        if (pairs_left != 0) pairs_left <= pairs_left - 1'b1;
        have_first  <= 1'b0;
        have_second <= 1'b0;
      end

      if (flip_back && have_first && have_second) begin
        if (tile_st[first_idx]  == ST_OPEN) tile_st[first_idx]  <= ST_CLOSED;
        if (tile_st[second_idx] == ST_OPEN) tile_st[second_idx] <= ST_CLOSED;
        have_first  <= 1'b0;
        have_second <= 1'b0;
      end
    end
  end

  always_comb begin
    int t;
    for (t = 0; t < N_TILES; t++) begin
      tiles_st_flat[2*t +: 2] = tile_st[t];
    end
  end
endmodule
