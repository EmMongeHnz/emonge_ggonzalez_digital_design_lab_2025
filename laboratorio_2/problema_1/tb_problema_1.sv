`timescale 1ns/1ps

module tb_problema_1;

  localparam logic [3:0]
    OP_ADD = 4'd0, OP_SUB = 4'd1, OP_MUL = 4'd2, OP_DIV = 4'd3, OP_MOD = 4'd4,
    OP_AND = 4'd5, OP_OR  = 4'd6, OP_XOR = 4'd7, OP_SLL = 4'd8, OP_SRL = 4'd9;

  function string fstr(input logic [3:0] F);
    return $sformatf("Z=%0d N=%0d C=%0d V=%0d", F[3], F[2], F[1], F[0]);
  endfunction


  localparam int N4 = 4;
  logic [N4-1:0] A4, B4;
  logic          CINBIN4;
  logic [3:0]    OP4;
  logic [N4-1:0] Y4;
  logic [3:0]    FLAGS4;

  alu_core #(.N(N4)) DUT4 (
    .A(A4), .B(B4), .CIN_BIN(CINBIN4), .OP(OP4), .Y(Y4), .FLAGS(FLAGS4)
  );


  localparam int N6 = 6;
  logic [N6-1:0] A6, B6;
  logic          CINBIN6;
  logic [3:0]    OP6;
  logic [N6-1:0] Y6;
  logic [3:0]    FLAGS6;

  alu_core #(.N(N6)) DUT6 (
    .A(A6), .B(B6), .CIN_BIN(CINBIN6), .OP(OP6), .Y(Y6), .FLAGS(FLAGS6)
  );


  task set4(input [3:0] op, input [N4-1:0] a, b, input bit cinbin=0);
    A4=a; B4=b; CINBIN4=cinbin; OP4=op; #1;
  endtask
  task show4(string tag);
    $display("[N=4][%s] A=0x%h  B=0x%h  -> Y=0x%h  %s", tag, A4, B4, Y4, fstr(FLAGS4));
  endtask

  task set6(input [3:0] op, input [N6-1:0] a, b, input bit cinbin=0);
    A6=a; B6=b; CINBIN6=cinbin; OP6=op; #1;
  endtask
  task show6(string tag);
    $display("[N=6][%s] A=0x%h  B=0x%h  -> Y=0x%h  %s", tag, A6, B6, Y6, fstr(FLAGS6));
  endtask

  initial begin
    $display("=== Test alu_core (FLAGS={Z,N,C,V}) ===");

    set4(OP_ADD, 4'h5, 4'h3, 1'b0);  show4("ADD");
    set4(OP_SUB, 4'h3, 4'h7, 1'b0);  show4("SUB");

    set4(OP_MUL, 4'd6, 4'd6);        show4("MUL");     
    set4(OP_DIV, 4'd13, 4'd3);       show4("DIV 13/3");
    set4(OP_MOD, 4'd13, 4'd3);       show4("MOD 13%3");

    set4(OP_AND, 4'b1010, 4'b1100);  show4("AND");
    set4(OP_OR , 4'b1010, 4'b0101);  show4("OR");
    set4(OP_XOR, 4'b1111, 4'b0101);  show4("XOR");

    set4(OP_SLL, 4'b0011, 4'd1);     show4("SLL A<<1");
    set4(OP_SRL, 4'b1000, 4'd2);     show4("SRL A>>2");


    set6(OP_ADD, 6'd10, 6'd3);       show6("ADD");
    set6(OP_SUB, 6'd0 , 6'd1);       show6("SUB");

    set6(OP_MUL, 6'd40, 6'd7);       show6("MUL");
    set6(OP_DIV, 6'd50, 6'd5);       show6("DIV 50/5");
    set6(OP_MOD, 6'd50, 6'd7);       show6("MOD 50%7");

    set6(OP_AND, 6'b101010, 6'b110011); show6("AND");
    set6(OP_OR , 6'b101010, 6'b010101); show6("OR");
    set6(OP_XOR, 6'b111100, 6'b010101); show6("XOR");

    set6(OP_SLL, 6'b000011, 6'd3);      show6("SLL A<<3");
    set6(OP_SRL, 6'b100000, 6'd4);      show6("SRL A>>4");

    $display("=== Fin de prueba ===");
    #5 $finish;
  end

endmodule
