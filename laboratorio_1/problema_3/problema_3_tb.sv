module problema_3_tb;
	parameter N = 6;
	logic clk;
	logic reset;
	logic [N-1:0] strt;
	logic [N-1:0] q;
	
	problema_3 #(.N(N)) dut (
		.clk(clk),
		.reset(reset),
		.strt(strt),
		.q(q)
	);
	
	initial clk = 1;
	always #(40/N) clk = ~clk;
	
	logic [1:0] expected_q2 [0:3] = '{2'h0, 2'h1, 2'h2, 2'h3};
	logic [3:0] expected_q4 [0:3] = '{4'h0, 4'h4, 4'h8, 4'hC};
	logic [5:0] expected_q6 [0:3] = '{6'h0, 6'h10, 6'h20, 6'h30};
	
	// To test diffrent parameters just check that every expected_qX is correctly set
	// where X is the parameter N
	initial begin
		strt = expected_q6[0];
		reset = 1;
		#(20);
		assert (q === expected_q6[0]) else $error("Expected q: %b, Got: %b, at %0t", expected_q6[0], q, $time);
		#(20);
		reset = 0;
		#(20*(N));
		assert (q === expected_q6[1]) else $error("Expected q: %b, Got: %b, at %0t", expected_q6[1], q, $time);
		#(20*(N));
		assert (q === expected_q6[2]) else $error("Expected q: %b, Got: %b, at %0t", expected_q6[2], q, $time);
		#(20*(N))
		assert (q === expected_q6[3]) else $error("Expected q: %b, Got: %b, at %0t", expected_q6[3], q, $time);
		strt = expected_q6[2];
		reset = 1;
		#(20);
		assert (q === expected_q6[2]) else $error("Expected q: %b, Got: %b, at %0t", expected_q6[0], q, $time);
		#(20);
		reset = 0;
		#(20*(N));
		assert (q === expected_q6[3]) else $error("Expected q: %b, Got: %b, at %0t", expected_q6[1], q, $time);
		#(20*(N));
		assert (q === expected_q6[0]) else $error("Expected q: %b, Got: %b, at %0t", expected_q6[2], q, $time);
		#(20*(N))
		assert (q === expected_q6[1]) else $error("Expected q: %b, Got: %b, at %0t", expected_q6[3], q, $time);
		$finish;
	end
endmodule