// top_mem.sv — Integración VGA + juego de memoria (FSM externa no requerida para probar).
// Mapea botones a acciones del tablero y renderiza el estado en pantalla.
//
// Puertos de placa (DE10-Standard):
// - Reloj 50 MHz
// - KEY[3:0] activos en bajo (K0=abrir, K1=shuffle, K2=cerrar no-match, K3=reset global)
// - SW[3:0] índice de carta (0..15)
// - Salidas VGA 8 bits/color

module top_mem(
    input  logic        CLOCK_50,
    input  logic [3:0]  KEY,         // activos en bajo
    input  logic [9:0]  SW,          // usamos SW[3:0] para índice

    output logic        VGA_HS,
    output logic        VGA_VS,
    output logic [7:0]  VGA_R,
    output logic [7:0]  VGA_G,
    output logic [7:0]  VGA_B,
    output logic        VGA_CLK,
    output logic        VGA_BLANK_N,
    output logic        VGA_SYNC_N
);

    // ============================================================
    // 1) Reloj de píxel ~25 MHz (÷2) y reset sincronizado
    // ============================================================
    logic clk_pix;

    always_ff @(posedge CLOCK_50) begin
        clk_pix <= ~clk_pix;
    end

    // KEY[3] = reset global activo en bajo
    // Sincronizamos a clk_pix (reset alto dentro del dominio)
    logic rst_meta, rst_sync;
    always_ff @(posedge clk_pix) begin
        rst_meta <= ~KEY[3];  // KEY[3]==0 → reset=1
        rst_sync <= rst_meta;
    end
    wire rst_pix = rst_sync;

    assign VGA_CLK     = clk_pix;
    assign VGA_BLANK_N = 1'b1;
    assign VGA_SYNC_N  = 1'b0;

    // ============================================================
    // 2) Control por botones: generar pulsos 1-ciclo en clk_pix
    //    KEY activo en bajo → detecto flanco de bajada (1→0 lógico)
    // ============================================================
    logic k0_d, k1_d, k2_d;  // registros de retardo
    always_ff @(posedge clk_pix) begin
        if (rst_pix) begin
            k0_d <= 1'b1; k1_d <= 1'b1; k2_d <= 1'b1;
        end else begin
            k0_d <= KEY[0];
            k1_d <= KEY[1];
            k2_d <= KEY[2];
        end
    end

    wire pulse_open    = (k0_d==1'b1) && (KEY[0]==1'b0); // flanco ↓
    wire pulse_shuffle = (k1_d==1'b1) && (KEY[1]==1'b0);
    wire pulse_close   = (k2_d==1'b1) && (KEY[2]==1'b0);

    // Índice desde SW[3:0]
    wire [3:0] idx_sel = SW[3:0];

    // ============================================================
    // 3) VGA timing 640x480@60 (polaridades negativas)
    // ============================================================
    logic       video_on;
    logic [11:0] x, y;
    logic       hs_int, vs_int;

    // RGB que entrega el renderer (8 bits/canal)
    logic [7:0] rgb_r, rgb_g, rgb_b;

    vga_controller #(
        .H_ACTIVE(640), .V_ACTIVE(480),
        .H_FP(16), .H_SYNC(96), .H_BP(48),
        .V_FP(10), .V_SYNC(2),  .V_BP(33),
        .HS_POL(1'b0), .VS_POL(1'b0),
        .N_COLOR_BITS(8),
        .USE_TEST_PATTERN(1'b0)   // usamos nuestro renderer
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

    // Registrar HS/VS hacia pines (opcional)
    always_ff @(posedge clk_pix or posedge rst_pix) begin
        if (rst_pix) begin
            VGA_HS <= 1'b1; // inactivo (negativo)
            VGA_VS <= 1'b1;
        end else begin
            VGA_HS <= hs_int;
            VGA_VS <= vs_int;
        end
    end

    // ============================================================
    // 4) Juego de memoria: tablero + renderer
    //    - El tablero maneja el estado de 16 cartas.
    //    - El renderer pinta según tiles_id_flat / tiles_st_flat.
    // ============================================================
    // Señales del tablero
    logic [3:0]  sel_a, sel_b;
    logic        two_open, is_match;
    logic [63:0] tiles_id_flat;  // 16*4
    logic [31:0] tiles_st_flat;  // 16*2
    logic [3:0]  pairs_left;

    mem_board u_board (
        .clk               (clk_pix),
        .rst               (rst_pix),

        .do_shuffle        (pulse_shuffle),
        .do_close_nonmatch (pulse_close),
        .req_open          (pulse_open),
        .idx               (idx_sel),

        .rnd               (16'hACE1), // interfaz mantenida; no usado en versión base

        .sel_a             (sel_a),
        .sel_b             (sel_b),
        .two_open          (two_open),
        .is_match          (is_match),
        .tiles_id_flat     (tiles_id_flat),
        .tiles_st_flat     (tiles_st_flat),
        .pairs_left        (pairs_left)
    );

    // ===== Renderer (asume esta interfaz) =====
    // Si tu mem_renderer usa otros nombres/anchos, dime y lo adapto.
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

endmodule
