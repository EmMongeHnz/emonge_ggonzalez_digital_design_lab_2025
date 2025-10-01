

module mem_fsm(
    input  logic        clk,
    input  logic        rst,

    //UI
    input  logic        evt_select,
    input  logic [3:0]  idx_in,

    //Estado del tablero
    input  logic        two_open,
    input  logic        is_match,
    input  logic [3:0]  pairs_left,
    input  logic [31:0] tiles_st_flat,   

    input  logic        tick_1hz,


    input  logic [15:0] rnd,

    //Acciones a tablero
    output logic        req_open,
    output logic        do_close_nonmatch,
    output logic [3:0]  idx_out,

    output logic        cur_player,    // 0=J1, 1=J2
    output logic [4:0]  sec_left,      // 15..0
    output logic [3:0]  score_j1,      // 0..8
    output logic [3:0]  score_j2,      // 0..8
    output logic        game_over
);


    typedef enum logic [1:0] { S_WAIT_FIRST, S_WAIT_SECOND, S_EVAL, S_GAMEOVER } state_t;
    state_t st, st_n;

    //registros
    logic        cur_pl, cur_pl_n;
    logic [4:0]  timer, timer_n;
    logic [3:0]  sc1, sc2, sc1_n, sc2_n;
    logic [3:0]  idx_latched, idx_latched_n;

    //input a tablero
    logic        req_open_n, close_n;
    logic [3:0]  idx_n;

  
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

    //verificacion carta disponible
    function automatic logic is_covered(input logic [3:0] k);
        logic cov;
        begin
            cov = 1'b0;
            unique case (k)
                4'd0: cov = (st0==2'd0);
                4'd1: cov = (st1==2'd0);
                4'd2: cov = (st2==2'd0);
                4'd3: cov = (st3==2'd0);
                4'd4: cov = (st4==2'd0);
                4'd5: cov = (st5==2'd0);
                4'd6: cov = (st6==2'd0);
                4'd7: cov = (st7==2'd0);
                4'd8: cov = (st8==2'd0);
                4'd9: cov = (st9==2'd0);
                4'd10: cov = (st10==2'd0);
                4'd11: cov = (st11==2'd0);
                4'd12: cov = (st12==2'd0);
                4'd13: cov = (st13==2'd0);
                4'd14: cov = (st14==2'd0);
                default: cov = (st15==2'd0);
            endcase
            is_covered = cov;
        end
    endfunction

    //elección automática
    function automatic logic [3:0] auto_pick_idx(input logic [3:0] seed);
        logic [3:0] k, res;
        logic       found;
        integer     t;
        begin
            res   = seed;
            found = 1'b0;
            k     = seed;
            for (t=0; t<16; t=t+1) begin
                if (!found && is_covered(k)) begin
                    res   = k;
                    found = 1'b1;
                end
                k = k + 4'd1;
            end
            auto_pick_idx = res; 
        end
    endfunction

    
    always_comb begin
      
        st_n      = st;
        cur_pl_n  = cur_pl;
        timer_n   = timer;
        sc1_n     = sc1;
        sc2_n     = sc2;
        idx_latched_n = idx_latched;

        req_open_n = 1'b0;
        close_n    = 1'b0;
        idx_n      = idx_in;   

        //fin del juego
        if (pairs_left == 4'd0) begin
            st_n = S_GAMEOVER;
        end

        case (st)
            
            S_WAIT_FIRST: begin
                if (tick_1hz && timer!=5'd0) timer_n = timer - 5'd1;

                if (evt_select) begin
                    if (is_covered(idx_in)) begin
                        req_open_n     = 1'b1;
                        idx_n          = idx_in;
                        idx_latched_n  = idx_in;
                        st_n           = S_WAIT_SECOND;
                        timer_n        = 5'd15;
                    end
                end else if (timer==5'd0) begin
                    logic [3:0] auto_idx;
                    auto_idx = auto_pick_idx(rnd[3:0]);  
                    idx_n    = auto_idx;
                    if (is_covered(idx_n)) begin
                        req_open_n     = 1'b1;
                        idx_latched_n  = idx_n;
                        st_n           = S_WAIT_SECOND;
                        timer_n        = 5'd15;
                    end else begin
                        st_n = S_EVAL;
                    end
                end
            end
          
            S_WAIT_SECOND: begin
                if (tick_1hz && timer!=5'd0) timer_n = timer - 5'd1;

                if (evt_select) begin
                    if (is_covered(idx_in)) begin
                        req_open_n = 1'b1;
                        idx_n      = idx_in;
                        st_n       = S_EVAL;
                    end
                end else if (timer==5'd0) begin
                    logic [3:0] auto_idx2;
                    auto_idx2 = auto_pick_idx(rnd[7:4]);
                    idx_n     = auto_idx2;
                    if (is_covered(idx_n)) begin
                        req_open_n = 1'b1;
                        st_n       = S_EVAL;
                    end else begin
                        st_n       = S_EVAL;
                    end
                end
            end
        
            S_EVAL: begin
                if (two_open && is_match) begin
                    if (cur_pl==1'b0) sc1_n = (sc1<4'd8)? (sc1+4'd1):sc1;
                    else               sc2_n = (sc2<4'd8)? (sc2+4'd1):sc2;
                    timer_n = 5'd15;      
                    st_n    = S_WAIT_FIRST;
                end else if (two_open && !is_match) begin
                    close_n   = 1'b1;     
                    cur_pl_n  = ~cur_pl;
                    timer_n   = 5'd15;
                    st_n      = S_WAIT_FIRST;
                end else begin
                    st_n = S_WAIT_FIRST;  
                end
            end
        
            default: begin 
                st_n = S_GAMEOVER;
            end
        endcase
    end

  
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            st           <= S_WAIT_FIRST;
            cur_pl       <= 1'b0;    
            timer        <= 5'd15;
            sc1          <= 4'd0;
            sc2          <= 4'd0;
            idx_latched  <= 4'd0;

            req_open         <= 1'b0;
            do_close_nonmatch<= 1'b0;
            idx_out          <= 4'd0;
        end else begin
            st          <= st_n;
            cur_pl      <= cur_pl_n;
            timer       <= timer_n;
            sc1         <= sc1_n;
            sc2         <= sc2_n;
            idx_latched <= idx_latched_n;

           
            req_open         <= req_open_n;
            do_close_nonmatch<= close_n;
            idx_out          <= idx_n;
        end
    end

   
    assign cur_player = cur_pl;
    assign sec_left   = timer;
    assign score_j1   = sc1;
    assign score_j2   = sc2;
    assign game_over  = (st==S_GAMEOVER);

endmodule
