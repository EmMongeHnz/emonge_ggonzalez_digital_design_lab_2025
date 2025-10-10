`timescale 1ns/1ps
module turn_timer #(
  parameter int unsigned START_FROM = 15,
  parameter int unsigned DIV_1HZ    = 25_000_000
)(
  input  logic clk, rst,
  input  logic tick_1hz,
  input  logic timer_start,
  input  logic timer_clear,
  output logic [4:0] sec_left,
  output logic       time_expired
);

  logic tick;
  generate
    if (DIV_1HZ == 1) begin : g_no_div
      assign tick = 1'b1;
    end else begin : g_div
      logic [$clog2(DIV_1HZ)-1:0] divcnt;
      always_ff @(posedge clk or posedge rst) begin
        if (rst)                      divcnt <= '0;
        else if (divcnt == DIV_1HZ-1) divcnt <= '0;
        else                          divcnt <= divcnt + 1'b1;
      end
      assign tick = (divcnt == DIV_1HZ-1);
    end
  endgenerate

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      sec_left     <= START_FROM[4:0];
      time_expired <= 1'b0;
    end else begin
      time_expired <= 1'b0;
      if (timer_clear) begin
        sec_left <= START_FROM[4:0];
      end else if (timer_start && tick) begin
        if (sec_left != 0) sec_left <= sec_left - 1'b1;
        else               time_expired <= 1'b1;
      end
    end
  end
endmodule
