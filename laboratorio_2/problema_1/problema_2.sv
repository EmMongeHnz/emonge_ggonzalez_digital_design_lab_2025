
module problema_2 #(
  parameter int N                  = 32,
  parameter int USE_INTERNAL_STIM  = 1, 
  parameter bit HAS_CIN        = 1
  )( 
  input  logic             clk,
  input  logic             rst_n,      
  input  logic             en_load,    
  input  logic [3:0]       op_code,

  input  logic [N-1:0]     ext_a,
  input  logic [N-1:0]     ext_b,
  input  logic             ext_cin,    

  output logic [N-1:0]     y_q,
  output logic [3:0]       flags_q
);

  logic [N-1:0] a_next, b_next;
  logic         cin_next;


  generate
    if (USE_INTERNAL_STIM) begin : GEN_PAT
      logic [N-1:0] a_pat, b_pat;
      logic         cin_pat;


      always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)               a_pat <= '0;
        else if (en_load)         a_pat <= a_pat + {{(N-1){1'b0}}, 1'b1};
      end

      
      always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)               b_pat <= {{(N-2){1'b0}}, 2'b01};
        else if (en_load)         b_pat <= b_pat + {{(N-2){1'b0}}, 2'b11};
      end

      
      always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)               cin_pat <= 1'b0;
        else if (en_load)         cin_pat <= ~cin_pat;
      end

      assign a_next   = a_pat;
      assign b_next   = b_pat;
      assign cin_next = cin_pat;
    end else begin : GEN_EXT
      assign a_next   = ext_a;
      assign b_next   = ext_b;
      assign cin_next = ext_cin;
    end
  endgenerate

  
  (* keep = "true" *) logic [N-1:0] a_qi, b_qi;
  (* keep = "true" *) logic         cin_qi;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      a_qi   <= '0;
      b_qi   <= '0;
      cin_qi <= 1'b0;
    end else if (en_load) begin
      a_qi   <= a_next;
      b_qi   <= b_next;
      cin_qi <= cin_next;
    end
  end

 
  logic [N-1:0] y_d;
  logic [3:0]   flags_d;

  
  generate
    if (HAS_CIN) begin : G_WITH_CIN
      alu_core #(.N(N)) DUT (
        .A      (a_qi),
        .B      (b_qi),
        .CIN_BIN(cin_qi),
        .OP     (op_code),
        .Y      (y_d),
        .FLAGS  (flags_d)
      );
    end else begin : G_NO_CIN
      alu_core #(.N(N)) DUT (
        .A      (a_qi),
        .B      (b_qi),
        .OP     (op_code),
        .Y      (y_d),
        .FLAGS  (flags_d)
      );
    end
  endgenerate

  
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      y_q     <= '0;
      flags_q <= '0;
    end else begin
      y_q     <= y_d;
      flags_q <= flags_d;
    end
  end

endmodule
