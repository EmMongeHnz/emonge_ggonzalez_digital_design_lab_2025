// hex7seg_sv.sv  -- gfedcba, por defecto activo en bajo
module hex7seg_sv #(
  parameter bit ACTIVE_LOW_7SEG = 1
)(
  input  logic [3:0] nibble,
  output logic [6:0] seg  // g f e d c b a
);
  // Tabla típica "activa en bajo" (DE-series) para 0..F (gfedcba)
  logic [6:0] lo;
  always_comb begin
    unique case (nibble)
      4'h0: lo = 7'b1000000;
      4'h1: lo = 7'b1111001;
      4'h2: lo = 7'b0100100;
      4'h3: lo = 7'b0110000;
      4'h4: lo = 7'b0011001;
      4'h5: lo = 7'b0010010;
      4'h6: lo = 7'b0000010;
      4'h7: lo = 7'b1111000;
      4'h8: lo = 7'b0000000;
      4'h9: lo = 7'b0010000;
      4'hA: lo = 7'b0001000;
      4'hB: lo = 7'b0000011;
      4'hC: lo = 7'b1000110;
      4'hD: lo = 7'b0100001;
      4'hE: lo = 7'b0000110;
      4'hF: lo = 7'b0001110;
      default: lo = 7'b1111111;
    endcase
  end
  assign seg = (ACTIVE_LOW_7SEG) ? lo : ~lo;
endmodule
