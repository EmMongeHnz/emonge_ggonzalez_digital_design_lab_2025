module problema_3 #(parameter N = 6)(
	input logic clk,
	input logic [N-1:0] strt,
	input logic reset,
	output logic [N-1:0] q,
	output logic [6:0] seg_h, seg_l
);
	
	always_ff@(posedge clk or posedge reset)
		if (reset) q <= strt;
		else	q <= q+1;
		
	display7seg _seg_h(.digit(q[5:4]), .segments(seg_h));
	display7seg _seg_l(.digit(q[3:0]), .segments(seg_l));
	
endmodule