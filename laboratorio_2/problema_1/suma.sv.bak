// sumador.sv
// SUMA bit a bit con celdas de full-adder lógicas.
// FLAGS = {Z,N,C,V}; C = carry-out; V = carry_in_MSB XOR carry_out_MSB

module sumador #(
  parameter int N = 4
) (
  input  logic [N-1:0] A,
  input  logic [N-1:0] B,
  input  logic         Cin,
  output logic [N-1:0] Y,
  output logic         Cout,
  output logic         Z,
  output logic         Nf,
  output logic         V,
  output logic         C
);

  logic [N:0] c; // c[i] = carry-in del bit i; c[N] = carry-out global
  assign c[0] = Cin;

  genvar i;
  generate
    for (i = 0; i < N; i++) begin : RC_ADD
      // Sum bit
      assign Y[i]   = A[i] ^ B[i] ^ c[i];
      // Carry next = mayorías
      assign c[i+1] = (A[i] & B[i]) | (A[i] & c[i]) | (B[i] & c[i]);
    end
  endgenerate

  assign Cout = c[N];
  assign C    = c[N];
  assign Nf   = Y[N-1];
  assign Z    = ~(|Y);                // reducción OR
  assign V    = c[N] ^ c[N-1];        // overflow = carry_in_MSB XOR carry_out_MSB

endmodule
