module top(
    input logic a, b,
    output logic s, c
);
    always_comb begin : adder
        s = a + b;
        c = a & b;
    end
endmodule