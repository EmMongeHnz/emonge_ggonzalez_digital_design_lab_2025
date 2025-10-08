`timescale 1ns/1ps
module tb_fsm;
  logic clk = 0; always #5 clk = ~clk;
  logic rst = 1;

  logic evento_sel, time_expired, es_par;
  logic [7:0] pares_restantes_i;
  logic turn_j1, timer_start, timer_clear, rng_req;
  logic capture_first, capture_second, eval_now, lock_pair, flip_back;
  logic score_p1_inc, score_p2_inc, show_winner;

  fsm dut (
    .clk, .rst,
    .evento_sel, .time_expired, .es_par,
    .pares_restantes_i,
    .turn_j1, .timer_start, .timer_clear, .rng_req,
    .capture_first, .capture_second, .eval_now, .lock_pair, .flip_back,
    .score_p1_inc, .score_p2_inc, .show_winner
  );

  initial begin
    pares_restantes_i = 3;
    forever begin
      @(posedge clk);
      if (lock_pair && pares_restantes_i > 0)
        pares_restantes_i <= pares_restantes_i - 1;
    end
  end

  task automatic pulse(ref logic sig);
    sig = 1; @(posedge clk); sig = 0;
  endtask

  initial begin
    evento_sel=0; time_expired=0; es_par=0;
    repeat (3) @(posedge clk); rst=0;

    pulse(evento_sel);
    pulse(evento_sel);
    es_par=1; @(posedge clk); es_par=0; @(posedge clk);

    pulse(evento_sel);
    pulse(evento_sel);
    es_par=0; @(posedge clk); es_par=0; @(posedge clk);

    pulse(time_expired);
    es_par=1; @(posedge clk); es_par=0; @(posedge clk);

    pulse(time_expired);
    es_par=1; @(posedge clk); es_par=0; @(posedge clk);

    pulse(time_expired);
    es_par=1; @(posedge clk); es_par=0; @(posedge clk);

    repeat (5) @(posedge clk);
    $finish;
  end
endmodule
