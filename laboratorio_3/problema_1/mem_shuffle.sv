`timescale 1ns/1ps
module mem_shuffle #(
  parameter int N_TILES = 16
)(
  input  logic                 clk,
  input  logic                 rst,
  input  logic                 start,          // 1 = comenzar barajado
  input  logic [15:0]          rnd,            // fuente pseudoaleatoria
  output logic                 busy,           // 1 mientras baraja
  output logic                 done,           // pulso 1 ciclo al terminar
  output logic [4*N_TILES-1:0] tiles_id_flat   // 16 * 4 bits = 64 bits
);
  localparam int N_PAIRS = N_TILES/2;

  typedef enum logic [1:0] {S_IDLE, S_INIT, S_SHUF, S_DONE} st_t;
  st_t s;

  // arreglo de IDs a barajar (0..7 repetidos dos veces)
  logic [3:0] a [0:N_TILES-1];

  // índice i del Fisher–Yates (va de N_TILES-1 hasta 0)
  logic [4:0] i;   // alcanza hasta 16

  // señales auxiliares
  logic [3:0] j;   // índice aleatorio en [0..i]
  logic [3:0] tmp; // temporal para swap

  // salida combinacional
  integer k;
  always_comb begin
    busy = (s == S_INIT) || (s == S_SHUF);
    done = (s == S_DONE);
    // empaquetar a[] en tiles_id_flat
    for (k = 0; k < N_TILES; k++) begin
      tiles_id_flat[4*k +: 4] = a[k];
    end
  end

  // j = rnd % (i+1) — sin funciones, cuidado i=0
  always_comb begin
    if (i == 0) j = 4'd0;
    else        j = rnd % (i + 5'd1);
  end

  // FSM + swap en un único always_ff
  integer t;
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      s <= S_IDLE;
      i <= 5'd0;
      // init por si alguien lee antes de start
      for (t = 0; t < N_TILES; t++) a[t] <= (t % N_PAIRS);
    end else begin
      unique case (s)
        S_IDLE: begin
          if (start) begin
            // Cargar IDs base 0..7,0..7
            for (t = 0; t < N_TILES; t++) a[t] <= (t % N_PAIRS);
            i <= N_TILES - 1;
            s <= S_INIT;
          end
        end

        S_INIT: begin
          // primer paso: pasar directamente a SHUF
          s <= S_SHUF;
        end

        S_SHUF: begin
          // swap a[i] <-> a[j]
          tmp   = a[j];        // bloqueo intencional para leer valor viejo
          a[j] <= a[i];        // no-blocking para escribir nuevo
          a[i] <= tmp;         // no-blocking para escribir nuevo

          if (i != 0) begin
            i <= i - 5'd1;
            s <= S_SHUF;
          end else begin
            s <= S_DONE;
          end
        end

        S_DONE: begin
          // pulso done un ciclo y volver a IDLE
          s <= S_IDLE;
        end
      endcase
    end
  end
endmodule
