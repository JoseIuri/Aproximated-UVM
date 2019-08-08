class mul8s_monitor extends uvm_monitor;

    virtual mul8s_if  mul8s_vif;
    event begin_record, end_record;
    mul8s_transaction tr;
    uvm_analysis_port #(mul8s_transaction) req_tr_port;
    uvm_analysis_port #(mul8s_transaction) resp_tr_port;
    `uvm_component_utils(mul8s_monitor)
   
    function new(string name, uvm_component parent);
        super.new(name, parent);
        req_tr_port = new("req_tr_port", this);
        resp_tr_port = new("resp_tr_port", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        assert(uvm_config_db#(virtual mul8s_if)::get(this, "", "mul8s_vif", mul8s_vif));
        tr = mul8s_transaction::type_id::create("tr", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        fork
            collect_transactions(phase);
            record_tr();
        join
    endtask

    virtual task collect_transactions(uvm_phase phase);
        wait(mul8s_vif.rst === 0);
        @(posedge mul8s_vif.rst);
        forever begin
            -> begin_record;
            @(posedge mul8s_vif.clk);
            
            tr.A = mul8s_vif.A;
            tr.B = mul8s_vif.B;
            req_tr_port.write(tr);
            resp_tr_port.write(tr);
            @(negedge mul8s_vif.clk);
            -> end_record;
        end
    endtask

    virtual task record_tr();
        forever begin
            @(begin_record);
            begin_tr(tr, "mul8s_monitor");
            @(end_record);
            end_tr(tr);
        end
    endtask
endclass: mul8s_monitor