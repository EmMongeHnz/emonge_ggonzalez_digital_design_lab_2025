// debounce.sv — filtro simple (~5–10 ms a 25 MHz)
module debounce #(parameter int N = 20)(
  input  logic clk, input logic rst, input logic din, output logic dout
);
  logic s1,s2; always_ff @(posedge clk) if (rst) begin s1<=0; s2<=0; end else begin s1<=din; s2<=s1; end
  logic [N-1:0] cnt; logic st;
  always_ff @(posedge clk) begin
    if (rst) begin cnt<='0; st<=0; end
    else if (s2!=st) begin cnt<=cnt+1; if (&cnt) begin st<=s2; cnt<='0; end end
    else cnt<='0;
  end
  assign dout = st;
endmodule

// one_pulse.sv — pulso de 1 ciclo a flanco ↑
module one_pulse(input logic clk, input logic rst, input logic din, output logic pulse);
  logic d; always_ff @(posedge clk) if (rst) d<=0; else d<=din;
  assign pulse = din & ~d;
endmodule

// lfsr16.sv — taps 16,14,13,11
module lfsr16(input logic clk, input logic rst, output logic [15:0] rnd);
  logic [15:0] s;
  always_ff @(posedge clk) begin
    if (rst) s <= 16'hACE1;
    else     s <= {s[14:0], s[15]^s[13]^s[12]^s[10]};
  end
  assign rnd = s;
endmodule

// tickgen_1hz.sv — 1 Hz desde F_HZ (25e6 si ÷2 de 50 MHz)
module tickgen_1hz #(parameter int F_HZ=25_000_000)(
  input logic clk, input logic rst, output logic tick_1hz
);
  localparam int TC=F_HZ-1; logic [$clog2(F_HZ)-1:0] cnt;
  always_ff @(posedge clk) begin
    if (rst) begin cnt<='0; tick_1hz<=0; end
    else if (cnt==TC) begin cnt<='0; tick_1hz<=1; end
    else begin cnt<=cnt+1; tick_1hz<=0; end
  end
endmodule

// sevenseg_hex.sv — activo en 0
module sevenseg_hex(input logic [3:0] n, output logic [6:0] seg);
  always_comb case(n)
    4'h0: seg=7'b1000000; 4'h1: seg=7'b1111001; 4'h2: seg=7'b0100100; 4'h3: seg=7'b0110000;
    4'h4: seg=7'b0011001; 4'h5: seg=7'b0010010; 4'h6: seg=7'b0000010; 4'h7: seg=7'b1111000;
    4'h8: seg=7'b0000000; 4'h9: seg=7'b0010000; 4'hA: seg=7'b0001000; 4'hB: seg=7'b0000011;
    4'hC: seg=7'b1000110; 4'hD: seg=7'b0100001; 4'hE: seg=7'b0000110; 4'hF: seg=7'b0001110;
  endcase
endmodule
