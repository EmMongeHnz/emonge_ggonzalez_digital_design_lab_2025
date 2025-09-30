// mem_board.sv — Tablero 4×4 (8 parejas) — versión súper compatible Quartus 22.1std (Lite).
// - Sin arreglos unpacked, sin funciones/tasks, sin part-select variables.
// - do_shuffle: reinicia tablero a base fija 0..7,0..7 y cubre todas (sin aleatoriedad).
// - Estados: 0=cubierta, 1=abierta, 2=removida.

module mem_board(
    input  logic        clk,
    input  logic        rst,

    // Control desde FSM
    input  logic        do_shuffle,         // reinicia tablero base
    input  logic        do_close_nonmatch,  // cierra abiertas si no son par
    input  logic        req_open,           // abrir carta en idx (si está cubierta)
    input  logic [3:0]  idx,                // 0..15

    // Azar (no usado en esta versión, se mantiene por interfaz)
    input  logic [15:0] rnd,

    // Observación
    output logic [3:0]  sel_a,              // primera abierta (o F)
    output logic [3:0]  sel_b,              // segunda abierta (o F)
    output logic        two_open,           // hay dos abiertas
    output logic        is_match,           // abiertas hacen pareja
    output logic [16*4-1:0] tiles_id_flat,  // IDs empacados (16×4)
    output logic [16*2-1:0] tiles_st_flat,  // ST empacados (16×2)
    output logic [3:0]  pairs_left          // parejas restantes (0..8)
);

    // --------- Estado explícito por carta (IDs y estados) ---------
    logic [3:0] id0, id1, id2, id3, id4, id5, id6, id7,
                id8, id9, id10,id11,id12,id13,id14,id15;
    logic [1:0] st0, st1, st2, st3, st4, st5, st6, st7,
                st8, st9, st10,st11,st12,st13,st14,st15;

    // IDs leídos para comparar
    logic [3:0] ida, idb;

    // ---------- Reset / Shuffle (reinicio a base fija) ----------
    always_ff @(posedge clk) begin
        if (rst) begin
            // Base fija: 0..7, 0..7
            id0<=4'd0; id1<=4'd1; id2<=4'd2; id3<=4'd3; id4<=4'd4; id5<=4'd5; id6<=4'd6; id7<=4'd7;
            id8<=4'd0; id9<=4'd1; id10<=4'd2; id11<=4'd3; id12<=4'd4; id13<=4'd5; id14<=4'd6; id15<=4'd7;

            st0<=2'd0; st1<=2'd0; st2<=2'd0; st3<=2'd0; st4<=2'd0; st5<=2'd0; st6<=2'd0; st7<=2'd0;
            st8<=2'd0; st9<=2'd0; st10<=2'd0; st11<=2'd0; st12<=2'd0; st13<=2'd0; st14<=2'd0; st15<=2'd0;
        end else begin
            if (do_shuffle) begin
                // Reinicia a base fija y cubre todas
                id0<=4'd0; id1<=4'd1; id2<=4'd2; id3<=4'd3; id4<=4'd4; id5<=4'd5; id6<=4'd6; id7<=4'd7;
                id8<=4'd0; id9<=4'd1; id10<=4'd2; id11<=4'd3; id12<=4'd4; id13<=4'd5; id14<=4'd6; id15<=4'd7;

                st0<=2'd0; st1<=2'd0; st2<=2'd0; st3<=2'd0; st4<=2'd0; st5<=2'd0; st6<=2'd0; st7<=2'd0;
                st8<=2'd0; st9<=2'd0; st10<=2'd0; st11<=2'd0; st12<=2'd0; st13<=2'd0; st14<=2'd0; st15<=2'd0;
            end

            if (do_close_nonmatch) begin
                if (st0==2'd1) st0<=2'd0; if (st1==2'd1) st1<=2'd0;
                if (st2==2'd1) st2<=2'd0; if (st3==2'd1) st3<=2'd0;
                if (st4==2'd1) st4<=2'd0; if (st5==2'd1) st5<=2'd0;
                if (st6==2'd1) st6<=2'd0; if (st7==2'd1) st7<=2'd0;
                if (st8==2'd1) st8<=2'd0; if (st9==2'd1) st9<=2'd0;
                if (st10==2'd1) st10<=2'd0; if (st11==2'd1) st11<=2'd0;
                if (st12==2'd1) st12<=2'd0; if (st13==2'd1) st13<=2'd0;
                if (st14==2'd1) st14<=2'd0; if (st15==2'd1) st15<=2'd0;
            end

            if (req_open) begin
                case (idx)
                    4'd0:  if (st0 ==2'd0) st0 <= 2'd1;
                    4'd1:  if (st1 ==2'd0) st1 <= 2'd1;
                    4'd2:  if (st2 ==2'd0) st2 <= 2'd1;
                    4'd3:  if (st3 ==2'd0) st3 <= 2'd1;
                    4'd4:  if (st4 ==2'd0) st4 <= 2'd1;
                    4'd5:  if (st5 ==2'd0) st5 <= 2'd1;
                    4'd6:  if (st6 ==2'd0) st6 <= 2'd1;
                    4'd7:  if (st7 ==2'd0) st7 <= 2'd1;
                    4'd8:  if (st8 ==2'd0) st8 <= 2'd1;
                    4'd9:  if (st9 ==2'd0) st9 <= 2'd1;
                    4'd10: if (st10==2'd0) st10<= 2'd1;
                    4'd11: if (st11==2'd0) st11<= 2'd1;
                    4'd12: if (st12==2'd0) st12<= 2'd1;
                    4'd13: if (st13==2'd0) st13<= 2'd1;
                    4'd14: if (st14==2'd0) st14<= 2'd1;
                    default: if (st15==2'd0) st15<= 2'd1;
                endcase
            end

            // Aplicar "removidas" si hubo par
            if (two_open && is_match) begin
                case (sel_a)
                    4'd0:  st0<=2'd2; 4'd1:  st1<=2'd2; 4'd2:  st2<=2'd2; 4'd3:  st3<=2'd2;
                    4'd4:  st4<=2'd2; 4'd5:  st5<=2'd2; 4'd6:  st6<=2'd2; 4'd7:  st7<=2'd2;
                    4'd8:  st8<=2'd2; 4'd9:  st9<=2'd2; 4'd10: st10<=2'd2;4'd11: st11<=2'd2;
                    4'd12: st12<=2'd2;4'd13: st13<=2'd2;4'd14: st14<=2'd2;default: st15<=2'd2;
                endcase
                case (sel_b)
                    4'd0:  st0<=2'd2; 4'd1:  st1<=2'd2; 4'd2:  st2<=2'd2; 4'd3:  st3<=2'd2;
                    4'd4:  st4<=2'd2; 4'd5:  st5<=2'd2; 4'd6:  st6<=2'd2; 4'd7:  st7<=2'd2;
                    4'd8:  st8<=2'd2; 4'd9:  st9<=2'd2; 4'd10: st10<=2'd2;4'd11: st11<=2'd2;
                    4'd12: st12<=2'd2;4'd13: st13<=2'd2;4'd14: st14<=2'd2;default: st15<=2'd2;
                endcase
            end
        end
    end

    // ---------- Encontrar dos abiertas (combinacional puro) ----------
    always_comb begin
        sel_a    = 4'hF;
        sel_b    = 4'hF;
        two_open = 1'b0;

        if (st0==2'd1 && sel_a==4'hF) sel_a=4'd0; else if (st0==2'd1 && sel_b==4'hF) sel_b=4'd0;
        if (st1==2'd1 && sel_a==4'hF) sel_a=4'd1; else if (st1==2'd1 && sel_b==4'hF) sel_b=4'd1;
        if (st2==2'd1 && sel_a==4'hF) sel_a=4'd2; else if (st2==2'd1 && sel_b==4'hF) sel_b=4'd2;
        if (st3==2'd1 && sel_a==4'hF) sel_a=4'd3; else if (st3==2'd1 && sel_b==4'hF) sel_b=4'd3;
        if (st4==2'd1 && sel_a==4'hF) sel_a=4'd4; else if (st4==2'd1 && sel_b==4'hF) sel_b=4'd4;
        if (st5==2'd1 && sel_a==4'hF) sel_a=4'd5; else if (st5==2'd1 && sel_b==4'hF) sel_b=4'd5;
        if (st6==2'd1 && sel_a==4'hF) sel_a=4'd6; else if (st6==2'd1 && sel_b==4'hF) sel_b=4'd6;
        if (st7==2'd1 && sel_a==4'hF) sel_a=4'd7; else if (st7==2'd1 && sel_b==4'hF) sel_b=4'd7;
        if (st8==2'd1 && sel_a==4'hF) sel_a=4'd8; else if (st8==2'd1 && sel_b==4'hF) sel_b=4'd8;
        if (st9==2'd1 && sel_a==4'hF) sel_a=4'd9; else if (st9==2'd1 && sel_b==4'hF) sel_b=4'd9;
        if (st10==2'd1&& sel_a==4'hF) sel_a=4'd10;else if (st10==2'd1&& sel_b==4'hF) sel_b=4'd10;
        if (st11==2'd1&& sel_a==4'hF) sel_a=4'd11;else if (st11==2'd1&& sel_b==4'hF) sel_b=4'd11;
        if (st12==2'd1&& sel_a==4'hF) sel_a=4'd12;else if (st12==2'd1&& sel_b==4'hF) sel_b=4'd12;
        if (st13==2'd1&& sel_a==4'hF) sel_a=4'd13;else if (st13==2'd1&& sel_b==4'hF) sel_b=4'd13;
        if (st14==2'd1&& sel_a==4'hF) sel_a=4'd14;else if (st14==2'd1&& sel_b==4'hF) sel_b=4'd14;
        if (st15==2'd1&& sel_a==4'hF) sel_a=4'd15;else if (st15==2'd1&& sel_b==4'hF) sel_b=4'd15;

        if (sel_a!=4'hF && sel_b!=4'hF) two_open = 1'b1;
    end

    // ---------- ¿Hacen pareja? ----------
    always_comb begin
        // ida = ID(sel_a)
        case (sel_a)
            4'd0: ida=id0; 4'd1: ida=id1; 4'd2: ida=id2; 4'd3: ida=id3;
            4'd4: ida=id4; 4'd5: ida=id5; 4'd6: ida=id6; 4'd7: ida=id7;
            4'd8: ida=id8; 4'd9: ida=id9; 4'd10: ida=id10; 4'd11: ida=id11;
            4'd12: ida=id12;4'd13: ida=id13;4'd14: ida=id14; default: ida=id15;
        endcase
        // idb = ID(sel_b)
        case (sel_b)
            4'd0: idb=id0; 4'd1: idb=id1; 4'd2: idb=id2; 4'd3: idb=id3;
            4'd4: idb=id4; 4'd5: idb=id5; 4'd6: idb=id6; 4'd7: idb=id7;
            4'd8: idb=id8; 4'd9: idb=id9; 4'd10: idb=id10; 4'd11: idb=id11;
            4'd12: idb=id12;4'd13: idb=id13;4'd14: idb=id14; default: idb=id15;
        endcase
    end
    assign is_match = (two_open && (ida == idb));

    // ---------- Parejas restantes (removidas/2) ----------
    always_comb begin
        integer removed_i;
        integer cntpairs;   // parejas removidas = removed_i >> 1

        removed_i = 0;
        if (st0==2'd2)  removed_i=removed_i+1; if (st1==2'd2)  removed_i=removed_i+1;
        if (st2==2'd2)  removed_i=removed_i+1; if (st3==2'd2)  removed_i=removed_i+1;
        if (st4==2'd2)  removed_i=removed_i+1; if (st5==2'd2)  removed_i=removed_i+1;
        if (st6==2'd2)  removed_i=removed_i+1; if (st7==2'd2)  removed_i=removed_i+1;
        if (st8==2'd2)  removed_i=removed_i+1; if (st9==2'd2)  removed_i=removed_i+1;
        if (st10==2'd2) removed_i=removed_i+1; if (st11==2'd2) removed_i=removed_i+1;
        if (st12==2'd2) removed_i=removed_i+1; if (st13==2'd2) removed_i=removed_i+1;
        if (st14==2'd2) removed_i=removed_i+1; if (st15==2'd2) removed_i=removed_i+1;

        cntpairs = removed_i >> 1; // 0..8

        // pairs_left = 8 - cntpairs (evitamos [3:0] sobre expresiones)
        case (cntpairs)
            0: pairs_left = 4'd8;
            1: pairs_left = 4'd7;
            2: pairs_left = 4'd6;
            3: pairs_left = 4'd5;
            4: pairs_left = 4'd4;
            5: pairs_left = 4'd3;
            6: pairs_left = 4'd2;
            7: pairs_left = 4'd1;
            8: pairs_left = 4'd0;
            default: pairs_left = 4'd0;
        endcase
    end

    // ---------- Buses planos (concatenación) ----------
    assign tiles_id_flat = { id15,id14,id13,id12,id11,id10,id9,id8,
                             id7,id6,id5,id4,id3,id2,id1,id0 };

    assign tiles_st_flat = { st15,st14,st13,st12,st11,st10,st9,st8,
                             st7,st6,st5,st4,st3,st2,st1,st0 };

endmodule
