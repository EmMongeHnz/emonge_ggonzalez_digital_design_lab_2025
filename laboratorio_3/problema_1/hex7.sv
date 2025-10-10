module hex7 #(
    parameter bit ACTIVE_LOW = 1'b1
)(
    input  logic [3:0] d,     
    output logic [6:0] seg     
);
    logic [6:0] pat;          

    always_comb begin
        unique case (d)
            4'h0: pat = 7'b1111110;
            4'h1: pat = 7'b0110000;
            4'h2: pat = 7'b1101101;
            4'h3: pat = 7'b1111001;
            4'h4: pat = 7'b0110011;
            4'h5: pat = 7'b1011011;
            4'h6: pat = 7'b1011111;
            4'h7: pat = 7'b1110000;
            4'h8: pat = 7'b1111111;
            4'h9: pat = 7'b1111011;
            4'hA: pat = 7'b1110111;
            4'hB: pat = 7'b0011111; 
            4'hC: pat = 7'b1001110;
            4'hD: pat = 7'b0111101; 
            4'hE: pat = 7'b1001111;
            default: pat = 7'b1000111; 
        endcase
    end

    
    always_comb begin
        if (ACTIVE_LOW) seg = ~pat; else seg = pat;
    end
endmodule
