// vga_top_color_cycle.sv — DE10-Standard, 8 bits/color, sin PLL (25 MHz)
// Cambia el color de toda la pantalla en cada frame (≈60 cambios/seg).
module vga_top(
    input  logic        CLOCK_50,
    input  logic        RESET_N,

    output logic        VGA_HS,
    output logic        VGA_VS,
    output logic [7:0]  VGA_R,
    output logic [7:0]  VGA_G,
    output logic [7:0]  VGA_B,
    output logic        VGA_CLK,
    output logic        VGA_BLANK_N,
    output logic        VGA_SYNC_N
);
    // === Pixel clock ≈25.000 MHz por ÷2 (para prueba; ideal final: PLL 25.175 MHz) ===
    logic clk_pix;
    always_ff @(posedge CLOCK_50 or negedge RESET_N) begin
        if (!RESET_N) clk_pix <= 1'b0;
        else          clk_pix <= ~clk_pix;
    end

    assign VGA_CLK     = clk_pix;
    assign VGA_BLANK_N = 1'b1; // habilita video en el DAC siempre
    assign VGA_SYNC_N  = 1'b0; // sin sync-on-green

    // === Reset síncrono al dominio de pixel ===
    logic r1, r2;
    always_ff @(posedge clk_pix or negedge RESET_N) begin
        if (!RESET_N) begin r1 <= 1'b1; r2 <= 1'b1; end
        else begin r1 <= 1'b0; r2 <= r1; end
    end
    wire rst_pix = r2;

    // === Señales del controlador solo para timing ===
    logic       video_on;
    logic [7:0] rgb_r_dummy, rgb_g_dummy, rgb_b_dummy; // no se usan
    logic       hs_int, vs_int;
    logic [11:0] x_unused, y_unused;

    vga_controller #(
        .H_ACTIVE(640), .V_ACTIVE(480),
        .H_FP(16), .H_SYNC(96), .H_BP(48),
        .V_FP(10), .V_SYNC(2),  .V_BP(33),
        .HS_POL(1'b0), .VS_POL(1'b0),     // 640x480@60: polaridades negativas
        .N_COLOR_BITS(8),
        .USE_TEST_PATTERN(1'b0)           // usamos nuestro propio color sólido
    ) u_vga (
        .clk_pix (clk_pix),
        .rst     (rst_pix),

        .rgb_in_r('0), .rgb_in_g('0), .rgb_in_b('0),

        .hsync   (hs_int),
        .vsync   (vs_int),
        .vga_r   (rgb_r_dummy),
        .vga_g   (rgb_g_dummy),
        .vga_b   (rgb_b_dummy),

        .video_on(video_on),
        .x(x_unused), .y(y_unused)
    );

    // Registramos HS/VS hacia pines
    always_ff @(posedge clk_pix or negedge RESET_N) begin
        if (!RESET_N) begin
            VGA_HS <= 1'b1;  // inactivo (negativo)
            VGA_VS <= 1'b1;
        end else begin
            VGA_HS <= hs_int;
            VGA_VS <= vs_int;
        end
    end

    // === Detector de borde en VSYNC para contar frames ===
    logic vs_d;
    always_ff @(posedge clk_pix or negedge RESET_N) begin
        if (!RESET_N) vs_d <= 1'b1;
        else          vs_d <= vs_int;
    end
    // Para polaridad negativa, VS va a 0 durante el pulso. Tomamos flanco de subida (0→1) al terminar el pulso.
    wire frame_edge = (~vs_d) & vs_int;

    // === Índice de color que avanza cada frame ===
    logic [2:0] color_idx;
    always_ff @(posedge clk_pix or negedge RESET_N) begin
        if (!RESET_N)          color_idx <= 3'd0;
        else if (frame_edge)   color_idx <= color_idx + 3'd1;
    end

    // === Mapa de colores ===
    logic [7:0] C_R, C_G, C_B;
    always_comb begin
        unique case (color_idx)
            3'd0: begin C_R=8'hFF; C_G=8'h00; C_B=8'h00; end // Rojo
            3'd1: begin C_R=8'h00; C_G=8'hFF; C_B=8'h00; end // Verde
            3'd2: begin C_R=8'h00; C_G=8'h00; C_B=8'hFF; end // Azul
            3'd3: begin C_R=8'hFF; C_G=8'hFF; C_B=8'h00; end // Amarillo
            3'd4: begin C_R=8'hFF; C_G=8'h00; C_B=8'hFF; end // Magenta
            3'd5: begin C_R=8'h00; C_G=8'hFF; C_B=8'hFF; end // Cian
            3'd6: begin C_R=8'hFF; C_G=8'hFF; C_B=8'hFF; end // Blanco
            default: begin C_R=8'h00; C_G=8'h00; C_B=8'h00; end // Negro
        endcase
    end

    // === Salida a pines: color sólido en zona visible; negro fuera ===
    always_ff @(posedge clk_pix or negedge RESET_N) begin
        if (!RESET_N) begin
            VGA_R <= '0; VGA_G <= '0; VGA_B <= '0;
        end else if (video_on) begin
            VGA_R <= C_R; VGA_G <= C_G; VGA_B <= C_B;
        end else begin
            VGA_R <= 8'h00; VGA_G <= 8'h00; VGA_B <= 8'h00;
        end
    end

endmodule
