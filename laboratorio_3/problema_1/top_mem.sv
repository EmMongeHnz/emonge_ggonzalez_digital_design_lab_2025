`timescale 1ns/1ps
module top_mem(
  input  logic        CLOCK_50,
  input  logic [3:0]  KEY,
  input  logic [9:0]  SW,
  output logic        VGA_HS,
  output logic        VGA_VS,
  output logic [7:0]  VGA_R,
  output logic [7:0]  VGA_G,
  output logic [7:0]  VGA_B,
  output logic        VGA_CLK,
  output logic        VGA_BLANK_N,
  output logic        VGA_SYNC_N,
  output logic [6:0]  HEX0,
  output logic [6:0]  HEX1,
  output logic [6:0]  HEX2
);

  logic clk_pix;
  always_ff @(posedge CLOCK_50 or negedge KEY[3]) begin
    if (!KEY[3]) clk_pix <= 1'b0;
    else         clk_pix <= ~clk_pix;
  end

  logic rst_meta, rst_pix;
  always_ff @(posedge clk_pix or negedge KEY[3]) begin
    if (!KEY[3]) begin rst_meta <= 1'b1; rst_pix <= 1'b1; end
    else begin rst_meta <= 1'b0; rst_pix <= rst_meta; end
  end

  assign VGA_CLK     = clk_pix;
  assign VGA_BLANK_N = 1'b1;
  assign VGA_SYNC_N  = 1'b0;

  logic sel_btn_db, sel_btn_pulse;
  debounce #(.N_CYCLES(50_000)) u_db (
    .clk (clk_pix), .rst (rst_pix),
    .din (~KEY[0]), .dout(sel_btn_db)
  );
  one_pulse u_op (
    .clk (clk_pix), .rst (rst_pix),
    .din (sel_btn_db), .pulse(sel_btn_pulse)
  );
  wire [3:0] idx_sw = SW[3:0];

  logic [15:0] rnd16;
  shift u_rng (.clk(clk_pix), .rst(rst_pix), .rnd(rnd16));

  localparam int unsigned FPIX_HZ = 25_000_000;
  logic [$clog2(FPIX_HZ)-1:0] div_cnt;
  logic tick_1hz;
  always_ff @(posedge clk_pix or posedge rst_pix) begin
    if (rst_pix) begin div_cnt <= '0; tick_1hz <= 1'b0; end
    else begin
      if (div_cnt == FPIX_HZ-1) begin div_cnt <= '0; tick_1hz <= 1'b1; end
      else begin div_cnt <= div_cnt + 1'b1; tick_1hz <= 1'b0; end
    end
  end

  logic        video_on;
  logic [11:0] x, y;
  logic        hs_int, vs_int;
  logic [7:0]  rgb_r, rgb_g, rgb_b;
  vga_controller #(
    .H_ACTIVE(640), .V_ACTIVE(480),
    .H_FP(16), .H_SYNC(96), .H_BP(48),
    .V_FP(10), .V_SYNC(2),  .V_BP(33),
    .HS_POL(1'b0), .VS_POL(1'b0),
    .N_COLOR_BITS(8),
    .USE_TEST_PATTERN(1'b0)
  ) u_vga (
    .clk_pix (clk_pix),
    .rst     (rst_pix),
    .rgb_in_r(rgb_r),
    .rgb_in_g(rgb_g),
    .rgb_in_b(rgb_b),
    .hsync   (hs_int),
    .vsync   (vs_int),
    .vga_r   (VGA_R),
    .vga_g   (VGA_G),
    .vga_b   (VGA_B),
    .video_on(video_on),
    .x       (x), .y(y)
  );

  always_ff @(posedge clk_pix or posedge rst_pix) begin
    if (rst_pix) begin VGA_HS <= 1'b1; VGA_VS <= 1'b1; end
    else begin VGA_HS <= hs_int; VGA_VS <= vs_int; end
  end

  logic        timer_start, timer_clear, time_expired;
  logic [4:0]  sec_left;
  turn_timer #(.START_FROM(15)) u_tmr (
    .clk(clk_pix), .rst(rst_pix),
    .tick_1hz(tick_1hz),
    .timer_start(timer_start),
    .timer_clear(timer_clear),
    .sec_left(sec_left),
    .time_expired(time_expired)
  );

  logic rng_req_fsm;
  logic capture_first_fsm, capture_second_fsm;
  logic eval_now_fsm, lock_pair_fsm, flip_back_fsm;
  logic turn_j1, show_winner;
  logic score_p1_inc, score_p2_inc;
  wire  evento_sel = sel_btn_pulse;

  localparam int N_TILES = 16;
  logic         es_par;
  logic [7:0]   pairs_restantes_i;
  logic [2*N_TILES-1:0] tiles_st_flat;
  logic [4*N_TILES-1:0] tiles_id_flat_out;

  fsm u_fsm (
    .clk(clk_pix), .rst(rst_pix),
    .evento_sel(evento_sel),
    .time_expired(time_expired),
    .es_par(es_par),
    .pares_restantes_i(pairs_restantes_i[7:0]),
    .turn_j1(turn_j1),
    .timer_start(timer_start),
    .timer_clear(timer_clear),
    .rng_req(rng_req_fsm),
    .capture_first(capture_first_fsm),
    .capture_second(capture_second_fsm),
    .eval_now(eval_now_fsm),
    .lock_pair(lock_pair_fsm),
    .flip_back(flip_back_fsm),
    .score_p1_inc(score_p1_inc),
    .score_p2_inc(score_p2_inc),
    .show_winner(show_winner)
  );

  logic rng_req_auto, cap_first_auto, reveal_tick_auto, auto_busy;
  auto_reveal #(.DELAY_SECS(2)) u_auto (
    .clk         (clk_pix),
    .rst         (rst_pix),
    .time_expired(time_expired),
    .tick_1hz    (tick_1hz),
    .rng_req_auto(rng_req_auto),
    .cap_first_auto(cap_first_auto),
    .reveal_tick (reveal_tick_auto),
    .auto_busy   (auto_busy)
  );

  logic shuf_btn_db, shuf_btn_pulse;
  debounce #(.N_CYCLES(50_000)) u_db_shuf (
    .clk (clk_pix), .rst (rst_pix),
    .din (~KEY[2]), .dout(shuf_btn_db)
  );
  one_pulse u_op_shuf (
    .clk(clk_pix), .rst(rst_pix),
    .din(shuf_btn_db), .pulse(shuf_btn_pulse)
  );
  logic                 shuf_busy, shuf_done;
  logic [4*N_TILES-1:0] shuf_ids_flat;
  mem_shuffle #(.N_TILES(N_TILES)) u_shuf (
    .clk          (clk_pix),
    .rst          (rst_pix),
    .start        (shuf_btn_pulse),
    .rnd          (rnd16),
    .busy         (shuf_busy),
    .done         (shuf_done),
    .tiles_id_flat(shuf_ids_flat)
  );

  wire game_over          = show_winner | (pairs_restantes_i == 8'd0);
  wire show_winner_render = game_over;

  wire block_fsm = game_over | time_expired | auto_busy | shuf_busy;

  wire rng_req_to_board        = ((block_fsm ? 1'b0 : rng_req_fsm)       | (rng_req_auto    & ~game_over));
  wire capture_first_to_board  = ((block_fsm ? 1'b0 : capture_first_fsm) | (cap_first_auto  & ~game_over));
  wire capture_second_to_board =  (block_fsm ? 1'b0 : capture_second_fsm);
  wire eval_now_to_board       =  (block_fsm ? 1'b0 : eval_now_fsm);
  wire lock_pair_to_board      =  (block_fsm ? 1'b0 : lock_pair_fsm);
  wire flip_back_to_board      =  (block_fsm ? 1'b0 : flip_back_fsm);
  wire reveal_tick_to_board    =   reveal_tick_auto & ~game_over;
  wire load_ids_to_board       =   shuf_done;

  mem_board #(.N_TILES(N_TILES)) u_board (
    .clk(clk_pix), .rst(rst_pix),
    .sel_pulse(sel_btn_pulse),
    .idx_sw(idx_sw),
    .rnd(rnd16[3:0]),
    .rng_req(rng_req_to_board),
    .capture_first (capture_first_to_board),
    .capture_second(capture_second_to_board),
    .eval_now      (eval_now_to_board),
    .lock_pair     (lock_pair_to_board),
    .flip_back     (flip_back_to_board),
    .reveal_tick   (reveal_tick_to_board),
    .load_ids        (load_ids_to_board),
    .tiles_id_flat_in(shuf_ids_flat),
    .es_par(es_par),
    .pairs_left(pairs_restantes_i),
    .tiles_st_flat(tiles_st_flat),
    .tiles_id_flat_out(tiles_id_flat_out)
  );

  logic [3:0] score_j1, score_j2;
  always_ff @(posedge clk_pix or posedge rst_pix) begin
    if (rst_pix) begin
      score_j1 <= 4'd0; score_j2 <= 4'd0;
    end else begin
      if (shuf_done) begin
        score_j1 <= 4'd0; score_j2 <= 4'd0;
      end else begin
        if (score_p1_inc) score_j1 <= score_j1 + 1'b1;
        if (score_p2_inc) score_j2 <= score_j2 + 1'b1;
      end
    end
  end

  mem_renderer #(.H_ACTIVE(640), .V_ACTIVE(480)) u_rend (
    .clk_pix(clk_pix),
    .rst    (rst_pix),
    .video_on(video_on),
    .x(x), .y(y),
    .idx_sw(idx_sw),
    .turn_j1(turn_j1),
    .tiles_st_flat(tiles_st_flat[31:0]),
    .tiles_id_flat(tiles_id_flat_out),
    .show_winner(show_winner_render),
    .score_j1(score_j1),
    .score_j2(score_j2),
    .rgb_r(rgb_r), .rgb_g(rgb_g), .rgb_b(rgb_b)
  );

  wire [6:0] seg_j1, seg_sec, seg_j2;
  hex7 #(.ACTIVE_LOW(1)) u_hex2 (.d(score_j1),      .seg(seg_j1));
  hex7 #(.ACTIVE_LOW(1)) u_hex1 (.d(sec_left[3:0]), .seg(seg_sec));
  hex7 #(.ACTIVE_LOW(1)) u_hex0 (.d(score_j2),      .seg(seg_j2));
  assign HEX2 = {seg_j1[0],seg_j1[1],seg_j1[2],seg_j1[3],seg_j1[4],seg_j1[5],seg_j1[6]};
  assign HEX1 = {seg_sec[0],seg_sec[1],seg_sec[2],seg_sec[3],seg_sec[4],seg_sec[5],seg_sec[6]};
  assign HEX0 = {seg_j2[0],seg_j2[1],seg_j2[2],seg_j2[3],seg_j2[4],seg_j2[5],seg_j2[6]};
endmodule
