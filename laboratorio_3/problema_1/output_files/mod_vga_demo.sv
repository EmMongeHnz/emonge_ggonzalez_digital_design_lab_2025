module mod_vga_demo (
    input  wire        CLK_50,      // reloj base de la placa (50 MHz)
    input  wire        KEY0_n,      // botón/reset activo bajo
    output wire        VGA_HS,
    output wire        VGA_VS,
    output wire [7:0]  VGA_R,
    output wire [7:0]  VGA_G,
    output wire [7:0]  VGA_B
);
    // --- Reloj de píxel mediante PLL (25.175 MHz aprox. o 25.0 MHz) ---
    wire clk_pix;
    wire pll_locked;

    // << Sustituir por tu IP de PLL >>
    pll_25m u_pll (
        .inclk0 (CLK_50),
        .c0     (clk_pix),   // ~25 MHz
        .locked (pll_locked)
    );

    // Reset sincrónico
    reg rst_n;
    always_ff @(posedge clk_pix or negedge pll_locked) begin
        if (!pll_locked) rst_n <= 1'b0;
        else             rst_n <= KEY0_n;  // usa el botón como reset global
    end

    // --- Núcleo VGA: 640x480@60, polaridad negativa (default) ---
    logic        de;
    logic [9:0]  x;  // clog2(640)=10
    logic [8:0]  y;  // clog2(480)=9

    vga_core #(
        .H_VISIBLE(640), .H_FP(16), .H_SYNC(96), .H_BP(48),
        .V_VISIBLE(480), .V_FP(10), .V_SYNC(2),  .V_BP(33),
        .HS_POL(1'b0), .VS_POL(1'b0)
    ) u_vga (
        .clk_pix   (clk_pix),
        .rst_n     (rst_n),
        .hsync     (VGA_HS),
        .vsync     (VGA_VS),
        .de        (de),
        .x         (x),
        .y         (y),
        .line_tick (),
        .frame_tick()
    );

    // --- Patrón de prueba simple: barras + damero ---
    // Solo dibujamos cuando de=1, fuera ponemos negro.
    logic [7:0] r,g,b;

    always_comb begin
        if (de) begin
            // Tres tercios horizontales: rojo / verde / azul
            if (x < 640/3) begin
                r = 8'hFF; g = 8'h00; b = 8'h00;
            end else if (x < 2*640/3) begin
                r = 8'h00; g = 8'hFF; b = 8'h00;
            end else begin
                r = 8'h00; g = 8'h00; b = 8'hFF;
            end

            // Superponer damero suave tomando bits de x,y
            if (x[5] ^ y[5]) begin
                r = r >> 1; g = g >> 1; b = b >> 1; // oscurecer cuadros alternos
            end
        end else begin
            r = 8'h00; g = 8'h00; b = 8'h00;
        end
    end

    assign VGA_R = r;
    assign VGA_G = g;
    assign VGA_B = b;

endmodule

// --- Placeholder del PLL ---
// Reemplázalo por el IP real generado con Quartus (ALTPLL).
module pll_25m (
    input  wire inclk0,
    output wire c0,
    output wire locked
);
    // Síntesis: reemplazar por tu instancia del IP.
    // Para simulación rápida podrías hacer:
    assign c0     = inclk0; // (solo simulación; NO en hardware real)
    assign locked = 1'b1;
endmodule
