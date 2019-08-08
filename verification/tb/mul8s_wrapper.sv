module mul8s_wrapper (mul8s_if bus);


    mul8s mul8s_sv (
        .rst(bus.rst),
        .clk(bus.clk),
        .A(bus.A),
        .B(bus.B),
        .O(bus.O));

endmodule