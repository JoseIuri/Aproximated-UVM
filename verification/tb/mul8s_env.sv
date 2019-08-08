class mul8s_env extends uvm_env;
    typedef mul8s_agent agent_type;
    agent_type agent;
    mul8s_scoreboard   sb;
    mul8s_cover sub;
    `uvm_component_utils(mul8s_env)

    function new(string name, uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = agent_type::type_id::create("agent", this);
        sb = mul8s_scoreboard::type_id::create("sb", this);
        sub = mul8s_cover::type_id::create("sub",this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agent.agt_req_port.connect(sub.req_port);
                agent.agt_resp_port.connect(sub.resp_port);
        agent.agt_resp_port.connect(sb.ap_comp);
        agent.agt_req_port.connect(sb.ap_rfm);
    endfunction

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
    endfunction

endclass: mul8s_env