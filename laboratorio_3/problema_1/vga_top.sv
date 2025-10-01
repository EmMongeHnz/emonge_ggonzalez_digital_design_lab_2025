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
    
    logic clk_pix;
    always_ff @(posedge CLOCK_50 or negedge RESET_N) begin
        if (!RESET_N) clk_pix <= 1'b0;
        else          clk_pix <= ~clk_pix;
    end

    assign VGA_CLK     = clk_pix;
    assign VGA_BLANK_N = 1'b1; 
    assign VGA_SYNC_N  = 1'b0; 

 //reset asincrono
    logic r1, r2;
    always_ff @(posedge clk_pix or negedge RESET_N) begin
        if (!RESET_N) begin r1 <= 1'b1; r2 <= 1'b1; end
        else begin r1 <= 1'b0; r2 <= r1; end
    end
    wire rst_pix = r2;

//señales de controlador
    logic       video_on;
    logic [7:0] rgb_r_dummy, rgb_g_dummy, rgb_b_dummy; 
    logic       hs_int, vs_int;
    logic [11:0] x_unused, y_unused;

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

        .rgb_in_r('0), .rgb_in_g('0), .rgb_in_b('0),

        .hsync   (hs_int),
        .vsync   (vs_int),
        .vga_r   (rgb_r_dummy),
        .vga_g   (rgb_g_dummy),
        .vga_b   (rgb_b_dummy),

        .video_on(video_on),
        .x(x_unused), .y(y_unused)
    );

    // registro hs/vs
    always_ff @(posedge clk_pix or negedge RESET_N) begin
        if (!RESET_N) begin
            VGA_HS <= 1'b1;  
            VGA_VS <= 1'b1;
        end else begin
            VGA_HS <= hs_int;
            VGA_VS <= vs_int;
        end
    end

    // detector vsync
    logic vs_d;
    always_ff @(posedge clk_pix or negedge RESET_N) begin
        if (!RESET_N) vs_d <= 1'b1;
        else          vs_d <= vs_int;
    end

    wire frame_edge = (~vs_d) & vs_int;

    //indice de color
    logic [2:0] color_idx;
    always_ff @(posedge clk_pix or negedge RESET_N) begin
        if (!RESET_N)          color_idx <= 3'd0;
        else if (frame_edge)   color_idx <= color_idx + 3'd1;
    end

    // mapa de colores
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

    // pinout
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
