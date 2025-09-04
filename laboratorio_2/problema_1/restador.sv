// restador.sv
// RESTA bit a bit con celdas de full-subtractor lógicas.
// Bin = borrow-in. Bout = borrow-out.
// FLAGS = {Z,N,C,V}; C = ~Bout (1 si NO hubo préstamo)
// V (overflow) = (signoA ^ signoB) & (signoA ^ signoY)

module restador #(
  parameter int N = 4
) (
  input  logic [N-1:0] A,
  input  logic [N-1:0] B,
  input  logic         Bin,      // borrow-in
  output logic [N-1:0] Y,
  output logic         Bout,     // borrow-out explícito
  output logic         Z,
  output logic         Nf,
  output logic         V,
  output logic         C         // C = ~Borrow
);

  logic [N:0] b; // b[i] = borrow-in del bit i; b[N] = borrow-out global
  assign b[0] = Bin;

  genvar i;
  generate
    for (i = 0; i < N; i++) begin : RB_SUB
      // Diferencia bit
      assign Y[i]   = A[i] ^ B[i] ^ b[i];
      // Borrow next = (~A & B) | ((~(A ^ B)) & borrow_in)
      assign b[i+1] = ((~A[i]) & B[i]) | ((~(A[i] ^ B[i])) & b[i]);
    end
  endgenerate

  assign Bout = b[N];
  assign C    = ~b[N];                     // convención típica: C=~Borrow
  assign Nf   = Y[N-1];
  assign Z    = ~(|Y);
  assign V    = (A[N-1] ^ B[N-1]) & (A[N-1] ^ Y[N-1]);

endmodule
