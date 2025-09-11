// top_fpga_problema_1.sv
// Mapea A y B desde switches, alterna operación con botón y muestra en 7seg.

module top_fpga_problema_1 #(
  parameter int N = 4,
  parameter bit ACTIVE_LOW_7SEG = 1,
  parameter int CLK_HZ = 50_000_000
)(
  input  logic                 clk,
  input  logic                 rst_n,
  input  logic                 btn_next,         // alterna operación mostrada
  input  logic [N-1:0]         sw_a,
  input  logic [N-1:0]         sw_b,
  output logic [6:0]           HEX_A,            // gfedcba
  output logic [6:0]           HEX_B,
  output logic [6:0]           HEX_Y,
  output logic [3:0]           LED_FLAGS,        // {Z,N,C,V}
  output logic [3:0]           LED_OP            // opcional: código de op actual
);

  // === 7-seg para A y B (sólo nibble bajo) ===
  hex7seg_sv #(.ACTIVE_LOW_7SEG(ACTIVE_LOW_7SEG)) u_hex_a (
    .nibble(sw_a[3:0]), .seg(HEX_A)
  );
  hex7seg_sv #(.ACTIVE_LOW_7SEG(ACTIVE_LOW_7SEG)) u_hex_b (
    .nibble(sw_b[3:0]), .seg(HEX_B)
  );

  // === Calcula TODAS las operaciones en paralelo ===
  // Suma
  logic [N-1:0] y_add; logic z_add, n_add, c_add, v_add;
  sumador #(.N(N)) u_add (
    .A(sw_a), .B(sw_b), .Cin(1'b0),
    .Y(y_add), .Cout(), .Z(z_add), .Nf(n_add), .V(v_add), .C(c_add)
  );
  // Resta
  logic [N-1:0] y_sub; logic z_sub, n_sub, c_sub, v_sub; logic bout_sub;
  restador #(.N(N)) u_sub (
    .A(sw_a), .B(sw_b), .Bin(1'b0),
    .Y(y_sub), .Bout(bout_sub), .Z(z_sub), .Nf(n_sub), .V(v_sub), .C(c_sub)
  );
  // Multiplicación (por sumas) -> trunc N, overflow si bits altos ≠ 0
  logic [2*N-1:0] P2N;
  multiplicador_sumas #(.N(N)) u_mul (.A(sw_a), .B(sw_b), .P(P2N));
  logic [N-1:0]   y_mul_trunc;  logic mul_overflow;
  assign y_mul_trunc  = P2N[N-1:0];
  assign mul_overflow = |P2N[2*N-1:N];

  // División y Módulo
  logic [N-1:0] y_div, y_mod; logic div0;
  div_mod #(.N(N)) u_divmod (.A(sw_a), .B(sw_b), .Q(y_div), .R(y_mod), .div0(div0));

  // Lógicas / Shifts
  logic [N-1:0] y_and, y_or, y_xor, y_sll, y_srl;
  logic_ops #(.N(N)) u_logic (
    .A(sw_a), .B(sw_b),
    .ANDY(y_and), .ORY(y_or), .XORY(y_xor), .SLLY(y_sll), .SRLY(y_srl)
  );

  // === Selección de operación por botón ===
  // Mapa de opcodes:
  localparam int NUM_OPS = 10;
  localparam logic [3:0]
    OP_ADD = 4'd0, OP_SUB = 4'd1, OP_MUL = 4'd2, OP_DIV = 4'd3, OP_MOD = 4'd4,
    OP_AND = 4'd5, OP_OR  = 4'd6, OP_XOR = 4'd7, OP_SLL = 4'd8, OP_SRL = 4'd9;

  // Debounce + pulso
  logic next_pulse;
  btn_onepulse #(.CLK_HZ(CLK_HZ), .DEBOUNCE_MS(10)) u_next (
    .clk(clk), .rst_n(rst_n), .btn_in(btn_next), .pulse(next_pulse)
  );

  // Contador de operación (0..NUM_OPS-1)
  logic [3:0] sel_op;
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) sel_op <= OP_ADD;
    else if (next_pulse) sel_op <= (sel_op == (NUM_OPS-1)) ? 4'd0 : (sel_op + 4'd1);
  end
  assign LED_OP = sel_op;

  // === Mux del resultado y de las flags a mostrar ===
  logic [N-1:0] y_sel;
  logic [3:0]   f_sel; // {Z,N,C,V}

  always_comb begin
    unique case (sel_op)
      OP_ADD: begin y_sel=y_add; f_sel={z_add, n_add, c_add, v_add}; end
      OP_SUB: begin y_sel=y_sub; f_sel={z_sub, n_sub, c_sub, v_sub}; end
      OP_MUL: begin y_sel=y_mul_trunc; f_sel={ (y_mul_trunc=='0), y_mul_trunc[N-1], mul_overflow, 1'b0 }; end
      OP_DIV: begin y_sel=y_div;       f_sel={ (y_div=='0),       y_div[N-1],       1'b0,         1'b0 }; end
      OP_MOD: begin y_sel=y_mod;       f_sel={ (y_mod=='0),       y_mod[N-1],       1'b0,         1'b0 }; end
      OP_AND: begin y_sel=y_and;       f_sel={ (y_and=='0),       y_and[N-1],       1'b0,         1'b0 }; end
      OP_OR : begin y_sel=y_or;        f_sel={ (y_or=='0),        y_or[N-1],        1'b0,         1'b0 }; end
      OP_XOR: begin y_sel=y_xor;       f_sel={ (y_xor=='0),       y_xor[N-1],       1'b0,         1'b0 }; end
      OP_SLL: begin y_sel=y_sll;       f_sel={ (y_sll=='0),       y_sll[N-1],       1'b0,         1'b0 }; end
      OP_SRL: begin y_sel=y_srl;       f_sel={ (y_srl=='0),       y_srl[N-1],       1'b0,         1'b0 }; end
      default: begin y_sel='0;         f_sel=4'b0000; end
    endcase
  end
  assign LED_FLAGS = f_sel;

  // === 7-seg para el resultado seleccionado (nibble bajo) ===
  hex7seg_sv #(.ACTIVE_LOW_7SEG(ACTIVE_LOW_7SEG)) u_hex_y (
    .nibble(y_sel[3:0]), .seg(HEX_Y)
  );

endmodule
