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
  input  logic [31:0] tiles_st_flat,
  input  logic [63:0] tiles_id_flat,
  input  logic        show_winner,
  input  logic [3:0]  score_j1,
  input  logic [3:0]  score_j2,
  output logic [7:0]  rgb_r,
  output logic [7:0]  rgb_g,
  output logic [7:0]  rgb_b
);

  localparam int COLS = 4;
  localparam int ROWS = 4;

  localparam int TW_I = H_ACTIVE / COLS;
  localparam int TH_I = V_ACTIVE / ROWS;

  localparam logic [11:0] TILE_W   = TW_I[11:0];
  localparam logic [11:0] TILE_H   = TH_I[11:0];
  localparam logic [11:0] TILE_W2  = TILE_W << 1;
  localparam logic [11:0] TILE_W3  = TILE_W + TILE_W2;
  localparam logic [11:0] TILE_H2  = TILE_H << 1;
  localparam logic [11:0] TILE_H3  = TILE_H + TILE_H2;

  localparam int GRID_W    = 3;
  localparam int BORDER_W  = 4;
  localparam int TILE_MARGIN = 8;

  localparam int BOX_W  = H_ACTIVE/2;
  localparam int BOX_H  = V_ACTIVE/3;
  localparam int BOX_X0 = (H_ACTIVE-BOX_W)/2;
  localparam int BOX_Y0 = (V_ACTIVE-BOX_H)/2;

  localparam int S_SHIFT = 2;
  localparam int S       = (1 << S_SHIFT);
  localparam int SP      = (1*S);
  localparam int TEXT_W  = (5 + SP + 5 + SP + 5 + 5 + 5) * S;
  localparam int TEXT_H  = 7*S;

  localparam int TXT_X_P   = BOX_X0 + (BOX_W - TEXT_W)/2;
  localparam int TXT_Y     = BOX_Y0 + (BOX_H - TEXT_H)/2;
  localparam int TXT_X_DIG = TXT_X_P + (5*S) + SP;
  localparam int TXT_X_W   = TXT_X_DIG + (5*S) + SP;
  localparam int TXT_X_I   = TXT_X_W + (5*S);
  localparam int TXT_X_N   = TXT_X_I + (5*S);

  logic [1:0] c, r;
  logic [3:0] idx_cur;
  logic [11:0] x_in, y_in;
  logic [1:0] st_cur;
  logic [3:0] id_cur;

  logic on_vgrid, on_hgrid, on_grid;
  logic is_selected, on_border;

  int gxP, gyP, gxD, gyD, gxW, gyW, gxI, gyI, gxN, gyN;
  logic [3:0] glyph_sel;

  always_comb begin
    if      (x < TILE_W)   c = 2'd0;
    else if (x < TILE_W2)  c = 2'd1;
    else if (x < TILE_W3)  c = 2'd2;
    else                   c = 2'd3;

    if      (y < TILE_H)   r = 2'd0;
    else if (y < TILE_H2)  r = 2'd1;
    else if (y < TILE_H3)  r = 2'd2;
    else                   r = 2'd3;
  end

  always_comb begin
    idx_cur = {r, c};
    unique case (c)
      2'd0:    x_in = x;
      2'd1:    x_in = x - TILE_W;
      2'd2:    x_in = x - TILE_W2;
      default: x_in = x - TILE_W3;
    endcase
    unique case (r)
      2'd0:    y_in = y;
      2'd1:    y_in = y - TILE_H;
      2'd2:    y_in = y - TILE_H2;
      default: y_in = y - TILE_H3;
    endcase
  end

  always_comb begin
    st_cur = tiles_st_flat[2*idx_cur +: 2];
    id_cur = tiles_id_flat[4*idx_cur +: 4];
  end

  always_comb begin
    on_vgrid = 1'b0; on_hgrid = 1'b0;
    if ((x >= (TILE_W - (GRID_W>>1)))  && (x < (TILE_W  + (GRID_W - (GRID_W>>1)))))  on_vgrid = 1'b1;
    if ((x >= (TILE_W2 - (GRID_W>>1))) && (x < (TILE_W2 + (GRID_W - (GRID_W>>1))))) on_vgrid = 1'b1;
    if ((x >= (TILE_W3 - (GRID_W>>1))) && (x < (TILE_W3 + (GRID_W - (GRID_W>>1))))) on_vgrid = 1'b1;

    if ((y >= (TILE_H - (GRID_W>>1)))  && (y < (TILE_H  + (GRID_W - (GRID_W>>1)))))  on_hgrid = 1'b1;
    if ((y >= (TILE_H2 - (GRID_W>>1))) && (y < (TILE_H2 + (GRID_W - (GRID_W>>1))))) on_hgrid = 1'b1;
    if ((y >= (TILE_H3 - (GRID_W>>1))) && (y < (TILE_H3 + (GRID_W - (GRID_W>>1))))) on_hgrid = 1'b1;

    on_grid = on_vgrid | on_hgrid;
  end

  always_comb begin
    is_selected = (idx_cur == idx_sw);
    on_border   = (x_in < BORDER_W) || (x_in >= TILE_W-BORDER_W) ||
                  (y_in < BORDER_W) || (y_in >= TILE_H-BORDER_W);
  end

  function automatic void color_closed_hatch(
    input logic [11:0] xi, yi, input bit darken,
    output logic [7:0] r, g, b
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
    input logic [2:0] id,
    output logic [7:0] r, g, b
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

  function automatic bit glyph_5x7(
    input logic [3:0] glyph,
    input int gx, input int gy
  );
    bit [4:0] row;
    begin
      if (gy > 6 || gx > 4 || gy < 0 || gx < 0) begin
        glyph_5x7 = 1'b0;
      end else begin
        unique case (glyph)
          4'd0: begin
            case (gy)
              0: row = 5'b11110;
              1: row = 5'b10001;
              2: row = 5'b10001;
              3: row = 5'b11110;
              4: row = 5'b10000;
              5: row = 5'b10000;
              default: row = 5'b10000;
            endcase
          end
          4'd1: begin
            case (gy)
              0: row = 5'b00100;
              1: row = 5'b01100;
              2: row = 5'b00100;
              3: row = 5'b00100;
              4: row = 5'b00100;
              5: row = 5'b00100;
              default: row = 5'b01110;
            endcase
          end
          4'd2: begin
            case (gy)
              0: row = 5'b11110;
              1: row = 5'b00001;
              2: row = 5'b00001;
              3: row = 5'b11110;
              4: row = 5'b10000;
              5: row = 5'b10000;
              default: row = 5'b11111;
            endcase
          end
          4'd3: begin
            case (gy)
              0: row = 5'b10001;
              1: row = 5'b10001;
              2: row = 5'b10101;
              3: row = 5'b10101;
              4: row = 5'b10101;
              5: row = 5'b11011;
              default: row = 5'b10001;
            endcase
          end
          4'd4: begin
            case (gy)
              0: row = 5'b01110;
              1: row = 5'b00100;
              2: row = 5'b00100;
              3: row = 5'b00100;
              4: row = 5'b00100;
              5: row = 5'b00100;
              default: row = 5'b01110;
            endcase
          end
          default: begin
            case (gy)
              0: row = 5'b10001;
              1: row = 5'b11001;
              2: row = 5'b10101;
              3: row = 5'b10011;
              4: row = 5'b10001;
              5: row = 5'b10001;
              default: row = 5'b10001;
            endcase
          end
        endcase
        glyph_5x7 = row[4 - gx];
      end
    end
  endfunction

  logic [1:0] win_code;
  always_comb begin
    if (score_j1 > score_j2)      win_code = 2'b01;
    else if (score_j2 > score_j1) win_code = 2'b10;
    else                          win_code = 2'b00;
  end

  logic [7:0] r_pix, g_pix, b_pix;
  always_comb begin
    r_pix = 8'd0; g_pix = 8'd0; b_pix = 8'd0;
    gxP=0; gyP=0; gxD=0; gyD=0; gxW=0; gyW=0; gxI=0; gyI=0; gxN=0; gyN=0; glyph_sel=4'd0;

    if (!video_on) begin
    end else if (show_winner) begin
      if ((x >= BOX_X0) && (x < BOX_X0+BOX_W) &&
          (y >= BOX_Y0) && (y < BOX_Y0+BOX_H)) begin
        unique case (win_code)
          2'b01: begin r_pix=8'd0;   g_pix=8'd220; b_pix=8'd0;   end
          2'b10: begin r_pix=8'd0;   g_pix=8'd0;   b_pix=8'd220; end
          default: begin r_pix=8'd230; g_pix=8'd230; b_pix=8'd230; end
        endcase
      end
      if (win_code != 2'b00) begin
        if ((x >= TXT_X_P) && (x < (TXT_X_P + 5*S)) &&
            (y >= TXT_Y)   && (y < (TXT_Y   + 7*S))) begin
          gxP = (x - TXT_X_P) >> S_SHIFT;
          gyP = (y - TXT_Y)   >> S_SHIFT;
          if (glyph_5x7(4'd0, gxP, gyP)) begin
            r_pix = 8'd0; g_pix = 8'd0; b_pix = 8'd0;
          end
        end
        if ((x >= TXT_X_DIG) && (x < (TXT_X_DIG + 5*S)) &&
            (y >= TXT_Y)     && (y < (TXT_Y     + 7*S))) begin
          gxD = (x - TXT_X_DIG) >> S_SHIFT;
          gyD = (y - TXT_Y)     >> S_SHIFT;
          glyph_sel = (win_code==2'b10) ? 4'd2 : 4'd1;
          if (glyph_5x7(glyph_sel, gxD, gyD)) begin
            r_pix = 8'd0; g_pix = 8'd0; b_pix = 8'd0;
          end
        end
        if ((x >= TXT_X_W) && (x < (TXT_X_W + 5*S)) &&
            (y >= TXT_Y)   && (y < (TXT_Y   + 7*S))) begin
          gxW = (x - TXT_X_W) >> S_SHIFT;
          gyW = (y - TXT_Y)   >> S_SHIFT;
          if (glyph_5x7(4'd3, gxW, gyW)) begin
            r_pix = 8'd0; g_pix = 8'd0; b_pix = 8'd0;
          end
        end
        if ((x >= TXT_X_I) && (x < (TXT_X_I + 5*S)) &&
            (y >= TXT_Y)   && (y < (TXT_Y   + 7*S))) begin
          gxI = (x - TXT_X_I) >> S_SHIFT;
          gyI = (y - TXT_Y)   >> S_SHIFT;
          if (glyph_5x7(4'd4, gxI, gyI)) begin
            r_pix = 8'd0; g_pix = 8'd0; b_pix = 8'd0;
          end
        end
        if ((x >= TXT_X_N) && (x < (TXT_X_N + 5*S)) &&
            (y >= TXT_Y)   && (y < (TXT_Y   + 7*S))) begin
          gxN = (x - TXT_X_N) >> S_SHIFT;
          gyN = (y - TXT_Y)   >> S_SHIFT;
          if (glyph_5x7(4'd5, gxN, gyN)) begin
            r_pix = 8'd0; g_pix = 8'd0; b_pix = 8'd0;
          end
        end
      end
    end else begin
      if (x_in < TILE_MARGIN || x_in >= TILE_W - TILE_MARGIN ||
          y_in < TILE_MARGIN || y_in >= TILE_H - TILE_MARGIN) begin
        color_closed_hatch(x_in, y_in, 1'b1, r_pix, g_pix, b_pix);
      end else begin
        unique case (st_cur)
          2'b00: color_closed_hatch(x_in, y_in, 1'b0, r_pix, g_pix, b_pix);
          2'b01: color_id(id_cur[2:0], r_pix, g_pix, b_pix);
          default: begin r_pix=8'd0; g_pix=8'd0; b_pix=8'd0; end
        endcase
      end
      if (is_selected && on_border) begin
        r_pix = 8'hFF; g_pix = turn_j1 ? 8'hFF : 8'h00; b_pix = turn_j1 ? 8'h00 : 8'hFF;
      end
      if (on_grid) begin
        r_pix = 8'hF0; g_pix = 8'hF0; b_pix = 8'hF0;
      end
    end
  end

  always_ff @(posedge clk_pix or posedge rst) begin
    if (rst) begin rgb_r <= '0; rgb_g <= '0; rgb_b <= '0; end
    else begin   rgb_r <= r_pix; rgb_g <= g_pix; rgb_b <= b_pix; end
  end
endmodule
