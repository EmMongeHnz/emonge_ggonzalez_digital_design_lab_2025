`timescale 1ns/1ps
module shift(
  input  logic        clk,
  input  logic        rst,
  output logic [15:0] rnd
);
  always_ff @(posedge clk or posedge rst) begin
    if (rst) rnd <= 16'hACE1;
    else     rnd <= {rnd[14:0], rnd[15]^rnd[13]^rnd[12]^rnd[10]};
  end
endmodule
