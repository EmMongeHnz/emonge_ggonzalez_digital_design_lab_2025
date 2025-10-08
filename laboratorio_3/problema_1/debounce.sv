`timescale 1ns/1ps
module debounce #(
  parameter int N_CYCLES = 50_000
)(
  input  logic clk, rst,
  input  logic din,
  output logic dout
);
  logic [$clog2(N_CYCLES)-1:0] cnt;
  logic q;
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin cnt<='0; q<=1'b0; dout<=1'b0; end
    else begin
      if (din!=q) begin q<=din; cnt<='0; end
      else if (cnt!=N_CYCLES-1) cnt<=cnt+1'b1;
      if (cnt==N_CYCLES-1) dout<=q;
    end
  end
endmodule
