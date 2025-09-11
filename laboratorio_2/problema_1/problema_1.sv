module alu_core #(
  parameter int N = 16
) (
  input  logic [N-1:0] A,
  input  logic [N-1:0] B,
  input  logic         CIN_BIN,
  input  logic  [3:0]  OP,    
  output logic [N-1:0] Y,
  output logic  [3:0]  FLAGS
);

  localparam logic [3:0]
    OP_ADD = 4'd0, OP_SUB = 4'd1, OP_MUL = 4'd2, OP_DIV = 4'd3, OP_MOD = 4'd4,
    OP_AND = 4'd5, OP_OR  = 4'd6, OP_XOR = 4'd7, OP_SLL = 4'd8, OP_SRL = 4'd9;

  // ---- SUMA/RESTA ----
  logic [N-1:0] y_add, y_sub;
  logic z_add, n_add, c_add, v_add;
  logic z_sub, n_sub, c_sub, v_sub, bout_sub;

  sumador  #(.N(N)) u_add(.A(A), .B(B), .Cin(CIN_BIN),
                          .Y(y_add), .Cout(), .Z(z_add), .Nf(n_add), .V(v_add), .C(c_add));

  restador #(.N(N)) u_sub(.A(A), .B(B), .Bin(CIN_BIN),
                          .Y(y_sub), .Bout(bout_sub), .Z(z_sub), .Nf(n_sub), .V(v_sub), .C(c_sub));

  // ---- MULTIPLICACIÓN por sumas ----
  logic [2*N-1:0] P2N;
  multiplicador_sumas #(.N(N)) u_mul (.A(A), .B(B), .P(P2N));

  logic [N-1:0] y_mul_trunc;
  logic         mul_overflow;
  assign y_mul_trunc  = P2N[N-1:0];
  assign mul_overflow = |P2N[2*N-1:N];

  // ---- DIV / MOD ----
  logic [N-1:0] Q_div, R_mod; logic div0;
  div_mod #(.N(N)) u_divmod(.A(A), .B(B), .Q(Q_div), .R(R_mod), .div0(div0));

  // ---- LÓGICAS / SHIFTS ----
  logic [N-1:0] y_and, y_or, y_xor, y_sll, y_srl;
  logic_ops #(.N(N)) u_logic (.A(A), .B(B), .ANDY(y_and), .ORY(y_or), .XORY(y_xor), .SLLY(y_sll), .SRLY(y_srl));

  // ---- MUX de resultado y flags ----
  always_comb begin
    unique case (OP)
      OP_ADD: begin Y=y_add;       FLAGS={z_add, n_add, c_add, v_add}; end
      OP_SUB: begin Y=y_sub;       FLAGS={z_sub, n_sub, c_sub, v_sub}; end
      OP_MUL: begin Y=y_mul_trunc; FLAGS={ (y_mul_trunc=='0), y_mul_trunc[N-1], mul_overflow, 1'b0 }; end
      OP_DIV: begin Y=Q_div;       FLAGS={ (Q_div=='0),       Q_div[N-1],       1'b0,         1'b0 }; end
      OP_MOD: begin Y=R_mod;       FLAGS={ (R_mod=='0),       R_mod[N-1],       1'b0,         1'b0 }; end
      OP_AND: begin Y=y_and;       FLAGS={ (y_and=='0),       y_and[N-1],       1'b0,         1'b0 }; end
      OP_OR : begin Y=y_or;        FLAGS={ (y_or=='0),        y_or[N-1],        1'b0,         1'b0 }; end
      OP_XOR: begin Y=y_xor;       FLAGS={ (y_xor=='0),       y_xor[N-1],       1'b0,         1'b0 }; end
      OP_SLL: begin Y=y_sll;       FLAGS={ (y_sll=='0),       y_sll[N-1],       1'b0,         1'b0 }; end
      OP_SRL: begin Y=y_srl;       FLAGS={ (y_srl=='0),       y_srl[N-1],       1'b0,         1'b0 }; end
      default: begin Y='0;         FLAGS=4'b0; end
    endcase
  end
endmodule


module problema_1 #(
  parameter int N = 4,
  parameter bit ACTIVE_LOW_7SEG = 1,
  parameter int CLK_HZ = 50_000_000
)(
  input  logic                 clk,
  input  logic                 rst_n,
  input  logic                 btn_next,         
  input  logic [N-1:0]         sw_a,
  input  logic [N-1:0]         sw_b,
  output logic [6:0]           HEX_A,           
  output logic [6:0]           HEX_B,
  output logic [6:0]           HEX_Y,
  output logic [3:0]           LED_FLAGS,       
  output logic [3:0]           LED_OP            
);

  logic next_pulse;
  btn_onepulse #(.CLK_HZ(CLK_HZ), .DEBOUNCE_MS(10)) u_btn (
    .clk(clk), .rst_n(rst_n), .btn_in(btn_next), .pulse(next_pulse)
  );

  localparam int NUM_OPS = 10;
  logic [3:0] op_sel;
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) op_sel <= 4'd0;
    else if (next_pulse) op_sel <= (op_sel == (NUM_OPS-1)) ? 4'd0 : (op_sel + 4'd1);
  end
  assign LED_OP = op_sel;


  logic [N-1:0] y;
  logic [3:0]   flags;
  alu_core #(.N(N)) u_alu (
    .A(sw_a),
    .B(sw_b),
    .CIN_BIN(1'b0),   
    .OP(op_sel),
    .Y(y),
    .FLAGS(flags)
  );
  assign LED_FLAGS = flags;


  hex7seg_sv #(.ACTIVE_LOW_7SEG(ACTIVE_LOW_7SEG)) u_hex_a (.nibble(sw_a[3:0]), .seg(HEX_A));
  hex7seg_sv #(.ACTIVE_LOW_7SEG(ACTIVE_LOW_7SEG)) u_hex_b (.nibble(sw_b[3:0]), .seg(HEX_B));
  hex7seg_sv #(.ACTIVE_LOW_7SEG(ACTIVE_LOW_7SEG)) u_hex_y (.nibble(y[3:0]),    .seg(HEX_Y));
endmodule
