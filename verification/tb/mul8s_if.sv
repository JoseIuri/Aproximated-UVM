/*
Project           : Approximated Circuits UVM Testench
File Name         : setup.py
Author            : Jose Iuri B. de Brito (XMEN LAB)
Purpose           : File that defines the interface of signals.
*/

interface mul8s_if (input logic clk, rst);

    logic signed [7:0] A;

    logic signed [7:0] B;

    logic signed [15:0] O;

    modport port(
        input   rst,
        input   clk,
        input   A,
        input   B,
        output   O
    );
endinterface : mul8s_if