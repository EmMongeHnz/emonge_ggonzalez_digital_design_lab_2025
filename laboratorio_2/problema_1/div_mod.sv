module div_mod #(
  parameter int N = 4
) (
  input  logic [N-1:0] A,
  input  logic [N-1:0] B,
  output logic [N-1:0] Q,
  output logic [N-1:0] R,
  output logic         div0
);
  assign div0 = (B == '0);
  assign Q    = div0 ? '0 : (A / B);   
  assign R    = div0 ? A  : (A % B);
endmodule
