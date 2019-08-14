/*
Project           : Approximated Circuits UVM Testench
File Name         : mul8s_env.sv
Author            : Jose Iuri B. de Brito (XMEN LAB)
Purpose           : File that defines the environment of the 
                    testbench architecture.
*/

class mul8s_env extends uvm_env;
    typedef mul8s_agent agent_type;
    agent_type agent;
    mul8s_scoreboard   sb;
    mul8s_cover cv;
    `uvm_component_utils(mul8s_env)

    function new(string name, uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = agent_type::type_id::create("agent", this);
        sb = mul8s_scoreboard::type_id::create("sb", this);
        cv = mul8s_cover::type_id::create("cv",this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agent.agt_comp_port.connect(sb.ap_comp);
        agent.agt_ref_port.connect(sb.ap_rfm);
        agent.agt_comp_port.connect(cv.resp_port);
        agent.agt_ref_port.connect(cv.req_port);
    endfunction

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
    endfunction

endclass: mul8s_env