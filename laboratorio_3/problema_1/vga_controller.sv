// vga_controller.sv
// Wrapper de timing + generador de color (patrón de prueba opcional).
// Compatible con Quartus (usa generate/endgenerate y función fuera del generate).

module vga_controller #(
    // Timing (por defecto 640x480@60)
    parameter int H_ACTIVE = 640, parameter int V_ACTIVE = 480,
    parameter int H_FP=16, parameter int H_SYNC=96, parameter int H_BP=48,
    parameter int V_FP=10, parameter int V_SYNC=2,  parameter int V_BP=33,
    parameter bit HS_POL=1'b0, parameter bit VS_POL=1'b0,

    // Profundidad de color por canal (DE10-Standard → 10)
    parameter int N_COLOR_BITS = 10,

    // 1 = usa patrón de prueba; 0 = pasa rgb_in
    parameter bit USE_TEST_PATTERN = 1'b1
)(
    input  logic                           clk_pix,
    input  logic                           rst,

    input  logic [N_COLOR_BITS-1:0]        rgb_in_r,
    input  logic [N_COLOR_BITS-1:0]        rgb_in_g,
    input  logic [N_COLOR_BITS-1:0]        rgb_in_b,

    output logic                           hsync,
    output logic                           vsync,
    output logic [N_COLOR_BITS-1:0]        vga_r,
    output logic [N_COLOR_BITS-1:0]        vga_g,
    output logic [N_COLOR_BITS-1:0]        vga_b,

    output logic                           video_on,
    output logic [11:0]                    x,
    output logic [11:0]                    y
);

    // --- Instancia de timing ---
    vga_timing #(
        .H_ACTIVE(H_ACTIVE), .V_ACTIVE(V_ACTIVE),
        .H_FP(H_FP), .H_SYNC(H_SYNC), .H_BP(H_BP),
        .V_FP(V_FP), .V_SYNC(V_SYNC), .V_BP(V_BP),
        .HS_POL(HS_POL), .VS_POL(VS_POL)
    ) u_timing (
        .clk_pix (clk_pix),
        .rst     (rst),
        .hsync   (hsync),
        .vsync   (vsync),
        .video_on(video_on),
        .x       (x),
        .y       (y),
        .line_tick(), .frame_tick()
    );

    // --- Colores internos ---
    logic [N_COLOR_BITS-1:0] test_r, test_g, test_b;

    // Función de gradiente (fuera del generate)
    function automatic [N_COLOR_BITS-1:0] grad(input [11:0] xx);
        int maxv; int val;
        begin
            maxv = (1<<N_COLOR_BITS) - 1;
            val  = (H_ACTIVE>1) ? (xx * maxv) / (H_ACTIVE-1) : 0;
            grad = logic'(val[N_COLOR_BITS-1:0]);
        end
    endfunction

    // --- Bloque generate compatible ---
    generate
        if (USE_TEST_PATTERN) begin : g_test
            localparam int BARS  = 8;
            localparam int SEG_W = (H_ACTIVE / BARS);

            logic [2:0] bar_sel;
            always_comb begin
                if      (x < SEG_W*1) bar_sel = 3'd0;
                else if (x < SEG_W*2) bar_sel = 3'd1;
                else if (x < SEG_W*3) bar_sel = 3'd2;
                else if (x < SEG_W*4) bar_sel = 3'd3;
                else if (x < SEG_W*5) bar_sel = 3'd4;
                else if (x < SEG_W*6) bar_sel = 3'd5;
                else if (x < SEG_W*7) bar_sel = 3'd6;
                else                   bar_sel = 3'd7;
            end

            always_comb begin
                unique case (bar_sel)
                    3'd0: begin test_r = {N_COLOR_BITS{1'b1}}; test_g = '0;                        test_b = '0;                        end
                    3'd1: begin test_r = '0;                        test_g = {N_COLOR_BITS{1'b1}}; test_b = '0;                        end
                    3'd2: begin test_r = '0;                        test_g = '0;                        test_b = {N_COLOR_BITS{1'b1}}; end
                    3'd3: begin test_r = {N_COLOR_BITS{1'b1}}; test_g = {N_COLOR_BITS{1'b1}}; test_b = '0;                        end
                    3'd4: begin test_r = {N_COLOR_BITS{1'b1}}; test_g = '0;                        test_b = {N_COLOR_BITS{1'b1}}; end
                    3'd5: begin test_r = '0;                        test_g = {N_COLOR_BITS{1'b1}}; test_b = {N_COLOR_BITS{1'b1}}; end
                    3'd6: begin test_r = {N_COLOR_BITS{1'b1}}; test_g = {N_COLOR_BITS{1'b1}}; test_b = {N_COLOR_BITS{1'b1}}; end
                    default: begin test_r = '0; test_g = '0; test_b = '0; end
                endcase
                // gradiente suave en G
                test_g = (test_g >> 2) + (grad(x) >> 2);
            end
        end else begin : g_bypass
            always_comb begin
                test_r = rgb_in_r;
                test_g = rgb_in_g;
                test_b = rgb_in_b;
            end
        end
    endgenerate

    // Salida: negro fuera de video_on
    always_ff @(posedge clk_pix) begin
        if (rst) begin
            vga_r <= '0; vga_g <= '0; vga_b <= '0;
        end else if (video_on) begin
            vga_r <= test_r;
            vga_g <= test_g;
            vga_b <= test_b;
        end else begin
            vga_r <= '0;
            vga_g <= '0;
            vga_b <= '0;
        end
    end

endmodule
