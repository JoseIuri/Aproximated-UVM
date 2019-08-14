/*
Project           : Approximated Circuits UVM Testench
File Name         : mul8s_transaction.sv
Author            : Jose Iuri B. de Brito (XMEN LAB)
Purpose           : File that defines the main agent of the testbench architecture.
*/
class mul8s_agent extends uvm_agent;
    uvm_sequencer#(mul8s_transaction) sqr;
    mul8s_driver    drv;
    mul8s_monitor   mon;

    uvm_analysis_port #(mul8s_transaction) agt_comp_port;
    uvm_analysis_port #(mul8s_transaction) agt_ref_port;

    `uvm_component_utils(mul8s_agent)

    function new(string name = "mul8s_agent", uvm_component parent = null);
        super.new(name, parent);
        agt_comp_port = new("agt_comp_port", this);
        agt_ref_port = new("agt_ref_port", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon = mul8s_monitor::type_id::create("mon", this);
        sqr = uvm_sequencer#(mul8s_transaction)::type_id::create("sqr", this);
        drv = mul8s_driver::type_id::create("drv", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        mon.item_comp_port.connect(agt_comp_port);
        mon.item_ref_port.connect(agt_ref_port);
        drv.seq_item_port.connect(sqr.seq_item_export);
    endfunction
endclass: mul8s_agent