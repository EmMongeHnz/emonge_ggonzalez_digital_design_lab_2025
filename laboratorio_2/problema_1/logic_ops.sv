// logic_ops.sv

module logic_ops #(
  parameter int N = 4
) (
  input  logic [N-1:0] A,
  input  logic [N-1:0] B,
  output logic [N-1:0] ANDY,
  output logic [N-1:0] ORY,
  output logic [N-1:0] XORY,
  output logic [N-1:0] SLLY,
  output logic [N-1:0] SRLY
);
  // ancho seguro para SHAMT (constante porque depende de N)
  localparam int S = (N <= 1) ? 1 : $clog2(N) + 1;

  wire [S-1:0] SHAMT;            // <-- declarar
  assign SHAMT = B[S-1:0];       // <-- asignar

  assign ANDY = A & B;
  assign ORY  = A | B;
  assign XORY = A ^ B;
  assign SLLY = A << SHAMT;
  assign SRLY = A >> SHAMT;      // lógico
endmodule
