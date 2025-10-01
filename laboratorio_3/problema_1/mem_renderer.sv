module mem_renderer(
    input  logic        clk_pix,        
    input  logic        rst,           
    input  logic        video_on,
    input  logic [11:0] x,
    input  logic [11:0] y,

    input  logic [16*4-1:0] tiles_id_flat, 
    input  logic [16*2-1:0] tiles_st_flat, 
    input  logic [3:0]      sel_a,
    input  logic [3:0]      sel_b,
    input  logic [3:0]      pairs_left,

    output logic [7:0]      vga_r,
    output logic [7:0]      vga_g,
    output logic [7:0]      vga_b
);

    //geometria
    localparam int H_ACTIVE = 640;
    localparam int V_ACTIVE = 480;
    localparam int TILE_W   = 160; 
    localparam int TILE_H   = 120; 

    // desempaquetado
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

    // señales intermedias
    logic [1:0] row;       
    logic [1:0] col;       
    logic [3:0] tile_idx;  

    logic [11:0] x0;       
    logic [11:0] y0;       
    logic [11:0] xi;      
    logic [11:0] yi;      

    logic        border;   
    logic        highlight;

    logic [3:0]  id_sel;   
    logic [1:0]  st_sel;   

    logic [7:0]  r, g, b; 

    always_comb begin
        
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

    always_comb begin
        case (row)
            2'd0: tile_idx = {2'b00, col};                
            2'd1: tile_idx = 4'd4  + {2'b00, col};         
            2'd2: tile_idx = 4'd8  + {2'b00, col};          
            default: tile_idx = 4'd12 + {2'b00, col};       
        endcase
    end

    
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


    always_comb begin
        border = (xi == 12'd0) || (xi == 12'd159) || (yi == 12'd0) || (yi == 12'd119);
    end

   
    always_comb begin
        highlight = (tile_idx == sel_a) || (tile_idx == sel_b);
    end

    // seleccion id
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

    // mapa de colores
    function automatic void color_from_id(input logic [3:0] id, output logic [7:0] R, G, B);
        begin
            case (id)
                4'd0: begin R=8'hFF; G=8'h20; B=8'h20; end 
                4'd1: begin R=8'h20; G=8'hFF; B=8'h20; end 
                4'd2: begin R=8'h20; G=8'h20; B=8'hFF; end 
                4'd3: begin R=8'hFF; G=8'hFF; B=8'h20; end 
                4'd4: begin R=8'hFF; G=8'h40; B=8'hFF; end 
                4'd5: begin R=8'h20; G=8'hFF; B=8'hFF; end 
                4'd6: begin R=8'hFF; G=8'hFF; B=8'hFF; end 
                default: begin R=8'hFF; G=8'hA0; B=8'h20; end 
            endcase
        end
    endfunction

    
    always_comb begin
     
        r = 8'h00; g = 8'h00; b = 8'h00;

        if (!video_on) begin
            r = 8'h00; g = 8'h00; b = 8'h00;
        end else begin
            unique case (st_sel)
                2'd0: begin 
                    r = 8'h40; g = 8'h40; b = 8'h40;
                end
                2'd1: begin 
                    color_from_id(id_sel, r, g, b);
                end
                default: begin // removida u otros
                    r = 8'h00; g = 8'h00; b = 8'h00;
                end
            endcase

   
            if (border) begin
     
                if (highlight) begin
                    r = 8'hFF; g = 8'hFF; b = 8'hFF;
                end else begin
           
                    r = 8'hB0; g = 8'hB0; b = 8'hB0;
                end
            end
        end
    end


    always_comb begin
        vga_r = r;
        vga_g = g;
        vga_b = b;
    end

endmodule
