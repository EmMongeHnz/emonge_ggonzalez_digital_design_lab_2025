// multiplicador_sumas.sv
// Producto por suma iterativa con el módulo sumador (ripple-carry).
// No se usan '*' ni '+'; solo instancias de sumador y desplazamientos de cableado.

module multiplicador_sumas #(
  parameter int N = 4
) (
  input  logic [N-1:0] A,
  input  logic [N-1:0] B,
  output logic [2*N-1:0] P
);
  localparam int W = 2*N;

  // Acumuladores en cascada: acc[0]=0; acc[i+1]=acc[i] + (B[i] ? (A<<i) : 0)
  logic [W-1:0] acc [0:N];
  assign acc[0] = '0;

  genvar i;
  generate
    for (i = 0; i < N; i++) begin : GEN_MUL
      logic [W-1:0] partial;
      // Extiendo A a W bits y desplazo i posiciones (OK usar <<)
      assign partial = (B[i]) ? ( {{N{1'b0}}, A} << i ) : '0;

      // Suma con nuestro sumador de W bits (Cin=0)
      logic Z_d, Nf_d, V_d, C_d;
      sumador #(.N(W)) u_add_i (
        .A   (acc[i]),
        .B   (partial),
        .Cin (1'b0),
        .Y   (acc[i+1]),
        .Cout(), .Z(Z_d), .Nf(Nf_d), .V(V_d), .C(C_d)
      );
    end
  endgenerate

  assign P = acc[N];
endmodule
