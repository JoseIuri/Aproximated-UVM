class simple_test extends uvm_test;
    mul8s_env env_h;
    mul8s_sequence seq;

    `uvm_component_utils(simple_test)

    function new(string name, uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env_h = mul8s_env::type_id::create("env_h", this);
        seq = mul8s_sequence::type_id::create("seq", this);
    endfunction

    task run_phase(uvm_phase phase);
        seq.start(env_h.agent.sqr);
    endtask: run_phase

endclass: simple_test