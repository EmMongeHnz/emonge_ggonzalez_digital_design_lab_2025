// =============================================================
// problema_1_with_hex_fpga.sv
// - problema_1   : binario (a[3:0]) -> Gray (z[3:0])
// - hex7seg      : decodificador 7-seg HEX SIN 'case' (one-hot + OR)
// - top_de10_std : TOP de FPGA con puertos SW[3:0] y HEX0[6:0]
//                  (HEX0 está en {g,f,e,d,c,b,a}, activo-bajo típico)
// =============================================================

// -------- Binario -> Gray ------------------------------------
module problema_1 #(
	parameter bit ACTIVE_HIGH = 1
)(
	input  logic [3:0] a,
	output logic [3:0] z,
	output logic [6:0] seg_abcd
);
	always_comb begin
		z[3] = a[3];
		z[2] = a[3] ^ a[2];
		z[1] = a[2] ^ a[1];
		z[0] = a[1] ^ a[0];
	end
	
	  // 4 → 16 one-hot
	logic [15:0] D;
	assign D = 16'h0001 << z;

	// Segmentos (activo-alto interno)
	logic seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g;

	// a: 0,2,3,5,6,7,8,9,A,C,E,F
	assign seg_a = D[0] | D[2] | D[3] | D[5] | D[6] | D[7] | D[8] | D[9] | D[10] | D[12] | D[14] | D[15];
	// b: 0,1,2,3,4,7,8,9,A,D
	assign seg_b = D[0] | D[1] | D[2] | D[3] | D[4] | D[7] | D[8] | D[9] | D[10] | D[13];
	// c: 0,1,3,4,5,6,7,8,9,A,B,D
	assign seg_c = D[0] | D[1] | D[3] | D[4] | D[5] | D[6] | D[7] | D[8] | D[9] | D[10] | D[11] | D[13];
	// d: 0,2,3,5,6,8,9,B,C,D,E
	assign seg_d = D[0] | D[2] | D[3] | D[5] | D[6] | D[8] | D[9] | D[11] | D[12] | D[13] | D[14];
	// e: 0,2,6,8,A,B,C,D,E,F
	assign seg_e = D[0] | D[2] | D[6] | D[8] | D[10] | D[11] | D[12] | D[13] | D[14] | D[15];
	// f: 0,4,5,6,8,9,A,B,C,E,F
	assign seg_f = D[0] | D[4] | D[5] | D[6] | D[8] | D[9] | D[10] | D[11] | D[12] | D[14] | D[15];
	// g: 2,3,4,5,6,8,9,A,B,D,E,F
	assign seg_g = D[2] | D[3] | D[4] | D[5] | D[6] | D[8] | D[9] | D[10] | D[11] | D[13] | D[14] | D[15];

	// Ensamble y ajuste de polaridad (¡en asignación continua para evitar X!)
	logic [6:0] on;
	assign on = {seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g};
	assign seg_abcd = (ACTIVE_HIGH) ? ~on : on;
endmodule