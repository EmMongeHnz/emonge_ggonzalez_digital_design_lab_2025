// vga_timing.sv
// Generador de sincronismos VGA parametrizable.
// Produce: hsync, vsync, video_on, x, y, line_tick, frame_tick.

module vga_timing #(
    // Resolución visible
    parameter int H_ACTIVE = 640,
    parameter int V_ACTIVE = 480,

    // Porciones horizontales (en píxeles)
    parameter int H_FP  = 16,    // front porch
    parameter int H_SYNC= 96,    // pulso HS
    parameter int H_BP  = 48,    // back porch

    // Porciones verticales (en líneas)
    parameter int V_FP  = 10,    // front porch
    parameter int V_SYNC= 2,     // pulso VS
    parameter int V_BP  = 33,    // back porch

    // Polaridades (1 = activo en alto, 0 = activo en bajo)
    parameter bit HS_POL = 1'b0,
    parameter bit VS_POL = 1'b0
)(
    input  logic        clk_pix,     // pixel clock
    input  logic        rst,         // reset síncrono a clk_pix (alto)

    output logic        hsync,
    output logic        vsync,
    output logic        video_on,
    output logic [11:0] x,
    output logic [11:0] y,
    output logic        line_tick,
    output logic        frame_tick
);

    localparam int H_TOTAL = H_ACTIVE + H_FP + H_SYNC + H_BP;
    localparam int V_TOTAL = V_ACTIVE + V_FP + V_SYNC + V_BP;

    // Contadores
    always_ff @(posedge clk_pix) begin
        if (rst) begin
            x <= '0;
            y <= '0;
        end else begin
            if (x == H_TOTAL-1) begin
                x <= 12'd0;
                if (y == V_TOTAL-1)
                    y <= 12'd0;
                else
                    y <= y + 12'd1;
            end else begin
                x <= x + 12'd1;
            end
        end
    end

    // Ventanas de sincronismo
    wire hsync_window = (x >= (H_ACTIVE + H_FP)) && (x < (H_ACTIVE + H_FP + H_SYNC));
    wire vsync_window = (y >= (V_ACTIVE + V_FP)) && (y < (V_ACTIVE + V_FP + V_SYNC));

    // Aplicar polaridad
    always_ff @(posedge clk_pix) begin
        if (rst) begin
            hsync <= HS_POL ? 1'b0 : 1'b1; // estado inactivo
            vsync <= VS_POL ? 1'b0 : 1'b1;
        end else begin
            hsync <= HS_POL ? hsync_window : ~hsync_window;
            vsync <= VS_POL ? vsync_window : ~vsync_window;
        end
    end

    // Zona visible
    always_ff @(posedge clk_pix) begin
        if (rst) video_on <= 1'b0;
        else     video_on <= (x < H_ACTIVE) && (y < V_ACTIVE);
    end

    assign line_tick  = (x == H_TOTAL-1);
    assign frame_tick = line_tick && (y == V_TOTAL-1);

endmodule
