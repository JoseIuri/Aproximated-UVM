class mul8s_refmod extends uvm_component;
    `uvm_component_utils(mul8s_refmod)
    
    mul8s_transaction tr_in;
    mul8s_transaction tr_out;
    integer a, b;
    uvm_get_port #(mul8s_transaction) in;
    uvm_put_port #(mul8s_transaction) out;
    
    function new(string name = "mul8s_refmod", uvm_component parent);
        super.new(name, parent);
        in = new("in", this);
        out = new("out", this);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        tr_out = mul8s_transaction::type_id::create("tr_out", this);
    endfunction: build_phase
    
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        
        forever begin
            in.get(tr_in);
            tr_out.A = tr_in.A;
            tr_out.B = tr_in.B;
            tr_out.O = tr_in.A*tr_in.B;
            out.put(tr_out);
        end
    endtask: run_phase
endclass: mul8s_refmod