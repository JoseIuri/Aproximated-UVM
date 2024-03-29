/*
Project           : Approximated Circuits UVM Testench
File Name         : top.sv
Author            : Jose Iuri B. de Brito (XMEN LAB)
Purpose           : File that defines the top module.
*/
module top;
    import uvm_pkg::*;
    import mul8s_pkg::*;
    logic clk;
    logic reset;
    parameter min_cover = 70;
    parameter min_transa = 2000;

    initial begin
    clk = 0;
    reset = 1;
    #1  reset = 0;
    #22 reset = 1;
    end

    always #5 clk = !clk;

    mul8s_if mul8s_vif (.clk(clk), .rst(reset));

    mul8s_wrapper DUT (.bus(mul8s_vif));

    // mul8s mul8s_sv (
    //     .rst(mul8s_vif.rst),
    //     .clk(mul8s_vif.clk),
    //     .A(mul8s_vif.A),
    //     .B(mul8s_vif.B),
    //     .O(mul8s_vif.O));

    initial begin
    `ifdef XCELIUM
       $recordvars();
    `endif
    `ifdef VCS
       $vcdpluson;
    `endif
    `ifdef QUESTA
       $wlfdumpvars();
       set_config_int("*", "recording_detail", 1);
    `endif

    uvm_config_db#(virtual mul8s_if)::set(uvm_root::get(), "*", "mul8s_vif", mul8s_vif);
    uvm_config_db#(int)::set(uvm_root::get(),"*", "min_cover", min_cover);
    uvm_config_db#(int)::set(uvm_root::get(),"*", "min_transa", min_transa);
    run_test("simple_test");
    end
endmodule