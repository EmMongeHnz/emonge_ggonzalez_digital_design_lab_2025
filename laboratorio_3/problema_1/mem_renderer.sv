`timescale 1ns/1ps
module mem_renderer #(
  parameter int H_ACTIVE = 640,
  parameter int V_ACTIVE = 480
)(
  input  logic        clk_pix,
  input  logic        rst,
  input  logic        video_on,
  input  logic [11:0] x,
  input  logic [11:0] y,

  input  logic [3:0]  idx_sw,
  input  logic        turn_j1,
  input  logic [31:0] tiles_st_flat,   // 16 tiles * 2 bits

  output logic [7:0]  rgb_r,
  output logic [7:0]  rgb_g,
  output logic [7:0]  rgb_b
);
  localparam int COLS = 4;
  localparam int ROWS = 4;
  localparam int TILE_W = H_ACTIVE / COLS;   // 160
  localparam int TILE_H = V_ACTIVE / ROWS;   // 120

  // grosor de líneas de grilla y de borde de selección
  localparam int GRID_W   = 3;
  localparam int BORDER_W = 4;
  // margen interno de cada carta (deja un “aire” alrededor)
  localparam int TILE_MARGIN = 8;

  // columna / fila
  logic [1:0] c, r;
  always_comb begin
    if      (x < TILE_W*1) c = 2'd0;
    else if (x < TILE_W*2) c = 2'd1;
    else if (x < TILE_W*3) c = 2'd2;
    else                   c = 2'd3;

    if      (y < TILE_H*1) r = 2'd0;
    else if (y < TILE_H*2) r = 2'd1;
    else if (y < TILE_H*3) r = 2'd2;
    else                   r = 2'd3;
  end

  // índice y coords locales dentro del tile
  logic [3:0]  idx_cur;
  logic [11:0] x_in, y_in;
  always_comb begin
    idx_cur = {r, c}; // r*4 + c
    unique case (c)
      2'd0: x_in = x;
      2'd1: x_in = x - TILE_W;
      2'd2: x_in = x - (2*TILE_W);
      default: x_in = x - (3*TILE_W);
    endcase
    unique case (r)
      2'd0: y_in = y;
      2'd1: y_in = y - TILE_H;
      2'd2: y_in = y - (2*TILE_H);
      default: y_in = y - (3*TILE_H);
    endcase
  end

  // estado del tile actual
  logic [1:0] st_cur;
  always_comb st_cur = tiles_st_flat[2*idx_cur +: 2];

  // ¿estoy sobre una línea de la grilla?
  logic on_vgrid, on_hgrid, on_grid;
  always_comb begin
    on_vgrid = 1'b0;
    on_hgrid = 1'b0;

    // verticales en x = 160, 320, 480 (± GRID_W/2)
    if ((x >= TILE_W- (GRID_W>>1) && x < TILE_W+ (GRID_W - (GRID_W>>1))) ||
        (x >= 2*TILE_W- (GRID_W>>1) && x < 2*TILE_W+ (GRID_W - (GRID_W>>1))) ||
        (x >= 3*TILE_W- (GRID_W>>1) && x < 3*TILE_W+ (GRID_W - (GRID_W>>1)))) begin
      on_vgrid = 1'b1;
    end

    // horizontales en y = 120, 240, 360
    if ((y >= TILE_H- (GRID_W>>1) && y < TILE_H+ (GRID_W - (GRID_W>>1))) ||
        (y >= 2*TILE_H- (GRID_W>>1) && y < 2*TILE_H+ (GRID_W - (GRID_W>>1))) ||
        (y >= 3*TILE_H- (GRID_W>>1) && y < 3*TILE_H+ (GRID_W - (GRID_W>>1)))) begin
      on_hgrid = 1'b1;
    end

    on_grid = on_vgrid | on_hgrid;
  end

  // selección y borde
  logic is_selected, on_border;
  always_comb begin
    is_selected = (idx_cur == idx_sw);
    on_border   = (x_in < BORDER_W) || (x_in >= TILE_W-BORDER_W) ||
                  (y_in < BORDER_W) || (y_in >= TILE_H-BORDER_W);
  end

  // helpers de color
  function automatic void color_closed_hatch(
    input [11:0] xi, yi, input bit darken,
    output [7:0] r, g, b
  );
    logic hatch;
    begin
      hatch = xi[4] ^ yi[4];
      r = darken ? 8'd40 : 8'd60;
      g = hatch ? (darken ? 8'd40 : 8'd80) : (darken ? 8'd60 : 8'd100);
      b = darken ? 8'd40 : 8'd60;
    end
  endfunction

  function automatic void color_id(
    input [2:0] id,
    output [7:0] r, g, b
  );
    begin
      unique case (id)
        3'd0: begin r=8'hE0; g=8'h30; b=8'h30; end
        3'd1: begin r=8'h30; g=8'hE0; b=8'h30; end
        3'd2: begin r=8'h30; g=8'h30; b=8'hE0; end
        3'd3: begin r=8'hE0; g=8'hE0; b=8'h30; end
        3'd4: begin r=8'hE0; g=8'h30; b=8'hE0; end
        3'd5: begin r=8'h30; g=8'hE0; b=8'hE0; end
        3'd6: begin r=8'hE0; g=8'hE0; b=8'hE0; end
        default: begin r=8'hA0; g=8'h60; b=8'h20; end
      endcase
    end
  endfunction

  logic [7:0] r_pix, g_pix, b_pix;

  always_comb begin
    if (!video_on) begin
      r_pix=8'd0; g_pix=8'd0; b_pix=8'd0;
    end else begin
      // base: cartas con margen interno
      if (x_in < TILE_MARGIN || x_in >= TILE_W-TILE_MARGIN ||
          y_in < TILE_MARGIN || y_in >= TILE_H-TILE_MARGIN) begin
        // fuera del “área” de la carta → deja ver un borde/margen
        color_closed_hatch(x_in, y_in, /*darken*/1'b1, r_pix, g_pix, b_pix);
      end else begin
        unique case (st_cur)
          2'b00: color_closed_hatch(x_in, y_in, 1'b0, r_pix, g_pix, b_pix); // CLOSED
          2'b01: color_id(idx_cur[2:0], r_pix, g_pix, b_pix);               // OPEN
          default: begin r_pix=8'd0; g_pix=8'd0; b_pix=8'd0; end            // REMOVED
        endcase
      end

      // borde de selección
      if (is_selected && on_border) begin
        r_pix = 8'hFF;
        g_pix = turn_j1 ? 8'hFF : 8'h00; // verde/azul según turno
        b_pix = turn_j1 ? 8'h00 : 8'hFF;
      end

      // líneas de grilla (siempre por encima)
      if (on_grid) begin
        r_pix = 8'hF0; g_pix = 8'hF0; b_pix = 8'hF0; // blanco suave
      end
    end
  end

  always_ff @(posedge clk_pix or posedge rst) begin
    if (rst) begin rgb_r<='0; rgb_g<='0; rgb_b<='0; end
    else begin   rgb_r<=r_pix; rgb_g<=g_pix; rgb_b<=b_pix; end
  end
endmodule
