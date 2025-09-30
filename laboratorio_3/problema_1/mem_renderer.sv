// mem_renderer.sv — Renderizador 4×4 para juego de memoria en 640×480.
// - 16 tiles de 160×120 px.
// - Colores por ID, estados: 0=cubierta (gris), 1=abierta (color), 2=removida (negro).
// - Resalta sel_a / sel_b con borde blanco.
// - 100% combinacional, sin latches, compatible con Quartus 22.1std.

module mem_renderer(
    input  logic        clk_pix,        // no usado aquí (combinacional), se deja por interfaz
    input  logic        rst,            // no usado aquí (combinacional), se deja por interfaz
    input  logic        video_on,
    input  logic [11:0] x,
    input  logic [11:0] y,

    input  logic [16*4-1:0] tiles_id_flat, // {id15,id14,...,id0}, cada uno 4 bits
    input  logic [16*2-1:0] tiles_st_flat, // {st15,st14,...,st0}, cada uno 2 bits
    input  logic [3:0]      sel_a,
    input  logic [3:0]      sel_b,
    input  logic [3:0]      pairs_left,

    output logic [7:0]      vga_r,
    output logic [7:0]      vga_g,
    output logic [7:0]      vga_b
);

    // ========= Parámetros de geometría =========
    localparam int H_ACTIVE = 640;
    localparam int V_ACTIVE = 480;
    localparam int TILE_W   = 160;  // 640 / 4
    localparam int TILE_H   = 120;  // 480 / 4

    // ========= Desempaquetado fijo (part-selects CONSTANTES) =========
    // IDs (64 bits): [63:60]=id15 ... [3:0]=id0
    wire [3:0] id0  = tiles_id_flat[ 3: 0];
    wire [3:0] id1  = tiles_id_flat[ 7: 4];
    wire [3:0] id2  = tiles_id_flat[11: 8];
    wire [3:0] id3  = tiles_id_flat[15:12];
    wire [3:0] id4  = tiles_id_flat[19:16];
    wire [3:0] id5  = tiles_id_flat[23:20];
    wire [3:0] id6  = tiles_id_flat[27:24];
    wire [3:0] id7  = tiles_id_flat[31:28];
    wire [3:0] id8  = tiles_id_flat[35:32];
    wire [3:0] id9  = tiles_id_flat[39:36];
    wire [3:0] id10 = tiles_id_flat[43:40];
    wire [3:0] id11 = tiles_id_flat[47:44];
    wire [3:0] id12 = tiles_id_flat[51:48];
    wire [3:0] id13 = tiles_id_flat[55:52];
    wire [3:0] id14 = tiles_id_flat[59:56];
    wire [3:0] id15 = tiles_id_flat[63:60];

    // ST (32 bits): [31:30]=st15 ... [1:0]=st0
    wire [1:0] st0  = tiles_st_flat[ 1: 0];
    wire [1:0] st1  = tiles_st_flat[ 3: 2];
    wire [1:0] st2  = tiles_st_flat[ 5: 4];
    wire [1:0] st3  = tiles_st_flat[ 7: 6];
    wire [1:0] st4  = tiles_st_flat[ 9: 8];
    wire [1:0] st5  = tiles_st_flat[11:10];
    wire [1:0] st6  = tiles_st_flat[13:12];
    wire [1:0] st7  = tiles_st_flat[15:14];
    wire [1:0] st8  = tiles_st_flat[17:16];
    wire [1:0] st9  = tiles_st_flat[19:18];
    wire [1:0] st10 = tiles_st_flat[21:20];
    wire [1:0] st11 = tiles_st_flat[23:22];
    wire [1:0] st12 = tiles_st_flat[25:24];
    wire [1:0] st13 = tiles_st_flat[27:26];
    wire [1:0] st14 = tiles_st_flat[29:28];
    wire [1:0] st15 = tiles_st_flat[31:30];

    // ========= Señales intermedias =========
    logic [1:0] row;       // 0..3
    logic [1:0] col;       // 0..3
    logic [3:0] tile_idx;  // 0..15

    logic [11:0] x0;       // x origen del tile
    logic [11:0] y0;       // y origen del tile
    logic [11:0] xi;       // x dentro del tile
    logic [11:0] yi;       // y dentro del tile

    logic        border;   // borde de 1 px
    logic        highlight;// si es sel_a o sel_b

    logic [3:0]  id_sel;   // id del tile actual
    logic [1:0]  st_sel;   // estado del tile actual

    logic [7:0]  r, g, b;  // color calculado

    // ========= Cálculo de fila/columna por umbrales (sin divisiones) =========
    always_comb begin
        // Por defecto (evitar latches)
        row = 2'd3;
        col = 2'd3;

        if (y < 12'd120)      row = 2'd0;
        else if (y < 12'd240) row = 2'd1;
        else if (y < 12'd360) row = 2'd2;
        else                  row = 2'd3;

        if (x < 12'd160)      col = 2'd0;
        else if (x < 12'd320) col = 2'd1;
        else if (x < 12'd480) col = 2'd2;
        else                  col = 2'd3;
    end

    // Índice del tile: row*4 + col (sin multiplicadores genéricos)
    always_comb begin
        case (row)
            2'd0: tile_idx = {2'b00, col};                  // 0..3
            2'd1: tile_idx = 4'd4  + {2'b00, col};          // 4..7
            2'd2: tile_idx = 4'd8  + {2'b00, col};          // 8..11
            default: tile_idx = 4'd12 + {2'b00, col};       // 12..15
        endcase
    end

    // Orígenes de tile (x0,y0) por col/row (sin multiplicación)
    always_comb begin
        case (col)
            2'd0: x0 = 12'd0;
            2'd1: x0 = 12'd160;
            2'd2: x0 = 12'd320;
            default: x0 = 12'd480;
        endcase

        case (row)
            2'd0: y0 = 12'd0;
            2'd1: y0 = 12'd120;
            2'd2: y0 = 12'd240;
            default: y0 = 12'd360;
        endcase

        xi = x - x0;
        yi = y - y0;
    end

    // Borde de 1 px
    always_comb begin
        border = (xi == 12'd0) || (xi == 12'd159) || (yi == 12'd0) || (yi == 12'd119);
    end

    // ¿Tile seleccionado (abierto)? Resaltamos borde en blanco
    always_comb begin
        highlight = (tile_idx == sel_a) || (tile_idx == sel_b);
    end

    // Selección de ID/Estado del tile actual (case completo)
    always_comb begin
        id_sel = 4'd0;
        st_sel = 2'd0;
        case (tile_idx)
            4'd0:  begin id_sel=id0;  st_sel=st0;  end
            4'd1:  begin id_sel=id1;  st_sel=st1;  end
            4'd2:  begin id_sel=id2;  st_sel=st2;  end
            4'd3:  begin id_sel=id3;  st_sel=st3;  end
            4'd4:  begin id_sel=id4;  st_sel=st4;  end
            4'd5:  begin id_sel=id5;  st_sel=st5;  end
            4'd6:  begin id_sel=id6;  st_sel=st6;  end
            4'd7:  begin id_sel=id7;  st_sel=st7;  end
            4'd8:  begin id_sel=id8;  st_sel=st8;  end
            4'd9:  begin id_sel=id9;  st_sel=st9;  end
            4'd10: begin id_sel=id10; st_sel=st10; end
            4'd11: begin id_sel=id11; st_sel=st11; end
            4'd12: begin id_sel=id12; st_sel=st12; end
            4'd13: begin id_sel=id13; st_sel=st13; end
            4'd14: begin id_sel=id14; st_sel=st14; end
            default: begin id_sel=id15; st_sel=st15; end
        endcase
    end

    // Mapa de colores por ID (RGB 8-bit)
    function automatic void color_from_id(input logic [3:0] id, output logic [7:0] R, G, B);
        begin
            case (id)
                4'd0: begin R=8'hFF; G=8'h20; B=8'h20; end // rojo
                4'd1: begin R=8'h20; G=8'hFF; B=8'h20; end // verde
                4'd2: begin R=8'h20; G=8'h20; B=8'hFF; end // azul
                4'd3: begin R=8'hFF; G=8'hFF; B=8'h20; end // amarillo
                4'd4: begin R=8'hFF; G=8'h40; B=8'hFF; end // magenta
                4'd5: begin R=8'h20; G=8'hFF; B=8'hFF; end // cian
                4'd6: begin R=8'hFF; G=8'hFF; B=8'hFF; end // blanco
                default: begin R=8'hFF; G=8'hA0; B=8'h20; end // naranja
            endcase
        end
    endfunction

    // Color base del tile según estado
    always_comb begin
        // defaults (evita latches)
        r = 8'h00; g = 8'h00; b = 8'h00;

        if (!video_on) begin
            r = 8'h00; g = 8'h00; b = 8'h00;
        end else begin
            unique case (st_sel)
                2'd0: begin // cubierta
                    r = 8'h40; g = 8'h40; b = 8'h40; // gris
                end
                2'd1: begin // abierta
                    color_from_id(id_sel, r, g, b);
                end
                default: begin // removida u otros
                    r = 8'h00; g = 8'h00; b = 8'h00; // negro
                end
            endcase

            // Borde del tile
            if (border) begin
                // si es sel_a/sel_b → borde blanco
                if (highlight) begin
                    r = 8'hFF; g = 8'hFF; b = 8'hFF;
                end else begin
                    // borde estándar (gris claro)
                    r = 8'hB0; g = 8'hB0; b = 8'hB0;
                end
            end
        end
    end

    // Salida registrada opcionalmente (aquí dejamos combinacional directo)
    always_comb begin
        vga_r = r;
        vga_g = g;
        vga_b = b;
    end

endmodule
