`timescale 1ns/1ps
module mem_shuffle #(
  parameter int N_TILES = 16
)(
  input  logic                   clk,
  input  logic                   rst,
  input  logic                   start,
  input  logic [15:0]            rnd,              // cambia cada ciclo (shift)
  output logic                   busy,
  output logic                   done,             // pulso 1 ciclo al terminar
  output logic [4*N_TILES-1:0]   tiles_id_flat     // ids barajados (4b por carta)
);
  localparam int N_PAIRS = N_TILES/2;

  typedef enum logic [1:0] {S_IDLE, S_INIT, S_SHUF, S_DONE} st_t;
  st_t s, s_n;

  logic [3:0] a    [0:N_TILES-1];   // arreglo a barajar (IDs 0..7 repetidos)
  logic [3:0] a_n  [0:N_TILES-1];
  logic [4:0] i, i_n;

  function automatic [3:0] mod_small(input [15:0] x, input [4:0] m);
    mod_small = (m==0) ? 4'd0 : x % m; // m en 1..16
  endfunction

  integer k;
  always_comb begin
    s_n   = s;
    i_n   = i;
    for (k=0;k<N_TILES;k++) a_n[k] = a[k];
    busy  = (s!=S_IDLE) && (s!=S_DONE);
    done  = 1'b0;

    unique case (s)
      S_IDLE: begin
        if (start) s_n = S_INIT;
      end

      S_INIT: begin
        for (k=0;k<N_TILES;k++) a_n[k] = (k % N_PAIRS)[3:0];
        i_n = N_TILES-1;
        s_n = S_SHUF;
      end

      S_SHUF: begin
        // Fisher–Yates: elegir j en [0..i], swap(a[i], a[j]), i--
        logic [3:0] j;
        j = mod_small(rnd, i + 5'd1);
        a_n[i] = a[j];
        a_n[j] = a[i];
        if (i != 0) begin
          i_n = i - 5'd1;
        end else begin
          s_n = S_DONE;
        end
      end

      S_DONE: begin
        done = 1'b1;
        s_n  = S_IDLE;
      end
    endcase
  end

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      s <= S_IDLE;
      i <= '0;
      for (k=0;k<N_TILES;k++) a[k] <= '0;
    end else begin
      s <= s_n;
      i <= i_n;
      for (k=0;k<N_TILES;k++) a[k] <= a_n[k];
    end
  end

  always_comb begin
    for (k=0;k<N_TILES;k++) begin
      tiles_id_flat[4*k +: 4] = a[k];
    end
  end
endmodule
