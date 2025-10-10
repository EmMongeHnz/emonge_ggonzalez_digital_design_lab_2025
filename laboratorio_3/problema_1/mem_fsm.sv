`timescale 1ns/1ps

module fsm #(
  parameter int PAREJAS_TOTALES = 8
) (
  input  logic        clk,
  input  logic        rst,
  input  logic        evento_sel,
  input  logic        time_expired,
  input  logic        es_par,
  input  logic [7:0]  pares_restantes_i,
  output logic        turn_j1,
  output logic        timer_start,
  output logic        timer_clear,
  output logic        rng_req,
  output logic        capture_first,
  output logic        capture_second,
  output logic        eval_now,
  output logic        lock_pair,
  output logic        flip_back,
  output logic        score_p1_inc,
  output logic        score_p2_inc,
  output logic        show_winner
);

  typedef enum logic [3:0] {
    S_INIT,
    S_TURNO_J1_ESPERA,
    S_TURNO_J1_CAP1,
    S_TURNO_J1_CAP2,
    S_TURNO_J1_EVAL,
    S_TURNO_J2_ESPERA,
    S_TURNO_J2_CAP1,
    S_TURNO_J2_CAP2,
    S_TURNO_J2_EVAL,
    S_FIN
  } state_t;

  state_t s, s_n;

  always_comb begin
    timer_start    = 1'b0;
    timer_clear    = 1'b0;
    rng_req        = 1'b0;
    capture_first  = 1'b0;
    capture_second = 1'b0;
    eval_now       = 1'b0;
    lock_pair      = 1'b0;
    flip_back      = 1'b0;
    score_p1_inc   = 1'b0;
    score_p2_inc   = 1'b0;
    show_winner    = 1'b0;
    s_n = s;

    unique case (s)
      S_INIT: begin
        timer_clear = 1'b1;
        s_n = S_TURNO_J1_ESPERA;
      end

      S_TURNO_J1_ESPERA: begin
        timer_start = 1'b1;
        if (pares_restantes_i == 0) s_n = S_FIN;
        else if (time_expired) begin
          rng_req = 1'b1;
          capture_second = 1'b1;
          s_n = S_TURNO_J1_CAP2;
        end else if (evento_sel) begin
          capture_first = 1'b1;
          s_n = S_TURNO_J1_CAP1;
        end
      end

      S_TURNO_J1_CAP1: begin
        if (time_expired) begin
          rng_req = 1'b1;
          capture_second = 1'b1;
          s_n = S_TURNO_J1_EVAL;
        end else if (evento_sel) begin
          capture_second = 1'b1;
          s_n = S_TURNO_J1_EVAL;
        end
      end

      S_TURNO_J1_CAP2: begin
        s_n = S_TURNO_J1_EVAL;
      end

      S_TURNO_J1_EVAL: begin
        eval_now = 1'b1;
        if (es_par) begin
          lock_pair    = 1'b1;
          score_p1_inc = 1'b1;
          timer_clear  = 1'b1;
          if (pares_restantes_i > 0) s_n = S_TURNO_J1_ESPERA;
          else                       s_n = S_FIN;
        end else begin
          flip_back   = 1'b1;
          timer_clear = 1'b1;
          s_n = S_TURNO_J2_ESPERA;
        end
      end

      S_TURNO_J2_ESPERA: begin
        timer_start = 1'b1;
        if (pares_restantes_i == 0) s_n = S_FIN;
        else if (time_expired) begin
          rng_req = 1'b1;
          capture_second = 1'b1;
          s_n = S_TURNO_J2_CAP2;
        end else if (evento_sel) begin
          capture_first = 1'b1;
          s_n = S_TURNO_J2_CAP1;
        end
      end

      S_TURNO_J2_CAP1: begin
        if (time_expired) begin
          rng_req = 1'b1;
          capture_second = 1'b1;
          s_n = S_TURNO_J2_EVAL;
        end else if (evento_sel) begin
          capture_second = 1'b1;
          s_n = S_TURNO_J2_EVAL;
        end
      end

      S_TURNO_J2_CAP2: begin
        s_n = S_TURNO_J2_EVAL;
      end

      S_TURNO_J2_EVAL: begin
        eval_now = 1'b1;
        if (es_par) begin
          lock_pair    = 1'b1;
          score_p2_inc = 1'b1;
          timer_clear  = 1'b1;
          if (pares_restantes_i > 0) s_n = S_TURNO_J2_ESPERA;
          else                       s_n = S_FIN;
        end else begin
          flip_back   = 1'b1;
          timer_clear = 1'b1;
          s_n = S_TURNO_J1_ESPERA;
        end
      end

      S_FIN: begin
        show_winner = 1'b1;
      end

      default: s_n = S_INIT;
    endcase
  end

  always_ff @(posedge clk) begin
    if (rst) begin
      s       <= S_INIT;
      turn_j1 <= 1'b1;
    end else begin
      if (s == S_TURNO_J1_EVAL && s_n == S_TURNO_J2_ESPERA) turn_j1 <= 1'b0;
      else if (s == S_TURNO_J2_EVAL && s_n == S_TURNO_J1_ESPERA) turn_j1 <= 1'b1;
      if (s == S_INIT && s_n == S_TURNO_J1_ESPERA) turn_j1 <= 1'b1;
      s <= s_n;
    end
  end

endmodule
