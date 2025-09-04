// btn_onepulse.sv  -- debounce + pulso de 1 ciclo en flanco ascendente
module btn_onepulse #(
  parameter int CLK_HZ = 50_000_000,
  parameter int DEBOUNCE_MS = 10
)(
  input  logic clk,
  input  logic rst_n,
  input  logic btn_in,      // botón crudo (asíncrono)
  output logic pulse        // pulso 1 ciclo por cada "click"
);
  // Sincronizador 2 FF
  logic s0, s1;
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin s0<=0; s1<=0; end
    else begin s0<=btn_in; s1<=s0; end
  end

  // Debounce por contador
  localparam int DB_CYC = (CLK_HZ/1000)*DEBOUNCE_MS;
  logic deb_state;
  logic [$clog2(DB_CYC+1)-1:0] cnt;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      deb_state <= 1'b0; cnt <= '0;
    end else if (s1 == deb_state) begin
      cnt <= '0;
    end else begin
      if (cnt == DB_CYC[$clog2(DB_CYC+1)-1:0]) begin
        deb_state <= s1;
        cnt <= '0;
      end else begin
        cnt <= cnt + 1'b1;
      end
    end
  end

  // One-pulse
  logic deb_state_q;
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) deb_state_q <= 1'b0;
    else        deb_state_q <= deb_state;
  end
  assign pulse = (deb_state & ~deb_state_q);
endmodule
