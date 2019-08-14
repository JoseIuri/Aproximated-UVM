/*
Project           : Approximated Circuits UVM Testench
File Name         : mul8s_pkg.sv
Author            : Jose Iuri B. de Brito (XMEN LAB)
Purpose           : This file defines the package of another files from testbench.
*/
package mul8s_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;


    `include "./mul8s_types.svh"
    `include "./mul8s_transaction.sv"
    
    `include "./mul8s_sequence.sv"
    `include "./mul8s_driver.sv"
    `include "./mul8s_monitor.sv"
    `include "./mul8s_agent.sv"

    `include "./mul8s_cover.sv"
    `include "./mul8s_refmod.sv"
    `include "./mul8s_analyzer.sv"
    `include "./mul8s_scoreboard.sv"
    `include "./mul8s_env.sv"

    `include "./simple_test.sv"
endpackage