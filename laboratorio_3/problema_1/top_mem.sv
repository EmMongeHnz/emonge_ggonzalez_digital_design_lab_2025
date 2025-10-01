// top_mem.sv — Integración completa con turnos, puntajes, temporizador y 7 segmentos.
// Usa hex7.sv para los displays (activo en bajo).
// Incluye REMAP de segmentos porque los pines en la DE10-Standard están en orden GFEDCBA.

module top_mem(
    input  logic        CLOCK_50,
    input  logic [3:0]  KEY,         // activos en bajo: K3=reset
    input  logic [9:0]  SW,          // SW[3:0]=índice

    output logic        VGA_HS,
    output logic        VGA_VS,
    output logic [7:0]  VGA_R,
    output logic [7:0]  VGA_G,
    output logic [7:0]  VGA_B,
    output logic        VGA_CLK,
    output logic        VGA_BLANK_N,
    output logic        VGA_SYNC_N,

    // 7-seg activos en bajo (DE10-Standard)
    output logic [6:0]  HEX0,   // score J2
    output logic [6:0]  HEX1,   // sec_left (hex)
    output logic [6:0]  HEX2    // score J1
);

    // ================== 1) Pixel clock y reset sync ==================
    logic clk_pix;
    always_ff @(posedge CLOCK_50) clk_pix <= ~clk_pix;

    logic rst_meta, rst_sync;
    always_ff @(posedge clk_pix) begin
        rst_meta <= ~KEY[3];  // activo en bajo → interno activo en alto
        rst_sync <= rst_meta;
    end
    wire rst_pix = rst_sync;

    assign VGA_CLK     = clk_pix;
    assign VGA_BLANK_N = 1'b1;
    assign VGA_SYNC_N  = 1'b0;

    // ================== 2) Pulsos de UI ==================
    logic k0_d, k1_d;
    always_ff @(posedge clk_pix or posedge rst_pix) begin
        if (rst_pix) begin
            k0_d <= 1'b1; k1_d <= 1'b1;
        end else begin
            k0_d <= KEY[0];
            k1_d <= KEY[1];
        end
    end
    wire pulse_open    = (k0_d==1'b1) && (KEY[0]==1'b0);
    wire pulse_shuffle = (k1_d==1'b1) && (KEY[1]==1'b0);

    wire [3:0] idx_sel = SW[3:0];

    // ================== 3) VGA timing ==================
    logic       video_on;
    logic [11:0] x, y;
    logic       hs_int, vs_int;

    logic [7:0] rgb_r, rgb_g, rgb_b;

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
        .x       (x),
        .y       (y)
    );

    always_ff @(posedge clk_pix or posedge rst_pix) begin
        if (rst_pix) begin
            VGA_HS <= 1'b1; VGA_VS <= 1'b1;
        end else begin
            VGA_HS <= hs_int; VGA_VS <= vs_int;
        end
    end

    // ================== 4) Tablero ==================
    logic [3:0]  sel_a, sel_b;
    logic        two_open, is_match;
    logic [63:0] tiles_id_flat;
    logic [31:0] tiles_st_flat;
    logic [3:0]  pairs_left;

    // Señales desde FSM → tablero
    logic        fsm_open, fsm_close;
    logic [3:0]  fsm_idx;

    // RNG (LFSR16 que ya tienes en debounce.sv)
    logic [15:0] rnd16;
    lfsr16 u_rng (.clk(clk_pix), .rst(rst_pix), .rnd(rnd16));

    mem_board u_board (
        .clk               (clk_pix),
        .rst               (rst_pix),

        .do_shuffle        (pulse_shuffle),
        .do_close_nonmatch (fsm_close),
        .req_open          (fsm_open),
        .idx               (fsm_idx),

        .rnd               (rnd16),

        .sel_a             (sel_a),
        .sel_b             (sel_b),
        .two_open          (two_open),
        .is_match          (is_match),
        .tiles_id_flat     (tiles_id_flat),
        .tiles_st_flat     (tiles_st_flat),
        .pairs_left        (pairs_left)
    );

    // ================== 5) Tick 1 Hz desde clk_pix (~25 MHz) ==================
    logic tick_1hz;
    localparam int DIV_1HZ = 25_000_000; // ajusta si tu pixel clock difiere
    logic [$clog2(DIV_1HZ)-1:0] divcnt;
    always_ff @(posedge clk_pix or posedge rst_pix) begin
        if (rst_pix) begin
            divcnt   <= '0;
            tick_1hz <= 1'b0;
        end else begin
            if (divcnt == DIV_1HZ-1) begin
                divcnt   <= '0;
                tick_1hz <= 1'b1;
            end else begin
                divcnt   <= divcnt + 1'b1;
                tick_1hz <= 1'b0;
            end
        end
    end

    // ================== 6) FSM turnos/puntajes/tiempo ==================
    logic        cur_player;
    logic [4:0]  sec_left;
    logic [3:0]  score_j1, score_j2;
    logic        game_over;

    mem_fsm u_fsm (
        .clk            (clk_pix),
        .rst            (rst_pix),

        .evt_select     (pulse_open),
        .idx_in         (idx_sel),

        .two_open       (two_open),
        .is_match       (is_match),
        .pairs_left     (pairs_left),
        .tiles_st_flat  (tiles_st_flat),

        .tick_1hz       (tick_1hz),
        .rnd            (rnd16),

        .req_open       (fsm_open),
        .do_close_nonmatch(fsm_close),
        .idx_out        (fsm_idx),

        .cur_player     (cur_player),
        .sec_left       (sec_left),
        .score_j1       (score_j1),
        .score_j2       (score_j2),
        .game_over      (game_over)
    );

    // ================== 7) Renderer ==================
    mem_renderer u_renderer (
        .clk_pix       (clk_pix),
        .rst           (rst_pix),
        .video_on      (video_on),
        .x             (x),
        .y             (y),

        .tiles_id_flat (tiles_id_flat),
        .tiles_st_flat (tiles_st_flat),
        .sel_a         (sel_a),
        .sel_b         (sel_b),
        .pairs_left    (pairs_left),

        .vga_r         (rgb_r),
        .vga_g         (rgb_g),
        .vga_b         (rgb_b)
    );

    // ================== 8) 7-Segmentos con REMAP GFEDCBA ==================
    // Salidas del decoder (activo en bajo) en orden A..G
    wire [6:0] seg_j1, seg_sec, seg_j2;

    hex7 #(.ACTIVE_LOW(1)) u_hex2 (.d(score_j1[3:0]), .seg(seg_j1)); // J1
    hex7 #(.ACTIVE_LOW(1)) u_hex1 (.d(sec_left[3:0]),  .seg(seg_sec)); // tiempo
    hex7 #(.ACTIVE_LOW(1)) u_hex0 (.d(score_j2[3:0]), .seg(seg_j2)); // J2

    // Mapeo a pines de la placa (GFEDCBA en los pines: HEXx[0]=g ... HEXx[6]=a)
    assign HEX2[0] = seg_j1[6];  // g
    assign HEX2[1] = seg_j1[5];  // f
    assign HEX2[2] = seg_j1[4];  // e
    assign HEX2[3] = seg_j1[3];  // d
    assign HEX2[4] = seg_j1[2];  // c
    assign HEX2[5] = seg_j1[1];  // b
    assign HEX2[6] = seg_j1[0];  // a

    assign HEX1[0] = seg_sec[6];
    assign HEX1[1] = seg_sec[5];
    assign HEX1[2] = seg_sec[4];
    assign HEX1[3] = seg_sec[3];
    assign HEX1[4] = seg_sec[2];
    assign HEX1[5] = seg_sec[1];
    assign HEX1[6] = seg_sec[0];

    assign HEX0[0] = seg_j2[6];
    assign HEX0[1] = seg_j2[5];
    assign HEX0[2] = seg_j2[4];
    assign HEX0[3] = seg_j2[3];
    assign HEX0[4] = seg_j2[2];
    assign HEX0[5] = seg_j2[1];
    assign HEX0[6] = seg_j2[0];

endmodule
