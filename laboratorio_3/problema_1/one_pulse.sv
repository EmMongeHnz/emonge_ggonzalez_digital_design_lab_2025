`timescale 1ns/1ps
module one_pulse(
  input  logic clk,
  input  logic rst,
  input  logic din,
  output logic pulse
);
  logic d1;
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      d1    <= 1'b0;
      pulse <= 1'b0;
    end else begin
      d1    <= din;
      pulse <= din & ~d1;
    end
  end
endmodule
