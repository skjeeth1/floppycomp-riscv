module tb(
    
);
    logic a, b, s, c;
    top A1 (a, b, s, c);
    
    initial begin
        a = 1;b=1; 
        #10;
        a=0;b=1;
    end

endmodule