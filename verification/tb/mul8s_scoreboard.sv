class mul8s_scoreboard extends uvm_scoreboard;
    
    typedef mul8s_transaction T;
    typedef uvm_in_order_class_comparator #(T) comp_type;

    mul8s_refmod rfm;
    comp_type comp;
    mul8s_analyzer analy;

    uvm_analysis_port #(T) ap_comp;
    uvm_analysis_port #(T) ap_rfm;

    `uvm_component_utils(mul8s_scoreboard)

    function new(string name="mul8s_scoreboard", uvm_component parent = null);
        super.new(name, parent);
        ap_comp = new("ap_comp", this);
        ap_rfm = new("ap_rfm", this);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        rfm = mul8s_refmod::type_id::create("rfm", this);
        comp = comp_type::type_id::create("comp", this);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        ap_comp.connect(comp.before_export);
        ap_rfm.connect(rfm.in);
        rfm.out.connect(comp.after_export);
        analy.from_comparator.connect(comp.pair_ap);
    endfunction

endclass: mul8s_scoreboard