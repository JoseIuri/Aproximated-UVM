class mul8s_refmod extends uvm_component;
    `uvm_component_utils(mul8s_refmod)
    
    mul8s_transaction tr_in;
    mul8s_transaction tr_out;
    uvm_analysis_imp #(mul8s_transaction, mul8s_refmod) in;
    uvm_analysis_port #(mul8s_transaction) out;

    bit signed [15:0] aux;

    event begin_refmodtask;
    
    function new(string name = "mul8s_refmod", uvm_component parent);
        super.new(name, parent);
        in = new("in", this);
        out = new("out", this);
        aux = 'b0;
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        tr_out = mul8s_transaction::type_id::create("tr_out", this);
    endfunction: build_phase
    
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        
        forever begin
            @begin_refmodtask;
            begin_tr(tr_out, "mul8s_refmod");
            tr_out.A = tr_in.A;
            tr_out.B = tr_in.B;
            tr_out.O = aux;
            aux = tr_in.A*tr_in.B;
            out.write(tr_out);
        end
    endtask: run_phase

    virtual function write (mul8s_transaction t);
        end_tr(tr_out);
        tr_in = mul8s_transaction::type_id::create("tr_in", this);
        tr_in.copy(t);
        -> begin_refmodtask;
    endfunction


endclass: mul8s_refmod