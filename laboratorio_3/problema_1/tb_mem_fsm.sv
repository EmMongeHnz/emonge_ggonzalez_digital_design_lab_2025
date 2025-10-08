`timescale 1ns/1ps
module tb_mem_fsm;

  // ===== Reloj y reset =====
  logic clk = 1'b0;
  always #5 clk = ~clk;          // 100 MHz (10 ns)

  logic rst = 1'b1;
  initial begin
    repeat (5) @(posedge clk);
    rst = 1'b0;
  end

  // ===== Constantes del tablero =====
  localparam int  N       = 16;
  localparam [1:0] ST_COV = 2'd0;   // cubierta
  localparam [1:0] ST_OPEN= 2'd1;   // abierta
  localparam [1:0] ST_REM = 2'd2;   // removida

  // ===== Señales DUT =====
  logic        evt_select;
  logic [3:0]  idx_in;

  logic        two_open;
  logic        is_match;
  logic [3:0]  pairs_left;
  logic [N*2-1:0] tiles_st_flat;

  logic        tick_1hz;
  logic [15:0] rnd;

  logic        req_open;
  logic [3:0]  idx_out;
  logic        do_close_nonmatch;
  logic        cur_player;
  logic [4:0]  sec_left;
  logic [3:0]  score_j1, score_j2;
  logic        game_over;

  // ===== Instancia DUT =====
  mem_fsm u_dut (
    .clk, .rst,
    .evt_select, .idx_in,
    .two_open, .is_match, .pairs_left, .tiles_st_flat,
    .tick_1hz, .rnd,
    .req_open, .idx_out, .do_close_nonmatch,
    .cur_player, .sec_left, .score_j1, .score_j2, .game_over
  );

  // ===== LFSR simple para rnd =====
  always_ff @(posedge clk or posedge rst) begin
    if (rst) rnd <= 16'h1ACE;
    else     rnd <= {rnd[14:0], rnd[15]^rnd[13]^rnd[12]^rnd[10]};
  end

  // ===== Modelo de tablero =====
  logic [1:0] st0, st1, st2, st3, st4, st5, st6, st7,
              st8, st9, st10, st11, st12, st13, st14, st15;

  logic [3:0] id0, id1, id2, id3, id4, id5, id6, id7,
              id8, id9, id10, id11, id12, id13, id14, id15;

  initial begin
    id0=0; id1=1; id2=2; id3=3; id4=4; id5=5; id6=6; id7=7;
    id8=0; id9=1; id10=2; id11=3; id12=4; id13=5; id14=6; id15=7;

    evt_select = 1'b0;
    idx_in     = 4'd0;
    tick_1hz   = 1'b0;
  end

  // Empaquetado en el bus plano esperado por el DUT
  assign tiles_st_flat = {
    st15, st14, st13, st12, st11, st10, st9, st8,
    st7,  st6,  st5,  st4,  st3,  st2,  st1, st0
  };

  function automatic [1:0] rd_st(input [3:0] i);
    case (i)
      4'd0: rd_st = st0;   4'd1: rd_st = st1;   4'd2: rd_st = st2;   4'd3: rd_st = st3;
      4'd4: rd_st = st4;   4'd5: rd_st = st5;   4'd6: rd_st = st6;   4'd7: rd_st = st7;
      4'd8: rd_st = st8;   4'd9: rd_st = st9;   4'd10: rd_st = st10; 4'd11: rd_st = st11;
      4'd12: rd_st = st12; 4'd13: rd_st = st13; 4'd14: rd_st = st14; 4'd15: rd_st = st15;
      default: rd_st = ST_COV;
    endcase
  endfunction

  task automatic wr_st(input [3:0] i, input [1:0] v);
    case (i)
      4'd0: st0=v;  4'd1: st1=v;  4'd2: st2=v;  4'd3: st3=v;
      4'd4: st4=v;  4'd5: st5=v;  4'd6: st6=v;  4'd7: st7=v;
      4'd8: st8=v;  4'd9: st9=v;  4'd10: st10=v; 4'd11: st11=v;
      4'd12: st12=v;4'd13: st13=v;4'd14: st14=v;4'd15: st15=v;
    endcase
  endtask

  function automatic [3:0] rd_id(input [3:0] i);
    case (i)
      4'd0: rd_id = id0;   4'd1: rd_id = id1;   4'd2: rd_id = id2;   4'd3: rd_id = id3;
      4'd4: rd_id = id4;   4'd5: rd_id = id5;   4'd6: rd_id = id6;   4'd7: rd_id = id7;
      4'd8: rd_id = id8;   4'd9: rd_id = id9;   4'd10: rd_id = id10; 4'd11: rd_id = id11;
      4'd12: rd_id = id12; 4'd13: rd_id = id13; 4'd14: rd_id = id14; 4'd15: rd_id = id15;
      default: rd_id = 4'h0;
    endcase
  endfunction

  // Detección de dos abiertas y match
  logic [3:0] sel_a, sel_b;
  always_comb begin
    sel_a = 4'hF; sel_b = 4'hF; two_open = 1'b0;
    if (rd_st(0)==ST_OPEN)  begin if (sel_a==4'hF) sel_a=4'd0;  else if (sel_b==4'hF) sel_b=4'd0;  end
    if (rd_st(1)==ST_OPEN)  begin if (sel_a==4'hF) sel_a=4'd1;  else if (sel_b==4'hF) sel_b=4'd1;  end
    if (rd_st(2)==ST_OPEN)  begin if (sel_a==4'hF) sel_a=4'd2;  else if (sel_b==4'hF) sel_b=4'd2;  end
    if (rd_st(3)==ST_OPEN)  begin if (sel_a==4'hF) sel_a=4'd3;  else if (sel_b==4'hF) sel_b=4'd3;  end
    if (rd_st(4)==ST_OPEN)  begin if (sel_a==4'hF) sel_a=4'd4;  else if (sel_b==4'hF) sel_b=4'd4;  end
    if (rd_st(5)==ST_OPEN)  begin if (sel_a==4'hF) sel_a=4'd5;  else if (sel_b==4'hF) sel_b=4'd5;  end
    if (rd_st(6)==ST_OPEN)  begin if (sel_a==4'hF) sel_a=4'd6;  else if (sel_b==4'hF) sel_b=4'd6;  end
    if (rd_st(7)==ST_OPEN)  begin if (sel_a==4'hF) sel_a=4'd7;  else if (sel_b==4'hF) sel_b=4'd7;  end
    if (rd_st(8)==ST_OPEN)  begin if (sel_a==4'hF) sel_a=4'd8;  else if (sel_b==4'hF) sel_b=4'd8;  end
    if (rd_st(9)==ST_OPEN)  begin if (sel_a==4'hF) sel_a=4'd9;  else if (sel_b==4'hF) sel_b=4'd9;  end
    if (rd_st(10)==ST_OPEN) begin if (sel_a==4'hF) sel_a=4'd10; else if (sel_b==4'hF) sel_b=4'd10; end
    if (rd_st(11)==ST_OPEN) begin if (sel_a==4'hF) sel_a=4'd11; else if (sel_b==4'hF) sel_b=4'd11; end
    if (rd_st(12)==ST_OPEN) begin if (sel_a==4'hF) sel_a=4'd12; else if (sel_b==4'hF) sel_b=4'd12; end
    if (rd_st(13)==ST_OPEN) begin if (sel_a==4'hF) sel_a=4'd13; else if (sel_b==4'hF) sel_b=4'd13; end
    if (rd_st(14)==ST_OPEN) begin if (sel_a==4'hF) sel_a=4'd14; else if (sel_b==4'hF) sel_b=4'd14; end
    if (rd_st(15)==ST_OPEN) begin if (sel_a==4'hF) sel_a=4'd15; else if (sel_b==4'hF) sel_b=4'd15; end
    if (sel_a!=4'hF && sel_b!=4'hF) two_open = 1'b1;
  end

  assign is_match = (two_open && (rd_id(sel_a) == rd_id(sel_b)));

  // Parejas restantes
  always_comb begin
    int rem; rem = 0;
    rem += (st0==ST_REM);  rem += (st1==ST_REM);  rem += (st2==ST_REM);  rem += (st3==ST_REM);
    rem += (st4==ST_REM);  rem += (st5==ST_REM);  rem += (st6==ST_REM);  rem += (st7==ST_REM);
    rem += (st8==ST_REM);  rem += (st9==ST_REM);  rem += (st10==ST_REM); rem += (st11==ST_REM);
    rem += (st12==ST_REM); rem += (st13==ST_REM); rem += (st14==ST_REM); rem += (st15==ST_REM);
    pairs_left = 4'd8 - (rem >> 1);
  end

  // Dinámica del tablero (abre solo con req_open)
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      st0<=ST_COV; st1<=ST_COV; st2<=ST_COV; st3<=ST_COV;
      st4<=ST_COV; st5<=ST_COV; st6<=ST_COV; st7<=ST_COV;
      st8<=ST_COV; st9<=ST_COV; st10<=ST_COV; st11<=ST_COV;
      st12<=ST_COV; st13<=ST_COV; st14<=ST_COV; st15<=ST_COV;
    end else begin
      if (req_open) begin
        if (rd_st(idx_out)==ST_COV) wr_st(idx_out, ST_OPEN);
      end
      if (do_close_nonmatch) begin
        if (st0==ST_OPEN) st0<=ST_COV;   if (st1==ST_OPEN) st1<=ST_COV;
        if (st2==ST_OPEN) st2<=ST_COV;   if (st3==ST_OPEN) st3<=ST_COV;
        if (st4==ST_OPEN) st4<=ST_COV;   if (st5==ST_OPEN) st5<=ST_COV;
        if (st6==ST_OPEN) st6<=ST_COV;   if (st7==ST_OPEN) st7<=ST_COV;
        if (st8==ST_OPEN) st8<=ST_COV;   if (st9==ST_OPEN) st9<=ST_COV;
        if (st10==ST_OPEN) st10<=ST_COV; if (st11==ST_OPEN) st11<=ST_COV;
        if (st12==ST_OPEN) st12<=ST_COV; if (st13==ST_OPEN) st13<=ST_COV;
        if (st14==ST_OPEN) st14<=ST_COV; if (st15==ST_OPEN) st15<=ST_COV;
      end
      if (two_open && is_match) begin
        wr_st(sel_a, ST_REM);
        wr_st(sel_b, ST_REM);
      end
    end
  end

  // ===== Utilidades =====
  task automatic one_sec_tick;
    tick_1hz = 1'b1; @(posedge clk);
    tick_1hz = 1'b0; @(posedge clk);
  endtask

  task automatic exhaust_timer;
    int s; for (s=0; s<15; s=s+1) one_sec_tick();
  endtask

  task automatic press_select(input [3:0] idx);
    idx_in = idx; evt_select = 1'b1; @(posedge clk);
    evt_select = 1'b0; @(posedge clk);
  endtask

  task automatic wait_until_ref(ref logic cond, input int max_cyc, input string msg);
    int t; begin
      t = 0;
      while (!cond && t < max_cyc) begin @(posedge clk); t++; end
      if (!cond) begin
        $error("TIMEOUT: %s (tras %0d ciclos) t=%0t", msg, max_cyc, $time);
        $fatal;
      end
    end
  endtask

  // Contador de aperturas solicitadas por la FSM
  int opens_cnt;
  logic req_open_q;
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      opens_cnt <= 0;
      req_open_q <= 1'b0;
    end else begin
      req_open_q <= req_open;
      if (!req_open_q && req_open) opens_cnt <= opens_cnt + 1;
    end
  end

  // ---- Señales de espera ----
  logic cond_removed_mid, cond_removed_last, cond_closed, cond_autoopen, cond_gameover, cond_score_up;
  logic cond_two_opens;
  int   opens_target;

  logic [3:0] a_ref, b_ref;
  logic [4:0] total_before;
  logic [3:0] pairs_prev;
  int         opens_base;

  always_comb begin
    cond_removed_mid = ((rd_st(a_ref)==ST_REM && rd_st(b_ref)==ST_REM) ||
                        (pairs_left < pairs_prev) || game_over);
    cond_removed_last= (pairs_left==0 || game_over ||
                        ((score_j1 + score_j2) > total_before) ||
                        (rd_st(a_ref)==ST_REM && rd_st(b_ref)==ST_REM));
    cond_closed      = (two_open==1'b0);
    cond_autoopen    = (opens_cnt > opens_base);
    cond_gameover    = (game_over==1'b1);
    cond_score_up    = ((score_j1 + score_j2) > total_before);
    cond_two_opens   = (opens_cnt >= opens_target);
  end

  function automatic bit find_next_pair(output logic [3:0] a, output logic [3:0] b);
    int i, j; bit ok; logic [3:0] ida, idb;
    ok = 0; a = '1; b = '1;
    for (i=0; i<16 && !ok; i++) begin
      if (rd_st(i[3:0])!=ST_REM) begin
        ida = rd_id(i[3:0]);
        for (j=i+1; j<16 && !ok; j++) begin
          if (rd_st(j[3:0])!=ST_REM) begin
            idb = rd_id(j[3:0]);
            if (ida==idb) begin
              a = i[3:0]; b = j[3:0]; ok = 1;
            end
          end
        end
      end
    end
    return ok;
  endfunction

  // ===== Plan de pruebas =====
  initial begin : MAIN
    logic [3:0] a, b, x, y;
    int         k;
    logic       last_pair;

    @(negedge rst); @(posedge clk);

    // TEST 1
    if (!find_next_pair(a,b)) $fatal(1, "No se encontró par inicial válido");
    press_select(a); press_select(b);
    opens_target = opens_cnt + 2;
    wait_until_ref(cond_two_opens, 10000, "FSM no abrió dos cartas");
    a_ref = a; b_ref = b; pairs_prev = pairs_left; total_before = score_j1 + score_j2;
    wait_until_ref(cond_removed_mid, 12000, "remover par inicial");
    wait_until_ref(cond_score_up,     6000, "incremento de puntaje tras match inicial");

    // TEST 2: fallo
    x = '1; y = '1;
    for (k=0; k<16; k++)  if (rd_st(k[3:0])!=ST_REM) begin x=k[3:0]; break; end
    for (k=15; k>=0; k--) if (rd_st(k[3:0])!=ST_REM && rd_id(k[3:0])!=rd_id(x)) begin y=k[3:0]; break; end
    if (x!=='1 && y!=='1) begin
      press_select(x); press_select(y);
      opens_target = opens_cnt + 2;
      wait_until_ref(cond_two_opens, 10000, "FSM no abrió dos cartas (fallo)");
      wait_until_ref(cond_closed,     9000, "cierre tras fallo");
    end

    // TEST 3: auto-open por timeout
    opens_base = opens_cnt;
    begin int s; for (s=0; s<15; s=s+1) one_sec_tick(); end
    wait_until_ref(cond_autoopen, 20000, "auto-open por timeout");

    // TEST 4: terminar el juego
    while (pairs_left != 0) begin
      if (!find_next_pair(a,b)) $fatal(1, "Inconsistencia: no hay par pero pairs_left!=0");
      last_pair = (pairs_left == 4'd1);
      press_select(a); press_select(b);
      opens_target = opens_cnt + 2;
      wait_until_ref(cond_two_opens, 12000, "FSM no abrió dos cartas (cierre)");
      a_ref = a; b_ref = b; pairs_prev = pairs_left; total_before = score_j1 + score_j2;
      if (last_pair)
        wait_until_ref(cond_removed_last, 40000, "remover último par / game_over");
      else
        wait_until_ref(cond_removed_mid,  16000, $sformatf("remover par (%0d,%0d)", a, b));
    end

    wait_until_ref(cond_gameover, 40000, "game_over");
    $display("\n>>> TODOS LOS TESTS PASARON <<<\n");
    $finish;
  end

  // ===== Trazas =====
  logic [3:0] s1q, s2q; logic cpq;
  always @(posedge clk) begin
    if (req_open)          $display("[%0t] req_open idx=%0d", $time, idx_out);
    if (two_open)          $display("[%0t] two_open is_match=%0b (sel_a=%0d sel_b=%0d)", $time, is_match, sel_a, sel_b);
    if (do_close_nonmatch) $display("[%0t] close_nonmatch", $time);
    if (s1q!=score_j1)     $display("[%0t] score_j1=%0d", $time, score_j1);
    if (s2q!=score_j2)     $display("[%0t] score_j2=%0d", $time, score_j2);
    if (cpq!=cur_player)   $display("[%0t] turno=%s sec_left=%0d", $time, cur_player?"J2":"J1", sec_left);
    s1q<=score_j1; s2q<=score_j2; cpq<=cur_player;
  end

endmodule
