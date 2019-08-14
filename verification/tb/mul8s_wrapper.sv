/*
Project           : Approximated Circuits UVM Testench
File Name         : mul8s_wrapper.sv
Author            : Jose Iuri B. de Brito (XMEN LAB)
Purpose           : This file contains the wrapper that encapsulate the DUT.
*/

module mul8s_wrapper (mul8s_if bus);


    mul8s mul8s_sv (
        .rst(bus.rst),
        .clk(bus.clk),
        .A(bus.A),
        .B(bus.B),
        .O(bus.O));

endmodule